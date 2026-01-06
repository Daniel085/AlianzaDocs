-- AI Call Intelligence Suite - Database Initialization
-- This script creates the initial database schema

-- Create extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Calls table - stores call metadata
CREATE TABLE IF NOT EXISTS calls (
    call_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255),
    direction VARCHAR(10) CHECK (direction IN ('INBOUND', 'OUTBOUND')),
    from_number VARCHAR(20),
    to_number VARCHAR(20),
    start_time TIMESTAMP,
    connect_time TIMESTAMP,
    end_time TIMESTAMP,
    duration_seconds INTEGER,
    status VARCHAR(20),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Call intelligence table - stores AI-generated insights
CREATE TABLE IF NOT EXISTS call_intelligence (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    call_id UUID REFERENCES calls(call_id) ON DELETE CASCADE,
    transcription TEXT,
    summary JSONB,
    sentiment JSONB,
    topics JSONB,
    keywords TEXT[],
    action_items JSONB,
    quality_metrics JSONB,
    business_insights JSONB,
    processing_time_ms INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Real-time events table - stores event stream data
CREATE TABLE IF NOT EXISTS real_time_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    call_id UUID REFERENCES calls(call_id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    data JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table - application users
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'agent',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics snapshots table - for dashboard metrics
CREATE TABLE IF NOT EXISTS analytics_snapshots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id VARCHAR(255) NOT NULL,
    period_start TIMESTAMP NOT NULL,
    period_end TIMESTAMP NOT NULL,
    metrics JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CRM integrations table
CREATE TABLE IF NOT EXISTS crm_integrations (
    integration_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id VARCHAR(255) NOT NULL,
    crm_type VARCHAR(50) NOT NULL,
    credentials JSONB NOT NULL,
    mappings JSONB DEFAULT '{}',
    triggers JSONB DEFAULT '{}',
    status VARCHAR(20) DEFAULT 'active',
    last_sync TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_calls_account_id ON calls(account_id);
CREATE INDEX idx_calls_start_time ON calls(start_time DESC);
CREATE INDEX idx_calls_user_id ON calls(user_id);

CREATE INDEX idx_call_intelligence_call_id ON call_intelligence(call_id);

CREATE INDEX idx_events_call_id ON real_time_events(call_id);
CREATE INDEX idx_events_timestamp ON real_time_events(timestamp DESC);
CREATE INDEX idx_events_type ON real_time_events(event_type);

CREATE INDEX idx_users_account_id ON users(account_id);
CREATE INDEX idx_users_email ON users(email);

CREATE INDEX idx_analytics_account_period ON analytics_snapshots(account_id, period_start, period_end);

CREATE INDEX idx_crm_account_id ON crm_integrations(account_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_calls_updated_at BEFORE UPDATE ON calls
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_call_intelligence_updated_at BEFORE UPDATE ON call_intelligence
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_crm_integrations_updated_at BEFORE UPDATE ON crm_integrations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for development
INSERT INTO users (account_id, email, name, role) VALUES
    ('acct_demo', 'admin@example.com', 'Admin User', 'admin'),
    ('acct_demo', 'agent1@example.com', 'Jane Smith', 'agent'),
    ('acct_demo', 'agent2@example.com', 'Mike Johnson', 'agent'),
    ('acct_demo', 'manager@example.com', 'Sarah Williams', 'manager')
ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
