-- Add MASTER_TENANT role to roles table in master database
-- This role is only for users who manage multiple tenants

INSERT INTO roles (name, description, created_at, updated_at)
VALUES ('MASTER_TENANT', 'Master Tenant - Full access to tenant management', NOW(), NOW())
ON DUPLICATE KEY UPDATE
    description = 'Master Tenant - Full access to tenant management',
    updated_at = NOW();

