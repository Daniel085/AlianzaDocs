# CLAUDE.md - AI Assistant Guide for AlianzaDocs Repository

## Repository Overview

This repository contains comprehensive API documentation for the **Alianza Public API**, a VoIP/telephony service platform. The repository serves as a centralized documentation hub for developers integrating with Alianza's telecommunications services.

### Repository Purpose
- **Primary Function**: Documentation repository for Alianza Public API v2
- **Target Audience**: Developers, partners, and integrators working with Alianza's VoIP platform
- **Content Type**: API specifications, interactive HTML guides, and reference documentation

## Repository Structure

```
AlianzaDocs/
├── openapi.yaml                                    # OpenAPI 3.0.3 specification (28,330 lines)
├── index.html                                      # Main landing page
├── CLAUDE.md                                       # This file - AI assistant guide
│
├── docs/                                           # Documentation source files
│   ├── getting-started/                            # Markdown source files
│   │   ├── authentication.md
│   │   └── quick-start.md
│   ├── guides/                                     # Guide markdown files
│   │   ├── account-management.md
│   │   └── phone-numbers.md
│   ├── code-examples/                              # Code example markdown files
│   │   ├── python-examples.md
│   │   └── nodejs-examples.md
│   ├── advanced/                                   # Advanced topic markdown files
│   │   ├── best-practices.md
│   │   └── error-handling.md
│   ├── architecture/                               # Architecture documentation
│   │   └── diagrams.md
│   │
│   └── html/                                       # Interactive HTML Documentation
│       ├── index.html                              # Documentation hub (477 lines)
│       ├── css/
│       │   └── main.css                            # Main stylesheet
│       ├── js/
│       │   └── main.js                             # Interactive features (theme toggle, copy buttons)
│       │
│       ├── getting-started/
│       │   ├── authentication.html                 # Authentication guide (665 lines)
│       │   ├── quick-start.html                    # Quick start tutorial
│       │   └── environments.html                   # Environment guide (717 lines)
│       │
│       ├── guides/
│       │   ├── account-management.html             # Account management (907 lines)
│       │   ├── user-provisioning.html              # User provisioning (1,248 lines)
│       │   ├── phone-numbers.html                  # Phone numbers (1,283 lines)
│       │   ├── device-management.html              # Device management
│       │   └── call-routing.html                   # Call routing
│       │
│       ├── code-examples/
│       │   ├── python-examples.html                # Python SDK (989 lines)
│       │   ├── nodejs-examples.html                # Node.js SDK (1,024 lines)
│       │   ├── php-examples.html                   # PHP examples
│       │   ├── java-examples.html                  # Java examples
│       │   ├── csharp-examples.html                # C# / .NET SDK (1,409 lines)
│       │   └── ruby-examples.html                  # Ruby SDK (1,216 lines)
│       │
│       ├── advanced/
│       │   ├── error-handling.html                 # Error handling (674 lines)
│       │   ├── best-practices.html                 # Best practices (810 lines)
│       │   └── webhooks.html                       # Webhooks guide (976 lines)
│       │
│       └── architecture/
│           └── diagrams.html                       # All 11 architecture diagrams (1,123 lines)
│
└── PDFs/                                           # Supplementary PDF documentation
    ├── Alianza API Reference Values.pdf
    ├── Alianza Account Create API.pdf
    ├── Alianza Account Create for BeYOC via API.pdf
    ├── Alianza Phone Numbers via API.pdf
    └── Alianza Specialty Lines via API.pdf
```

### File Statistics

**HTML Documentation:**
- **Total HTML Pages**: 19 interactive pages
- **Total Lines of HTML**: 15,000+ lines
- **Features**: Responsive design, dark/light themes, copy buttons, mobile navigation
- **Structure**: Modern navbar with sidebar navigation

**Source Files:**
- **OpenAPI Spec**: 28,330 lines (875 KB)
- **Markdown Guides**: 9 comprehensive guides (5,091 lines total)
- **PDF Documentation**: 5 supplementary guides

## HTML Documentation Structure

### Modern Page Template

All HTML pages follow a consistent structure with modern, responsive design:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title - Alianza API Documentation</title>
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Modern Navbar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-left">
                <button class="sidebar-toggle" id="sidebarToggle">
                    <i class="fas fa-bars"></i>
                </button>
                <a href="../index.html" class="logo">
                    <i class="fas fa-book"></i>
                    Alianza API Docs
                </a>
            </div>
            <div class="nav-right">
                <button id="themeToggle" class="theme-toggle" aria-label="Toggle theme">
                    <i class="fas fa-moon"></i>
                </button>
            </div>
        </div>
    </nav>

    <!-- Sidebar Navigation -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-content">
            <!-- Navigation sections -->
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="content-wrapper">
            <!-- Page content here -->
        </div>
    </main>

    <script src="../js/main.js"></script>
</body>
</html>
```

### Key HTML Components

**Navbar (`<nav class="navbar">`)**:
- Responsive header with mobile toggle
- Logo with FontAwesome icon
- Theme toggle button (dark/light mode)
- Mobile-friendly hamburger menu

**Sidebar (`<aside class="sidebar" id="sidebar">`)**:
- Consistent navigation across all pages
- Sections: Getting Started, Guides, Advanced, Code Examples, Architecture
- Active page highlighting with `class="active"`
- Collapsible on mobile devices

**Main Content (`<main class="main-content">`)**:
- `<div class="content-wrapper">` for consistent padding
- Page header with icon: `<div class="page-header">`
- Table of contents: `<div class="toc-card">`
- Content sections: `<section class="content-section">`

**Interactive Elements**:
- Code blocks with copy buttons
- Language tabs for multi-language examples
- Info/warning/success boxes
- Collapsible diagrams
- Theme persistence via localStorage

### CSS Classes Reference

**Layout:**
- `.navbar` - Top navigation bar
- `.sidebar` - Side navigation panel
- `.main-content` - Main content area
- `.content-wrapper` - Content container with padding

**Content:**
- `.page-header` - Page title section
- `.toc-card` - Table of contents
- `.content-section` - Major content sections
- `.code-block` - Code snippet containers
- `.diagram-block` - ASCII diagram containers

**Components:**
- `.info-box` - Blue informational alerts
- `.warning-box` - Yellow warning alerts
- `.link-card` - Clickable navigation cards
- `.comparison-grid` - DO/DON'T comparison layout
- `.language-tabs` - Multi-language code tabs

**Utility:**
- `.copy-btn` - Copy to clipboard button
- `.active` - Active navigation item
- `.theme-toggle` - Theme switcher button

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
2. Receive `authToken` in response (1-hour expiration)
3. Include token in `X-AUTH-TOKEN` header for subsequent API calls
4. Alternative: JWT-based authentication via `/v2/authorize/jwt`

### API Environments
- **Development**: `https://api.d2.alianza.com` - Testing and development
- **QA**: `https://api.q2.alianza.com` - Quality assurance and validation
- **Beta**: `https://api.b2.alianza.com` - Pre-production validation
- **Production**: `https://api.alianza.com` - Live customer operations

## Development Workflows

### Working with HTML Documentation

#### Adding a New HTML Page

1. **Create HTML file** in appropriate directory:
   - Getting Started: `docs/html/getting-started/`
   - Guides: `docs/html/guides/`
   - Code Examples: `docs/html/code-examples/`
   - Advanced: `docs/html/advanced/`

2. **Use modern template structure**:
   - Include FontAwesome CDN
   - Use `<nav class="navbar">` header
   - Use `<aside class="sidebar" id="sidebar">` navigation
   - Use `<main class="main-content">` wrapper
   - Include `main.js` script

3. **Update navigation**:
   - Add link to sidebar in ALL pages
   - Mark new page as active: `class="active"`
   - Update index.html if it's a major section

4. **Maintain consistency**:
   - Follow existing CSS class patterns
   - Use FontAwesome icons throughout
   - Include responsive meta tags
   - Add copy buttons to code blocks

#### Updating Existing HTML Pages

1. **Read the file first** (required for Edit tool)
2. **Preserve structure**: Don't change navbar/sidebar/main structure
3. **Update content**: Modify only within `<div class="content-wrapper">`
4. **Test responsive design**: Ensure mobile compatibility
5. **Validate paths**: Verify all relative links work

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
- **Main Branch**: Production-ready documentation
- **Feature Branches**: Use pattern `claude/[descriptive-name]-[session-id]`
- Example: `claude/add-claude-documentation-phI5b`

### Commit Guidelines
When making changes to this repository:

1. **Commit Message Format**:
   ```
   [Type]: Brief description

   - Detailed change 1
   - Detailed change 2
   ```

2. **Types**:
   - `docs`: Documentation updates (HTML, markdown, guides)
   - `spec`: OpenAPI specification changes
   - `fix`: Corrections to existing content
   - `feat`: New documentation pages or features
   - `style`: CSS/design updates

3. **Examples**:
   ```
   docs: Add comprehensive webhooks guide with examples

   docs: Standardize all HTML pages to modern navbar structure

   feat: Add C# and Ruby SDK documentation with complete examples
   ```

### Push Requirements
- Always push to branches starting with `claude/` and ending with session ID
- Use: `git push -u origin <branch-name>`
- Retry with exponential backoff on network failures (2s, 4s, 8s, 16s)
- Never push directly to main/master without explicit permission

## AI Assistant Best Practices

### Understanding User Requests

#### HTML Documentation Updates
When asked to update HTML documentation:
1. Read the existing file to understand structure
2. Preserve the modern navbar/sidebar/main wrapper
3. Update only content within `<div class="content-wrapper">`
4. Maintain consistency with other pages
5. Test all relative links
6. Ensure FontAwesome icons are used
7. Keep responsive design intact

#### Creating New Documentation Pages
When creating new HTML pages:
1. Start with the modern template structure
2. Include all required sections (navbar, sidebar, main)
3. Add to sidebar navigation on ALL pages
4. Follow CSS class naming conventions
5. Include interactive features (copy buttons, theme toggle)
6. Aim for 600-1,200 lines for comprehensive content
7. Add proper FontAwesome icons throughout

#### Maintaining Consistency
When working on multiple pages:
1. All pages must use modern navbar/sidebar structure
2. All pages must include FontAwesome CDN
3. Theme toggle ID must be `themeToggle` (not `theme-toggle`)
4. Sidebar must have `id="sidebar"` for mobile toggle
5. Use consistent icon patterns across similar pages
6. Follow existing CSS class patterns

### Common Tasks

#### Adding a New Endpoint to OpenAPI
1. Read existing similar endpoints for pattern consistency
2. Add to `paths:` section in alphabetical order
3. Include all HTTP methods (GET, POST, PUT, DELETE, PATCH)
4. Define request/response schemas
5. Add proper tags for categorization
6. Include security requirements
7. Validate YAML syntax

#### Creating a New Guide Page
1. Create markdown source in `docs/[category]/`
2. Create HTML version in `docs/html/[category]/`
3. Use modern template with navbar/sidebar
4. Include comprehensive examples (600+ lines)
5. Add to sidebar navigation on all pages
6. Include interactive features (copy buttons, tabs)
7. Add to index.html if major section

#### Updating Schema Definitions
1. Locate schema in `components.schemas` section (line 21997+)
2. Understand referenced schemas
3. Maintain property naming conventions (camelCase)
4. Include descriptions for all properties
5. Define required fields appropriately
6. Add examples where helpful

### Conventions to Follow

#### HTML Structure
- **All pages**: Modern navbar + sidebar + main-content structure
- **IDs**: `sidebarToggle` for menu button, `themeToggle` for theme button
- **Active links**: Use `class="active"` in sidebar
- **Icons**: FontAwesome 6.4.0 for all icons
- **Paths**: Relative paths based on file location (`../` for parent directory)

#### CSS Classes
- **Layouts**: Use `.navbar`, `.sidebar`, `.main-content`, `.content-wrapper`
- **Sections**: Use `.content-section` for major sections
- **Alerts**: Use `.info-box`, `.warning-box` for notices
- **Code**: Use `.code-block` with `.copy-btn` buttons
- **Cards**: Use `.link-card` for navigation cards

#### Naming Conventions
- **Endpoints**: `/v2/resource-name/sub-resource`
- **Schema Names**: PascalCase (e.g., `AccountDevice`, `UserProfile`)
- **Property Names**: camelCase (e.g., `firstName`, `phoneNumber`)
- **Operation IDs**: Action + Resource (e.g., `getAccount`, `createDevice`)
- **HTML Files**: kebab-case (e.g., `user-provisioning.html`, `best-practices.html`)

#### Documentation Standards
- Always include descriptions for endpoints, schemas, and properties
- Use present tense in descriptions
- Be concise but complete
- Include examples for complex schemas
- Cross-reference related resources using links
- Aim for 600-1,200 lines for comprehensive HTML pages
- Include interactive elements (copy buttons, theme toggle)

#### Version Control
- Read files before editing (required by Edit tool)
- Make atomic commits (one logical change per commit)
- Write clear commit messages explaining what and why
- Remove temporary files before committing
- Test changes locally when possible

## Technical Stack

### File Formats
- **HTML5**: Interactive documentation pages
- **CSS3**: Modern responsive styling
- **JavaScript**: Interactive features (ES6+)
- **OpenAPI 3.0.3**: YAML format for API specification
- **Markdown**: Source documentation files
- **PDF**: Supplementary documentation (read-only)

### External Dependencies
- **FontAwesome 6.4.0**: Icon library (CDN)
- **Google Fonts**: Typography (if used)

### Tools and Validation
- YAML linters for syntax validation
- OpenAPI validators for spec compliance
- HTML/CSS validators for web standards
- Git for version control

### API Characteristics
- **Protocol**: REST over HTTPS
- **Authentication**: Token-based (X-AUTH-TOKEN header)
- **Data Format**: JSON request/response bodies
- **Versioning**: URI versioning (`/v2/`)
- **Rate Limiting**: 100 requests/second

## Troubleshooting

### Common Issues

#### Large File Handling
**Problem**: OpenAPI file exceeds read limits (875 KB, 28,330 lines)
**Solution**:
- Use offset and limit parameters with Read tool
- Use Grep for searching specific content
- Read only necessary sections

#### HTML Structure Inconsistencies
**Problem**: Some pages have different navbar/sidebar structure
**Solution**:
- All pages must use modern template (navbar, not docs-header)
- Include FontAwesome CDN on all pages
- Use `id="themeToggle"` (not `theme-toggle`)
- Ensure sidebar has `id="sidebar"`

#### Broken Links in Documentation
**Problem**: Links return 404 errors
**Solution**:
- Verify all referenced pages exist
- Check relative paths based on file location
- Update sidebar navigation on all pages when adding new pages
- Test navigation flow

#### Theme Toggle Not Working
**Problem**: Theme doesn't persist or toggle
**Solution**:
- Ensure `id="themeToggle"` on button
- Verify `main.js` is loaded
- Check localStorage permissions
- Confirm CSS variables are defined

#### Mobile Navigation Issues
**Problem**: Sidebar doesn't toggle on mobile
**Solution**:
- Ensure sidebar has `id="sidebar"`
- Verify toggle button has `id="sidebarToggle"`
- Check `main.js` event listeners
- Test responsive breakpoints

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
- Check for untracked files (`git status`)
- Ensure all changes are committed

## Quick Reference

### Repository Stats
- **HTML Pages**: 19 interactive documentation pages
- **Total HTML Lines**: 15,000+ lines
- **Markdown Guides**: 9 comprehensive guides
- **Primary Spec**: openapi.yaml (28,330 lines, 875 KB)
- **PDF Guides**: 5 supplementary documents
- **API Version**: v2
- **OpenAPI Version**: 3.0.3

### Key HTML Pages
- **Main Hub**: `docs/html/index.html` (477 lines)
- **Architecture**: `docs/html/architecture/diagrams.html` (1,123 lines - all 11 diagrams)
- **Phone Numbers**: `docs/html/guides/phone-numbers.html` (1,283 lines)
- **User Provisioning**: `docs/html/guides/user-provisioning.html` (1,248 lines)
- **C# Examples**: `docs/html/code-examples/csharp-examples.html` (1,409 lines)
- **Ruby Examples**: `docs/html/code-examples/ruby-examples.html` (1,216 lines)
- **Node.js Examples**: `docs/html/code-examples/nodejs-examples.html` (1,024 lines)
- **Python Examples**: `docs/html/code-examples/python-examples.html` (989 lines)
- **Webhooks**: `docs/html/advanced/webhooks.html` (976 lines)

### Key Line Numbers in openapi.yaml
- **Lines 1-135**: Metadata, servers, security, tags
- **Line 136**: Start of `paths:` section
- **Lines 136-21996**: API endpoint definitions
- **Line 21997**: Start of `components:` section
- **Lines 21997-end**: Schemas, responses, parameters, examples

### Essential Commands

```bash
# HTML Documentation
find docs/html -name "*.html" -type f                 # List all HTML files
grep -l "navbar" docs/html/**/*.html                  # Find pages with modern navbar
grep -l "docs-header" docs/html/**/*.html             # Find pages with old structure

# OpenAPI Specification
grep -E "^\s{2}/v2/endpoint:" openapi.yaml            # Find specific endpoint
grep -cE "^\s{2}/v2/" openapi.yaml                    # Count total endpoints
grep -n "SchemaName:" openapi.yaml                    # Search for schema
yamllint openapi.yaml                                 # Validate YAML syntax

# Git Operations
git status                                             # Check working tree
git add . && git commit -m "message"                  # Commit changes
git push -u origin claude/branch-name-sessionid       # Push to feature branch

# File Information
wc -l openapi.yaml                                    # Count lines
ls -lh openapi.yaml                                   # Check file size
find docs/html -name "*.html" | wc -l                 # Count HTML files
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

### Web Technologies
- **FontAwesome 6.4.0**: https://fontawesome.com/v6/icons
- **MDN Web Docs**: https://developer.mozilla.org/
- **CSS Variables**: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

### Contact
- Reach out to Alianza account manager for:
  - API credentials
  - Authentication tokens
  - Access to environments
  - Updated documentation

## Changelog

### 2025-12-25
- Created comprehensive HTML documentation (19 interactive pages, 15,000+ lines)
- Added 6 new landing pages to fix 404 errors:
  - Main documentation index
  - Environments guide (Dev/QA/Beta/Production)
  - User provisioning guide
  - Webhooks guide
  - C# / .NET SDK examples
  - Ruby SDK examples
- Completed Architecture Diagrams page with all 11 diagrams:
  - Platform Hierarchy & Data Model
  - Authentication Flow
  - Account Creation Workflow
  - Phone Number Lifecycle
  - Call Routing Architecture
  - BeYOC Architecture
  - Multi-Environment Architecture
  - Emergency Call (E911) Flow
  - Bulk Operations Flow
  - System Integration Architecture
  - Device Provisioning State Machine
- Standardized all HTML pages to modern navbar/sidebar structure
- Added FontAwesome 6.4.0 icons throughout
- Implemented responsive design with mobile navigation
- Added theme toggle (dark/light mode) with persistence
- Created interactive features (copy buttons, language tabs)
- Updated 11 pages from old structure to modern structure

### 2025-12-18
- Initial creation of CLAUDE.md
- Documented repository structure and purpose
- Added comprehensive guide for AI assistants
- Included best practices and conventions
- Added troubleshooting section

---

**Note for AI Assistants**: This document should be updated whenever significant changes are made to the repository structure, workflows, or conventions. Always read this file first when starting work on this repository to understand the current state and practices.
