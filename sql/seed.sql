-- seed.sql
-- Populate reference data
INSERT INTO app.status_codes (code, description)
VALUES 
    ('ACTIVE', 'Item is active and available'),
    ('PENDING', 'Item is awaiting approval'),
    ('ARCHIVED', 'Item has been archived')
ON CONFLICT (code) DO NOTHING;

-- Sample users
INSERT INTO app.users (username, email)
VALUES 
    ('demo_user', 'demo@example.com'),
    ('test_admin', 'admin@example.com')
ON CONFLICT (username) DO NOTHING;

-- Sample items
INSERT INTO app.items (name, description, owner_id, status)
VALUES 
    ('Sample Item 1', 'This is a description for the first sample item', 
        (SELECT id FROM app.users WHERE username = 'demo_user'), 'ACTIVE'),
    ('Sample Item 2', 'This is a description for the second sample item', 
        (SELECT id FROM app.users WHERE username = 'demo_user'), 'PENDING'),
    ('Admin Item', 'This is an item owned by the admin user', 
        (SELECT id FROM app.users WHERE username = 'test_admin'), 'ACTIVE')
ON CONFLICT DO NOTHING;

-- Add comments to explain the purpose of sample data
COMMENT ON TABLE app.status_codes IS 'Reference table for status codes';