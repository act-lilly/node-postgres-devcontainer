-- schema.sql
-- Create schemas
CREATE SCHEMA IF NOT EXISTS app;

-- Create tables
CREATE TABLE IF NOT EXISTS app.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS app.items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    owner_id INTEGER REFERENCES app.users(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create reference tables
CREATE TABLE IF NOT EXISTS app.status_codes (
    code VARCHAR(10) PRIMARY KEY,
    description TEXT NOT NULL
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_items_owner ON app.items(owner_id);
CREATE INDEX IF NOT EXISTS idx_items_status ON app.items(status);

-- Comments to help users understand the schema
COMMENT ON TABLE app.users IS 'Stores user account information';
COMMENT ON TABLE app.items IS 'Main application items';