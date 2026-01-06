# Quick Start Guide - AI Call Intelligence Suite

Get the application running in under 5 minutes!

---

## 🚀 Prerequisites

Make sure you have these installed:

- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Node.js** >= 18.0 (for local development without Docker)
- **npm** >= 9.0 (for local development without Docker)

---

## 📦 Option 1: Docker Compose (Recommended)

The easiest way to get everything running:

```bash
# Navigate to the project directory
cd ai-call-intelligence-suite

# Start all services (PostgreSQL, Redis, Kafka, Backend, Frontend)
docker-compose up -d

# Watch the logs
docker-compose logs -f

# Check service health
docker-compose ps
```

### Access the Application

Once all services are running:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:4000
- **API Health**: http://localhost:4000/health
- **API Info**: http://localhost:4000/api/v1

### Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

---

## 💻 Option 2: Local Development (Without Docker)

For faster development iteration:

### Step 1: Start Infrastructure Services

```bash
# Start only PostgreSQL, Redis, and Kafka
docker-compose up -d postgres redis kafka
```

### Step 2: Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your configuration (optional for development)
nano .env

# Start backend server
npm run dev
```

Backend will start on http://localhost:4000

### Step 3: Setup Frontend

Open a new terminal:

```bash
cd frontend

# Install dependencies
npm install

# Start frontend dev server
npm run dev
```

Frontend will start on http://localhost:3000

---

## 🧪 Verify Installation

### 1. Check Backend Health

```bash
curl http://localhost:4000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-06T...",
  "uptime": 12.345,
  "environment": "development"
}
```

### 2. Check API Info

```bash
curl http://localhost:4000/api/v1
```

Expected response:
```json
{
  "name": "AI Call Intelligence Suite API",
  "version": "0.1.0",
  "description": "ICF Experience Layer - AI-powered call analytics",
  "endpoints": {
    "calls": "/api/v1/calls",
    "intelligence": "/api/v1/intelligence",
    "analytics": "/api/v1/analytics",
    "integrations": "/api/v1/integrations"
  }
}
```

### 3. Check Frontend

Open http://localhost:3000 in your browser. You should see:

- ✅ Backend API status showing "connected ✓"
- ✅ Feature grid with 6 features
- ✅ Gradient purple background
- ✅ API info displayed

---

## 🗄️ Database Setup

The database is automatically initialized with the schema when you start PostgreSQL via Docker Compose.

### View Database

```bash
# Connect to PostgreSQL
docker exec -it ai-call-intel-postgres psql -U postgres -d ai_call_intelligence

# List tables
\dt

# View sample users
SELECT * FROM users;

# Exit
\q
```

### Tables Created

- `calls` - Call metadata and CDR data
- `call_intelligence` - AI-generated insights
- `real_time_events` - Event stream storage
- `users` - Application users (4 sample users included)
- `analytics_snapshots` - Dashboard metrics
- `crm_integrations` - CRM configuration

---

## 🛠️ Development Workflow

### Backend Development

```bash
cd backend

# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Lint code
npm run lint

# Fix lint issues
npm run lint:fix

# Check logs
tail -f logs/combined.log
```

### Frontend Development

```bash
cd frontend

# Run type checking
npm run type-check

# Lint code
npm run lint

# Build for production
npm run build

# Preview production build
npm run preview
```

### Environment Variables

Backend `.env` important variables:

```bash
# Alianza API (required for production)
ALIANZA_API_BASE_URL=https://api.alianza.com
ALIANZA_API_USERNAME=your_username
ALIANZA_API_PASSWORD=your_password
ALIANZA_PARTITION_ID=your_partition_id

# OpenAI (required for AI features)
OPENAI_API_KEY=sk-your-api-key

# Database (default values work with Docker Compose)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ai_call_intelligence
DB_USER=postgres
DB_PASSWORD=postgres
```

---

## 🐛 Troubleshooting

### Port Already in Use

If ports 3000, 4000, 5432, 6379, or 9092 are already in use:

```bash
# Check what's using the port
lsof -i :4000

# Kill the process
kill -9 <PID>

# Or change ports in docker-compose.yml
```

### Docker Compose Fails

```bash
# Clean everything and restart
docker-compose down -v
docker system prune -a
docker-compose up -d
```

### Backend Won't Start

```bash
# Check logs
docker-compose logs backend

# Rebuild backend
docker-compose up -d --build backend
```

### Database Connection Errors

```bash
# Ensure PostgreSQL is healthy
docker-compose ps postgres

# Restart PostgreSQL
docker-compose restart postgres

# Check PostgreSQL logs
docker-compose logs postgres
```

### Frontend Shows "disconnected"

1. Check backend is running: http://localhost:4000/health
2. Check browser console for errors
3. Verify CORS settings in backend `.env`
4. Clear browser cache and refresh

---

## 📝 Next Steps

Now that everything is running:

1. **Explore the UI** - Open http://localhost:3000
2. **Check API docs** - Visit http://localhost:4000/api/v1
3. **Review the plan** - Read `AI_CALL_INTELLIGENCE_SUITE_PLAN.md`
4. **Start coding** - Follow Phase 1 of the 8-week roadmap

### Recommended Reading

- [Implementation Plan](../AI_CALL_INTELLIGENCE_SUITE_PLAN.md)
- [ICF Research](../ICF_RESEARCH.md)
- [Case Studies Review](../CASE_STUDIES_REVIEW.md)
- [Project README](./README.md)

---

## 🎯 What's Working Right Now

✅ **Infrastructure**
- PostgreSQL database with schema
- Redis cache
- Kafka message broker
- Docker Compose orchestration

✅ **Backend**
- Express.js API server
- WebSocket server (Socket.io)
- Health check endpoint
- API info endpoint
- Winston logging
- Configuration management

✅ **Frontend**
- React + TypeScript app
- Vite development server
- Backend connection check
- Modern UI design
- Feature showcase

### What's Next to Build

🚧 **Phase 1 Goals** (Weeks 1-2):
- [ ] Authentication & authorization
- [ ] Alianza v2 API integration
- [ ] Call list API endpoint
- [ ] Call detail API endpoint
- [ ] Basic transcription service
- [ ] Sentiment analysis service

---

## 💡 Tips

**Development Speed:**
- Use `npm run dev` in both backend and frontend for hot reload
- Keep Docker logs open: `docker-compose logs -f`
- Use React DevTools browser extension

**Debugging:**
- Backend logs: `./backend/logs/combined.log`
- Frontend: Browser console (F12)
- Database: Connect via `psql` or pgAdmin

**Performance:**
- Backend rebuilds are slow - use local dev mode
- Frontend hot-reload is very fast with Vite
- Database queries are logged in development mode

---

**Happy coding! 🚀**

If you encounter any issues, check the [troubleshooting section](#-troubleshooting) or review the logs.
