-- ===== Appointments feature =====

CREATE TABLE IF NOT EXISTS appointments (
    id                  BIGSERIAL PRIMARY KEY,
    tenant_id           VARCHAR(50)  NOT NULL,
    appointment_number  VARCHAR(20)  NOT NULL,
    customer_id         BIGINT,
    customer_name       VARCHAR(255) NOT NULL,
    customer_phone      VARCHAR(20),
    scheduled_date      DATE         NOT NULL,
    scheduled_start_time TIME        NOT NULL,
    duration_minutes    INT          NOT NULL DEFAULT 60,
    status              VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    note                TEXT,
    linked_order_id     BIGINT,
    created_by          VARCHAR(255) NOT NULL,
    created_at          TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP    NOT NULL DEFAULT NOW(),
    deleted             BOOLEAN      NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMP
);

CREATE TABLE IF NOT EXISTS appointment_services (
    id                      BIGSERIAL PRIMARY KEY,
    appointment_id          BIGINT       NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
    product_id              BIGINT       NOT NULL,
    product_name            VARCHAR(255) NOT NULL,
    unit_price              DECIMAL(15,2) NOT NULL DEFAULT 0,
    duration_minutes        INT          NOT NULL DEFAULT 0,
    assigned_employee_id    BIGINT,
    assigned_employee_name  VARCHAR(255)
);

-- RLS policies
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments FORCE ROW LEVEL SECURITY;

CREATE POLICY appointments_tenant_isolation ON appointments
    USING (tenant_id = current_setting('app.current_tenant', true));

-- Unique appointment number per tenant
CREATE UNIQUE INDEX IF NOT EXISTS idx_appointments_number
    ON appointments (tenant_id, appointment_number)
    WHERE deleted = FALSE;

-- Fast lookup by date
CREATE INDEX IF NOT EXISTS idx_appointments_tenant_date
    ON appointments (tenant_id, scheduled_date)
    WHERE deleted = FALSE;

-- Insert APPOINTMENT feature into master features table
INSERT INTO features (code, name, description)
VALUES ('APPOINTMENT', 'Lịch Hẹn', 'Quản lý lịch hẹn với khách hàng, đặt lịch và xác nhận')
ON CONFLICT (code) DO NOTHING;
