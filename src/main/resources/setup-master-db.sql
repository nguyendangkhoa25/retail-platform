-- Master database setup (barber-shop-mgmt)
-- This script should be run on the master database
-- Employees Table
CREATE TABLE IF NOT EXISTS employees (
                                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                         name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NULL,
    position VARCHAR(50) NOT NULL,
    user_id BIGINT NULL,
    hire_date DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'ON_LEAVE') NOT NULL DEFAULT 'ACTIVE',
    description TEXT,
    base_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_earned DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    INDEX idx_status (status),
    INDEX idx_phone (phone),
    INDEX idx_deleted_at (deleted_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=79202600001;

-- Tenants Table (Multi-tenancy support)
CREATE TABLE IF NOT EXISTS tenants (
                                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                       tenant_id VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    db_name VARCHAR(100) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    expiration_date DATE,
    max_users INT,
    features TEXT,
    subscription_type VARCHAR(50),
    contact_person_name VARCHAR(100),
    contact_person_phone VARCHAR(20),
    contact_person_email VARCHAR(100),
    contact_person_zalo_id VARCHAR(50),
    created_at BIGINT NOT NULL,
    updated_at BIGINT NOT NULL,
    active_at BIGINT,
    active_by VARCHAR(100),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_active (active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=20260001;



-- Users Table
CREATE TABLE IF NOT EXISTS users (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    require_action VARCHAR(50) NULL,
    full_name VARCHAR(100),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    account_non_locked BOOLEAN NOT NULL DEFAULT TRUE,
    credentials_non_expired BOOLEAN NOT NULL DEFAULT TRUE,
    account_non_expired BOOLEAN NOT NULL DEFAULT TRUE,
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    INDEX idx_username (username),
    INDEX idx_active (active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=7600001;

CREATE TABLE IF NOT EXISTS refresh_tokens (
                                              id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                              user_id BIGINT NOT NULL,
                                              token VARCHAR(500) NOT NULL UNIQUE,
    expiry_date BIGINT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at BIGINT NOT NULL,
    updated_at BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_active (active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS roles (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    INDEX idx_name (name),
    INDEX idx_deleted (deleted),
    INDEX idx_deleted_at (deleted_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=202600001;
-- Insert 5 predefined roles (only these roles are available in the system)
INSERT IGNORE INTO roles (name, description) VALUES
    ('MASTER_TENANT', 'Tenant Master - Full access to all features');

-- User Roles Junction Table
CREATE TABLE IF NOT EXISTS user_roles (
                                          user_id BIGINT NOT NULL,
                                          role_id BIGINT NOT NULL,
                                          PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--  Auto-generated SQL script #202601040859
INSERT INTO users (username,password,email,full_name)
VALUES ('Administrator','$2a$10$81SZ5pugtdDEuO2PqngSlOnP00MAfybQmLRV62i4C5A5/uWaqs88C','nguyendangkhoa25@gmail.com','Khoa Nguyen');

CREATE TABLE IF NOT EXISTS features (
                                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                        name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Feature code/identifier (e.g., DASHBOARD, ORDER)',
    display_name VARCHAR(100) NOT NULL COMMENT 'Display name for UI (e.g., Dashboard)',
    description VARCHAR(500) COMMENT 'Detailed description of the feature',
    active BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Is feature enabled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,

    INDEX idx_name (name),
    INDEX idx_active (active),
    INDEX idx_deleted (deleted),
    INDEX idx_deleted_at (deleted_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=202601001;

INSERT IGNORE INTO features (name, display_name, description, active) VALUES
    ('DASHBOARD', 'Bảng Điều Khiển', 'Xem tổng quan và thống kê chính của cửa hàng', TRUE),
    ('ORDER', 'Đơn Hàng', 'Quản lý đơn hàng, theo dõi trạng thái và lịch sử đơn hàng', TRUE),
    ('MY_WORK', 'Công Việc Của Tôi', 'Xem công việc được giao cho nhân viên hiện tại', TRUE),
    ('PRODUCT', 'Sản Phẩm & Dịch Vụ', 'Quản lý danh sách sản phẩm, dịch vụ, giá cả và hoa hồng', TRUE),
    ('PROMOTION', 'Khuyến Mãi', 'Tạo và quản lý các chương trình khuyến mãi, giảm giá', TRUE),
    ('EMPLOYEE', 'Nhân Viên', 'Quản lý nhân viên, chức vụ, lương cơ bản', TRUE),
    ('SALARY', 'Lương Nhân Viên', 'Quản lý bảng lương, tính toán lương, chi trả', TRUE),
    ('CUSTOMER', 'Khách Hàng', 'Quản lý thông tin khách hàng, lịch sử mua hàng', TRUE),
    ('INVOICE', 'Hóa Đơn', 'Quản lý hóa đơn, xuất hóa đơn điện tử', TRUE),
    ('REVENUE', 'Doanh Thu', 'Xem báo cáo doanh thu, lợi nhuận, chi phí', TRUE),
    ('USER', 'Người Dùng', 'Quản lý tài khoản người dùng, quyền truy cập', TRUE),
    ('TENANT_MGMT', 'Quản Lý Cửa Hàng', 'Quản lý các chi nhánh, cửa hàng trong hệ thống', TRUE),
    ('SHOP_INFO', 'Thông Tin Cửa Hàng', 'Cập nhật thông tin cửa hàng, cấu hình hệ thống', TRUE);

CREATE TABLE IF NOT EXISTS role_features (
                                             id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                             role_id BIGINT NOT NULL COMMENT 'Reference to roles table',
                                             feature_id BIGINT NOT NULL COMMENT 'Reference to features table',
                                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Unique constraint: each role can have each feature only once
                                             UNIQUE KEY uk_role_feature (role_id, feature_id),

    -- Foreign keys
    CONSTRAINT fk_role_features_role_id FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_role_features_feature_id FOREIGN KEY (feature_id) REFERENCES features(id) ON DELETE CASCADE,

    -- Indexes for optimal query performance
    INDEX idx_role_id (role_id),
    INDEX idx_feature_id (feature_id),
    INDEX idx_created_at (created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=20260001
    COMMENT='Maps roles to features for role-based access control';

INSERT INTO role_features (role_id, feature_id)
SELECT r.id, f.id FROM roles r, features f
WHERE r.name = 'MASTER_TENANT'
  AND f.name IN ('TENANT_MGMT', 'USER')
  AND f.deleted = FALSE;

-- Insert test tenant 'phuc-barber'
--  Auto-generated SQL script #202601040835
INSERT INTO tenants (tenant_id,
                    name,
                    db_name,
                    max_users,
                    subscription_type,
                    active,
                    created_at,
                    updated_at,
                     contact_person_name, contact_person_phone, contact_person_email, contact_person_zalo_id)
VALUES ('phuc-barber',
        'Phuc Barber',
        'phuc_barber_db',
        100,
        '',
        true,
        UNIX_TIMESTAMP() * 1000,
        UNIX_TIMESTAMP() * 1000, 'Khoa Nguyen', '0974637451', 'nguyendangkhoa25@gmail.com', '');




