# AI Call Intelligence Suite

> Demonstrating Alianza's Intelligent Communications Fabric (ICF) with AI-powered call analytics

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org/)
[![React](https://img.shields.io/badge/react-18.x-blue)](https://reactjs.org/)

---

## 🎯 Overview

The **AI Call Intelligence Suite** is a demonstration application showcasing the Alianza Intelligent Communications Fabric's (ICF) ability to deliver AI-infused communication services. It provides real-time call intelligence, post-call analytics, and actionable insights for contact centers and customer service teams.

### Key Features

- 🎙️ **Real-Time Call Transcription** - Live speech-to-text with speaker diarization
- 😊 **Sentiment Analysis** - Emotion tracking and frustration detection
- 🤖 **AI Agent Assistance** - Real-time suggestions and knowledge base integration
- 📊 **Analytics Dashboard** - Trends, performance metrics, and business insights
- 🔗 **CRM Integration** - Automatic call logging to Salesforce, HubSpot, etc.
- 💰 **Revenue Intelligence** - Upsell detection and churn prevention

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              AI Call Intelligence Suite                      │
│              (Web App + REST/WebSocket APIs)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                 ┌────────────┴────────────┐
                 │                         │
      ┌──────────▼──────────┐   ┌─────────▼──────────┐
      │   ICF Experience    │   │  ICF Orchestration │
      │       Layer         │   │       Layer        │
      └─────────────────────┘   └────────────────────┘
                              │
                 ┌────────────┴────────────┐
                 │                         │
      ┌──────────▼──────────┐   ┌─────────▼──────────┐
      │  Alianza v2 APIs    │   │   AI Services      │
      │  - CDR Search       │   │  - Whisper         │
      │  - Account Mgmt     │   │  - GPT-4           │
      └─────────────────────┘   └────────────────────┘
```

### Technology Stack

**Backend:**
- **Node.js** (Express.js) - REST API server
- **Python** (FastAPI) - AI processing microservices
- **PostgreSQL** - Primary database
- **Redis** - Caching and real-time state
- **Kafka** - Event streaming

**Frontend:**
- **React 18** + **TypeScript**
- **Tailwind CSS** + **shadcn/ui**
- **Socket.io** - Real-time updates
- **React Query** - Data fetching
- **Recharts** - Analytics visualization

**AI/ML Services:**
- **OpenAI Whisper** - Speech-to-text
- **OpenAI GPT-4** - Summarization & complex analysis
- **Hugging Face Transformers** - Sentiment analysis
- **Rasa** - Intent classification

---

## 📁 Project Structure

```
ai-call-intelligence-suite/
├── backend/                    # Backend services
│   ├── src/
│   │   ├── api/               # REST/WebSocket API routes
│   │   ├── services/          # Business logic
│   │   ├── models/            # Database models
│   │   ├── middleware/        # Express middleware
│   │   └── utils/             # Helper functions
│   ├── tests/                 # Backend tests
│   └── config/                # Configuration files
│
├── frontend/                   # React web application
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── pages/             # Page components
│   │   ├── hooks/             # Custom React hooks
│   │   ├── services/          # API clients
│   │   ├── store/             # State management
│   │   └── utils/             # Utilities
│   └── public/                # Static assets
│
├── ai-services/               # Python AI microservices
│   ├── transcription/         # Speech-to-text service
│   ├── sentiment/             # Sentiment analysis
│   ├── summarization/         # Call summarization
│   └── intent/                # Intent classification
│
├── infrastructure/            # Infrastructure as Code
│   ├── docker/                # Docker configurations
│   ├── kubernetes/            # K8s manifests
│   └── terraform/             # Cloud infrastructure
│
├── docs/                      # Documentation
│   ├── api/                   # API documentation
│   ├── architecture/          # Architecture diagrams
│   └── guides/                # Development guides
│
└── scripts/                   # Utility scripts
    ├── setup/                 # Setup scripts
    ├── migration/             # Database migrations
    └── deployment/            # Deployment scripts
```

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** >= 18.0.0
- **Python** >= 3.10
- **Docker** >= 20.10
- **PostgreSQL** >= 14
- **Redis** >= 6.0

### Installation

```bash
# Clone the repository
git clone https://github.com/your-org/ai-call-intelligence-suite.git
cd ai-call-intelligence-suite

# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Start services with Docker Compose
docker-compose up -d

# Run database migrations
npm run migrate

# Start development servers
npm run dev
```

### Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:4000
- **API Documentation**: http://localhost:4000/docs

---

## 📖 Documentation

- **[Implementation Plan](../AI_CALL_INTELLIGENCE_SUITE_PLAN.md)** - Complete implementation guide
- **[API Reference](./docs/api/README.md)** - API endpoint documentation
- **[Architecture Guide](./docs/architecture/README.md)** - System architecture
- **[Development Guide](./docs/guides/DEVELOPMENT.md)** - Developer setup
- **[Deployment Guide](./docs/guides/DEPLOYMENT.md)** - Production deployment

---

## 🎬 Demo Scenarios

### Scenario 1: Technical Support Call
Live demonstration of real-time transcription, sentiment detection, and agent assistance during a customer support call.

### Scenario 2: Sales Upsell
Showcase AI-powered upsell opportunity detection and guided selling features.

### Scenario 3: Churn Prevention
Demonstrate proactive churn risk identification and retention workflows.

See [Demo Guide](./docs/guides/DEMO.md) for detailed scenarios.

---

## 🧪 Testing

```bash
# Run backend unit tests
cd backend
npm test

# Run backend integration tests
npm run test:integration

# Run frontend tests
cd ../frontend
npm test

# Run end-to-end tests
npm run test:e2e

# Generate coverage report
npm run test:coverage
```

---

## 📊 Development Roadmap

### Phase 1: Foundation (Weeks 1-2) ✅
- [x] Project setup and structure
- [ ] Authentication & authorization
- [ ] Alianza v2 API integration
- [ ] Basic call list UI
- [ ] Post-call transcription

### Phase 2: Real-Time Intelligence (Weeks 3-4)
- [ ] WebSocket infrastructure
- [ ] Real-time transcription streaming
- [ ] Live sentiment analysis
- [ ] Agent assist sidebar
- [ ] Real-time alerts

### Phase 3: Analytics & Insights (Weeks 5-6)
- [ ] Analytics dashboard
- [ ] Trend visualization
- [ ] Agent performance metrics
- [ ] Custom report builder
- [ ] Export functionality

### Phase 4: Automation & Integration (Weeks 7-8)
- [ ] CRM integration framework
- [ ] Salesforce connector
- [ ] Workflow automation
- [ ] Webhook system
- [ ] Demo preparation

---

## 🤝 Contributing

This is a demonstration project for the Alianza ICF platform. For contributions:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Alianza** - For the Intelligent Communications Fabric platform
- **OpenAI** - Whisper and GPT-4 models
- **Hugging Face** - Transformer models
- All contributors and early adopters

---

## 📞 Contact & Support

- **Documentation**: [./docs](./docs)
- **Issues**: [GitHub Issues](https://github.com/your-org/ai-call-intelligence-suite/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/ai-call-intelligence-suite/discussions)

---

**Built with ❤️ to showcase the power of Alianza's Intelligent Communications Fabric**
