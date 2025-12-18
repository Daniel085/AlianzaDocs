# Quick Start Guide

Get up and running with the Alianza API in under 5 minutes. This guide will walk you through authentication and your first API call.

## Prerequisites

Before you begin, ensure you have:

- **API Credentials**: Contact your Alianza account manager to obtain:
  - Username
  - Password
  - Partition ID
- **API Environment**: Choose your environment
  - **Development**: `https://api.d2.alianza.com`
  - **QA**: `https://api.q2.alianza.com`
  - **Beta**: `https://api.b2.alianza.com`
  - **Production**: `https://api.alianza.com`
- **Tools**: Any HTTP client (curl, Postman, or your favorite programming language)

## Step 1: Authenticate and Get Your Token

All API requests require an `X-AUTH-TOKEN` header. First, you need to obtain this token by logging in.

### Request

```bash
curl -X POST https://api.alianza.com/v2/authorize \
  -H "Content-Type: application/json" \
  -d '{
    "userName": "your-username",
    "password": "your-password"
  }'
```

### Response

```json
{
  "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "userId": "user123",
  "partitionId": "partition123",
  "userType": "MANAGEMENT_USER"
}
```

**Save the `authToken` value** - you'll need it for all subsequent requests.

## Step 2: Make Your First API Call

Let's retrieve all accounts in your partition to verify everything is working.

### Request

```bash
curl -X GET https://api.alianza.com/v2/partition/{partitionId}/account \
  -H "X-AUTH-TOKEN: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json"
```

Replace `{partitionId}` with your actual partition ID from the login response.

### Response

```json
[
  {
    "accountId": "account123",
    "accountNumber": "1001",
    "name": "Acme Corporation",
    "status": "ACTIVE",
    "timeZone": "America/New_York",
    "createdDate": "2025-01-15T10:30:00Z"
  }
]
```

## Step 3: Create Your First Account

Now let's create a new account to demonstrate write operations.

### Request

```bash
curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account \
  -H "X-AUTH-TOKEN: your-auth-token" \
  -H "Content-Type: application/json" \
  -d '{
    "accountNumber": "2001",
    "name": "New Business Account",
    "timeZone": "America/Los_Angeles",
    "status": "ACTIVE"
  }'
```

### Response

```json
{
  "accountId": "account456",
  "accountNumber": "2001",
  "name": "New Business Account",
  "status": "ACTIVE",
  "timeZone": "America/Los_Angeles",
  "createdDate": "2025-12-18T15:45:00Z"
}
```

## What's Next?

🎉 Congratulations! You've successfully:
- ✅ Authenticated with the Alianza API
- ✅ Retrieved account data
- ✅ Created a new account

### Continue Your Journey

Explore these guides to build out your integration:

1. **[Authentication Guide](authentication.md)** - Deep dive into auth methods, token management, and security
2. **[Account Management Guide](../guides/account-management.md)** - Complete account lifecycle
3. **[Phone Numbers Guide](../guides/phone-numbers.md)** - Provision and manage phone numbers
4. **[Code Examples](../code-examples/)** - See examples in Python, Node.js, PHP, Ruby, Java, and C#
5. **[Architecture Diagrams](../architecture/diagrams.md)** - Understand the platform architecture

### Common Next Steps

Most integrations follow this pattern:

1. **Create Account** → Set up a business or residential account
2. **Validate Address** → Ensure E911 compliance
3. **Provision Phone Number** → Assign telephone numbers
4. **Create End User** → Add individual users
5. **Configure Device** → Set up VoIP phones
6. **Set Up Call Routing** → Configure IVRs, hunt groups, etc.

See the [Account Management Guide](../guides/account-management.md) for the complete workflow.

## Need Help?

- **API Reference**: Full OpenAPI specification in `openapi.yaml`
- **Support**: Contact your Alianza account manager
- **Environments**: Test in development before deploying to production

## Code Examples in Multiple Languages

Want to see this in your preferred language? Check out our [code examples](../code-examples/) for:

- [Python](../code-examples/python-examples.md)
- [Node.js](../code-examples/nodejs-examples.md)
- [PHP](../code-examples/php-examples.md)
- [Ruby](../code-examples/ruby-examples.md)
- [Java](../code-examples/java-examples.md)
- [C#](../code-examples/csharp-examples.md)
