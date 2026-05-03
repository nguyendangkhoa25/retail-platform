-- Add ORDER_VIEW_ALL sub-feature.
-- Users without this feature can only see orders they created (created_by = their username).
-- Users with this feature (typically SHOP_OWNER role) see all orders in the tenant.
INSERT INTO features (id, name, display_name, description, active, deleted)
VALUES (202601031, 'ORDER_VIEW_ALL', 'Xem Tất Cả Đơn Hàng',
        'Xem đơn hàng của tất cả nhân viên; nếu không có quyền này, chỉ xem được đơn hàng tự tạo',
        TRUE, FALSE)
ON CONFLICT (name) DO NOTHING;

SELECT setval(pg_get_serial_sequence('features', 'id'), 202601031, true);

-- Backfill a default POS_RECEIPT print_template for every active tenant that has none.
-- Needed for shops provisioned before print_template seeding was added to the DML scripts.
-- FORCE ROW SECURITY is on print_templates, so we must set app.current_tenant per tenant.

DO $$
DECLARE
    v_tenant_id TEXT;
    v_config    TEXT := '{"headerText":"","footerText":"Cảm ơn quý khách!\nHẹn gặp lại!","showAddress":true,"showTaxId":false,"showOrderNumber":true,"showDateTime":true,"showCustomer":true,"showTaxBreakdown":false,"showCashDetails":true,"paperWidth":"80mm","autoClose":true,"showVietQr":false}';
BEGIN
    FOR v_tenant_id IN
        SELECT tenant_id FROM tenants WHERE active = TRUE
    LOOP
        -- Scope RLS to this tenant so we can read and write its rows.
        PERFORM set_config('app.current_tenant', v_tenant_id, true);

        IF NOT EXISTS (
            SELECT 1 FROM print_templates
            WHERE template_type = 'POS_RECEIPT' AND deleted = FALSE
        ) THEN
            INSERT INTO print_templates (tenant_id, template_type, name, config_json, is_default)
            VALUES (v_tenant_id, 'POS_RECEIPT', 'Mặc định', v_config, TRUE)
            ON CONFLICT DO NOTHING;
        END IF;
    END LOOP;

    -- Clear tenant context when done.
    PERFORM set_config('app.current_tenant', '', true);
END $$;

-- Add identity card fields to employees table.
ALTER TABLE employees
    ADD COLUMN IF NOT EXISTS id_card_number       VARCHAR(20),
    ADD COLUMN IF NOT EXISTS date_of_birth        DATE,
    ADD COLUMN IF NOT EXISTS gender               VARCHAR(10),
    ADD COLUMN IF NOT EXISTS permanent_address    TEXT,
    ADD COLUMN IF NOT EXISTS id_card_issued_date  DATE,
    ADD COLUMN IF NOT EXISTS id_card_issued_place VARCHAR(255),
    ADD COLUMN IF NOT EXISTS id_card_front_image  TEXT,
    ADD COLUMN IF NOT EXISTS id_card_back_image   TEXT;
