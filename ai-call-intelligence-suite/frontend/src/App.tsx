import { useState, useEffect } from 'react'
import { API_BASE_URL } from './config'
import './App.css'

interface ApiInfo {
  name: string
  version: string
  description: string
}

function App() {
  const [apiStatus, setApiStatus] = useState<string>('checking...')
  const [apiInfo, setApiInfo] = useState<ApiInfo | null>(null)

  useEffect(() => {
    // Check backend health. /health returns 503 with status 'degraded'
    // when the API is up but the database or Redis is not.
    fetch(`${API_BASE_URL}/health`)
      .then(res => res.json())
      .then(data => {
        setApiStatus(data.status === 'healthy' ? 'connected ✓' : 'degraded ⚠')
        console.log('Backend health:', data)
      })
      .catch(err => {
        setApiStatus('disconnected ✗')
        console.error('Backend connection failed:', err)
      })

    // Get API info
    fetch(`${API_BASE_URL}/api/v1`)
      .then(res => res.json())
      .then((data: ApiInfo) => {
        setApiInfo(data)
        console.log('API info:', data)
      })
      .catch(err => console.error('API info failed:', err))
  }, [])

  return (
    <div className="app">
      <header className="app-header">
        <h1>🤖 AI Call Intelligence Suite</h1>
        <p className="subtitle">Demonstrating Alianza's Intelligent Communications Fabric</p>
      </header>

      <main className="app-main">
        <div className="status-card">
          <h2>System Status</h2>
          <div className="status-item">
            <span className="label">Backend API:</span>
            <span className={`status ${
              apiStatus.includes('✓') ? 'connected'
                : apiStatus.includes('⚠') ? 'degraded'
                : 'disconnected'
            }`}>
              {apiStatus}
            </span>
          </div>
          {apiInfo && (
            <div className="api-info">
              <h3>{apiInfo.name}</h3>
              <p>Version: {apiInfo.version}</p>
              <p>{apiInfo.description}</p>
            </div>
          )}
        </div>

        <div className="feature-grid">
          <div className="feature-card">
            <span className="icon">🎙️</span>
            <h3>Real-Time Transcription</h3>
            <p>Live speech-to-text with speaker diarization</p>
          </div>

          <div className="feature-card">
            <span className="icon">😊</span>
            <h3>Sentiment Analysis</h3>
            <p>Emotion tracking and frustration detection</p>
          </div>

          <div className="feature-card">
            <span className="icon">🤖</span>
            <h3>AI Agent Assist</h3>
            <p>Real-time suggestions and knowledge base</p>
          </div>

          <div className="feature-card">
            <span className="icon">📊</span>
            <h3>Analytics Dashboard</h3>
            <p>Trends, metrics, and business insights</p>
          </div>

          <div className="feature-card">
            <span className="icon">🔗</span>
            <h3>CRM Integration</h3>
            <p>Auto-sync to Salesforce, HubSpot, etc.</p>
          </div>

          <div className="feature-card">
            <span className="icon">💰</span>
            <h3>Revenue Intelligence</h3>
            <p>Upsell detection and churn prevention</p>
          </div>
        </div>

        <div className="cta-section">
          <h2>Get Started</h2>
          <p>This is the initial setup. Development in progress...</p>
          <div className="button-group">
            <button className="btn btn-primary" disabled>
              View Dashboard
            </button>
            <button className="btn btn-secondary" disabled>
              View API Docs
            </button>
          </div>
        </div>
      </main>

      <footer className="app-footer">
        <p>Built with ❤️ to showcase Alianza's Intelligent Communications Fabric</p>
      </footer>
    </div>
  )
}

export default App
