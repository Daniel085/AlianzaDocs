/**
 * AI Call Intelligence Suite - Backend Server
 * Main entry point for the Express.js API server
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { createServer } = require('http');
const { Server } = require('socket.io');
const logger = require('./utils/logger');
const config = require('./config');

// Import routes (to be created)
// const callsRouter = require('./api/routes/calls');
// const intelligenceRouter = require('./api/routes/intelligence');
// const analyticsRouter = require('./api/routes/analytics');
// const integrationsRouter = require('./api/routes/integrations');

// Initialize Express app
const app = express();
const httpServer = createServer(app);

// Initialize Socket.io for real-time communication
const io = new Server(httpServer, {
  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
    methods: ['GET', 'POST'],
    credentials: true
  }
});

// Middleware
app.use(helmet()); // Security headers
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get('user-agent')
  });
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV
  });
});

// API version endpoint
app.get('/api/v1', (req, res) => {
  res.json({
    name: 'AI Call Intelligence Suite API',
    version: '0.1.0',
    description: 'ICF Experience Layer - AI-powered call analytics',
    documentation: '/docs',
    endpoints: {
      calls: '/api/v1/calls',
      intelligence: '/api/v1/intelligence',
      analytics: '/api/v1/analytics',
      integrations: '/api/v1/integrations',
      events: 'ws://localhost:4000/call-events'
    }
  });
});

// Mount API routes (uncomment when routes are created)
// app.use('/api/v1/calls', callsRouter);
// app.use('/api/v1/intelligence', intelligenceRouter);
// app.use('/api/v1/analytics', analyticsRouter);
// app.use('/api/v1/integrations', integrationsRouter);

// WebSocket connection handling
io.on('connection', (socket) => {
  logger.info('WebSocket client connected', { socketId: socket.id });

  // Subscribe to call events
  socket.on('subscribe:call-events', (data) => {
    logger.info('Client subscribed to call events', {
      socketId: socket.id,
      accountId: data.accountId
    });

    // Join room for this account
    socket.join(`account:${data.accountId}`);

    socket.emit('subscribed', {
      success: true,
      accountId: data.accountId,
      timestamp: new Date().toISOString()
    });
  });

  // Unsubscribe from call events
  socket.on('unsubscribe:call-events', (data) => {
    socket.leave(`account:${data.accountId}`);
    logger.info('Client unsubscribed from call events', {
      socketId: socket.id,
      accountId: data.accountId
    });
  });

  // Handle disconnect
  socket.on('disconnect', () => {
    logger.info('WebSocket client disconnected', { socketId: socket.id });
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error('Unhandled error', {
    error: err.message,
    stack: err.stack,
    path: req.path
  });

  res.status(err.status || 500).json({
    error: {
      message: process.env.NODE_ENV === 'production'
        ? 'Internal server error'
        : err.message,
      status: err.status || 500,
      timestamp: new Date().toISOString()
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: {
      message: 'Endpoint not found',
      status: 404,
      path: req.path,
      timestamp: new Date().toISOString()
    }
  });
});

// Start server
const PORT = process.env.PORT || 4000;
const HOST = process.env.HOST || '0.0.0.0';

httpServer.listen(PORT, HOST, () => {
  logger.info(`🚀 AI Call Intelligence Suite API server started`, {
    port: PORT,
    host: HOST,
    environment: process.env.NODE_ENV,
    nodeVersion: process.version
  });
  logger.info(`📡 WebSocket server ready for real-time connections`);
  logger.info(`🏥 Health check: http://${HOST}:${PORT}/health`);
  logger.info(`📚 API info: http://${HOST}:${PORT}/api/v1`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  httpServer.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT signal received: closing HTTP server');
  httpServer.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
});

// Export for testing
module.exports = { app, io, httpServer };
