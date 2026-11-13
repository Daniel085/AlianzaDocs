/**
 * Frontend runtime configuration.
 *
 * Values come from Vite env vars (VITE_*), set in .env files or the
 * environment at build/dev time. Defaults match local development.
 */

// Strip a trailing slash so `${API_BASE_URL}/health` never becomes `//health`
const stripTrailingSlash = (url: string) => url.replace(/\/+$/, '')

export const API_BASE_URL = stripTrailingSlash(
  import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'
)

export const WS_URL = stripTrailingSlash(
  import.meta.env.VITE_WS_URL || 'ws://localhost:4000'
)
