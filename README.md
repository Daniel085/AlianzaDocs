# Alianza API Developer Documentation

Welcome to the comprehensive developer documentation for the **Alianza Public API v2** - a powerful VoIP and telecommunications platform API.

## 🚀 Quick Start

New to the Alianza API? Start here:

1. **[Quick Start Guide](docs/getting-started/quick-start.md)** - Get your first API call working in under 5 minutes
2. **[Authentication Guide](docs/getting-started/authentication.md)** - Learn about token-based auth and security
3. **[Architecture Diagrams](docs/architecture/diagrams.md)** - Understand the platform visually

## 📚 What's in This Repository

This repository contains:

- **OpenAPI 3.0.3 Specification** (`openapi.yaml`) - Complete API reference with 28,330 lines covering all endpoints
- **PDF Documentation** - Detailed guides for specific workflows:
  - Account creation
  - BeYOC (Bring Your Own Carrier) integration
  - Phone number management
  - Specialty lines
- **Developer Guides** - Comprehensive how-to guides and best practices
- **Code Examples** - Working examples in Python, Node.js, PHP, Java, C#, and Ruby
- **Architecture Diagrams** - Visual guides to understanding the platform

## 🎯 Popular Use Cases

Jump directly to common integration scenarios:

| Use Case | Guide | Code Example |
|----------|-------|--------------|
| Create a VoIP account | [Account Management](docs/guides/account-management.md) | [Python](docs/code-examples/python-examples.md#create-account) |
| Provision phone numbers | [Phone Numbers](docs/guides/phone-numbers.md) | [Node.js](docs/code-examples/nodejs-examples.md#search-and-order-phone-number) |
| Port existing numbers | [Phone Numbers - Porting](docs/guides/phone-numbers.md#porting-numbers) | [Python](docs/code-examples/python-examples.md) |
| Configure devices | Device Management (see OpenAPI spec) | Coming soon |
| Set up call routing | Call Routing (see OpenAPI spec) | Coming soon |

## 📖 Documentation Structure

### Getting Started

Perfect for developers new to the Alianza API:

- **[Quick Start Guide](docs/getting-started/quick-start.md)** - Your first API call in 5 minutes
- **[Authentication Guide](docs/getting-started/authentication.md)** - Token management and security

### Guides

In-depth guides for specific features:

- **[Account Management](docs/guides/account-management.md)** - Create and manage VoIP accounts
- **[Phone Number Management](docs/guides/phone-numbers.md)** - Search, order, port, and assign numbers
- More guides coming soon (Devices, Call Routing, IVR, etc.)

### Architecture

Visual understanding of the platform:

- **[Architecture Diagrams](docs/architecture/diagrams.md)** - 11 comprehensive diagrams including:
  - Platform hierarchy and data model
  - Authentication flow
  - Account creation workflow
  - Phone number lifecycle
  - Call routing architecture
  - BeYOC architecture
  - Emergency call (E911) flow
  - Bulk operations flow
  - And more...

### Code Examples

Production-ready code in multiple languages:

- **[Python Examples](docs/code-examples/python-examples.md)** - Complete SDK with error handling
- **[Node.js Examples](docs/code-examples/nodejs-examples.md)** - JavaScript/TypeScript examples
- **[PHP Examples](docs/code-examples/php-examples.md)** - Coming soon
- **[Java Examples](docs/code-examples/java-examples.md)** - Coming soon
- **[C# Examples](docs/code-examples/csharp-examples.md)** - Coming soon
- **[Ruby Examples](docs/code-examples/ruby-examples.md)** - Coming soon

### Advanced Topics

For production deployments:

- **[Error Handling](docs/advanced/error-handling.md)** - Comprehensive error handling patterns
- **[Best Practices](docs/advanced/best-practices.md)** - Performance, security, and reliability tips

## 🔑 API Environments

Alianza provides multiple environments for development and testing:

| Environment | URL | Purpose |
|-------------|-----|---------|
| **Development** | `https://api.d2.alianza.com` | Initial development and testing |
| **QA** | `https://api.q2.alianza.com` | Integration and user acceptance testing |
| **Beta** | `https://api.b2.alianza.com` | Pre-production validation |
| **Production** | `https://api.alianza.com` | Live production traffic |

**Best Practice**: Always develop and test in the Development environment before moving to Production.

## 🎓 Key Concepts

Understanding these core concepts is essential:

### Platform Hierarchy

```
Partition (Your Service Provider Space)
  └── Accounts (Businesses or Residences)
       ├── End Users (People with phones)
       │    └── Phone Numbers
       ├── Devices (VoIP phones)
       │    └── Device Lines (Line configurations)
       └── Services (IVR, Hunt Groups, etc.)
```

### Authentication

- **Token-based**: All requests use `X-AUTH-TOKEN` header
- **Expiration**: Tokens expire after 1 hour
- **Refresh**: Re-authenticate before expiration
- **Security**: Always use HTTPS

### Core Resources

- **Partition**: Logical separation between customers (multi-tenancy)
- **Account**: Basic unit of telephone service
- **End User**: Individual with phone number(s) and device(s)
- **Device**: VoIP equipment (hard phone or soft phone)
- **Telephone Number**: DID, toll-free, or specialty number
- **Management User**: Administrator without a device

## 🛠️ Working with the OpenAPI Specification

The `openapi.yaml` file is large (875 KB, 28,330 lines). Here's how to work with it:

### Key Line Numbers

- **Lines 1-135**: Metadata, servers, security, tags
- **Line 136**: Start of `paths:` (API endpoints)
- **Line 21,997**: Start of `components:` (schemas, responses)

### Finding Endpoints

```bash
# Search for specific endpoint
grep -E "^\s{2}/v2/account:" openapi.yaml

# Count total endpoints
grep -cE "^\s{2}/v2/" openapi.yaml

# Find schema definition
grep -n "Account:" openapi.yaml
```

### Tools for OpenAPI

- **[Swagger Editor](https://editor.swagger.io/)** - Online editor and validator
- **[Postman](https://www.postman.com/)** - Import OpenAPI spec for testing
- **[OpenAPI Generator](https://openapi-generator.tech/)** - Generate client SDKs

## 📦 API Features

The Alianza API provides comprehensive telephony features:

### Account & User Management
- Create and manage accounts
- Provision end users
- Configure account users (managers)
- Bulk user operations

### Phone Number Management
- Search available numbers by area code
- Order local and toll-free numbers
- Port numbers from other carriers
- E911 address registration
- Directory listing configuration

### Device Management
- Provision VoIP devices
- Configure device lines
- Manage SIP credentials
- Device inventory tracking

### Call Routing
- IVR (Interactive Voice Response) menus
- Hunt groups (simultaneous/sequential)
- Paging groups (one-way broadcast)
- Pickup groups
- Call parking
- Call queues

### Advanced Features
- Call Detail Records (CDRs)
- Emergency notifications (911/Kari's Law)
- Voicemail configuration
- Call forwarding/screening
- Calling plans
- Business lines
- Specialty lines

### Integration Features
- BeYOC (Bring Your Own Carrier)
- SIP trunk management
- Webhook notifications
- Bulk operations
- Address validation

## 🔧 Prerequisites

Before you begin, you'll need:

1. **API Credentials**
   - Username and password
   - Contact your Alianza account manager to obtain these

2. **Partition ID**
   - Your unique partition identifier
   - Provided during account setup

3. **Development Tools**
   - HTTP client (curl, Postman, or programming language)
   - API testing environment
   - Code editor

## 📝 Quick Example

Here's a complete example in Python:

```python
import requests

# 1. Authenticate
auth_response = requests.post(
    'https://api.alianza.com/v2/authorize',
    json={'userName': 'your-user', 'password': 'your-pass'}
)
token = auth_response.json()['authToken']
partition_id = auth_response.json()['partitionId']

# 2. Create headers for authenticated requests
headers = {
    'X-AUTH-TOKEN': token,
    'Content-Type': 'application/json'
}

# 3. List accounts
accounts_response = requests.get(
    f'https://api.alianza.com/v2/partition/{partition_id}/account',
    headers=headers
)
accounts = accounts_response.json()
print(f"Found {len(accounts)} accounts")

# 4. Create new account
new_account = requests.post(
    f'https://api.alianza.com/v2/partition/{partition_id}/account',
    headers=headers,
    json={
        'accountNumber': '2001',
        'name': 'My New Business',
        'timeZone': 'America/New_York'
    }
)
print(f"Created account: {new_account.json()['accountId']}")
```

See the [Quick Start Guide](docs/getting-started/quick-start.md) for more details.

## 📚 Additional Resources

### PDF Documentation

This repository includes detailed PDF guides:

- **`Alianza API Reference Values.pdf`** - Enumeration values and reference data
- **`Alianza Account Create API.pdf`** - Step-by-step account creation
- **`Alianza Account Create for BeYOC via API.pdf`** - BeYOC-specific workflows
- **`Alianza Phone Numbers via API.pdf`** - Complete number management guide
- **`Alianza Specialty Lines via API.pdf`** - Advanced line configurations

### External Resources

- **[OpenAPI 3.0.3 Specification](https://spec.openapis.org/oas/v3.0.3)** - OpenAPI standard
- **[Swagger Editor](https://editor.swagger.io/)** - Edit and visualize OpenAPI specs
- **Production API Documentation**: Contact your account manager

### Support

- **Technical Support**: Contact your Alianza account manager
- **API Credentials**: Request from your account manager
- **Feature Requests**: Reach out to your account representative

## 🤝 Contributing

### For AI Assistants

See **[CLAUDE.md](CLAUDE.md)** for:
- Repository structure and organization
- Development workflows
- Best practices for code generation
- Common tasks and patterns
- Troubleshooting guides

### Documentation Updates

When updating documentation:
1. Follow existing structure and patterns
2. Update the relevant guide in `docs/`
3. Add code examples where applicable
4. Update this README if adding new sections
5. Test all code examples before committing

## 🗺️ Roadmap

Planned documentation additions:

- [ ] Device Management guide
- [ ] Call Routing guide
- [ ] IVR Configuration guide
- [ ] Bulk Operations guide
- [ ] CDR Analysis guide
- [ ] PHP code examples
- [ ] Java code examples
- [ ] C# code examples
- [ ] Ruby code examples
- [ ] Postman collection
- [ ] Interactive tutorials

## 📄 License

This documentation is provided for Alianza API users and partners. The Alianza API itself is subject to Alianza's terms of service and licensing agreements.

## 🆘 Getting Help

### Common Issues

**Authentication Errors**:
- Verify credentials are correct
- Check token hasn't expired (1-hour lifetime)
- Ensure using correct environment URL

**404 Errors**:
- Verify resource ID is correct
- Check you're using the correct partition ID
- Ensure resource exists in your environment

**Rate Limiting**:
- Implement backoff and retry logic
- Use bulk operations for multiple items
- Contact support for rate limit increases

See the [Error Handling Guide](docs/advanced/error-handling.md) for comprehensive troubleshooting.

### Documentation Navigation

```
AlianzaDocs/
├── README.md (← You are here)
├── CLAUDE.md (AI assistant guide)
├── openapi.yaml (Complete API specification)
├── *.pdf (Detailed workflow guides)
└── docs/
    ├── getting-started/
    │   ├── quick-start.md
    │   └── authentication.md
    ├── guides/
    │   ├── account-management.md
    │   └── phone-numbers.md
    ├── architecture/
    │   └── diagrams.md
    ├── code-examples/
    │   ├── python-examples.md
    │   └── nodejs-examples.md
    └── advanced/
        ├── error-handling.md
        └── best-practices.md
```

---

**Ready to get started?** Head to the **[Quick Start Guide](docs/getting-started/quick-start.md)** and make your first API call in under 5 minutes!

**Need to understand the architecture first?** Check out the **[Architecture Diagrams](docs/architecture/diagrams.md)** for visual guides.

**Want to dive deep?** Explore the **[OpenAPI Specification](openapi.yaml)** or browse the **[PDF guides](.)**.
