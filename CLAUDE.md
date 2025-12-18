# CLAUDE.md - AI Assistant Guide for AlianzaDocs Repository

## Repository Overview

This repository contains comprehensive API documentation for the **Alianza Public API**, a VoIP/telephony service platform. The repository serves as a centralized documentation hub for developers integrating with Alianza's telecommunications services.

### Repository Purpose
- **Primary Function**: Documentation repository for Alianza Public API v2
- **Target Audience**: Developers, partners, and integrators working with Alianza's VoIP platform
- **Content Type**: API specifications and reference documentation

## Repository Structure

```
AlianzaDocs/
├── openapi.yaml                                    # OpenAPI 3.0.3 specification (28,330 lines)
├── Alianza API Reference Values.pdf                # Reference values and enumerations
├── Alianza Account Create API.pdf                  # Account creation API documentation
├── Alianza Account Create for BeYOC via API.pdf    # BeYOC (Bring Your Own Carrier) account creation
├── Alianza Phone Numbers via API.pdf               # Phone number management documentation
├── Alianza Specialty Lines via API.pdf             # Specialty lines API documentation
└── CLAUDE.md                                       # This file - AI assistant guide
```

### File Descriptions

#### openapi.yaml (875 KB, 28,330 lines)
The comprehensive OpenAPI 3.0.3 specification file containing:
- **API Information**: Alianza Public API v2
- **Authentication**: X-AUTH-TOKEN header-based authentication
- **Servers**:
  - Development: `https://api.d2.alianza.com`
  - QA: `https://api.q2.alianza.com`
  - Beta: `https://api.b2.alianza.com`
  - Production: `https://api.alianza.com`
- **Paths**: Starts at line 136
- **Components**: Starts at line 21997
- **Major Resource Categories**:
  - Account management (accounts, devices, lines, users)
  - Address validation
  - Authorization and authentication
  - Bulk operations
  - Business lines and hunt groups
  - Call management (groups, parking, CDRs)
  - Calling plans
  - Device management and inventory
  - Emergency notifications (911/Kari's Law compliance)
  - IVR (Interactive Voice Response)
  - Media (audio files, hold music)
  - Phone number management (porting, provisioning)
  - Partitions (multi-tenancy)
  - And many more telephony features

#### PDF Documentation Files
Supplementary documentation covering specific API use cases:
- **Account Creation**: Standard account setup workflows
- **BeYOC Integration**: Bring Your Own Carrier scenarios
- **Phone Number Management**: Number provisioning, porting, and assignment
- **Specialty Lines**: Advanced line configurations
- **Reference Values**: Enumeration values, constants, and lookup data

## Key Concepts

### Alianza Platform Architecture
1. **Partition**: Logical separation between Alianza customers; required for all API interactions
2. **Account**: Basic unit of telephone service for a business or home
3. **End User**: Individual user with assigned devices and phone numbers
4. **Device**: VoIP equipment (hard phones, soft phones) associated with accounts
5. **Device Line**: Configuration defining features available per device
6. **Management User**: Service provider employees who administer partitions
7. **Account User**: Account managers without devices who can manage accounts

### Authentication Flow
1. Use `POST /v2/authorize` endpoint with login credentials
2. Receive `authToken` in response
3. Include token in `X-AUTH-TOKEN` header for subsequent API calls
4. Alternative: JWT-based authentication via `/v2/authorize/jwt`

## Development Workflows

### Working with OpenAPI Specification

#### Reading the OpenAPI File
Due to its large size (875 KB), use these strategies:

1. **Read Specific Sections**:
   ```bash
   # Read header/info (lines 1-135)
   Read with offset=1, limit=135

   # Read paths section (starts at line 136)
   Read with offset=136, limit=500

   # Read components/schemas (starts at line 21997)
   Read with offset=21997, limit=500
   ```

2. **Search for Specific Endpoints**:
   ```bash
   grep -E "^\s{2}/v2/[endpoint-path]:" openapi.yaml
   ```

3. **Find Schema Definitions**:
   ```bash
   grep -A 20 "SchemaName:" openapi.yaml
   ```

#### Common Modifications
When updating the OpenAPI specification:
- **Adding Endpoints**: Add to `paths:` section (starts line 136)
- **Adding Schemas**: Add to `components:` section (starts line 21997)
- **Updating Servers**: Modify server URLs in lines 18-26
- **Authentication**: Modify security schemes in `components.securitySchemes`

### Working with PDF Documentation

#### Extracting Information
PDF files are read-only reference materials:
- Use for understanding workflows and business logic
- Reference when implementing API integrations
- Cross-reference with OpenAPI spec for technical details

#### When to Update PDFs
- PDFs should be replaced entirely when new versions are provided
- Do not attempt to edit PDFs programmatically
- Request updated PDFs from documentation team for changes

## Git Workflow

### Branch Strategy
- **Main Branch**: Production-ready documentation (branch name not specified in current repo)
- **Feature Branches**: Use pattern `claude/[descriptive-name]-[session-id]`
- **Current Branch**: `claude/add-claude-documentation-phI5b`

### Commit Guidelines
When making changes to this repository:

1. **Commit Message Format**:
   ```
   [Type]: Brief description

   - Detailed change 1
   - Detailed change 2
   ```

2. **Types**:
   - `docs`: Documentation updates
   - `spec`: OpenAPI specification changes
   - `fix`: Corrections to existing content
   - `feat`: New documentation or endpoints

3. **Examples**:
   ```
   docs: Add CLAUDE.md AI assistant guide

   spec: Add new endpoint for call recording management

   fix: Correct authentication header name in OpenAPI spec
   ```

### Push Requirements
- Always push to branches starting with `claude/` and ending with session ID
- Use: `git push -u origin <branch-name>`
- Retry with exponential backoff on network failures (2s, 4s, 8s, 16s)
- Never push directly to main/master without explicit permission

## AI Assistant Best Practices

### Understanding User Requests

#### Documentation Updates
When asked to update documentation:
1. Determine which file(s) need changes (OpenAPI vs PDFs)
2. For OpenAPI changes:
   - Read relevant sections first
   - Understand existing patterns
   - Make consistent changes
   - Validate YAML syntax
3. For PDF updates:
   - Note that PDFs cannot be edited programmatically
   - Advise user to provide updated PDF files

#### Searching for Information
When users ask about API capabilities:
1. Search OpenAPI spec using Grep for endpoints: `grep -E "/v2/[keyword]" openapi.yaml`
2. Check operation IDs and descriptions
3. Review schema definitions in components section
4. Cross-reference with PDF documentation for workflows

### Common Tasks

#### Adding a New Endpoint
1. Read existing similar endpoints for pattern consistency
2. Add to `paths:` section in alphabetical order
3. Include all HTTP methods (GET, POST, PUT, DELETE, PATCH)
4. Define request/response schemas
5. Add proper tags for categorization
6. Include security requirements
7. Validate YAML syntax

#### Updating Schema Definitions
1. Locate schema in `components.schemas` section (line 21997+)
2. Understand referenced schemas
3. Maintain property naming conventions (camelCase)
4. Include descriptions for all properties
5. Define required fields appropriately
6. Add examples where helpful

#### Validating Changes
```bash
# Check YAML syntax
yamllint openapi.yaml

# Count lines to verify file integrity
wc -l openapi.yaml

# Search for syntax errors
grep -n "Error\|error" openapi.yaml
```

### Conventions to Follow

#### Naming Conventions
- **Endpoints**: `/v2/resource-name/sub-resource`
- **Schema Names**: PascalCase (e.g., `AccountDevice`, `UserProfile`)
- **Property Names**: camelCase (e.g., `firstName`, `phoneNumber`)
- **Operation IDs**: Action + Resource (e.g., `getAccount`, `createDevice`)

#### Documentation Standards
- Always include descriptions for endpoints, schemas, and properties
- Use present tense in descriptions
- Be concise but complete
- Include examples for complex schemas
- Cross-reference related resources using markdown links

#### Version Control
- Read files before editing (required by Edit tool)
- Make atomic commits (one logical change per commit)
- Write clear commit messages explaining what and why
- Test changes locally when possible (YAML validation)

## Technical Stack

### File Formats
- **OpenAPI 3.0.3**: YAML format for API specification
- **PDF**: Supplementary documentation (read-only)

### Tools and Validation
- YAML linters for syntax validation
- OpenAPI validators for spec compliance
- Git for version control

### API Characteristics
- **Protocol**: REST over HTTPS
- **Authentication**: Token-based (X-AUTH-TOKEN header)
- **Data Format**: JSON request/response bodies
- **Versioning**: URI versioning (`/v2/`)

## Troubleshooting

### Common Issues

#### Large File Handling
**Problem**: OpenAPI file exceeds read limits (875 KB, 28,330 lines)
**Solution**:
- Use offset and limit parameters with Read tool
- Use Grep for searching specific content
- Read only necessary sections

#### YAML Syntax Errors
**Problem**: Invalid YAML after edits
**Solution**:
- Validate indentation (use spaces, not tabs)
- Check for unescaped special characters
- Ensure proper quoting of strings with colons
- Validate with `yamllint` or online validators

#### Git Push Failures
**Problem**: Push rejected or network errors
**Solution**:
- Verify branch name starts with `claude/` and ends with session ID
- Retry with exponential backoff (2s, 4s, 8s, 16s)
- Check branch permissions
- Ensure changes are committed

## Quick Reference

### Repository Stats
- **Total Files**: 6 documentation files + git metadata
- **Primary File**: openapi.yaml (875 KB)
- **File Types**: YAML (1), PDF (5)
- **API Version**: v2
- **OpenAPI Version**: 3.0.3
- **Total Lines**: 28,330 (openapi.yaml)

### Key Line Numbers in openapi.yaml
- **Lines 1-135**: Metadata, servers, security, tags
- **Line 136**: Start of `paths:` section
- **Lines 136-21996**: API endpoint definitions
- **Line 21997**: Start of `components:` section
- **Lines 21997-end**: Schemas, responses, parameters, examples

### Essential Commands
```bash
# Find specific endpoint
grep -E "^\s{2}/v2/endpoint:" openapi.yaml

# Count total endpoints
grep -cE "^\s{2}/v2/" openapi.yaml

# Search for schema
grep -n "SchemaName:" openapi.yaml

# Validate YAML
yamllint openapi.yaml

# Check file size
ls -lh openapi.yaml

# View git status
git status

# Commit changes
git add . && git commit -m "message"

# Push to feature branch
git push -u origin claude/branch-name-sessionid
```

## Resources and References

### Alianza API Resources
- **Development**: https://api.d2.alianza.com
- **QA**: https://api.q2.alianza.com
- **Beta**: https://api.b2.alianza.com
- **Production**: https://api.alianza.com
- **Swagger 2.0 Docs**: https://api.alianza.com/v2/apidocs/

### OpenAPI Specification
- **OpenAPI 3.0.3 Spec**: https://spec.openapis.org/oas/v3.0.3
- **Swagger Editor**: https://editor.swagger.io/

### Contact
- Reach out to Alianza account manager for:
  - API credentials
  - Authentication tokens
  - Access to environments
  - Updated documentation

## Changelog

### 2025-12-18
- Initial creation of CLAUDE.md
- Documented repository structure and purpose
- Added comprehensive guide for AI assistants
- Included best practices and conventions
- Added troubleshooting section

---

**Note for AI Assistants**: This document should be updated whenever significant changes are made to the repository structure, workflows, or conventions. Always read this file first when starting work on this repository to understand the current state and practices.
