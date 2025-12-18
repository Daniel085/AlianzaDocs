# HTML Documentation

Beautiful, interactive HTML version of the Alianza API documentation.

## 🎨 Features

- **Modern Design**: Clean, professional interface with dark/light mode
- **Interactive**: Copy-to-clipboard, language tabs, smooth scrolling
- **Responsive**: Works perfectly on mobile, tablet, and desktop
- **Accessible**: Keyboard navigation, semantic HTML, ARIA labels
- **Fast**: Vanilla JavaScript, no heavy frameworks

## 📁 Structure

```
docs/html/
├── README.md                    # This file
├── css/
│   └── main.css                 # Complete design system
├── js/
│   └── main.js                  # Interactive features
├── getting-started/
│   ├── quick-start.html         # Interactive quick start
│   └── authentication.html      # Coming soon
├── guides/                      # Coming soon
├── code-examples/              # Coming soon
└── architecture/               # Coming soon
```

## 🚀 Viewing the Documentation

### Option 1: Open Locally

Simply open `index.html` in your web browser:

```bash
open index.html
# or
google-chrome index.html
# or
firefox index.html
```

### Option 2: Local Server (Recommended)

For best experience, use a local web server:

```bash
# Python 3
python3 -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Node.js (with http-server)
npx http-server -p 8000
```

Then visit: http://localhost:8000

### Option 3: Deploy to GitHub Pages

1. Push to GitHub
2. Go to repository Settings → Pages
3. Select branch and `/` (root) directory
4. Save and visit the provided URL

## 🎨 Design System

### Colors

The design uses CSS custom properties for theming:

- **Light Mode**: Clean whites and blues
- **Dark Mode**: Professional dark grays

Toggle theme with the button in the header or it auto-detects system preference.

### Typography

- **Base Font**: System font stack for performance
- **Mono Font**: Monaco for code blocks
- **Sizes**: Responsive scale from 0.75rem to 3rem

### Components

- **Buttons**: Primary, secondary variants
- **Cards**: Hover effects, shadows
- **Code Blocks**: Syntax highlighting, copy buttons
- **Alerts**: Info, success, warning, danger
- **Tables**: Responsive, hover states
- **Navigation**: Sidebar, header, mobile menu

## 🔧 Interactive Features

### Copy to Clipboard

All code blocks have copy buttons:

```html
<div class="code-block">
  <div class="code-header">
    <span class="code-language">Bash</span>
    <button class="copy-button">Copy</button>
  </div>
  <pre><code>your code here</code></pre>
</div>
```

### Language Tabs

Switch between code examples:

```html
<div class="language-tabs">
  <button class="language-tab active" data-language="python">Python</button>
  <button class="language-tab" data-language="nodejs">Node.js</button>
</div>

<div class="language-content active" data-language="python">
  <!-- Python code -->
</div>

<div class="language-content" data-language="nodejs">
  <!-- Node.js code -->
</div>
```

### Dark/Light Mode

Automatically saves preference to localStorage:

```javascript
// Toggle theme
const theme = document.documentElement.getAttribute('data-theme');
document.documentElement.setAttribute('data-theme', theme === 'dark' ? 'light' : 'dark');
```

### Smooth Scrolling

All anchor links scroll smoothly with header offset.

### Active Navigation

Sidebar highlights current section as you scroll.

## 📝 Creating New Pages

### Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page Title - Alianza API</title>
  <link rel="stylesheet" href="../css/main.css">
</head>
<body>
  <!-- Header -->
  <header class="docs-header">
    <a href="../../index.html" class="docs-logo">
      <span>📞</span> Alianza API
    </a>
    <nav class="docs-nav">
      <a href="../../index.html">Home</a>
      <button id="theme-toggle" class="theme-toggle">🌙 Dark</button>
    </nav>
  </header>

  <div class="docs-container">
    <!-- Sidebar -->
    <aside class="docs-sidebar">
      <!-- Navigation -->
    </aside>

    <!-- Main Content -->
    <main class="docs-main">
      <h1>Page Title</h1>
      <p>Content goes here...</p>
    </main>
  </div>

  <script src="../js/main.js"></script>
</body>
</html>
```

## 🔄 Converting Markdown to HTML

We maintain both formats:

- **Markdown**: Source of truth, easy to edit
- **HTML**: Enhanced viewing experience

### Manual Conversion

Key elements to add when converting:

1. **Wrap code blocks**:
   ```html
   <div class="code-block">
     <div class="code-header">
       <span class="code-language">Python</span>
       <button class="copy-button">Copy</button>
     </div>
     <pre><code>...</code></pre>
   </div>
   ```

2. **Add language tabs** for multi-language examples

3. **Use alerts** for important notes:
   ```html
   <div class="alert alert-warning">
     <strong>⚠️ Warning:</strong> Important message
   </div>
   ```

4. **Create cards** for related links:
   ```html
   <div class="card-grid">
     <div class="card">
       <div class="card-title">Title</div>
       <p>Description</p>
       <a href="#" class="btn btn-primary">Learn More →</a>
     </div>
   </div>
   ```

### Automated Conversion (Future)

Consider using:
- **Marked.js**: Markdown parser
- **markdown-it**: Customizable markdown parser
- **Custom script**: Build step to generate HTML from markdown

## 🎯 Best Practices

### Performance

- Use vanilla JavaScript (no heavy frameworks)
- Lazy load images if added
- Minify CSS/JS for production
- Use CDN for external resources

### Accessibility

- Semantic HTML5 elements
- ARIA labels where needed
- Keyboard navigation support
- Color contrast ratios meet WCAG AA
- Focus indicators visible

### Responsive Design

- Mobile-first approach
- Breakpoint at 768px for tablets
- Collapsible sidebar on mobile
- Touch-friendly buttons (44px minimum)

### SEO

- Descriptive title tags
- Meta descriptions
- Semantic heading hierarchy (h1 → h6)
- Alt text for images (when added)

## 🛠️ Customization

### Change Colors

Edit CSS custom properties in `css/main.css`:

```css
:root {
  --accent-primary: #0066cc;  /* Change primary color */
  --accent-secondary: #0052a3;
  /* ... */
}
```

### Add New Components

Follow existing patterns in `css/main.css`:

```css
.my-component {
  background-color: var(--bg-secondary);
  border-radius: var(--radius-md);
  padding: var(--spacing-lg);
}
```

### Add JavaScript Features

Add to `js/main.js` and initialize in `DOMContentLoaded`:

```javascript
function initMyFeature() {
  // Your code
}

document.addEventListener('DOMContentLoaded', () => {
  initMyFeature();
  // ... other inits
});
```

## 📊 Analytics (Optional)

To track usage, add Google Analytics or similar:

```html
<!-- Add before </head> -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

## 🚀 Next Steps

### Priority Conversions

Convert these markdown files to HTML next:

1. ✅ `getting-started/quick-start.md` → `html/getting-started/quick-start.html`
2. ⏳ `getting-started/authentication.md` → `html/getting-started/authentication.html`
3. ⏳ `guides/account-management.md` → `html/guides/account-management.html`
4. ⏳ `guides/phone-numbers.md` → `html/guides/phone-numbers.html`
5. ⏳ `code-examples/python-examples.md` → `html/code-examples/python-examples.html`
6. ⏳ `code-examples/nodejs-examples.md` → `html/code-examples/nodejs-examples.html`

### Enhancements

Future improvements:

- [ ] Search functionality (full-text)
- [ ] Syntax highlighting library (Prism.js or highlight.js)
- [ ] SVG diagrams for architecture
- [ ] Interactive API explorer
- [ ] Offline support (Service Worker)
- [ ] PDF export
- [ ] Print styles
- [ ] Automated markdown → HTML build

## 📚 Resources

### Frameworks Used

- **None!** Pure vanilla JavaScript and CSS for:
  - Zero dependencies
  - Fast loading
  - Easy maintenance
  - Maximum compatibility

### Optional Libraries

Consider adding:

- **Prism.js**: Syntax highlighting
- **Mermaid.js**: Diagram rendering
- **lunr.js**: Client-side search
- **markdown-it**: Markdown parsing

### Browser Support

Tested and working on:

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 🤝 Contributing

When adding new HTML pages:

1. Follow the existing structure
2. Use CSS custom properties for colors
3. Add to sidebar navigation
4. Test on mobile
5. Check dark mode
6. Validate HTML
7. Update this README

---

**Questions?** See the main [README.md](../../README.md) or check [CLAUDE.md](../../CLAUDE.md) for development guidelines.
