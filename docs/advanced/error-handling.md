# Error Handling Guide

Comprehensive guide to handling errors when working with the Alianza API.

## Error Response Format

All API errors follow a consistent JSON structure:

```json
{
  "errorCode": "ERROR_TYPE",
  "message": "Human-readable error description",
  "details": "Additional context about the error",
  "timestamp": "2025-12-18T15:30:00Z",
  "path": "/v2/partition/123/account",
  "requestId": "req_abc123"
}
```

## HTTP Status Codes

### 400 Bad Request

**Cause**: Invalid request parameters or malformed data

**Common Scenarios**:
- Missing required fields
- Invalid data format
- Business rule violations

**Example**:
```json
{
  "errorCode": "INVALID_REQUEST",
  "message": "Account number already exists",
  "details": "Account number '1001' is already in use in this partition"
}
```

**Solution**:
```python
try:
    account = client.create_account(data)
except requests.exceptions.HTTPError as e:
    if e.response.status_code == 400:
        error = e.response.json()
        if 'already exists' in error['message']:
            # Generate new account number
            data['accountNumber'] = generate_unique_number()
            account = client.create_account(data)
```

### 401 Unauthorized

**Cause**: Missing, invalid, or expired authentication token

**Common Scenarios**:
- Token expired (after 1 hour)
- Invalid credentials
- Token not provided

**Example**:
```json
{
  "errorCode": "UNAUTHORIZED",
  "message": "Authentication token expired",
  "timestamp": "2025-12-18T15:30:00Z"
}
```

**Solution**:
```python
def make_request_with_retry(client, method, *args, **kwargs):
    try:
        return getattr(client, method)(*args, **kwargs)
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 401:
            # Re-authenticate and retry
            client.authenticate()
            return getattr(client, method)(*args, **kwargs)
        raise
```

### 403 Forbidden

**Cause**: Authenticated but not authorized for the operation

**Common Scenarios**:
- Insufficient permissions for user type
- Accessing resources outside your partition
- Feature not enabled for account

**Example**:
```json
{
  "errorCode": "FORBIDDEN",
  "message": "User does not have permission to delete accounts",
  "details": "ACCOUNT_USER role cannot delete accounts. Contact MANAGEMENT_USER."
}
```

**Solution**:
- Verify user role and permissions
- Contact account manager to enable features
- Use appropriate user credentials

### 404 Not Found

**Cause**: Resource doesn't exist

**Common Scenarios**:
- Invalid ID provided
- Resource was deleted
- Wrong partition ID

**Example**:
```json
{
  "errorCode": "NOT_FOUND",
  "message": "Account not found",
  "details": "No account with ID 'acc_invalid' exists in partition 'part_123'"
}
```

**Solution**:
```python
def get_account_safe(client, account_id):
    try:
        return client.get_account(account_id)
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 404:
            return None  # Resource doesn't exist
        raise
```

### 409 Conflict

**Cause**: Resource state conflict

**Common Scenarios**:
- Duplicate resource creation
- State transition not allowed
- Concurrent modification

**Example**:
```json
{
  "errorCode": "CONFLICT",
  "message": "Telephone number already assigned",
  "details": "Number +16071234567 is already assigned to user user_xyz"
}
```

**Solution**:
- Check current resource state
- Unassign/release resources first
- Use unique identifiers

### 429 Too Many Requests

**Cause**: Rate limit exceeded

**Common Scenarios**:
- Too many requests in short time
- Bulk operations without throttling
- No backoff on retries

**Example**:
```json
{
  "errorCode": "RATE_LIMIT_EXCEEDED",
  "message": "Too many requests",
  "details": "Maximum 100 requests per second exceeded",
  "retryAfter": 5
}
```

**Solution**:
```python
import time

def make_request_with_backoff(client, method, *args, max_retries=3, **kwargs):
    for attempt in range(max_retries):
        try:
            return getattr(client, method)(*args, **kwargs)
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 429:
                retry_after = int(e.response.headers.get('Retry-After', 5))
                if attempt < max_retries - 1:
                    time.sleep(retry_after)
                    continue
            raise
```

### 500 Internal Server Error

**Cause**: Server-side error

**Common Scenarios**:
- Unexpected server condition
- Database errors
- Downstream service failures

**Example**:
```json
{
  "errorCode": "INTERNAL_ERROR",
  "message": "An internal error occurred",
  "requestId": "req_abc123"
}
```

**Solution**:
- Retry with exponential backoff
- Contact support with requestId
- Check status page

## Error Handling Patterns

### Comprehensive Error Handler

```python
import time
import logging
from typing import Callable, Any

logger = logging.getLogger(__name__)

class AlianzaAPIError(Exception):
    """Base exception for Alianza API errors"""
    def __init__(self, status_code, error_data):
        self.status_code = status_code
        self.error_code = error_data.get('errorCode')
        self.message = error_data.get('message')
        self.details = error_data.get('details')
        self.request_id = error_data.get('requestId')
        super().__init__(self.message)

def handle_api_errors(func: Callable) -> Callable:
    """Decorator for handling API errors with retry logic"""
    def wrapper(*args, **kwargs) -> Any:
        max_retries = kwargs.pop('max_retries', 3)
        retry_delay = kwargs.pop('retry_delay', 1)

        for attempt in range(max_retries):
            try:
                return func(*args, **kwargs)

            except requests.exceptions.HTTPError as e:
                status = e.response.status_code
                error_data = e.response.json() if e.response.content else {}

                # Log error
                logger.error(
                    f"API Error: {status} - {error_data.get('message')}",
                    extra={'request_id': error_data.get('requestId')}
                )

                # Handle specific errors
                if status == 401:  # Unauthorized
                    # Re-authenticate handled by interceptor
                    if attempt < max_retries - 1:
                        continue

                elif status == 429:  # Rate limit
                    retry_after = int(e.response.headers.get('Retry-After', retry_delay))
                    if attempt < max_retries - 1:
                        logger.warning(f"Rate limited. Retrying after {retry_after}s")
                        time.sleep(retry_after)
                        continue

                elif status >= 500:  # Server error
                    if attempt < max_retries - 1:
                        delay = retry_delay * (2 ** attempt)  # Exponential backoff
                        logger.warning(f"Server error. Retrying after {delay}s")
                        time.sleep(delay)
                        continue

                # Raise custom exception
                raise AlianzaAPIError(status, error_data)

            except requests.exceptions.ConnectionError as e:
                logger.error(f"Connection error: {e}")
                if attempt < max_retries - 1:
                    delay = retry_delay * (2 ** attempt)
                    time.sleep(delay)
                    continue
                raise

            except requests.exceptions.Timeout as e:
                logger.error(f"Request timeout: {e}")
                if attempt < max_retries - 1:
                    delay = retry_delay * (2 ** attempt)
                    time.sleep(delay)
                    continue
                raise

    return wrapper

# Usage
@handle_api_errors
def create_account_safe(client, account_data):
    return client.create_account(account_data)
```

### Validation Before API Calls

```python
def validate_account_data(account_data: dict) -> list:
    """Validate account data before API call"""
    errors = []

    required_fields = ['accountNumber', 'name', 'timeZone']
    for field in required_fields:
        if field not in account_data:
            errors.append(f"Missing required field: {field}")

    if 'accountNumber' in account_data:
        if not account_data['accountNumber'].strip():
            errors.append("Account number cannot be empty")

    if 'timeZone' in account_data:
        valid_timezones = ['America/New_York', 'America/Chicago', 'America/Denver', 'America/Los_Angeles']
        if account_data['timeZone'] not in valid_timezones:
            errors.append(f"Invalid timezone: {account_data['timeZone']}")

    return errors

# Usage
errors = validate_account_data(account_data)
if errors:
    raise ValueError(f"Validation failed: {', '.join(errors)}")
```

## Common Error Scenarios

### Duplicate Account Number

```python
def create_account_with_unique_number(client, base_data):
    """Create account with auto-incrementing number on conflict"""
    import random

    for attempt in range(10):
        try:
            account_data = base_data.copy()
            if attempt > 0:
                # Add random suffix on retry
                account_data['accountNumber'] = f"{base_data['accountNumber']}-{random.randint(1000, 9999)}"

            return client.create_account(account_data)

        except AlianzaAPIError as e:
            if e.status_code == 400 and 'already exists' in e.message.lower():
                continue
            raise

    raise Exception("Failed to create account with unique number after 10 attempts")
```

### Phone Number Not Available

```python
def order_number_with_fallback(client, npa, account_id):
    """Order number with automatic fallback to alternatives"""
    numbers = client.search_numbers(npa=npa, quantity=10)

    for number in numbers:
        try:
            return client.order_number(number['telephoneNumber'], account_id)
        except AlianzaAPIError as e:
            if e.status_code == 409:  # Number no longer available
                continue
            raise

    raise Exception(f"No available numbers in area code {npa}")
```

### Port Request Rejection

```python
def handle_port_rejection(client, port_request_id):
    """Handle port request rejection"""
    port_status = client.check_port_status(port_request_id)

    if port_status['status'] == 'REJECTED':
        reason = port_status.get('rejectionReason', 'Unknown')

        # Common rejection reasons and solutions
        solutions = {
            'ACCOUNT_MISMATCH': 'Verify account holder name matches exactly',
            'INVALID_PIN': 'Check PIN with current carrier',
            'SERVICE_ACTIVE': 'Do not cancel service before port completes',
            'INVALID_ADDRESS': 'Verify service address matches carrier records'
        }

        solution = solutions.get(reason, 'Contact current carrier for details')

        return {
            'rejected': True,
            'reason': reason,
            'solution': solution,
            'details': port_status.get('rejectionDetails')
        }
```

## Logging and Monitoring

### Structured Logging

```python
import logging
import json

class AlianzaLogger:
    """Structured logger for API operations"""

    def __init__(self, name):
        self.logger = logging.getLogger(name)

    def log_request(self, method, endpoint, **kwargs):
        self.logger.info(
            "API Request",
            extra={
                'method': method,
                'endpoint': endpoint,
                'has_body': 'json' in kwargs
            }
        )

    def log_response(self, status_code, duration_ms, **kwargs):
        self.logger.info(
            "API Response",
            extra={
                'status_code': status_code,
                'duration_ms': duration_ms,
                **kwargs
            }
        )

    def log_error(self, error, **kwargs):
        self.logger.error(
            "API Error",
            extra={
                'error_type': type(error).__name__,
                'error_message': str(error),
                **kwargs
            },
            exc_info=True
        )
```

### Monitoring Metrics

```python
from datetime import datetime
from collections import defaultdict

class APIMetrics:
    """Track API performance and errors"""

    def __init__(self):
        self.request_count = 0
        self.error_count = defaultdict(int)
        self.response_times = []
        self.start_time = datetime.now()

    def record_request(self, duration_ms, status_code):
        self.request_count += 1
        self.response_times.append(duration_ms)

        if status_code >= 400:
            self.error_count[status_code] += 1

    def get_stats(self):
        if not self.response_times:
            return {}

        return {
            'total_requests': self.request_count,
            'total_errors': sum(self.error_count.values()),
            'error_rate': sum(self.error_count.values()) / self.request_count,
            'avg_response_time': sum(self.response_times) / len(self.response_times),
            'max_response_time': max(self.response_times),
            'errors_by_code': dict(self.error_count),
            'uptime_seconds': (datetime.now() - self.start_time).total_seconds()
        }
```

## Best Practices

### 1. Always Validate Input

Validate data before making API calls to catch errors early.

### 2. Implement Retry Logic

Use exponential backoff for transient errors (500, 503, 429).

### 3. Log Request IDs

Always log the `requestId` from error responses for support.

### 4. Handle 401 Automatically

Implement automatic re-authentication on token expiry.

### 5. Use Circuit Breakers

For high-volume integrations, implement circuit breakers to prevent cascading failures.

### 6. Monitor Error Rates

Track and alert on error rates above thresholds.

### 7. Graceful Degradation

Have fallback behavior when API is unavailable.

### 8. User-Friendly Messages

Transform API errors into user-friendly messages.

## Next Steps

- [Best Practices Guide](best-practices.md)
- [Code Examples](../code-examples/)
- [Authentication Guide](../getting-started/authentication.md)
