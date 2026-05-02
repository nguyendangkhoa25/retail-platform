-- V002: Fix missing/incorrect column definitions across several tables.
-- ADD COLUMN IF NOT EXISTS and ALTER COLUMN … TYPE are idempotent — safe to re-run.

-- notification_preferences was missing created_at, deleted, deleted_at.
ALTER TABLE notification_preferences
    ADD COLUMN IF NOT EXISTS created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS updated_at  TIMESTAMP,
    ADD COLUMN IF NOT EXISTS deleted     BOOLEAN   NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS deleted_at  TIMESTAMP;

-- invoice_items was missing deleted, deleted_at.
ALTER TABLE invoice_items
    ADD COLUMN IF NOT EXISTS deleted     BOOLEAN   NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS deleted_at  TIMESTAMP;

-- cart_items.variants must be jsonb so Hibernate can bind JSON values without a cast error.
ALTER TABLE cart_items
    ALTER COLUMN variants TYPE jsonb USING variants::jsonb;

-- Ensure AGENT role has the correct master feature set.
-- Fixes deployments where V001 was applied before the AGENT features block was added.
-- Note: role_features.tenant_id and features.tenant_id still exist here — they are
-- dropped later in this same migration.
INSERT INTO role_features (tenant_id, role_id, feature_id)
SELECT NULL, r.id, f.id
FROM roles r
CROSS JOIN features f
WHERE r.name = 'AGENT'
  AND r.tenant_id IS NULL
  AND f.name IN ('TENANT_MGMT', 'MASTER_DASHBOARD', 'NOTIFICATION')
  AND f.tenant_id IS NULL
ON CONFLICT (role_id, feature_id) DO NOTHING;

-- ============================================================
-- Features table is platform-defined master data (DASHBOARD,
-- ORDER, POS, etc.) shared by all tenants. tenant_id on this
-- table served no purpose and broke RLS — tenant-context queries
-- could not see the NULL-tenant feature rows without workaround
-- OR clauses in every native query.
-- ============================================================

-- Remove RLS policy and row-security enforcement
DROP POLICY IF EXISTS tenant_isolation ON features;
ALTER TABLE features NO FORCE ROW LEVEL SECURITY;
ALTER TABLE features DISABLE ROW LEVEL SECURITY;

-- The two partial unique indexes both reference tenant_id and
-- will be dropped automatically by PostgreSQL when the column
-- is dropped. Replace them with a single global unique index.
DROP INDEX IF EXISTS uq_features_name_master;
DROP INDEX IF EXISTS uq_features_name_tenant;

ALTER TABLE features DROP COLUMN IF EXISTS tenant_id;

ALTER TABLE features ADD CONSTRAINT uq_features_name UNIQUE (name);

-- ============================================================
-- user_roles, role_features, and refresh_tokens all have a
-- tenant_id column that is logically redundant: tenant isolation
-- is already enforced through the FK references
-- (users.tenant_id, roles.tenant_id). The column is never
-- populated by the application and the RLS policies it backed
-- are bypassed by the superuser connection anyway.
-- ============================================================

-- user_roles
DROP POLICY IF EXISTS tenant_isolation ON user_roles;
ALTER TABLE user_roles NO FORCE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
DROP INDEX IF EXISTS idx_ur_tenant_id;
ALTER TABLE user_roles DROP COLUMN IF EXISTS tenant_id;

-- role_features
DROP POLICY IF EXISTS tenant_isolation ON role_features;
ALTER TABLE role_features NO FORCE ROW LEVEL SECURITY;
ALTER TABLE role_features DISABLE ROW LEVEL SECURITY;
DROP INDEX IF EXISTS idx_rf_tenant_id;
ALTER TABLE role_features DROP COLUMN IF EXISTS tenant_id;

-- refresh_tokens
DROP POLICY IF EXISTS tenant_isolation ON refresh_tokens;
ALTER TABLE refresh_tokens NO FORCE ROW LEVEL SECURITY;
ALTER TABLE refresh_tokens DISABLE ROW LEVEL SECURITY;
DROP INDEX IF EXISTS idx_rt_tenant_id;
ALTER TABLE refresh_tokens DROP COLUMN IF EXISTS tenant_id;
