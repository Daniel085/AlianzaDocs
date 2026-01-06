/**
 * Application configuration
 * Centralizes all environment variables and config
 */

module.exports = {
  // Server
  server: {
    port: parseInt(process.env.PORT, 10) || 4000,
    host: process.env.HOST || 'localhost',
    env: process.env.NODE_ENV || 'development'
  },

  // Database
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    name: process.env.DB_NAME || 'ai_call_intelligence',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    pool: {
      min: 2,
      max: 10
    }
  },

  // Redis
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT, 10) || 6379,
    password: process.env.REDIS_PASSWORD || undefined
  },

  // Kafka
  kafka: {
    brokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(','),
    clientId: process.env.KAFKA_CLIENT_ID || 'ai-call-intelligence',
    groupId: process.env.KAFKA_GROUP_ID || 'ai-call-intelligence-group'
  },

  // Alianza API
  alianza: {
    baseUrl: process.env.ALIANZA_API_BASE_URL || 'https://api.alianza.com',
    username: process.env.ALIANZA_API_USERNAME,
    password: process.env.ALIANZA_API_PASSWORD,
    partitionId: process.env.ALIANZA_PARTITION_ID,
    timeout: 30000 // 30 seconds
  },

  // Authentication
  auth: {
    jwtSecret: process.env.JWT_SECRET || 'change-this-secret-key',
    jwtExpiresIn: process.env.JWT_EXPIRES_IN || '24h',
    oauthClientId: process.env.OAUTH_CLIENT_ID,
    oauthClientSecret: process.env.OAUTH_CLIENT_SECRET
  },

  // AI Services
  ai: {
    openai: {
      apiKey: process.env.OPENAI_API_KEY,
      orgId: process.env.OPENAI_ORG_ID,
      model: {
        transcription: process.env.TRANSCRIPTION_MODEL || 'whisper-1',
        summarization: process.env.SUMMARIZATION_MODEL || 'gpt-4'
      }
    },
    services: {
      transcription: process.env.TRANSCRIPTION_SERVICE_URL || 'http://localhost:5001',
      sentiment: process.env.SENTIMENT_SERVICE_URL || 'http://localhost:5002',
      intent: process.env.INTENT_SERVICE_URL || 'http://localhost:5003',
      summarization: process.env.SUMMARIZATION_SERVICE_URL || 'http://localhost:5004'
    }
  },

  // CRM Integration
  crm: {
    salesforce: {
      instanceUrl: process.env.SALESFORCE_INSTANCE_URL,
      clientId: process.env.SALESFORCE_CLIENT_ID,
      clientSecret: process.env.SALESFORCE_CLIENT_SECRET
    }
  },

  // CORS
  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000'
  },

  // Rate Limiting
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 900000, // 15 minutes
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS, 10) || 100
  },

  // WebSocket
  websocket: {
    heartbeatInterval: parseInt(process.env.WS_HEARTBEAT_INTERVAL, 10) || 30000,
    maxConnections: parseInt(process.env.WS_MAX_CONNECTIONS, 10) || 1000
  }
};
