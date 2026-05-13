-- Mark whether a tenant has completed the self-provisioning onboarding wizard.
-- DEFAULT TRUE: existing tenants and admin-created tenants are already fully set up.
-- The self-provision flow returns setupComplete=true on success so the mobile app
-- can route to the main app instead of the onboarding wizard.
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS setup_complete BOOLEAN NOT NULL DEFAULT TRUE;
