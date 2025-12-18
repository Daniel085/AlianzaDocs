#!/bin/bash

# Script to update all markdown links to HTML links in existing HTML files

echo "Updating links in HTML files..."

# Update index.html
echo "Updating index.html..."
sed -i 's|docs/architecture/diagrams\.md|docs/html/architecture/diagrams.html|g' index.html
sed -i 's|docs/guides/account-management\.md|docs/html/guides/account-management.html|g' index.html
sed -i 's|docs/guides/phone-numbers\.md|docs/html/guides/phone-numbers.html|g' index.html
sed -i 's|docs/advanced/error-handling\.md|docs/html/advanced/error-handling.html|g' index.html
sed -i 's|docs/advanced/best-practices\.md|docs/html/advanced/best-practices.html|g' index.html
sed -i 's|docs/code-examples/python-examples\.md|docs/html/code-examples/python-examples.html|g' index.html
sed -i 's|docs/code-examples/nodejs-examples\.md|docs/html/code-examples/nodejs-examples.html|g' index.html
echo "✓ Updated index.html"

# Update quick-start.html
echo "Updating quick-start.html..."
sed -i 's|../../architecture/diagrams\.md|../architecture/diagrams.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../../guides/account-management\.md|../guides/account-management.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../../guides/phone-numbers\.md|../guides/phone-numbers.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../../advanced/error-handling\.md|../advanced/error-handling.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../../advanced/best-practices\.md|../advanced/best-practices.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../code-examples/python-examples\.html|../code-examples/python-examples.html|g' docs/html/getting-started/quick-start.html
sed -i 's|../code-examples/nodejs-examples\.html|../code-examples/nodejs-examples.html|g' docs/html/getting-started/quick-start.html
echo "✓ Updated quick-start.html"

echo ""
echo "✅ All links updated!"
echo ""
echo "Verification:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checking for remaining .md links in HTML files..."
echo ""

MD_COUNT=$(grep -r "\.md[\"']" index.html docs/html/getting-started/quick-start.html | grep -v "\.html" | wc -l)

if [ "$MD_COUNT" -eq 0 ]; then
    echo "✓ No markdown links found in main HTML files!"
    echo "✓ All links now point to HTML versions"
else
    echo "⚠ Found $MD_COUNT remaining markdown links:"
    grep -r "\.md[\"']" index.html docs/html/getting-started/quick-start.html | grep -v "\.html"
fi

echo ""
echo "Link structure:"
echo "  index.html → docs/html/*.html"
echo "  quick-start.html → ../*/...html"
echo ""
