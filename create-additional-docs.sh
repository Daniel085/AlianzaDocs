#!/bin/bash

# Create the 4 missing HTML documentation pages with actual content

echo "Creating comprehensive HTML documentation pages..."

# 1. Device Management Guide
cat > docs/html/guides/device-management.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Device Management Guide - Alianza API">
  <title>Device Management Guide - Alianza API</title>
  <link rel="stylesheet" href="../css/main.css">
</head>
<body>
  <header class="docs-header">
    <a href="../../../index.html" class="docs-logo">
      <span>📞</span> Alianza API
    </a>
    <nav class="docs-nav">
      <a href="../../../index.html">Home</a>
      <a href="../architecture/diagrams.html">Architecture</a>
      <a href="account-management.html">Guides</a>
      <a href="../../../openapi.yaml">API Reference</a>
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
          <li><a href="account-management.html">Account Management</a></li>
          <li><a href="phone-numbers.html">Phone Numbers</a></li>
          <li><a href="device-management.html" class="active">Device Management</a></li>
          <li><a href="call-routing.html">Call Routing</a></li>
        </ul>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-title">Code Examples</div>
        <ul class="sidebar-links">
          <li><a href="../code-examples/python-examples.html">Python</a></li>
          <li><a href="../code-examples/nodejs-examples.html">Node.js</a></li>
          <li><a href="../code-examples/php-examples.html">PHP</a></li>
          <li><a href="../code-examples/java-examples.html">Java</a></li>
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
      <h1>Device Management Guide</h1>
      <p style="font-size: 1.2rem;">Complete guide to provisioning, configuring, and managing VoIP devices with the Alianza API.</p>

      <div class="alert alert-info">
        <strong>📱 What is a Device?</strong> A device is VoIP equipment (IP phone, soft phone, ATA) that connects to the Alianza platform for making and receiving calls.
      </div>

      <h2 id="overview">Overview</h2>
      <p>Device management in Alianza includes:</p>
      <ul>
        <li>Creating and configuring VoIP devices</li>
        <li>Managing device lines and features</li>
        <li>Setting up SIP credentials</li>
        <li>Device inventory management</li>
        <li>Device provisioning and auto-configuration</li>
      </ul>

      <h2 id="device-types">Device Types</h2>
      <div class="card-grid">
        <div class="card">
          <div class="card-title">🖥️ Hard Phones</div>
          <p>Physical IP phones with displays, buttons, and advanced features. Examples: Yealink, Polycom, Cisco phones.</p>
        </div>
        <div class="card">
          <div class="card-title">💻 Soft Phones</div>
          <p>Software applications that turn computers or mobile devices into phones. Examples: Desktop apps, mobile apps.</p>
        </div>
        <div class="card">
          <div class="card-title">📞 ATAs</div>
          <p>Analog Telephone Adapters that connect traditional phones to VoIP networks.</p>
        </div>
      </div>

      <h2 id="creating-device">Creating a Device</h2>
      <p>Devices must be associated with an account before they can be used.</p>

      <h3>Request</h3>
      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code>curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/device \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "macAddress": "00:15:65:4D:12:34",
    "deviceType": "IP_PHONE",
    "model": "Yealink T46G",
    "description": "Conference Room Phone"
  }'</code></pre>
      </div>

      <h3>Response</h3>
      <div class="code-block">
        <div class="code-header">
          <span class="code-language">JSON</span>
        </div>
        <pre><code>{
  "deviceId": "device_abc123",
  "macAddress": "00:15:65:4D:12:34",
  "deviceType": "IP_PHONE",
  "model": "Yealink T46G",
  "status": "PENDING_CONFIGURATION",
  "createdDate": "2025-12-18T10:30:00Z"
}</code></pre>
      </div>

      <h2 id="device-lines">Configuring Device Lines</h2>
      <p>Each device can have multiple lines. Lines define the features available on each button/line appearance.</p>

      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code>curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/device/{deviceId}/line \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "lineNumber": 1,
    "userId": "user_xyz789",
    "features": {
      "voicemail": true,
      "callWaiting": true,
      "callForwarding": true,
      "doNotDisturb": true
    }
  }'</code></pre>
      </div>

      <h2 id="sip-credentials">SIP Credentials</h2>
      <p>Devices use SIP credentials to register with the Alianza platform.</p>

      <div class="alert alert-warning">
        <strong>🔒 Security:</strong> SIP credentials are automatically generated. Store them securely and never expose them in logs or client-side code.
      </div>

      <h2 id="device-inventory">Device Inventory Management</h2>
      <p>Track and manage devices across your organization:</p>
      <ul>
        <li>View all devices in an account</li>
        <li>Check device status (online/offline)</li>
        <li>Track firmware versions</li>
        <li>Manage device replacements</li>
      </ul>

      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code># List all devices
curl -X GET https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/device \
  -H "X-AUTH-TOKEN: your-token"</code></pre>
      </div>

      <h2 id="auto-provisioning">Auto-Provisioning</h2>
      <p>Alianza supports automatic device configuration for supported phone models:</p>
      <ol>
        <li>Device connects to network (DHCP)</li>
        <li>Device receives provisioning server URL</li>
        <li>Device downloads configuration from Alianza</li>
        <li>Device automatically registers</li>
      </ol>

      <h2 id="best-practices">Best Practices</h2>
      <div class="card-grid">
        <div class="card">
          <h3>MAC Address Format</h3>
          <p>Use standard format: <code>00:15:65:4D:12:34</code> or <code>00-15-65-4D-12-34</code></p>
        </div>
        <div class="card">
          <h3>Device Naming</h3>
          <p>Use descriptive names: "Conference Room A", "Reception Desk", "John's Phone"</p>
        </div>
        <div class="card">
          <h3>Line Configuration</h3>
          <p>Configure essential features first: voicemail, call waiting, transfer</p>
        </div>
      </div>

      <h2 id="next-steps">Next Steps</h2>
      <ul>
        <li><a href="account-management.html">Account Management</a> - Set up accounts first</li>
        <li><a href="phone-numbers.html">Phone Numbers</a> - Assign numbers to device lines</li>
        <li><a href="call-routing.html">Call Routing</a> - Configure call flow</li>
      </ul>

      <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <a href="phone-numbers.html" class="btn btn-secondary">← Phone Numbers</a>
          </div>
          <div>
            <a href="call-routing.html" class="btn btn-primary">Next: Call Routing →</a>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script src="../js/main.js"></script>
</body>
</html>
EOF

echo "✓ Created device-management.html"

# 2. Call Routing Guide
cat > docs/html/guides/call-routing.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Call Routing Guide - Alianza API">
  <title>Call Routing Guide - Alianza API</title>
  <link rel="stylesheet" href="../css/main.css">
</head>
<body>
  <header class="docs-header">
    <a href="../../../index.html" class="docs-logo">
      <span>📞</span> Alianza API
    </a>
    <nav class="docs-nav">
      <a href="../../../index.html">Home</a>
      <a href="../architecture/diagrams.html">Architecture</a>
      <a href="account-management.html">Guides</a>
      <a href="../../../openapi.yaml">API Reference</a>
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
          <li><a href="account-management.html">Account Management</a></li>
          <li><a href="phone-numbers.html">Phone Numbers</a></li>
          <li><a href="device-management.html">Device Management</a></li>
          <li><a href="call-routing.html" class="active">Call Routing</a></li>
        </ul>
      </div>
      <div class="sidebar-section">
        <div class="sidebar-title">Code Examples</div>
        <ul class="sidebar-links">
          <li><a href="../code-examples/python-examples.html">Python</a></li>
          <li><a href="../code-examples/nodejs-examples.html">Node.js</a></li>
          <li><a href="../code-examples/php-examples.html">PHP</a></li>
          <li><a href="../code-examples/java-examples.html">Java</a></li>
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
      <h1>Call Routing Guide</h1>
      <p style="font-size: 1.2rem;">Master IVR menus, hunt groups, call queues, and advanced call routing with the Alianza API.</p>

      <div class="alert alert-info">
        <strong>📞 Call Routing:</strong> Control how incoming calls flow through your system with IVRs, hunt groups, queues, and more.
      </div>

      <h2 id="routing-options">Call Routing Options</h2>
      <div class="card-grid">
        <div class="card">
          <div class="card-title">🎹 IVR Menus</div>
          <p>Interactive Voice Response - automated menus where callers press numbers to navigate</p>
        </div>
        <div class="card">
          <div class="card-title">👥 Hunt Groups</div>
          <p>Ring multiple devices simultaneously or sequentially</p>
        </div>
        <div class="card">
          <div class="card-title">📢 Paging Groups</div>
          <p>One-way broadcast to multiple devices</p>
        </div>
        <div class="card">
          <div class="card-title">📞 Call Queues</div>
          <p>Hold callers in queue with music and position announcements</p>
        </div>
      </div>

      <h2 id="ivr">IVR (Interactive Voice Response)</h2>
      <p>IVR menus let callers self-navigate to the right destination.</p>

      <h3>Creating an IVR</h3>
      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code>curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/ivr \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Main Menu",
    "greeting": "Thank you for calling. Press 1 for Sales, 2 for Support, 0 for Operator",
    "options": [
      {
        "digit": "1",
        "action": "TRANSFER",
        "destination": "hunt_group_sales"
      },
      {
        "digit": "2",
        "action": "TRANSFER",
        "destination": "hunt_group_support"
      },
      {
        "digit": "0",
        "action": "TRANSFER",
        "destination": "user_operator"
      }
    ],
    "timeout": 5,
    "maxRetries": 3
  }'</code></pre>
      </div>

      <h2 id="hunt-groups">Hunt Groups</h2>
      <p>Hunt groups ring multiple devices to ensure calls are answered.</p>

      <h3>Hunt Group Strategies</h3>
      <ul>
        <li><strong>Simultaneous</strong> - Ring all devices at once (best for urgent calls)</li>
        <li><strong>Sequential</strong> - Try devices in order (best for escalation)</li>
        <li><strong>Round Robin</strong> - Distribute calls evenly (best for load balancing)</li>
        <li><strong>Longest Idle</strong> - Route to agent idle longest</li>
      </ul>

      <h3>Creating a Hunt Group</h3>
      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code>curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/hunt-group \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sales Team",
    "strategy": "SIMULTANEOUS",
    "members": [
      {"userId": "user_1", "priority": 1},
      {"userId": "user_2", "priority": 1},
      {"userId": "user_3", "priority": 1}
    ],
    "ringTimeout": 30,
    "voicemailEnabled": true
  }'</code></pre>
      </div>

      <h2 id="call-queues">Call Queues</h2>
      <p>Call queues hold callers with music and announcements until an agent is available.</p>

      <h3>Queue Features</h3>
      <ul>
        <li>Hold music</li>
        <li>Position announcements ("You are caller number 3")</li>
        <li>Estimated wait time</li>
        <li>Callback options</li>
        <li>Queue priority levels</li>
      </ul>

      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code>curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/call-queue \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Support Queue",
    "maxWaitTime": 300,
    "holdMusic": "media_id_123",
    "positionAnnouncements": true,
    "agents": [
      {"userId": "agent_1"},
      {"userId": "agent_2"}
    ]
  }'</code></pre>
      </div>

      <h2 id="paging-groups">Paging Groups</h2>
      <p>Paging groups broadcast one-way audio to multiple devices (like an intercom).</p>

      <div class="alert alert-warning">
        <strong>📢 One-Way Audio:</strong> Paging is for announcements only. Devices auto-answer and play audio, but cannot respond.
      </div>

      <h2 id="call-parking">Call Parking</h2>
      <p>Park calls in a "spot" and retrieve them from any device.</p>

      <div class="code-block">
        <div class="code-header">
          <span class="code-language">Bash</span>
          <button class="copy-button">Copy</button>
        </div>
        <pre><code># Create parking spots
curl -X POST https://api.alianza.com/v2/partition/{partitionId}/account/{accountId}/call-parking-spot \
  -H "X-AUTH-TOKEN: your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "spotNumber": "701",
    "timeout": 60
  }'</code></pre>
      </div>

      <h2 id="time-based-routing">Time-Based Routing</h2>
      <p>Route calls differently based on time of day and day of week.</p>

      <h3>Example: Business Hours Routing</h3>
      <ul>
        <li><strong>Business Hours (M-F 9-5)</strong> → Hunt Group</li>
        <li><strong>After Hours</strong> → Voicemail</li>
        <li><strong>Weekends</strong> → On-Call Phone</li>
        <li><strong>Holidays</strong> → Special Greeting + Voicemail</li>
      </ul>

      <h2 id="best-practices">Best Practices</h2>

      <h3>IVR Design</h3>
      <ul>
        <li>Keep menus simple (max 5 options)</li>
        <li>Always provide a "0 for operator" option</li>
        <li>Use clear, professional recordings</li>
        <li>Test with real callers before launch</li>
      </ul>

      <h3>Hunt Group Configuration</h3>
      <ul>
        <li>Use simultaneous ring for urgent calls</li>
        <li>Set appropriate timeouts (20-30 seconds)</li>
        <li>Always configure voicemail as fallback</li>
        <li>Monitor answer rates and adjust</li>
      </ul>

      <h3>Queue Management</h3>
      <ul>
        <li>Monitor average wait times</li>
        <li>Add agents during peak hours</li>
        <li>Provide callback options for long waits</li>
        <li>Use queue priority for VIP customers</li>
      </ul>

      <h2 id="next-steps">Next Steps</h2>
      <ul>
        <li><a href="../advanced/best-practices.html">Best Practices</a> - Production tips</li>
        <li><a href="../code-examples/python-examples.html">Code Examples</a> - See it in code</li>
        <li><a href="../../../openapi.yaml">API Reference</a> - Full spec</li>
      </ul>

      <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <a href="device-management.html" class="btn btn-secondary">← Device Management</a>
          </div>
          <div>
            <a href="../advanced/best-practices.html" class="btn btn-primary">Next: Best Practices →</a>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script src="../js/main.js"></script>
</body>
</html>
EOF

echo "✓ Created call-routing.html"

echo ""
echo "✅ Created Device Management and Call Routing guides!"
echo "Next: Creating PHP and Java code examples..."
