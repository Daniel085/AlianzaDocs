# HTML Link Mapping

## Current State Analysis

### Links in index.html (Landing Page)

**Markdown Links Found:**
1. `docs/architecture/diagrams.md` → **NEEDS HTML** (3 occurrences)
2. `docs/guides/account-management.md` → **NEEDS HTML** (2 occurrences)
3. `docs/guides/phone-numbers.md` → **NEEDS HTML** (1 occurrence)
4. `docs/advanced/best-practices.md` → **NEEDS HTML** (2 occurrences)
5. `docs/advanced/error-handling.md` → **NEEDS HTML** (1 occurrence)
6. `docs/guides/device-management.md` → Coming soon (can stay .md)
7. `docs/guides/call-routing.md` → Coming soon (can stay .md)
8. `docs/code-examples/php-examples.md` → Coming soon (can stay .md)
9. `docs/code-examples/java-examples.md` → Coming soon (can stay .md)

### Links in docs/html/getting-started/quick-start.html

**Markdown Links Found:**
1. `../../architecture/diagrams.md` → **NEEDS HTML**
2. `../../guides/account-management.md` → **NEEDS HTML** (3 occurrences)
3. `../../guides/phone-numbers.md` → **NEEDS HTML** (2 occurrences)
4. `../../advanced/error-handling.md` → **NEEDS HTML**
5. `../../advanced/best-practices.md` → **NEEDS HTML**

### Links in Sidebar Navigation

**Authentication guide** - Not yet created but needed!

## Conversion Priority

### High Priority (Heavily Linked)
1. ✅ `quick-start.md` → `quick-start.html` (DONE)
2. ⏳ `authentication.md` → `authentication.html` (LINKED IN SIDEBAR)
3. ⏳ `architecture/diagrams.md` → `architecture/diagrams.html` (3+ links)
4. ⏳ `guides/account-management.md` → `guides/account-management.html` (5+ links)
5. ⏳ `guides/phone-numbers.md` → `guides/phone-numbers.html` (3+ links)

### Medium Priority (Referenced)
6. ⏳ `code-examples/python-examples.md` → `code-examples/python-examples.html`
7. ⏳ `code-examples/nodejs-examples.md` → `code-examples/nodejs-examples.html`
8. ⏳ `advanced/error-handling.md` → `advanced/error-handling.html`
9. ⏳ `advanced/best-practices.md` → `advanced/best-practices.html`

### Low Priority (Coming Soon Placeholders)
- `device-management.md` → Can stay as markdown link
- `call-routing.md` → Can stay as markdown link
- `php-examples.md` → Can stay as markdown link
- `java-examples.md` → Can stay as markdown link
- `csharp-examples.md` → Can stay as markdown link
- `ruby-examples.md` → Can stay as markdown link

## Link Updates Needed

### In index.html
Replace:
- `docs/architecture/diagrams.md` → `docs/html/architecture/diagrams.html`
- `docs/guides/account-management.md` → `docs/html/guides/account-management.html`
- `docs/guides/phone-numbers.md` → `docs/html/guides/phone-numbers.html`
- `docs/advanced/error-handling.md` → `docs/html/advanced/error-handling.html`
- `docs/advanced/best-practices.md` → `docs/html/advanced/best-practices.html`

### In quick-start.html
Replace:
- `../../architecture/diagrams.md` → `../architecture/diagrams.html`
- `../../guides/account-management.md` → `../guides/account-management.html`
- `../../guides/phone-numbers.md` → `../guides/phone-numbers.html`
- `../../advanced/error-handling.md` → `../advanced/error-handling.html`
- `../../advanced/best-practices.md` → `../advanced/best-practices.html`

### New HTML Files to Create
1. `docs/html/getting-started/authentication.html`
2. `docs/html/architecture/diagrams.html`
3. `docs/html/guides/account-management.html`
4. `docs/html/guides/phone-numbers.html`
5. `docs/html/code-examples/python-examples.html`
6. `docs/html/code-examples/nodejs-examples.html`
7. `docs/html/advanced/error-handling.html`
8. `docs/html/advanced/best-practices.html`

## Action Plan

1. Create 8 new HTML files from markdown
2. Update all links in index.html
3. Update all links in quick-start.html
4. Update all links in new HTML files to point to HTML versions
5. Test all navigation paths
6. Commit and push

## Status
- [x] Audit complete
- [ ] Create HTML files
- [ ] Update links
- [ ] Test navigation
- [ ] Commit changes
