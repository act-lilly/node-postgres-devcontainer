-- functions.sql
-- Contains stored functions, procedures, and triggers for the application
-- Add your custom database logic here

-- Set the schema
SET search_path TO app;

-- =================================================================
-- FUNCTIONS
-- =================================================================

-- Function to get items by status
CREATE OR REPLACE FUNCTION get_items_by_status(status_filter VARCHAR)
RETURNS TABLE (
    item_id INTEGER,
    item_name VARCHAR,
    item_description TEXT,
    username VARCHAR,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.id AS item_id,
        i.name AS item_name,
        i.description AS item_description,
        u.username,
        i.status
    FROM 
        app.items i
    JOIN 
        app.users u ON i.owner_id = u.id
    WHERE 
        i.status = status_filter;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate statistics
CREATE OR REPLACE FUNCTION get_user_statistics(user_id_param INTEGER)
RETURNS TABLE (
    total_items BIGINT,
    active_items BIGINT,
    pending_items BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*) AS total_items,
        COUNT(*) FILTER (WHERE status = 'ACTIVE') AS active_items,
        COUNT(*) FILTER (WHERE status = 'PENDING') AS pending_items
    FROM
        app.items
    WHERE
        owner_id = user_id_param;
END;
$$ LANGUAGE plpgsql;

-- =================================================================
-- PROCEDURES (PostgreSQL 11+)
-- =================================================================

-- Procedure to archive old items
CREATE OR REPLACE PROCEDURE archive_old_items(days_old INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE app.items
    SET status = 'ARCHIVED'
    WHERE 
        status = 'ACTIVE' AND
        created_at < CURRENT_TIMESTAMP - (days_old * INTERVAL '1 day');

    RAISE NOTICE 'Archived items older than % days', days_old;
END;
$$;

-- =================================================================
-- TRIGGERS
-- =================================================================

-- Function used by trigger
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- First add updated_at column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_schema = 'app' AND table_name = 'items' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE app.items ADD COLUMN updated_at TIMESTAMP;
    END IF;
END $$;

-- Create a trigger to automatically update the timestamp
DROP TRIGGER IF EXISTS update_items_modtime ON app.items;

CREATE TRIGGER update_items_modtime
BEFORE UPDATE ON app.items
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- =================================================================
-- EXAMPLE USAGE COMMENTS
-- =================================================================

/*
-- Example function calls:
SELECT * FROM get_items_by_status('ACTIVE');
SELECT * FROM get_user_statistics(1);

-- Example procedure call:
CALL archive_old_items(30);
*/

-- Add helpful comments for users
COMMENT ON FUNCTION get_items_by_status IS 'Returns items filtered by their status';
COMMENT ON FUNCTION get_user_statistics IS 'Returns count statistics for a user''s items';
COMMENT ON PROCEDURE archive_old_items IS 'Archives active items older than the specified number of days';