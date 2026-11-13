/**
 * Redis client (node-redis v4)
 *
 * Note: v4 uses camelCase commands (setEx, not setex) and returns promises.
 */

const { createClient } = require('redis');
const config = require('./index');
const logger = require('../utils/logger');

const client = createClient({
  socket: {
    host: config.redis.host,
    port: config.redis.port,
    connectTimeout: 5000,
    // Back off up to 5s between reconnect attempts
    reconnectStrategy: (retries) => Math.min(retries * 200, 5000)
  },
  password: config.redis.password
});

// Without an 'error' listener, a lost connection throws and kills the process
client.on('error', (err) => {
  logger.error('Redis client error', { error: err.message });
});
client.on('ready', () => logger.info('Redis connected'));
client.on('reconnecting', () => logger.warn('Redis reconnecting'));

/**
 * Open the connection. Safe to call more than once.
 */
const connect = async () => {
  if (!client.isOpen) {
    await client.connect();
  }
  return client;
};

/**
 * Returns true if Redis answers PING.
 */
const checkHealth = async () => {
  try {
    if (!client.isReady) return false;
    return (await client.ping()) === 'PONG';
  } catch (err) {
    return false;
  }
};

const close = async () => {
  if (client.isOpen) {
    await client.quit();
  }
};

module.exports = {
  client,
  connect,
  checkHealth,
  close
};
