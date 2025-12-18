# Architecture Diagrams

Visual guides to understanding the Alianza platform architecture, data models, and workflows.

## Table of Contents

1. [Platform Hierarchy & Data Model](#1-platform-hierarchy--data-model)
2. [Authentication Flow](#2-authentication-flow)
3. [Account Creation Workflow](#3-account-creation-workflow)
4. [Phone Number Lifecycle](#4-phone-number-lifecycle)
5. [Call Routing Architecture](#5-call-routing-architecture)
6. [BeYOC Architecture](#6-beyoc-bring-your-own-carrier-architecture)
7. [Multi-Environment Architecture](#7-multi-environment-architecture)
8. [Emergency Call Flow](#8-emergency-call-e911-flow)
9. [Bulk Operations Flow](#9-bulk-operations-flow)
10. [System Integration Architecture](#10-system-integration-architecture)
11. [Device Provisioning State Machine](#11-device-provisioning-state-machine)

---

## 1. Platform Hierarchy & Data Model

Understanding the hierarchical structure of the Alianza platform is fundamental to working with the API.

```
┌─────────────────────────────────────────┐
│           Partition (Tenant)            │
│  (Service Provider's logical space)     │
│  - Multi-tenant isolation               │
│  - Required for all API calls           │
└────────────┬────────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
┌─────▼──────┐  ┌──▼─────────────┐
│ Management │  │    Accounts    │
│   Users    │  │  (Businesses/  │
│            │  │   Residences)  │
│ - Admins   │  │                │
│ - Full     │  │ - Account #    │
│   access   │  │ - Billing      │
└────────────┘  │ - Settings     │
                └───────┬────────┘
                        │
                 ┌──────┴───────┐
                 │              │
          ┌──────▼─────┐  ┌────▼──────┐
          │  End Users │  │  Devices  │
          │            │  │           │
          │ - People   │  │ - Phones  │
          │ - Mailbox  │  │ - MAC addr│
          │ - Settings │  │ - SIP     │
          └──────┬─────┘  └─────┬─────┘
                 │              │
                 │         ┌────▼──────────┐
                 │         │ Device Lines  │
                 │         │               │
                 │         │ - Line config │
                 │         │ - Features    │
                 │         └───────────────┘
                 │
          ┌──────▼────────────────┐
          │  Phone Numbers (TNs)  │
          │                       │
          │ - DID                 │
          │ - Toll-free           │
          │ - E911 info           │
          └───────────────────────┘
```

**Key Relationships**:
- **1 Partition** : **N Accounts** (one-to-many)
- **1 Account** : **N End Users** (one-to-many)
- **1 Account** : **N Devices** (one-to-many)
- **1 End User** : **N Phone Numbers** (one-to-many)
- **1 Device** : **N Device Lines** (one-to-many)

**API Pattern**:
```
/v2/partition/{partitionId}/account
/v2/partition/{partitionId}/account/{accountId}/user
/v2/partition/{partitionId}/account/{accountId}/device
```

---

## 2. Authentication Flow

Token-based authentication is required for all API operations.

```
┌─────────────┐                          ┌──────────────┐
│   Client    │                          │ Alianza API  │
│ Application │                          │   Gateway    │
└──────┬──────┘                          └──────┬───────┘
       │                                        │
       │  1. POST /v2/authorize                 │
       │     {userName, password}               │
       ├───────────────────────────────────────>│
       │                                        │
       │                                   [Validate]
       │                                   [Credentials]
       │                                        │
       │  2. 200 OK                             │
       │     {authToken, expiresIn, userId,     │
       │      partitionId, userType}            │
       │<───────────────────────────────────────┤
       │                                        │
  [Store Token]                                 │
  [Set Expiry]                                  │
       │                                        │
       │  3. GET /v2/partition/123/account      │
       │     Header: X-AUTH-TOKEN: xyz...       │
       ├───────────────────────────────────────>│
       │                                        │
       │                                  [Validate]
       │                                   [Token]
       │                                        │
       │  4. 200 OK                             │
       │     {accounts: [...]}                  │
       │<───────────────────────────────────────┤
       │                                        │
       │  ... (more authenticated requests)     │
       │                                        │
  [Token Expires]                               │
       │                                        │
       │  5. GET /v2/partition/123/users        │
       │     Header: X-AUTH-TOKEN: xyz...       │
       ├───────────────────────────────────────>│
       │                                        │
       │  6. 401 Unauthorized                   │
       │<───────────────────────────────────────┤
       │                                        │
 [Re-authenticate]                              │
       │  7. POST /v2/authorize                 │
       │     {userName, password}               │
       ├───────────────────────────────────────>│
       │                                        │
       │  8. 200 OK {new authToken}             │
       │<───────────────────────────────────────┤
```

**Best Practices**:
- Store token securely (never in client-side localStorage)
- Refresh token proactively before expiration (50-55 minutes)
- Implement 401 error handling with automatic re-authentication
- Log out explicitly to invalidate tokens

---

## 3. Account Creation Workflow

Complete workflow for creating a fully functional VoIP account.

```
┌─────────────────────────────────────────────────┐
│ STEP 1: Validate Address                       │
│ GET /v2/address/validate                        │
│ Purpose: E911 compliance, service availability  │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 2: Create Account                         │
│ POST /v2/partition/{id}/account                │
│ Data: name, accountNumber, timeZone, address   │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 3: Search & Provision Phone Number        │
│ GET /v2/partition/{id}/telephone-number/search │
│ POST /v2/partition/{id}/telephone-number/order │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 4: Create End User                        │
│ POST /v2/partition/{id}/account/{id}/user      │
│ Data: firstName, lastName, extension           │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 5: Create/Assign Device                   │
│ POST /v2/partition/{id}/account/{id}/device    │
│ Data: macAddress, deviceType, model            │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 6: Configure Device Line                  │
│ POST /v2/partition/{id}/account/{id}/          │
│      device/{id}/line                           │
│ Data: lineNumber, features, codecs             │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 7: Assign Phone Number to User/Line       │
│ PUT /v2/partition/{id}/account/{id}/user/{id}/ │
│     telephone-number                            │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ STEP 8: Configure Services (Optional)          │
│ - Voicemail settings                           │
│ - Call forwarding                              │
│ - Call screening                               │
│ - Emergency notifications                      │
└────────────┬────────────────────────────────────┘
             │
             ▼
         ┌───────┐
         │ READY │
         └───────┘
    Account fully provisioned
    User can make/receive calls
```

**Critical Steps**:
1. Address validation is required for E911 compliance
2. Phone number must be in inventory or ordered
3. Device line configuration determines available features
4. All steps should be validated before proceeding

---

## 4. Phone Number Lifecycle

Understanding the states and transitions of telephone numbers.

```
┌─────────────────────────┐
│  INVENTORY AVAILABLE    │
│  (In Alianza pool)      │
└───────────┬─────────────┘
            │
            │ Search Available Numbers
            │ GET /telephone-number/search
            │
            ▼
┌─────────────────────────┐
│   SEARCH RESULTS        │
│   (Available TNs)       │
└───────────┬─────────────┘
            │
            │ Reserve/Order Number
            │ POST /telephone-number/order
            │
            ▼
┌─────────────────────────┐
│      RESERVED           │
│  (Pending assignment)   │
└───────────┬─────────────┘
            │
     ┌──────┴──────┐
     │             │
     │             │ Port from Another Carrier
     │             │ POST /telephone-number/port
     │             │
     │             ▼
     │      ┌─────────────────┐
     │      │  PORT PENDING   │
     │      │  (Waiting)      │
     │      └────────┬────────┘
     │               │
     │               │ Port Complete
     │               │
     │               ▼
     │      ┌─────────────────┐
     │      │  PORT COMPLETE  │
     │      └────────┬────────┘
     │               │
     └───────┬───────┘
             │
             │ Assign to User/Device
             │ PUT /user/{id}/telephone-number
             │
             ▼
┌─────────────────────────┐
│    ACTIVE/ASSIGNED      │
│  (In service)           │
│  - Inbound calls work   │
│  - Outbound caller ID   │
│  - E911 registered      │
└───────────┬─────────────┘
            │
            │ Unassign/Disconnect
            │ DELETE /user/{id}/telephone-number
            │
            ▼
┌─────────────────────────┐
│     DISCONNECTED        │
│  (Available to release) │
└───────────┬─────────────┘
            │
            │ Release to inventory
            │ DELETE /telephone-number/{id}
            │
            ▼
┌─────────────────────────┐
│      RELEASED           │
│  (Returned to pool)     │
└─────────────────────────┘
```

**Special Cases**:
- **Toll-Free Numbers**: Different ordering process
- **Vanity Numbers**: May require manual approval
- **Ported Numbers**: 7-10 business day process
- **Emergency Numbers**: Cannot be released immediately

---

## 5. Call Routing Architecture

How calls flow through the Alianza platform and routing options.

```
                    ┌───────────────────┐
                    │  Incoming Call    │
                    │  (PSTN/SIP Trunk) │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Phone Number     │
                    │  (Telephone #)    │
                    └─────────┬─────────┘
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
            ▼                 ▼                 ▼
    ┌──────────────┐  ┌─────────────┐  ┌──────────────┐
    │ Device Line  │  │  IVR Menu   │  │ Hunt Group   │
    │              │  │             │  │              │
    │ Ring phone   │  │ Press 1...  │  │ Ring multi-  │
    │ directly     │  │ Press 2...  │  │ ple devices  │
    └──────────────┘  └──────┬──────┘  └──────┬───────┘
                             │                │
                   ┌─────────┼────────────┐   │
                   │         │            │   │
                   ▼         ▼            ▼   ▼
            ┌──────────┐ ┌────────┐ ┌─────────────┐
            │ Paging   │ │ Pickup │ │ Call Queue  │
            │ Group    │ │ Group  │ │             │
            │          │ │        │ │ Hold music  │
            │ One-way  │ │ Ring   │ │ Position    │
            │ broadcast│ │ all    │ │ announce    │
            └──────────┘ └────────┘ └──────┬──────┘
                                           │
                                           ▼
                                    ┌─────────────┐
                                    │   Agent     │
                                    │  Answers    │
                                    └─────────────┘

    ┌────────────────────────────────────────────┐
    │ All Call Options Can Also Route To:       │
    │                                            │
    │ • Voicemail                                │
    │ • Call Parking Spot                        │
    │ • External Number (forwarding)             │
    │ • Time-based routing                       │
    │ • Business hours routing                   │
    └────────────────────────────────────────────┘

    Every call generates:
    ┌─────────────────────┐
    │ CDR (Call Detail    │
    │ Record)             │
    │                     │
    │ - Caller ID         │
    │ - Duration          │
    │ - Disposition       │
    │ - Cost/billing      │
    └─────────────────────┘
```

**Routing Strategies**:

**Hunt Group Modes**:
- **Simultaneous**: Ring all devices at once
- **Sequential**: Try devices in order
- **Round-robin**: Distribute calls evenly

**IVR Capabilities**:
- Multi-level menus
- Custom audio prompts
- Dial-by-extension
- Voicemail integration

---

## 6. BeYOC (Bring Your Own Carrier) Architecture

Integration model for customers using their own SIP trunk provider.

```
┌──────────────────────┐
│   Customer's Own     │
│   Carrier/Trunk      │
│   Provider           │
│                      │
│   (PSTN Gateway)     │
└──────────┬───────────┘
           │
           │ SIP Trunk
           │ (Customer manages)
           │
           ▼
┌──────────────────────┐         ┌─────────────────────┐
│   Alianza Platform   │────────>│   Alianza API       │
│   (Soft Switch)      │         │   Management        │
│                      │         │                     │
│ - Call routing       │         │ - Account setup     │
│ - Feature server     │<────────│ - Device config     │
│ - Voicemail          │         │ - User management   │
│ - IVR                │         │ - Reporting         │
│ - Call parking       │         │ - CDR access        │
│ - Hunt groups        │         │                     │
└──────────┬───────────┘         └─────────────────────┘
           │
           │ SIP Registration
           │
           ▼
┌──────────────────────┐
│   End User Devices   │
│                      │
│   - IP Phones        │
│   - Soft phones      │
│   - SIP devices      │
└──────────────────────┘
```

**Key Differences from Standard Deployment**:
- Customer maintains PSTN connectivity
- Customer responsible for trunking costs
- Alianza provides feature server only
- API usage remains the same
- Billing integration may differ

**BeYOC API Endpoints**:
- Same account/user/device management
- Special trunk configuration endpoints
- SIP credential management

See: `Alianza Account Create for BeYOC via API.pdf`

---

## 7. Multi-Environment Architecture

Promotion path from development to production.

```
┌─────────────────────────────────────────────────────┐
│                 DEVELOPMENT                         │
│          https://api.d2.alianza.com                 │
│                                                     │
│  Purpose:                                           │
│  • Initial development                              │
│  • Feature testing                                  │
│  • API exploration                                  │
│  • Integration development                          │
│                                                     │
│  Characteristics:                                   │
│  • Frequent changes                                 │
│  • May have unstable features                       │
│  • Test data only                                   │
│  • Reset periodically                               │
└──────────────────────┬──────────────────────────────┘
                       │
                       │ Promote when stable
                       ▼
┌─────────────────────────────────────────────────────┐
│                      QA                             │
│          https://api.q2.alianza.com                 │
│                                                     │
│  Purpose:                                           │
│  • Integration testing                              │
│  • User acceptance testing                          │
│  • Performance testing                              │
│  • Regression testing                               │
│                                                     │
│  Characteristics:                                   │
│  • Stable API                                       │
│  • Matches production                               │
│  • Controlled test data                             │
└──────────────────────┬──────────────────────────────┘
                       │
                       │ Final validation
                       ▼
┌─────────────────────────────────────────────────────┐
│                     BETA                            │
│          https://api.b2.alianza.com                 │
│                                                     │
│  Purpose:                                           │
│  • Pre-production validation                        │
│  • Pilot deployments                                │
│  • Partner previews                                 │
│  • Production rehearsal                             │
│                                                     │
│  Characteristics:                                   │
│  • Production-like data                             │
│  • Production-like scale                            │
│  • Release candidates                               │
└──────────────────────┬──────────────────────────────┘
                       │
                       │ Go-live
                       ▼
┌─────────────────────────────────────────────────────┐
│                  PRODUCTION                         │
│          https://api.alianza.com                    │
│                                                     │
│  Purpose:                                           │
│  • Live customer traffic                            │
│  • Production workloads                             │
│  • Real billing/CDRs                                │
│                                                     │
│  Characteristics:                                   │
│  • Highly available (99.999%)                       │
│  • Monitored 24/7                                   │
│  • Real customer data                               │
│  • Strict change control                            │
└─────────────────────────────────────────────────────┘
```

**Best Practices**:
- Maintain separate credentials per environment
- Test in dev/QA before production deployment
- Use beta for pilot customers
- Never point production to dev/QA URLs

---

## 8. Emergency Call (E911) Flow

Kari's Law compliance for emergency calling.

```
┌───────────────────┐
│  User Dials 911   │
└─────────┬─────────┘
          │
          ▼
┌─────────────────────────────────┐
│    Alianza Switch Detects       │
│    Emergency Call               │
└─────────┬───────────────────────┘
          │
          │ Parallel Actions:
          │
    ┌─────┼─────┬────────┬────────────┐
    │     │     │        │            │
    ▼     ▼     ▼        ▼            ▼
┌──────┐ ┌────┐ ┌──────┐ ┌─────────┐ ┌──────┐
│Route │ │Log │ │Lookup│ │ Trigger │ │Create│
│ to   │ │ in │ │ E911 │ │ Notif.  │ │ CDR  │
│PSAP  │ │CDR │ │ Addr │ │ Webhook │ │      │
└──┬───┘ └────┘ └──────┘ └────┬────┘ └──────┘
   │                           │
   │                           │
   │                     ┌─────┴─────┐
   │                     │           │
   │                     ▼           ▼
   │              ┌──────────┐ ┌─────────┐
   │              │   SMS    │ │  Email  │
   │              │   to     │ │   to    │
   │              │ Contacts │ │ Contacts│
   │              └──────────┘ └─────────┘
   │
   │ Connect caller to
   │ Public Safety
   │
   ▼
┌─────────────────────────┐
│  PSAP (911 Center)      │
│  Receives call with:    │
│  - Caller ID            │
│  - E911 address         │
│  - Callback number      │
└─────────────────────────┘
```

**Kari's Law Requirements**:
1. Direct routing to 911 (no prefix dialing)
2. Notification sent to designated contact(s)
3. Caller location information transmitted
4. Must work even without fully provisioned service

**Emergency Notification Configuration**:
- Configure via: `POST /v2/partition/{id}/account/{id}/emergency-notification`
- Can set: SMS recipients, email recipients, webhook URLs
- Test notifications without calling 911

---

## 9. Bulk Operations Flow

Managing large numbers of users efficiently.

```
┌────────────────────────────────────────────────┐
│ STEP 1: Create Collection                     │
│                                                │
│ POST /v2/bulk-user-operation/collection       │
│                                                │
│ Purpose: Container for users to operate on    │
│ Returns: collectionId                          │
└──────────────────┬─────────────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────────────┐
│ STEP 2: Add Users to Collection               │
│                                                │
│ POST /v2/bulk-user-operation/collection/      │
│      {collectionId}/{extension}                │
│                                                │
│ Repeat for each user:                          │
│ • User 1001                                    │
│ • User 1002                                    │
│ • User 1003                                    │
│ • ... (can add hundreds/thousands)             │
└──────────────────┬─────────────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────────────┐
│ STEP 3: Create Bulk Job                       │
│                                                │
│ POST /v2/bulk-user-operation/job              │
│ {                                              │
│   "collectionId": "abc123",                    │
│   "operation": "UPDATE_CALLING_PLAN",          │
│   "parameters": {                              │
│     "callingPlanId": "plan456"                 │
│   }                                            │
│ }                                              │
│                                                │
│ Returns: jobId                                 │
└──────────────────┬─────────────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────────────┐
│ STEP 4: Monitor Job Progress                  │
│                                                │
│ GET /v2/bulk-user-operation/job/{jobId}       │
│                                                │
│ Poll every 5-10 seconds                        │
│                                                │
│ Status Progression:                            │
│ PENDING → PROCESSING → COMPLETED               │
│                      ↘ FAILED                  │
│                      ↘ PARTIAL                 │
└──────────────────┬─────────────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────────────┐
│ Job Complete                                   │
│                                                │
│ Response includes:                             │
│ • Total users processed                        │
│ • Successful operations                        │
│ • Failed operations                            │
│ • Error details per user                       │
└────────────────────────────────────────────────┘
```

**Supported Bulk Operations**:
- Update calling plans
- Change voicemail settings
- Modify call forwarding
- Update device configurations
- Delete users
- Provision features

**Best Practices**:
- Batch users into collections of 500-1000
- Poll job status (don't wait synchronously)
- Handle partial failures gracefully
- Log results for audit trail

---

## 10. System Integration Architecture

How external systems integrate with Alianza.

```
┌───────────────────────────────────────────────┐
│        Your System (CRM, Billing, etc.)      │
│                                               │
│  • Customer management                        │
│  • Billing system                             │
│  • Ticketing system                           │
│  • Custom applications                        │
└─────────────────┬─────────────────────────────┘
                  │
                  │ HTTPS REST API Calls
                  │ (JSON over TLS 1.2+)
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│         Alianza API Gateway                     │
│                                                 │
│  Authentication: X-AUTH-TOKEN header            │
│  Rate Limiting: 100 requests/second             │
│  Security: IP whitelisting (optional)           │
└─────────────┬───────────────────────────────────┘
              │
        ┌─────┴─────┬──────────┬──────────┐
        │           │          │          │
        ▼           ▼          ▼          ▼
┌──────────┐ ┌──────────┐ ┌────────┐ ┌─────────┐
│ Accounts │ │ Devices  │ │Numbers │ │ Routing │
│          │ │          │ │        │ │         │
│ - CRUD   │ │ - CRUD   │ │- Search│ │- IVR    │
│ - Search │ │ - Config │ │- Order │ │- Hunt   │
│ - Update │ │ - Lines  │ │- Port  │ │- Queue  │
└────┬─────┘ └────┬─────┘ └───┬────┘ └────┬────┘
     │            │            │           │
     └────────────┴────────────┴───────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│         Alianza VoIP Platform                   │
│           (Soft Switch)                         │
│                                                 │
│  • Call processing                              │
│  • Feature servers                              │
│  • Media servers                                │
│  • Voicemail                                    │
└─────────────┬───────────────────────────────────┘
              │
        ┌─────┴─────┐
        │           │
        ▼           ▼
┌──────────┐   ┌─────────┐
│   PSTN   │   │   SIP   │
│ Gateway  │   │ Devices │
└──────────┘   └─────────┘

┌─────────────────────────────────────────────────┐
│  Async Events (Future Capability)              │
│                                                 │
│  Webhooks for:                                  │
│  • Call completed (CDR)                         │
│  • Voicemail received                           │
│  • Number ported (status change)                │
│  • Device registered/unregistered               │
│  • Emergency call (911)                         │
└─────────────────────────────────────────────────┘
```

**Integration Patterns**:

**1. Synchronous Request/Response**:
- Create/update operations
- Real-time queries
- Immediate validation

**2. Polling**:
- CDR retrieval
- Bulk operation status
- Port request status

**3. Webhooks** (if configured):
- Emergency notifications
- Event-driven updates

---

## 11. Device Provisioning State Machine

Lifecycle states of VoIP devices.

```
┌─────────────────────────┐
│  UNASSIGNED             │
│  (Device in inventory)  │
│                         │
│  • Not linked to user   │
│  • No configuration     │
└───────────┬─────────────┘
            │
            │ POST /account/{id}/device
            │ {macAddress, model, type}
            │
            ▼
┌─────────────────────────┐
│  CREATED                │
│  (Device record exists) │
│                         │
│  • MAC address recorded │
│  • Model identified     │
└───────────┬─────────────┘
            │
            │ POST /device/{id}/line
            │ Configure line 1, 2, etc.
            │
            ▼
┌─────────────────────────┐
│  CONFIGURED             │
│  (Lines provisioned)    │
│                         │
│  • SIP credentials set  │
│  • Line features set    │
│  • Codecs configured    │
└───────────┬─────────────┘
            │
            │ Device boots,
            │ downloads config,
            │ sends SIP REGISTER
            │
            ▼
┌─────────────────────────┐
│  REGISTERED             │
│  (Device online)        │
│                         │
│  • SIP registration OK  │
│  • Can receive calls    │
│  • Shows as online      │
└───────────┬─────────────┘
            │
      ┌─────┴─────┐
      │           │
      │      [Network issue,
      │       power loss]
      │           │
      │           ▼
      │     ┌─────────────┐
      │     │UNREGISTERED │
      │     │(Offline)    │
      │     └──────┬──────┘
      │            │
      │            │ Device reconnects
      │            │
      │     ┌──────┘
      │     │
      └─────┤
            │
            │ PUT /device/{id}
            │ {status: "INACTIVE"}
            │
            ▼
┌─────────────────────────┐
│  INACTIVE               │
│  (Deactivated)          │
│                         │
│  • Cannot register      │
│  • Config unavailable   │
│  • Calls blocked        │
└───────────┬─────────────┘
            │
            │ DELETE /device/{id}
            │
            ▼
┌─────────────────────────┐
│  DELETED                │
│  (Removed from system)  │
│                         │
│  • Record removed       │
│  • MAC available reuse  │
└─────────────────────────┘
```

**Device States**:
- **UNASSIGNED**: In inventory, not configured
- **CREATED**: Record exists, basic info set
- **CONFIGURED**: Lines and features provisioned
- **REGISTERED**: Online and ready (SIP registered)
- **UNREGISTERED**: Temporarily offline
- **INACTIVE**: Administratively disabled
- **DELETED**: Removed from system

**Troubleshooting**:
- Device stuck in CREATED → Check line configuration
- Device stuck in CONFIGURED → Check network/DHCP/TFTP
- REGISTERED → UNREGISTERED → Check network connectivity
- Cannot delete → Unassign from user first

---

## Next Steps

Now that you understand the architecture:

1. **[Quick Start Guide](../getting-started/quick-start.md)** - Get hands-on
2. **[Account Management Guide](../guides/account-management.md)** - Implement workflows
3. **[Code Examples](../code-examples/)** - See it in code
4. **[Best Practices](../advanced/best-practices.md)** - Optimize your integration

## Additional Resources

- **OpenAPI Specification**: `openapi.yaml` - Complete API reference
- **PDF Guides**: Detailed workflows for specific use cases
- **Support**: Contact your Alianza account manager
