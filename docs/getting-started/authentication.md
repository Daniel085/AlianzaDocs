# Authentication Guide

Complete guide to authenticating with the Alianza API, managing tokens, and implementing security best practices.

## Authentication Overview

The Alianza API uses **token-based authentication** via the `X-AUTH-TOKEN` header. All API endpoints (except the authentication endpoints themselves) require a valid token.

### Authentication Flow

```
┌─────────┐                    ┌──────────────┐
│ Client  │                    │ Alianza API  │
└────┬────┘                    └──────┬───────┘
     │                                │
     │ POST /v2/authorize             │
     │ {username, password}           │
     ├───────────────────────────────>│
     │                                │
     │ 200 OK                         │
     │ {authToken: "xyz..."}          │
     │<───────────────────────────────┤
     │                                │
     │ Store token securely           │
     │                                │
     │ GET /v2/partition/123/account  │
     │ X-AUTH-TOKEN: xyz...           │
     ├───────────────────────────────>│
     │                                │
     │ 200 OK                         │
     │ {accounts: [...]}              │
     │<───────────────────────────────┤
```

## Authentication Methods

### 1. Username/Password Authentication (Primary)

The standard authentication method using credentials.

**Endpoint**: `POST /v2/authorize`

**Request**:
```json
{
  "userName": "your-username",
  "password": "your-password"
}
```

**Response**:
```json
{
  "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "userId": "user123",
  "partitionId": "partition123",
  "userType": "MANAGEMENT_USER",
  "userName": "your-username",
  "partitionName": "Your Company"
}
```

**Response Fields**:
- `authToken`: The token to include in subsequent requests (required)
- `expiresIn`: Token lifetime in seconds (typically 3600 = 1 hour)
- `partitionId`: Your partition ID (needed for most API calls)
- `userId`: Your user ID
- `userType`: User role (MANAGEMENT_USER, END_USER, ACCOUNT_USER)

### 2. JWT Authentication (Advanced)

For Single Sign-On (SSO) integrations.

**Endpoint**: `POST /v2/authorize/jwt`

**Requirements**:
- Pre-configured JWT integration with Alianza
- Alianza must have your public key
- Contact your account manager to set up

**Request**:
```json
{
  "token": "your-signed-jwt-token"
}
```

### 3. SSO Authentication

OAuth 2.0 / OpenID Connect flow for Single Sign-On.

**Step 1**: Get SSO configuration
```bash
GET /v2/authorize/sso
```

**Step 2**: Complete OAuth flow and exchange code for token
```bash
POST /v2/authorize/sso?code={auth_code}&redirect_uri={uri}
```

## Using the Authentication Token

### Include Token in Headers

All authenticated requests must include the token in the `X-AUTH-TOKEN` header:

**curl Example**:
```bash
curl -X GET https://api.alianza.com/v2/partition/123/account \
  -H "X-AUTH-TOKEN: your-auth-token-here" \
  -H "Content-Type: application/json"
```

**Python Example**:
```python
import requests

headers = {
    'X-AUTH-TOKEN': 'your-auth-token-here',
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://api.alianza.com/v2/partition/123/account',
    headers=headers
)
```

**Node.js Example**:
```javascript
const axios = require('axios');

const config = {
  headers: {
    'X-AUTH-TOKEN': 'your-auth-token-here',
    'Content-Type': 'application/json'
  }
};

const response = await axios.get(
  'https://api.alianza.com/v2/partition/123/account',
  config
);
```

## Token Management

### Token Expiration

- **Default Lifetime**: 1 hour (3600 seconds)
- **Expiration Handling**: When a token expires, you'll receive a `401 Unauthorized` response
- **Best Practice**: Refresh token proactively before expiration

### Refreshing Tokens

Tokens cannot be refreshed - you must re-authenticate:

```python
class AlianzaClient:
    def __init__(self, username, password, base_url):
        self.username = username
        self.password = password
        self.base_url = base_url
        self.token = None
        self.token_expiry = None

    def authenticate(self):
        """Obtain a new authentication token"""
        response = requests.post(
            f'{self.base_url}/v2/authorize',
            json={'userName': self.username, 'password': self.password}
        )
        data = response.json()
        self.token = data['authToken']
        self.token_expiry = time.time() + data['expiresIn']
        return self.token

    def ensure_authenticated(self):
        """Re-authenticate if token is expired or missing"""
        if not self.token or time.time() >= self.token_expiry - 60:
            self.authenticate()

    def make_request(self, method, endpoint, **kwargs):
        """Make an authenticated API request"""
        self.ensure_authenticated()
        headers = kwargs.pop('headers', {})
        headers['X-AUTH-TOKEN'] = self.token

        response = requests.request(
            method,
            f'{self.base_url}{endpoint}',
            headers=headers,
            **kwargs
        )

        # Handle token expiration
        if response.status_code == 401:
            self.authenticate()
            headers['X-AUTH-TOKEN'] = self.token
            response = requests.request(method, f'{self.base_url}{endpoint}',
                                       headers=headers, **kwargs)

        return response
```

### Logging Out

Explicitly invalidate a token when done:

**Endpoint**: `PUT /v2/authorize/logout`

```bash
curl -X PUT https://api.alianza.com/v2/authorize/logout \
  -H "X-AUTH-TOKEN: your-auth-token"
```

**Response**: `200 OK` (no body)

## Security Best Practices

### 1. Store Credentials Securely

**Never hardcode credentials**. Use environment variables or secure credential management:

```python
import os

username = os.environ.get('ALIANZA_USERNAME')
password = os.environ.get('ALIANZA_PASSWORD')
```

```javascript
// Node.js with dotenv
require('dotenv').config();

const username = process.env.ALIANZA_USERNAME;
const password = process.env.ALIANZA_PASSWORD;
```

### 2. Protect Tokens in Transit

- **Always use HTTPS**: Never send tokens over HTTP
- **TLS 1.2+**: Ensure your HTTP client uses modern TLS

### 3. Protect Tokens at Rest

- **Server-side**: Store tokens in secure session storage or encrypted databases
- **Client-side**: Use secure storage mechanisms (not localStorage for sensitive apps)
- **Never log tokens**: Redact tokens from application logs

### 4. Implement Token Rotation

For long-running applications:

```python
import threading
import time

class TokenRefresher:
    def __init__(self, client, refresh_interval=3000):  # 50 minutes
        self.client = client
        self.refresh_interval = refresh_interval
        self.running = False

    def start(self):
        """Start automatic token refresh"""
        self.running = True
        self.thread = threading.Thread(target=self._refresh_loop)
        self.thread.daemon = True
        self.thread.start()

    def _refresh_loop(self):
        while self.running:
            time.sleep(self.refresh_interval)
            try:
                self.client.authenticate()
            except Exception as e:
                print(f"Token refresh failed: {e}")

    def stop(self):
        self.running = False
```

### 5. Handle Authentication Errors Gracefully

```python
def handle_auth_error(response):
    if response.status_code == 401:
        # Token expired or invalid
        return {'error': 'Authentication required', 'action': 'refresh_token'}
    elif response.status_code == 403:
        # Authenticated but not authorized
        return {'error': 'Insufficient permissions', 'action': 'check_roles'}
    return None
```

### 6. Use Different Credentials Per Environment

Maintain separate credentials for each environment:

```bash
# Development
ALIANZA_DEV_USERNAME=dev-user
ALIANZA_DEV_PASSWORD=dev-pass
ALIANZA_DEV_URL=https://api.d2.alianza.com

# Production
ALIANZA_PROD_USERNAME=prod-user
ALIANZA_PROD_PASSWORD=prod-pass
ALIANZA_PROD_URL=https://api.alianza.com
```

## User Types and Permissions

Different user types have different access levels:

### Management User
- **Access**: Full partition management
- **Can**: Create/modify accounts, users, devices, numbers
- **Typical Use**: Service provider administrators

### Account User
- **Access**: Manage specific account(s)
- **Can**: Modify account settings, users within account
- **Cannot**: Create new accounts or access other accounts
- **Typical Use**: Business account administrators

### End User
- **Access**: Personal settings only
- **Can**: Modify own voicemail, call forwarding, etc.
- **Cannot**: Modify account or other users
- **Typical Use**: Individual phone users

## Password Management

### Update Password

**Endpoint**: `PUT /v2/authorize`

```bash
curl -X PUT https://api.alianza.com/v2/authorize \
  -H "Content-Type: application/json" \
  -d '{
    "userName": "your-username",
    "password": "current-password",
    "newPassword": "new-secure-password"
  }'
```

**Password Requirements**:
- Minimum 8 characters
- Contains uppercase and lowercase letters
- Contains at least one number
- Contains at least one special character
- Cannot reuse recent passwords

## Error Handling

### Common Authentication Errors

| Status Code | Error | Meaning | Solution |
|-------------|-------|---------|----------|
| 401 | Unauthorized | Invalid credentials or expired token | Re-authenticate |
| 400 | Invalid Request | Malformed login request | Check request format |
| 404 | Not Found | User not found | Verify username |
| 429 | Too Many Requests | Rate limit exceeded | Implement backoff |
| 500 | Internal Error | Server error | Retry with backoff |

### Example Error Response

```json
{
  "errorCode": "UNAUTHORIZED",
  "message": "Invalid credentials",
  "timestamp": "2025-12-18T15:30:00Z",
  "path": "/v2/authorize"
}
```

## Testing Authentication

### Test in Development Environment

Always test authentication in the development environment first:

```bash
# Development
curl -X POST https://api.d2.alianza.com/v2/authorize \
  -H "Content-Type: application/json" \
  -d '{"userName": "dev-user", "password": "dev-pass"}'
```

### Verify Token Validity

Test your token with a simple GET request:

```bash
curl -X GET https://api.alianza.com/v2/authorize/userinfo \
  -H "X-AUTH-TOKEN: your-token"
```

This returns information about the authenticated user.

## Next Steps

- **[Quick Start Guide](quick-start.md)** - Get started with your first API call
- **[Code Examples](../code-examples/)** - See authentication in multiple languages
- **[Best Practices](../advanced/best-practices.md)** - Security and performance tips
- **[Error Handling](../advanced/error-handling.md)** - Handle errors gracefully
