// Alianza API Documentation - Interactive Features

// Theme Toggle
function initThemeToggle() {
  // Support both old (theme-toggle) and new (themeToggle) IDs
  const toggle = document.getElementById('themeToggle') || document.getElementById('theme-toggle');
  const html = document.documentElement;

  if (!toggle) return;

  // Check for saved theme preference or default to light mode
  const currentTheme = localStorage.getItem('theme') || 'light';
  html.setAttribute('data-theme', currentTheme);
  updateToggleButton(currentTheme);

  toggle.addEventListener('click', () => {
    const theme = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    updateToggleButton(theme);
  });

  function updateToggleButton(theme) {
    const icon = toggle.querySelector('i');
    if (icon) {
      // Modern structure with FontAwesome icons
      icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    } else {
      // Old structure with text
      toggle.textContent = theme === 'dark' ? '☀️ Light' : '🌙 Dark';
    }
  }
}

// Copy to Clipboard
function initCopyButtons() {
  document.querySelectorAll('.copy-button').forEach(button => {
    button.addEventListener('click', async () => {
      const codeBlock = button.closest('.code-block').querySelector('code');
      const text = codeBlock.textContent;

      try {
        await navigator.clipboard.writeText(text);
        button.textContent = '✓ Copied!';
        button.classList.add('copied');

        setTimeout(() => {
          button.textContent = 'Copy';
          button.classList.remove('copied');
        }, 2000);
      } catch (err) {
        console.error('Failed to copy:', err);
      }
    });
  });
}

// Language Tabs
function initLanguageTabs() {
  document.querySelectorAll('.language-tabs').forEach(tabContainer => {
    const tabs = tabContainer.querySelectorAll('.language-tab');
    const contents = tabContainer.parentElement.querySelectorAll('.language-content');

    tabs.forEach(tab => {
      tab.addEventListener('click', () => {
        const language = tab.dataset.language;

        // Update active tab
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');

        // Update active content
        contents.forEach(content => {
          if (content.dataset.language === language) {
            content.classList.add('active');
          } else {
            content.classList.remove('active');
          }
        });
      });
    });
  });
}

// Mobile Menu Toggle
function initMobileMenu() {
  // Support both old and new structures
  const toggle = document.getElementById('sidebarToggle') || document.getElementById('mobile-menu-toggle');
  const sidebar = document.querySelector('.sidebar') || document.querySelector('.docs-sidebar');

  if (!toggle || !sidebar) return;

  toggle.addEventListener('click', (e) => {
    e.stopPropagation();
    sidebar.classList.toggle('open');
  });

  // Close sidebar when clicking outside on mobile
  document.addEventListener('click', (e) => {
    if (window.innerWidth <= 768) {
      if (sidebar.classList.contains('open') &&
          !sidebar.contains(e.target) &&
          !toggle.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    }
  });

  // Close sidebar when clicking a link on mobile
  sidebar.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
    });
  });
}

// Smooth Scroll with Offset
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        const offset = 80; // Header height + padding
        const targetPosition = target.offsetTop - offset;
        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      }
    });
  });
}

// Active Navigation Highlighting
function initActiveNav() {
  // Support both old (.sidebar-links) and new (.sidebar-section) structures
  const navLinks = document.querySelectorAll('.sidebar-section a, .sidebar-links a');
  if (navLinks.length === 0) return;

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const id = entry.target.getAttribute('id');
          navLinks.forEach(link => {
            if (link.getAttribute('href').includes('#')) {
              link.classList.remove('active');
              if (link.getAttribute('href') === `#${id}`) {
                link.classList.add('active');
              }
            }
          });
        }
      });
    },
    { rootMargin: '-100px 0px -80% 0px' }
  );

  document.querySelectorAll('h2[id], h3[id]').forEach(heading => {
    observer.observe(heading);
  });
}

// Search Functionality
function initSearch() {
  const searchInput = document.getElementById('search-input');
  const searchResults = document.getElementById('search-results');

  if (!searchInput) return;

  let debounceTimer;
  searchInput.addEventListener('input', (e) => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      const query = e.target.value.toLowerCase();
      if (query.length < 2) {
        searchResults.innerHTML = '';
        searchResults.style.display = 'none';
        return;
      }

      // Simple search through page content
      const results = performSearch(query);
      displaySearchResults(results);
    }, 300);
  });

  function performSearch(query) {
    const results = [];
    const sections = document.querySelectorAll('h2, h3, p, li');

    sections.forEach(section => {
      const text = section.textContent.toLowerCase();
      if (text.includes(query)) {
        results.push({
          title: section.tagName.startsWith('H') ? section.textContent : getHeadingContext(section),
          content: section.textContent.substring(0, 150) + '...',
          element: section
        });
      }
    });

    return results.slice(0, 5); // Limit to 5 results
  }

  function getHeadingContext(element) {
    let heading = element.previousElementSibling;
    while (heading && !heading.tagName.startsWith('H')) {
      heading = heading.previousElementSibling;
    }
    return heading ? heading.textContent : 'Search Result';
  }

  function displaySearchResults(results) {
    if (results.length === 0) {
      searchResults.innerHTML = '<div class="search-result">No results found</div>';
      searchResults.style.display = 'block';
      return;
    }

    searchResults.innerHTML = results.map(result => `
      <div class="search-result" onclick="scrollToElement('${result.element.id || ''}')">
        <div class="search-result-title">${result.title}</div>
        <div class="search-result-content">${result.content}</div>
      </div>
    `).join('');
    searchResults.style.display = 'block';
  }
}

function scrollToElement(id) {
  if (!id) return;
  const element = document.getElementById(id);
  if (element) {
    element.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  document.getElementById('search-results').style.display = 'none';
}

// Code Syntax Highlighting (Simple)
function initSyntaxHighlighting() {
  document.querySelectorAll('pre code').forEach(block => {
    // Simple keyword highlighting
    const keywords = ['function', 'const', 'let', 'var', 'if', 'else', 'for', 'while', 'return', 'import', 'from', 'class', 'def', 'async', 'await'];
    let html = block.innerHTML;

    // Highlight strings
    html = html.replace(/(["'])(.*?)\1/g, '<span class="syntax-string">$1$2$1</span>');

    // Highlight comments
    html = html.replace(/(\/\/.*|#.*)/g, '<span class="syntax-comment">$1</span>');

    // Highlight keywords
    keywords.forEach(keyword => {
      const regex = new RegExp(`\\b${keyword}\\b`, 'g');
      html = html.replace(regex, `<span class="syntax-keyword">${keyword}</span>`);
    });

    block.innerHTML = html;
  });
}

// Table of Contents Generator
function generateTOC() {
  const tocContainer = document.getElementById('toc');
  if (!tocContainer) return;

  // Support both old and new structures
  const mainContent = document.querySelector('.main-content') || document.querySelector('.docs-main');
  if (!mainContent) return;

  const headings = mainContent.querySelectorAll('h2, h3');
  const tocList = document.createElement('ul');
  tocList.className = 'toc-list';

  headings.forEach((heading, index) => {
    if (!heading.id) {
      heading.id = `heading-${index}`;
    }

    const li = document.createElement('li');
    li.className = heading.tagName.toLowerCase();

    const a = document.createElement('a');
    a.href = `#${heading.id}`;
    a.textContent = heading.textContent;
    a.addEventListener('click', (e) => {
      e.preventDefault();
      heading.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });

    li.appendChild(a);
    tocList.appendChild(li);
  });

  tocContainer.appendChild(tocList);
}

// Initialize all features when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  initThemeToggle();
  initCopyButtons();
  initLanguageTabs();
  initMobileMenu();
  initSmoothScroll();
  initActiveNav();
  initSearch();
  generateTOC();
  // initSyntaxHighlighting(); // Optional, can use a library like Prism.js instead
});

// Keyboard shortcuts
document.addEventListener('keydown', (e) => {
  // Ctrl/Cmd + K for search
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault();
    document.getElementById('search-input')?.focus();
  }

  // ESC to close search
  if (e.key === 'Escape') {
    const searchResults = document.getElementById('search-results');
    if (searchResults) {
      searchResults.style.display = 'none';
    }
  }
});
