# Best Practices Guide

Production-ready patterns and best practices for Alianza API integrations.

## Authentication

### Token Management

**DO**:
```python
# Refresh proactively before expiration
def ensure_valid_token(client):
    if not client.token or time_until_expiry() < 300:  # 5 minutes
        client.authenticate()
```

**DON'T**:
```python
# Wait for 401 error
try:
    client.make_request()
except UnauthorizedError:
    client.authenticate()  # Too late, request failed
```

### Credential Storage

**DO**:
```python
# Use environment variables
import os
username = os.getenv('ALIANZA_USERNAME')
password = os.getenv('ALIANZA_PASSWORD')
```

**DON'T**:
```python
# Hardcode credentials
username = "admin@company.com"  # Never do this!
password = "MyPassword123"
```

## Rate Limiting

### Implement Request Throttling

```python
import time
from collections import deque

class RateLimiter:
    def __init__(self, max_requests=100, time_window=1.0):
        self.max_requests = max_requests
        self.time_window = time_window
        self.requests = deque()

    def wait_if_needed(self):
        now = time.time()

        # Remove old requests outside time window
        while self.requests and self.requests[0] < now - self.time_window:
            self.requests.popleft()

        # Wait if at limit
        if len(self.requests) >= self.max_requests:
            sleep_time = self.time_window - (now - self.requests[0])
            if sleep_time > 0:
                time.sleep(sleep_time)

        self.requests.append(time.time())

# Usage
rate_limiter = RateLimiter(max_requests=100, time_window=1.0)

for account in accounts_to_create:
    rate_limiter.wait_if_needed()
    client.create_account(account)
```

### Batch Operations

**DO**:
```python
# Use bulk operations for multiple users
collection_id = client.create_bulk_collection()
for user in users:
    client.add_to_collection(collection_id, user)
job_id = client.execute_bulk_operation(collection_id, 'UPDATE_CALLING_PLAN')
```

**DON'T**:
```python
# Update users one by one in a loop
for user in users:
    client.update_user(user['id'], {'callingPlanId': new_plan})  # Slow!
```

## Error Handling

### Comprehensive Error Handling

```python
def safe_api_call(func, *args, max_retries=3, **kwargs):
    """Wrapper for API calls with retry logic"""
    last_error = None

    for attempt in range(max_retries):
        try:
            return func(*args, **kwargs)

        except RateLimitError as e:
            time.sleep(int(e.retry_after))
            continue

        except ServerError as e:
            if attempt < max_retries - 1:
                delay = 2 ** attempt  # Exponential backoff
                time.sleep(delay)
                continue
            last_error = e

        except ClientError as e:
            # Don't retry client errors (400, 404, etc.)
            raise

        except NetworkError as e:
            if attempt < max_retries - 1:
                time.sleep(2 ** attempt)
                continue
            last_error = e

    raise last_error
```

### Validation Before API Calls

```python
def validate_before_create(account_data):
    """Validate locally before API call"""
    errors = []

    # Required fields
    if not account_data.get('accountNumber'):
        errors.append("Account number is required")

    # Business rules
    if len(account_data.get('accountNumber', '')) > 50:
        errors.append("Account number too long (max 50 chars)")

    # Valid values
    if account_data.get('timeZone') not in VALID_TIMEZONES:
        errors.append(f"Invalid timezone: {account_data.get('timeZone')}")

    if errors:
        raise ValidationError(errors)

    return True
```

## Performance Optimization

### Parallel Requests

```python
import concurrent.futures

def create_accounts_parallel(client, accounts, max_workers=5):
    """Create multiple accounts in parallel"""
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(client.create_account, account): account
            for account in accounts
        }

        results = []
        for future in concurrent.futures.as_completed(futures):
            try:
                result = future.result()
                results.append(result)
            except Exception as e:
                account = futures[future]
                print(f"Failed to create account {account['accountNumber']}: {e}")

        return results
```

### Caching

```python
from functools import lru_cache
import time

class CachedAlianzaClient:
    def __init__(self, client):
        self.client = client
        self._cache = {}
        self._cache_ttl = {}

    def get_account_cached(self, account_id, ttl=300):
        """Get account with 5-minute cache"""
        now = time.time()

        if account_id in self._cache:
            if now < self._cache_ttl.get(account_id, 0):
                return self._cache[account_id]

        # Fetch from API
        account = self.client.get_account(account_id)
        self._cache[account_id] = account
        self._cache_ttl[account_id] = now + ttl

        return account
```

### Pagination for Large Datasets

```python
def get_all_accounts(client, partition_id, page_size=100):
    """Fetch all accounts with pagination"""
    all_accounts = []
    offset = 0

    while True:
        response = client.list_accounts(
            partition_id,
            limit=page_size,
            offset=offset
        )

        accounts = response.get('accounts', [])
        all_accounts.extend(accounts)

        if len(accounts) < page_size:
            break  # Last page

        offset += page_size

    return all_accounts
```

## Data Management

### E911 Compliance

**Always validate and register E911 addresses**:

```python
def create_user_with_e911(client, account_id, user_data, telephone_number):
    """Ensure E911 compliance"""
    # 1. Validate address
    address_validation = client.validate_address(
        user_data['address'],
        user_data['postalCode']
    )

    if not address_validation['valid']:
        raise ValueError("Invalid E911 address")

    # 2. Create user
    user = client.create_user(account_id, user_data)

    # 3. Assign number with E911
    client.assign_number(
        account_id,
        user['userId'],
        telephone_number,
        e911_address=address_validation['formatted']
    )

    return user
```

### Idempotency

```python
def create_account_idempotent(client, account_data):
    """Create account with idempotency check"""
    account_number = account_data['accountNumber']

    # Check if exists
    try:
        existing = client.get_account_by_number(account_number)
        return existing  # Already created
    except NotFoundError:
        pass  # Doesn't exist, create it

    # Create new account
    return client.create_account(account_data)
```

## Security

### Input Sanitization

```python
import re

def sanitize_input(data):
    """Sanitize user input"""
    sanitized = {}

    for key, value in data.items():
        if isinstance(value, str):
            # Remove potential injection characters
            value = re.sub(r'[<>\"\'%;()&+]', '', value)
            # Trim whitespace
            value = value.strip()

        sanitized[key] = value

    return sanitized
```

### Audit Logging

```python
import logging
import json
from datetime import datetime

class AuditLogger:
    """Log all API operations for audit trail"""

    def __init__(self, log_file):
        self.logger = logging.getLogger('audit')
        handler = logging.FileHandler(log_file)
        handler.setFormatter(logging.Formatter('%(message)s'))
        self.logger.addHandler(handler)
        self.logger.setLevel(logging.INFO)

    def log_operation(self, user, operation, resource_type, resource_id, result):
        """Log API operation"""
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'user': user,
            'operation': operation,
            'resource_type': resource_type,
            'resource_id': resource_id,
            'result': result,
            'ip_address': self.get_client_ip()
        }

        self.logger.info(json.dumps(log_entry))

# Usage
audit = AuditLogger('/var/log/alianza_audit.log')
audit.log_operation(
    user='admin@company.com',
    operation='CREATE',
    resource_type='ACCOUNT',
    resource_id='acc_123',
    result='SUCCESS'
)
```

### Principle of Least Privilege

```python
# Use different credentials for different operations
class AlianzaClientFactory:
    @staticmethod
    def create_readonly_client():
        """Client with read-only credentials"""
        return AlianzaClient(
            username=os.getenv('ALIANZA_READONLY_USER'),
            password=os.getenv('ALIANZA_READONLY_PASS')
        )

    @staticmethod
    def create_admin_client():
        """Client with admin credentials"""
        return AlianzaClient(
            username=os.getenv('ALIANZA_ADMIN_USER'),
            password=os.getenv('ALIANZA_ADMIN_PASS')
        )

# Use appropriate client
readonly_client = AlianzaClientFactory.create_readonly_client()
accounts = readonly_client.list_accounts()  # Safe read operation

admin_client = AlianzaClientFactory.create_admin_client()
admin_client.create_account(data)  # Requires admin privileges
```

## Testing

### Test in Development Environment

```python
class AlianzaConfig:
    """Environment-specific configuration"""

    ENVIRONMENTS = {
        'development': 'https://api.d2.alianza.com',
        'qa': 'https://api.q2.alianza.com',
        'beta': 'https://api.b2.alianza.com',
        'production': 'https://api.alianza.com'
    }

    @classmethod
    def get_url(cls, env='development'):
        return cls.ENVIRONMENTS.get(env)

# Always test in dev first
dev_client = AlianzaClient(
    username=os.getenv('DEV_USERNAME'),
    password=os.getenv('DEV_PASSWORD'),
    base_url=AlianzaConfig.get_url('development')
)
```

### Mock for Unit Tests

```python
from unittest.mock import Mock, patch

def test_create_account():
    """Unit test with mocked API"""
    mock_client = Mock()
    mock_client.create_account.return_value = {
        'accountId': 'acc_123',
        'accountNumber': '1001',
        'name': 'Test Account'
    }

    # Test your logic
    result = create_account_with_validation(mock_client, account_data)

    assert result['accountId'] == 'acc_123'
    mock_client.create_account.assert_called_once()
```

## Monitoring

### Health Checks

```python
def check_api_health(client):
    """Verify API connectivity and authentication"""
    try:
        # Attempt to authenticate
        client.authenticate()

        # Make a simple API call
        client.list_accounts()

        return {
            'status': 'healthy',
            'timestamp': datetime.utcnow().isoformat()
        }

    except Exception as e:
        return {
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': datetime.utcnow().isoformat()
        }
```

### Metrics Collection

```python
import statsd

class MetricsCollector:
    """Collect and send metrics"""

    def __init__(self):
        self.statsd = statsd.StatsClient('localhost', 8125)

    def record_api_call(self, endpoint, duration_ms, status_code):
        """Record API call metrics"""
        # Timing
        self.statsd.timing(f'api.{endpoint}.duration', duration_ms)

        # Counter
        self.statsd.incr(f'api.{endpoint}.count')

        # Status codes
        self.statsd.incr(f'api.{endpoint}.status.{status_code}')

        # Error rate
        if status_code >= 400:
            self.statsd.incr(f'api.{endpoint}.errors')
```

## Documentation

### Code Documentation

```python
def create_account(
    client: AlianzaClient,
    account_number: str,
    name: str,
    timezone: str,
    **kwargs
) -> Dict[str, Any]:
    """
    Create a new account in the Alianza platform.

    Args:
        client: Authenticated Alianza API client
        account_number: Unique account identifier (max 50 chars)
        name: Account name/business name
        timezone: IANA timezone (e.g., 'America/New_York')
        **kwargs: Additional optional fields (address, callingPlanId, etc.)

    Returns:
        Dict containing created account with accountId

    Raises:
        ValueError: If validation fails
        AlianzaAPIError: If API call fails

    Example:
        >>> client = AlianzaClient()
        >>> account = create_account(
        ...     client,
        ...     account_number='1001',
        ...     name='Acme Corp',
        ...     timezone='America/New_York'
        ... )
        >>> print(account['accountId'])
        'acc_abc123'
    """
    # Implementation
    pass
```

## Summary Checklist

**Authentication**:
- ✅ Store credentials securely (environment variables)
- ✅ Refresh tokens proactively
- ✅ Handle 401 errors gracefully
- ✅ Use separate credentials per environment

**Performance**:
- ✅ Implement rate limiting
- ✅ Use bulk operations for multiple items
- ✅ Cache frequently accessed data
- ✅ Use parallel requests where appropriate

**Reliability**:
- ✅ Implement retry logic with exponential backoff
- ✅ Validate input before API calls
- ✅ Handle all error scenarios
- ✅ Log all errors with request IDs

**Security**:
- ✅ Sanitize user input
- ✅ Use least privilege principle
- ✅ Implement audit logging
- ✅ Never log sensitive data (tokens, passwords)

**Testing**:
- ✅ Test in development environment first
- ✅ Write unit tests with mocks
- ✅ Test error scenarios
- ✅ Validate in QA before production

**Monitoring**:
- ✅ Implement health checks
- ✅ Collect metrics (latency, error rates)
- ✅ Set up alerts for anomalies
- ✅ Monitor token expiration

## Next Steps

- [Error Handling Guide](error-handling.md)
- [Code Examples](../code-examples/)
- [Architecture Diagrams](../architecture/diagrams.md)
