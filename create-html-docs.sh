#!/bin/bash

# Script to create HTML versions of markdown documentation
# This creates functional HTML pages with proper navigation

echo "Creating HTML documentation files..."

# Function to create HTML file
create_html_page() {
    local output_file="$1"
    local title="$2"
    local md_source="$3"
    local css_path="$4"
    local js_path="$5"
    local index_path="$6"

    cat > "$output_file" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TITLE_PLACEHOLDER - Alianza API</title>
  <link rel="stylesheet" href="CSS_PATH_PLACEHOLDER">
  <style>
    .markdown-note {
      background: var(--accent-tertiary);
      border-left: 4px solid var(--accent-primary);
      padding: 1rem;
      margin: 2rem 0;
      border-radius: var(--radius-md);
    }
    .view-markdown-btn {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.5rem 1rem;
      background: var(--accent-primary);
      color: white;
      text-decoration: none;
      border-radius: var(--radius-md);
    }
  </style>
</head>
<body>
  <header class="docs-header">
    <a href="INDEX_PATH_PLACEHOLDER" class="docs-logo">
      <span>📞</span> Alianza API
    </a>
    <nav class="docs-nav">
      <a href="INDEX_PATH_PLACEHOLDER">Home</a>
      <button id="theme-toggle" class="theme-toggle">🌙 Dark</button>
    </nav>
  </header>

  <div class="docs-container">
    <aside class="docs-sidebar">
      <div class="sidebar-section">
        <div class="sidebar-title">Getting Started</div>
        <ul class="sidebar-links">
          <li><a href="../getting-started/quick-start.html">Quick Start</a></li>
          <li><a href="../getting-started/authentication.html">Authentication</a></li>
        </ul>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-title">Guides</div>
        <ul class="sidebar-links">
          <li><a href="../guides/account-management.html">Account Management</a></li>
          <li><a href="../guides/phone-numbers.html">Phone Numbers</a></li>
        </ul>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-title">Code Examples</div>
        <ul class="sidebar-links">
          <li><a href="../code-examples/python-examples.html">Python</a></li>
          <li><a href="../code-examples/nodejs-examples.html">Node.js</a></li>
        </ul>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-title">Advanced</div>
        <ul class="sidebar-links">
          <li><a href="../advanced/error-handling.html">Error Handling</a></li>
          <li><a href="../advanced/best-practices.html">Best Practices</a></li>
        </ul>
      </div>
    </aside>

    <main class="docs-main">
      <h1>TITLE_PLACEHOLDER</h1>

      <div class="markdown-note">
        <strong>📝 Note:</strong> This page is being converted from markdown to interactive HTML.
        <br>
        <a href="MD_SOURCE_PLACEHOLDER" class="view-markdown-btn">View Markdown Version →</a>
      </div>

      <p>Interactive HTML version coming soon. For now, please refer to the markdown version above.</p>
    </main>
  </div>

  <script src="JS_PATH_PLACEHOLDER"></script>
</body>
</html>
HTMLEOF

    # Replace placeholders
    sed -i "s|TITLE_PLACEHOLDER|$title|g" "$output_file"
    sed -i "s|MD_SOURCE_PLACEHOLDER|$md_source|g" "$output_file"
    sed -i "s|CSS_PATH_PLACEHOLDER|$css_path|g" "$output_file"
    sed -i "s|JS_PATH_PLACEHOLDER|$js_path|g" "$output_file"
    sed -i "s|INDEX_PATH_PLACEHOLDER|$index_path|g" "$output_file"

    echo "✓ Created $output_file"
}

# Create HTML files
create_html_page "docs/html/getting-started/authentication.html" \
    "Authentication Guide" \
    "../../../docs/getting-started/authentication.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/architecture/diagrams.html" \
    "Architecture Diagrams" \
    "../../../docs/architecture/diagrams.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/guides/account-management.html" \
    "Account Management Guide" \
    "../../../docs/guides/account-management.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/guides/phone-numbers.html" \
    "Phone Number Management Guide" \
    "../../../docs/guides/phone-numbers.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/code-examples/python-examples.html" \
    "Python Code Examples" \
    "../../../docs/code-examples/python-examples.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/code-examples/nodejs-examples.html" \
    "Node.js Code Examples" \
    "../../../docs/code-examples/nodejs-examples.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/advanced/error-handling.html" \
    "Error Handling Guide" \
    "../../../docs/advanced/error-handling.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

create_html_page "docs/html/advanced/best-practices.html" \
    "Best Practices Guide" \
    "../../../docs/advanced/best-practices.md" \
    "../css/main.css" \
    "../js/main.js" \
    "../../../index.html"

echo ""
echo "✅ All HTML stub files created!"
echo "Next: Run update script to fix all links in existing HTML files"
