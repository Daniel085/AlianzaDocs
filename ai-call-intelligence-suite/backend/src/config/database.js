/**
 * PostgreSQL connection pool
 */

const { Pool } = require('pg');
const config = require('./index');
const logger = require('../utils/logger');

const pool = new Pool({
  host: config.database.host,
  port: config.database.port,
  database: config.database.name,
  user: config.database.user,
  password: config.database.password,
  min: config.database.pool.min,
  max: config.database.pool.max,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

// An idle client erroring (e.g. the DB restarting) must not crash the process
pool.on('error', (err) => {
  logger.error('Unexpected PostgreSQL pool error', { error: err.message });
});

/**
 * Run a parameterized query.
 * @param {string} text - SQL with $1, $2... placeholders
 * @param {Array} params - Parameter values
 */
const query = (text, params) => pool.query(text, params);

/**
 * Returns true if the database answers a trivial query.
 */
const checkHealth = async () => {
  try {
    await pool.query('SELECT 1');
    return true;
  } catch (err) {
    return false;
  }
};

const close = () => pool.end();

module.exports = {
  pool,
  query,
  checkHealth,
  close
};
