# Account Management Guide

Complete guide to creating, managing, and configuring accounts in the Alianza platform.

## Table of Contents

1. [Overview](#overview)
2. [Account Basics](#account-basics)
3. [Creating an Account](#creating-an-account)
4. [Managing Accounts](#managing-accounts)
5. [Account Users](#account-users)
6. [End Users](#end-users)
7. [Best Practices](#best-practices)

## Overview

An **Account** is the basic unit of telephone service for a business or residential customer. Each account:

- Belongs to a partition (your service provider space)
- Contains end users (people with phones)
- Has devices (physical/software phones)
- Owns phone numbers
- Has billing and service configuration

### Account Hierarchy

```
Partition
  └── Account
       ├── End Users
       │    └── Phone Numbers
       ├── Devices
       │    └── Device Lines
       ├── Account Users (managers)
       └── Services (IVR, hunt groups, etc.)
```

## Account Basics

### Key Account Properties

| Property | Description | Required | Example |
|----------|-------------|----------|---------|
| `accountNumber` | Unique identifier within partition | Yes | "1001", "ACME-001" |
| `name` | Account display name | Yes | "Acme Corporation" |
| `timeZone` | Account timezone | Yes | "America/New_York" |
| `status` | Account status | No | "ACTIVE", "SUSPENDED" |
| `address` | Physical address | Recommended | For E911 |
| `callingPlanId` | Default calling plan | No | Long distance rules |

### Account Status Values

- **ACTIVE**: Normal operation, can make/receive calls
- **SUSPENDED**: Temporarily disabled, no call service
- **PENDING**: Being provisioned
- **CANCELLED**: Terminated service

## Creating an Account

### Step-by-Step Account Creation

#### 1. Validate Address (E911 Requirement)

Before creating an account, validate the service address for E911 compliance.

```bash
GET /v2/address/validate?address=135 Front St&country=USA&postalCode=13905
```

**Response**:
```json
{
  "valid": true,
  "formatted": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "country": "USA"
  },
  "customerServiceRecord": {
    "latitude": 42.0987,
    "longitude": -75.9180,
    "geocodingAccuracy": "ROOFTOP"
  }
}
```

#### 2. Create Account

```bash
POST /v2/partition/{partitionId}/account
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "accountNumber": "2001",
  "name": "Acme Corporation",
  "timeZone": "America/New_York",
  "status": "ACTIVE",
  "address": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "country": "USA"
  },
  "billingAddress": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "country": "USA"
  },
  "serviceType": "BUSINESS",
  "callingPlanId": "unlimited-us-canada"
}
```

**Response**:
```json
{
  "accountId": "acc_abc123",
  "accountNumber": "2001",
  "name": "Acme Corporation",
  "status": "ACTIVE",
  "timeZone": "America/New_York",
  "partitionId": "part_xyz789",
  "createdDate": "2025-12-18T10:30:00Z",
  "serviceType": "BUSINESS",
  "address": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "country": "USA"
  }
}
```

### Complete Account Setup Workflow

```bash
# 1. Validate address
GET /v2/address/validate?...

# 2. Create account
POST /v2/partition/{partitionId}/account

# 3. Create end user
POST /v2/partition/{partitionId}/account/{accountId}/user

# 4. Provision phone number
POST /v2/partition/{partitionId}/telephone-number/order

# 5. Assign number to user
PUT /v2/partition/{partitionId}/account/{accountId}/user/{userId}/telephone-number

# 6. Configure device
POST /v2/partition/{partitionId}/account/{accountId}/device

# 7. Configure device line
POST /v2/partition/{partitionId}/account/{accountId}/device/{deviceId}/line
```

See the [Architecture Diagrams](../architecture/diagrams.md#3-account-creation-workflow) for a visual workflow.

## Managing Accounts

### List All Accounts

Retrieve all accounts in your partition:

```bash
GET /v2/partition/{partitionId}/account
X-AUTH-TOKEN: your-token
```

**Response**:
```json
[
  {
    "accountId": "acc_123",
    "accountNumber": "1001",
    "name": "Acme Corporation",
    "status": "ACTIVE",
    "createdDate": "2025-01-15T10:30:00Z"
  },
  {
    "accountId": "acc_456",
    "accountNumber": "1002",
    "name": "Widget Industries",
    "status": "ACTIVE",
    "createdDate": "2025-02-20T14:15:00Z"
  }
]
```

### Get Account Details

```bash
GET /v2/partition/{partitionId}/account/{accountId}
X-AUTH-TOKEN: your-token
```

### Update Account

```bash
PUT /v2/partition/{partitionId}/account/{accountId}
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "accountId": "acc_123",
  "name": "Acme Corporation (Updated)",
  "status": "ACTIVE",
  "timeZone": "America/Los_Angeles",
  "callingPlanId": "new-calling-plan"
}
```

**Common Updates**:
- Change account name
- Update timezone
- Change calling plan
- Update address (for E911)
- Suspend/reactivate account

### Delete Account

```bash
DELETE /v2/partition/{partitionId}/account/{accountId}
X-AUTH-TOKEN: your-token
```

**Prerequisites**:
- Remove all users first
- Disconnect all phone numbers
- Delete all devices
- Cancel all services

### Search Accounts

Search by various criteria:

```bash
# By account number
GET /v2/partition/{partitionId}/account?accountNumber=1001

# By name
GET /v2/partition/{partitionId}/account?name=Acme

# By status
GET /v2/partition/{partitionId}/account?status=ACTIVE
```

## Account Users

**Account Users** are account managers without devices who can administer the account.

### Create Account User

```bash
POST /v2/partition/{partitionId}/account/{accountId}/account-user
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "firstName": "Jane",
  "lastName": "Manager",
  "email": "jane@acme.com",
  "userName": "jane.manager",
  "password": "SecurePass123!",
  "role": "ACCOUNT_ADMIN"
}
```

### Account User Permissions

- **ACCOUNT_ADMIN**: Full account management
- **ACCOUNT_USER**: Limited management (users, call settings)
- **BILLING_ADMIN**: Billing and usage reports only

### List Account Users

```bash
GET /v2/partition/{partitionId}/account/{accountId}/account-user
X-AUTH-TOKEN: your-token
```

## End Users

**End Users** are individuals with devices and phone numbers.

### Create End User

```bash
POST /v2/partition/{partitionId}/account/{accountId}/user
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "extension": "1001",
  "email": "john.doe@acme.com",
  "callingPlanId": "unlimited-us-canada",
  "voicemail": {
    "enabled": true,
    "pin": "1234",
    "emailNotification": true
  },
  "callForwarding": {
    "enabled": false
  }
}
```

**Response**:
```json
{
  "userId": "user_xyz789",
  "accountId": "acc_123",
  "firstName": "John",
  "lastName": "Doe",
  "extension": "1001",
  "email": "john.doe@acme.com",
  "status": "ACTIVE",
  "createdDate": "2025-12-18T11:00:00Z"
}
```

### User Configuration Options

**Voicemail**:
```json
{
  "voicemail": {
    "enabled": true,
    "pin": "1234",
    "emailNotification": true,
    "emailAddress": "john@acme.com",
    "transcription": true,
    "greeting": "custom-greeting-media-id"
  }
}
```

**Call Forwarding**:
```json
{
  "callForwarding": {
    "enabled": true,
    "forwardTo": "+15551234567",
    "alwaysForward": false,
    "noAnswerForward": true,
    "noAnswerTimeout": 20,
    "busyForward": true
  }
}
```

**Call Screening**:
```json
{
  "callScreening": {
    "enabled": true,
    "screenUnknown": true,
    "announceCallerName": true,
    "allowedNumbers": ["+15551111111"],
    "blockedNumbers": ["+15552222222"]
  }
}
```

### List Users

```bash
GET /v2/partition/{partitionId}/account/{accountId}/user
X-AUTH-TOKEN: your-token
```

### Update User

```bash
PUT /v2/partition/{partitionId}/account/{accountId}/user/{userId}
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

### Delete User

```bash
DELETE /v2/partition/{partitionId}/account/{accountId}/user/{userId}
X-AUTH-TOKEN: your-token
```

**Prerequisites**:
- Unassign all phone numbers
- Remove device associations
- Disable voicemail

## Best Practices

### 1. Address Validation

**Always validate addresses** before account creation:
- Required for E911 compliance
- Prevents service activation failures
- Ensures accurate emergency services

### 2. Account Numbering

Use a consistent account numbering scheme:

**Good**:
- `ACME-001`, `ACME-002` (for partner/reseller tracking)
- `1001`, `1002`, `1003` (simple sequential)
- `{customerId}-{siteId}` (multi-location)

**Avoid**:
- Random numbers
- Phone numbers as account numbers
- Duplicate numbers across partitions

### 3. Timezone Configuration

Set correct timezone to ensure:
- Accurate CDR timestamps
- Proper business hours routing
- Correct voicemail timestamps

### 4. Bulk User Management

For accounts with many users:
- Use [Bulk Operations](bulk-operations.md) API
- Batch creates in groups of 100-500
- Validate templates before bulk execution

### 5. Account Status Management

Use status appropriately:

**ACTIVE**:
- Normal operation
- All services available

**SUSPENDED**:
- Temporary hold (non-payment, etc.)
- No incoming/outgoing calls
- Voicemail still accessible
- Reversible

**CANCELLED**:
- Permanent termination
- Release phone numbers
- Archive data before cancelling

### 6. Error Handling

Common account creation errors:

| Error | Cause | Solution |
|-------|-------|----------|
| `DUPLICATE_ACCOUNT_NUMBER` | Account number exists | Use unique number |
| `INVALID_ADDRESS` | Address validation failed | Validate first |
| `INVALID_CALLING_PLAN` | Plan doesn't exist | Check available plans |
| `INVALID_TIMEZONE` | Bad timezone string | Use IANA timezone |

### 7. Prevalidation

Use the prevalidation endpoint before creating accounts:

```bash
POST /v2/partition/{partitionId}/account/prevalidate
```

This checks:
- Account number availability
- Address validity
- Calling plan existence
- Service availability at address

### 8. Account History

Track changes with account history:

```bash
GET /v2/partition/{partitionId}/account/accounthistorysearch?accountNumber=1001
```

Returns:
- All modifications
- Timestamps
- User who made changes
- Before/after values

### 9. Multi-Location Accounts

For businesses with multiple locations:

**Option 1: Separate Accounts**
```
Account 1001 (HQ - New York)
Account 1002 (Branch - LA)
Account 1003 (Branch - Chicago)
```

**Option 2: Single Account with Hunt Groups**
```
Account 1001 (Corporate)
  └── Hunt Groups per location
```

Choose based on:
- Billing requirements
- Dial plan complexity
- Management structure

### 10. Service Type Selection

- **BUSINESS**: Multi-user, hunt groups, IVR, etc.
- **RESIDENTIAL**: Simple, single-user focused
- **BEYOC**: Bring Your Own Carrier integration

## Code Examples

### Python: Complete Account Setup

```python
import requests

class AlianzaAccountManager:
    def __init__(self, base_url, token, partition_id):
        self.base_url = base_url
        self.headers = {
            'X-AUTH-TOKEN': token,
            'Content-Type': 'application/json'
        }
        self.partition_id = partition_id

    def validate_address(self, address, postal_code):
        """Validate address for E911"""
        response = requests.get(
            f'{self.base_url}/v2/address/validate',
            params={
                'address': address,
                'country': 'USA',
                'postalCode': postal_code
            },
            headers=self.headers
        )
        return response.json()

    def create_account(self, account_data):
        """Create new account"""
        response = requests.post(
            f'{self.base_url}/v2/partition/{self.partition_id}/account',
            json=account_data,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

    def create_user(self, account_id, user_data):
        """Create end user"""
        response = requests.post(
            f'{self.base_url}/v2/partition/{self.partition_id}/account/{account_id}/user',
            json=user_data,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

# Usage
manager = AlianzaAccountManager(
    'https://api.alianza.com',
    'your-token',
    'your-partition-id'
)

# Validate address
address = manager.validate_address('135 Front St', '13905')

# Create account
account = manager.create_account({
    'accountNumber': '2001',
    'name': 'Acme Corporation',
    'timeZone': 'America/New_York',
    'address': address['formatted']
})

# Create user
user = manager.create_user(account['accountId'], {
    'firstName': 'John',
    'lastName': 'Doe',
    'extension': '1001',
    'email': 'john@acme.com'
})

print(f"Account created: {account['accountId']}")
print(f"User created: {user['userId']}")
```

## Next Steps

- **[Phone Numbers Guide](phone-numbers.md)** - Provision numbers for accounts
- **[Device Management](device-management.md)** - Configure phones
- **[Call Routing](call-routing.md)** - Set up IVRs and hunt groups
- **[Code Examples](../code-examples/)** - More implementation examples

## Additional Resources

- See `Alianza Account Create API.pdf` for detailed workflows
- See `Alianza Account Create for BeYOC via API.pdf` for BeYOC scenarios
- Use account prevalidation to catch errors early
- Monitor account history for audit trails
