# Phone Number Management Guide

Complete guide to searching, provisioning, porting, and managing telephone numbers with the Alianza API.

## Table of Contents

1. [Overview](#overview)
2. [Phone Number Types](#phone-number-types)
3. [Searching for Numbers](#searching-for-numbers)
4. [Ordering Numbers](#ordering-numbers)
5. [Porting Numbers](#porting-numbers)
6. [Assigning Numbers](#assigning-numbers)
7. [Managing Numbers](#managing-numbers)
8. [Specialty Lines](#specialty-lines)
9. [Best Practices](#best-practices)

## Overview

Telephone numbers (also called TNs or DIDs) are essential for making and receiving calls. The Alianza API provides comprehensive number management capabilities:

- Search available numbers by area code, NPA-NXX, or pattern
- Order new numbers from inventory
- Port numbers from other carriers
- Assign numbers to users or devices
- Configure E911 and directory listing
- Manage toll-free numbers

### Phone Number Lifecycle

See the [Architecture Diagrams](../architecture/diagrams.md#4-phone-number-lifecycle) for a visual representation of the phone number lifecycle.

## Phone Number Types

### Local DIDs (Direct Inward Dialing)

Standard geographic phone numbers:
- **Format**: +1 (NPA) NXX-XXXX (e.g., +1 607-123-4567)
- **Use**: Primary business/residential numbers
- **E911**: Required address registration

### Toll-Free Numbers

Free for callers, charged to account owner:
- **Prefixes**: 800, 888, 877, 866, 855, 844, 833
- **Format**: +1 (8XX) XXX-XXXX
- **Use**: Customer service, sales lines
- **Ordering**: May require additional approval

### Vanity Numbers

Numbers with memorable patterns:
- **Examples**: 1-800-FLOWERS, 1-888-123-4567
- **Availability**: Limited, popular patterns rare
- **Cost**: May have premium pricing

## Searching for Numbers

### Search by Area Code

Find available numbers in a specific area code:

```bash
GET /v2/partition/{partitionId}/telephone-number/search?npa=607&quantity=10
X-AUTH-TOKEN: your-token
```

**Parameters**:
- `npa`: Area code (e.g., 607)
- `quantity`: Number of results (default: 10, max: 100)

**Response**:
```json
{
  "telephoneNumbers": [
    {
      "telephoneNumber": "+16071234567",
      "formatted": "(607) 123-4567",
      "npa": "607",
      "nxx": "123",
      "line": "4567",
      "rateCenter": "BINGHAMTON",
      "state": "NY",
      "lata": "132",
      "available": true
    },
    {
      "telephoneNumber": "+16071234568",
      "formatted": "(607) 123-4568",
      "npa": "607",
      "nxx": "123",
      "line": "4568",
      "rateCenter": "BINGHAMTON",
      "state": "NY",
      "lata": "132",
      "available": true
    }
  ]
}
```

### Search by NPA-NXX

Search within a specific exchange:

```bash
GET /v2/partition/{partitionId}/telephone-number/search?npa=607&nxx=123&quantity=20
X-AUTH-TOKEN: your-token
```

### Search by Rate Center

Find numbers in a specific rate center:

```bash
GET /v2/partition/{partitionId}/telephone-number/search?rateCenter=BINGHAMTON&state=NY&quantity=10
X-AUTH-TOKEN: your-token
```

### Search by Pattern

Find numbers matching a pattern:

```bash
# Search for numbers ending in 0000
GET /v2/partition/{partitionId}/telephone-number/search?pattern=*0000&npa=607

# Search for numbers containing 1234
GET /v2/partition/{partitionId}/telephone-number/search?pattern=*1234*&npa=607
```

### Search Toll-Free Numbers

```bash
GET /v2/partition/{partitionId}/telephone-number/search/tollfree?pattern=*1234&quantity=10
X-AUTH-TOKEN: your-token
```

**Toll-Free Prefixes**:
- 800, 888, 877, 866, 855, 844, 833

## Ordering Numbers

### Order from Search Results

After searching, order a number:

```bash
POST /v2/partition/{partitionId}/telephone-number/order
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "telephoneNumbers": ["+16071234567"],
  "accountId": "acc_123"
}
```

**Response**:
```json
{
  "orderId": "order_xyz789",
  "status": "COMPLETED",
  "telephoneNumbers": [
    {
      "telephoneNumber": "+16071234567",
      "status": "ACTIVE",
      "accountId": "acc_123",
      "orderedDate": "2025-12-18T10:30:00Z"
    }
  ]
}
```

### Bulk Order Numbers

Order multiple numbers at once:

```json
{
  "telephoneNumbers": [
    "+16071234567",
    "+16071234568",
    "+16071234569"
  ],
  "accountId": "acc_123"
}
```

### Order Toll-Free Number

```bash
POST /v2/partition/{partitionId}/telephone-number/order/tollfree
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "telephoneNumber": "+18001234567",
  "accountId": "acc_123"
}
```

## Porting Numbers

**Number porting** transfers a number from another carrier to Alianza.

### Port Request Workflow

```
1. Check portability
   ↓
2. Submit port request
   ↓
3. Provide carrier info
   ↓
4. Wait for carrier approval (7-10 business days)
   ↓
5. Number activated in Alianza
```

### Check Number Portability

Verify a number can be ported:

```bash
GET /v2/partition/{partitionId}/telephone-number/port/check?telephoneNumber=+16071234567
X-AUTH-TOKEN: your-token
```

**Response**:
```json
{
  "telephoneNumber": "+16071234567",
  "portable": true,
  "currentCarrier": "AT&T",
  "lineType": "BUSINESS",
  "estimatedDays": 7
}
```

### Submit Port Request

```bash
POST /v2/partition/{partitionId}/telephone-number/port
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "telephoneNumbers": ["+16071234567"],
  "accountId": "acc_123",
  "subscriber": {
    "firstName": "John",
    "lastName": "Doe",
    "companyName": "Acme Corporation",
    "authorizedName": "John Doe"
  },
  "serviceAddress": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905"
  },
  "billingTelephoneNumber": "+16071234567",
  "accountNumber": "123456789",
  "pin": "1234",
  "requestedDate": "2025-12-25",
  "currentProvider": "AT&T"
}
```

**Key Fields**:
- `subscriber`: Must match losing carrier records exactly
- `accountNumber`: Account number with current carrier
- `pin`: PIN with current carrier (if applicable)
- `requestedDate`: Desired activation date
- `billingTelephoneNumber`: BTN on current carrier account

**Response**:
```json
{
  "portRequestId": "port_abc123",
  "status": "PENDING",
  "telephoneNumbers": ["+16071234567"],
  "submittedDate": "2025-12-18T10:30:00Z",
  "requestedDate": "2025-12-25",
  "estimatedCompletionDate": "2025-12-25"
}
```

### Check Port Status

```bash
GET /v2/partition/{partitionId}/telephone-number/port/{portRequestId}
X-AUTH-TOKEN: your-token
```

**Port Statuses**:
- `PENDING`: Submitted to carrier
- `APPROVED`: Carrier approved
- `IN_PROGRESS`: Port in progress
- `COMPLETED`: Successfully ported
- `REJECTED`: Carrier rejected (see rejection reason)
- `CANCELLED`: Port cancelled

### Cancel Port Request

```bash
DELETE /v2/partition/{partitionId}/telephone-number/port/{portRequestId}
X-AUTH-TOKEN: your-token
```

**Note**: Can only cancel before carrier approval.

## Assigning Numbers

### Assign to End User

Assign a telephone number to an end user:

```bash
PUT /v2/partition/{partitionId}/account/{accountId}/user/{userId}/telephone-number
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "telephoneNumber": "+16071234567",
  "primary": true,
  "e911Address": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "location": "Suite 200"
  }
}
```

### Assign to Device Line

Assign directly to a device line:

```bash
PUT /v2/partition/{partitionId}/account/{accountId}/device/{deviceId}/line/{lineNumber}/telephone-number
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

### Assign to Service

Assign to IVR, hunt group, or other service:

```bash
PUT /v2/partition/{partitionId}/account/{accountId}/ivr/{ivrId}/telephone-number
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "telephoneNumber": "+16071234567"
}
```

## Managing Numbers

### List Account Numbers

Get all numbers for an account:

```bash
GET /v2/partition/{partitionId}/account/{accountId}/telephone-number
X-AUTH-TOKEN: your-token
```

**Response**:
```json
[
  {
    "telephoneNumber": "+16071234567",
    "formatted": "(607) 123-4567",
    "assignedTo": "user_xyz789",
    "assignmentType": "END_USER",
    "primary": true,
    "status": "ACTIVE",
    "e911Registered": true
  },
  {
    "telephoneNumber": "+16071234568",
    "formatted": "(607) 123-4568",
    "assignedTo": "ivr_abc123",
    "assignmentType": "IVR",
    "primary": false,
    "status": "ACTIVE",
    "e911Registered": true
  }
]
```

### Get Number Details

```bash
GET /v2/partition/{partitionId}/telephone-number/{telephoneNumber}
X-AUTH-TOKEN: your-token
```

**Response**:
```json
{
  "telephoneNumber": "+16071234567",
  "formatted": "(607) 123-4567",
  "npa": "607",
  "nxx": "123",
  "status": "ACTIVE",
  "accountId": "acc_123",
  "assignedTo": "user_xyz789",
  "assignmentType": "END_USER",
  "e911": {
    "registered": true,
    "address": {
      "street": "135 Front St",
      "city": "Binghamton",
      "state": "NY",
      "zipCode": "13905",
      "location": "Suite 200"
    }
  },
  "directoryListing": {
    "listed": true,
    "name": "Acme Corporation",
    "address": "135 Front St, Binghamton, NY"
  },
  "callerIdName": "ACME CORP"
}
```

### Update Number Configuration

```bash
PUT /v2/partition/{partitionId}/telephone-number/{telephoneNumber}
Content-Type: application/json
X-AUTH-TOKEN: your-token
```

**Request Body**:
```json
{
  "callerIdName": "ACME SUPPORT",
  "e911Address": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "location": "Suite 300"
  },
  "directoryListing": {
    "listed": false
  }
}
```

### Unassign Number

Remove number from user/device:

```bash
DELETE /v2/partition/{partitionId}/account/{accountId}/user/{userId}/telephone-number/{telephoneNumber}
X-AUTH-TOKEN: your-token
```

### Disconnect/Release Number

Return number to inventory:

```bash
DELETE /v2/partition/{partitionId}/telephone-number/{telephoneNumber}
X-AUTH-TOKEN: your-token
```

**Warning**: Number will be released and may become unavailable.

## Specialty Lines

### Call Queues

Assign numbers to call queues for ACD functionality:

```bash
PUT /v2/partition/{partitionId}/account/{accountId}/call-queue/{queueId}/telephone-number
```

### Business Lines

Enterprise features with advanced routing:

```bash
POST /v2/partition/{partitionId}/account/{accountId}/business-line
```

See `Alianza Specialty Lines via API.pdf` for detailed workflows.

## Best Practices

### 1. E911 Registration

**Always register E911 addresses**:
- Legal requirement for all US numbers
- Register immediately after assignment
- Update when user location changes
- Include suite/floor in location field

```json
{
  "e911Address": {
    "street": "135 Front St",
    "city": "Binghamton",
    "state": "NY",
    "zipCode": "13905",
    "location": "Floor 3, Desk 42"  // Important for large buildings
  }
}
```

### 2. Number Inventory Management

**Monitor your number usage**:
- Track assigned vs unassigned numbers
- Release unused numbers to avoid charges
- Reserve numbers for future use
- Use consistent numbering patterns

### 3. Porting Best Practices

**Successful ports require**:

✅ **Do**:
- Verify current carrier account info exactly
- Request ports at least 2 weeks in advance
- Submit during business hours
- Keep current service active until port completes
- Provide LOA (Letter of Authorization) if required

❌ **Don't**:
- Cancel current service before port completes
- Rush port requests (minimum 7 days)
- Mismatch account holder names
- Forget PIN if carrier requires one

### 4. Caller ID Configuration

Set meaningful caller ID names:

```json
{
  "callerIdName": "ACME SUPPORT"  // Max 15 characters
}
```

**Guidelines**:
- Use all caps
- Maximum 15 characters
- No special characters
- Be descriptive (SUPPORT, SALES, BILLING)

### 5. Directory Listing

Configure directory listing appropriately:

**Listed**:
```json
{
  "directoryListing": {
    "listed": true,
    "name": "Acme Corporation",
    "address": "135 Front St, Binghamton, NY"
  }
}
```

**Unlisted**:
```json
{
  "directoryListing": {
    "listed": false
  }
}
```

### 6. Number Search Strategy

**For best availability**:
1. Search broad area first (NPA only)
2. Narrow to specific exchange (NPA-NXX)
3. Use pattern matching for vanity
4. Order immediately if found (popular numbers go fast)

### 7. Bulk Operations

For large number orders:
- Order in batches of 50-100
- Check inventory before bulk operations
- Use async job tracking
- Validate assignments before deployment

### 8. Toll-Free Considerations

**Toll-free specifics**:
- Higher monthly costs
- Inbound call charges
- May require business verification
- Popular patterns (e.g., *-FLOWERS) rarely available
- Reserve memorable patterns early

### 9. Number Recycling

When releasing numbers:
- Remove all assignments first
- Clear E911 registration
- Remove from call routing
- Wait 90 days before reassignment (FCC rule)

### 10. Monitoring and Alerts

Track number events:
- Port status changes
- Assignment changes
- E911 registration updates
- Directory listing publication

## Code Examples

### Python: Complete Number Management

```python
import requests
import time

class AlianzaNumberManager:
    def __init__(self, base_url, token, partition_id):
        self.base_url = base_url
        self.headers = {
            'X-AUTH-TOKEN': token,
            'Content-Type': 'application/json'
        }
        self.partition_id = partition_id

    def search_numbers(self, npa, quantity=10):
        """Search for available numbers"""
        response = requests.get(
            f'{self.base_url}/v2/partition/{self.partition_id}/telephone-number/search',
            params={'npa': npa, 'quantity': quantity},
            headers=self.headers
        )
        return response.json()['telephoneNumbers']

    def order_number(self, telephone_number, account_id):
        """Order a telephone number"""
        response = requests.post(
            f'{self.base_url}/v2/partition/{self.partition_id}/telephone-number/order',
            json={
                'telephoneNumbers': [telephone_number],
                'accountId': account_id
            },
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

    def assign_to_user(self, account_id, user_id, telephone_number, e911_address):
        """Assign number to user with E911"""
        response = requests.put(
            f'{self.base_url}/v2/partition/{self.partition_id}/account/{account_id}/user/{user_id}/telephone-number',
            json={
                'telephoneNumber': telephone_number,
                'primary': True,
                'e911Address': e911_address
            },
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

    def port_number(self, port_request):
        """Submit number port request"""
        response = requests.post(
            f'{self.base_url}/v2/partition/{self.partition_id}/telephone-number/port',
            json=port_request,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()

    def check_port_status(self, port_request_id):
        """Check port request status"""
        response = requests.get(
            f'{self.base_url}/v2/partition/{self.partition_id}/telephone-number/port/{port_request_id}',
            headers=self.headers
        )
        return response.json()

    def wait_for_port(self, port_request_id, timeout=1800):
        """Wait for port to complete (30 min max for API check)"""
        start_time = time.time()
        while time.time() - start_time < timeout:
            status = self.check_port_status(port_request_id)
            if status['status'] in ['COMPLETED', 'REJECTED', 'CANCELLED']:
                return status
            time.sleep(30)  # Check every 30 seconds
        raise TimeoutError("Port request timeout")

# Usage
manager = AlianzaNumberManager(
    'https://api.alianza.com',
    'your-token',
    'your-partition-id'
)

# Search and order
numbers = manager.search_numbers('607', quantity=5)
print(f"Found {len(numbers)} numbers")

# Order first number
order = manager.order_number(numbers[0]['telephoneNumber'], 'acc_123')
print(f"Ordered: {order}")

# Assign with E911
assignment = manager.assign_to_user(
    'acc_123',
    'user_xyz',
    numbers[0]['telephoneNumber'],
    {
        'street': '135 Front St',
        'city': 'Binghamton',
        'state': 'NY',
        'zipCode': '13905'
    }
)
print(f"Assigned to user: {assignment}")
```

## Next Steps

- **[Device Management](device-management.md)** - Configure phones to use numbers
- **[Call Routing](call-routing.md)** - Route calls to numbers
- **[Account Management](account-management.md)** - Manage accounts owning numbers
- **[Code Examples](../code-examples/)** - More implementation examples

## Additional Resources

- See `Alianza Phone Numbers via API.pdf` for detailed workflows
- FCC regulations on number portability
- E911 compliance requirements
- Toll-free number ordering process
