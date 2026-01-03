-- Add new columns to tenants table for enhanced tenant management
-- Migration for master database
-- NOTE: Removed db_url, db_username, db_password columns as we now use master DB credentials

-- Remove old columns if they exist (we use master DB credentials now)
ALTER TABLE tenants DROP COLUMN IF EXISTS db_url;
ALTER TABLE tenants DROP COLUMN IF EXISTS db_username;
ALTER TABLE tenants DROP COLUMN IF EXISTS db_password;

-- Add new management columns
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS expiration_date DATE;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS max_users INT;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS features TEXT;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS subscription_type VARCHAR(50);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS contact_person_name VARCHAR(100);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS contact_person_phone VARCHAR(20);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS contact_person_email VARCHAR(100);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS contact_person_zalo_id VARCHAR(50);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS active_at BIGINT;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS active_by VARCHAR(100);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS created_by VARCHAR(100);
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS updated_by VARCHAR(100);

