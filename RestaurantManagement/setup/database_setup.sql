-- ============================================================================
-- RESTAURANT MANAGEMENT & ONLINE BOOKING SYSTEM DATABASE SCRIPT
-- SQL Server 2014+ | JPA/Hibernate/EclipseLink compatible | UTF-8 source
-- ============================================================================

IF DB_ID('RestaurantManagement') IS NULL
BEGIN
    CREATE DATABASE RestaurantManagement;
END
GO

USE RestaurantManagement;
GO

-- Drop child tables first so the script can be re-run safely on SQL Server 2014+.
IF OBJECT_ID('audit_log', 'U') IS NOT NULL DROP TABLE audit_log;
IF OBJECT_ID('notification', 'U') IS NOT NULL DROP TABLE notification;
IF OBJECT_ID('refund_transaction', 'U') IS NOT NULL DROP TABLE refund_transaction;
IF OBJECT_ID('verification_token', 'U') IS NOT NULL DROP TABLE verification_token;
IF OBJECT_ID('review', 'U') IS NOT NULL DROP TABLE review;
IF OBJECT_ID('voucher_redemption', 'U') IS NOT NULL DROP TABLE voucher_redemption;
IF OBJECT_ID('voucher', 'U') IS NOT NULL DROP TABLE voucher;
IF OBJECT_ID('invoice', 'U') IS NOT NULL DROP TABLE invoice;
IF OBJECT_ID('reservation_addon', 'U') IS NOT NULL DROP TABLE reservation_addon;
IF OBJECT_ID('reservation_menu_item', 'U') IS NOT NULL DROP TABLE reservation_menu_item;
IF OBJECT_ID('reservation_table', 'U') IS NOT NULL DROP TABLE reservation_table;
IF OBJECT_ID('reservation', 'U') IS NOT NULL DROP TABLE reservation;
IF OBJECT_ID('holiday_surcharge', 'U') IS NOT NULL DROP TABLE holiday_surcharge;
IF OBJECT_ID('addon_service', 'U') IS NOT NULL DROP TABLE addon_service;
IF OBJECT_ID('menu_set_item', 'U') IS NOT NULL DROP TABLE menu_set_item;
IF OBJECT_ID('menu_set', 'U') IS NOT NULL DROP TABLE menu_set;
IF OBJECT_ID('menu_item_size', 'U') IS NOT NULL DROP TABLE menu_item_size;
IF OBJECT_ID('menu_item', 'U') IS NOT NULL DROP TABLE menu_item;
IF OBJECT_ID('menu_category', 'U') IS NOT NULL DROP TABLE menu_category;
IF OBJECT_ID('dining_table', 'U') IS NOT NULL DROP TABLE dining_table;
IF OBJECT_ID('room', 'U') IS NOT NULL DROP TABLE room;
IF OBJECT_ID('area', 'U') IS NOT NULL DROP TABLE area;
IF OBJECT_ID('event_type', 'U') IS NOT NULL DROP TABLE event_type;
IF OBJECT_ID('loyalty_transaction', 'U') IS NOT NULL DROP TABLE loyalty_transaction;
IF OBJECT_ID('rank_topup', 'U') IS NOT NULL DROP TABLE rank_topup;
IF OBJECT_ID('customer_profile', 'U') IS NOT NULL DROP TABLE customer_profile;
IF OBJECT_ID('customer_rank_config', 'U') IS NOT NULL DROP TABLE customer_rank_config;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
GO

CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    google_id VARCHAR(255) NULL,
    avatar_url VARCHAR(500) NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER'
        CHECK (role IN ('ADMIN','STAFF','CUSTOMER')),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','NEEDS_INFO','ACTIVE','BANNED')),
    email_verify_token VARCHAR(255) NULL,
    email_verified BIT NOT NULL DEFAULT 0,
    first_order_used BIT NOT NULL DEFAULT 0,
    remember_token VARCHAR(255) NULL,
    token_expiry DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE UNIQUE NONCLUSTERED INDEX UQ_users_google_id
ON users(google_id)
WHERE google_id IS NOT NULL;

CREATE TABLE customer_rank_config (
    id INT IDENTITY(1,1) PRIMARY KEY,
    rank_name VARCHAR(20) NOT NULL UNIQUE
        CHECK (rank_name IN ('BRONZE','SILVER','GOLD','PLATINUM','DIAMOND')),
    min_spend_threshold DECIMAL(12,0) NOT NULL CHECK (min_spend_threshold >= 0),
    discount_percent DECIMAL(5,2) NOT NULL CHECK (discount_percent >= 0),
    points_per_thousand_vnd INT NOT NULL CHECK (points_per_thousand_vnd >= 0),
    can_book_vip BIT NOT NULL DEFAULT 0,
    can_book_vvip BIT NOT NULL DEFAULT 0,
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE customer_profile (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE
        CONSTRAINT FK_customer_profile_user REFERENCES users(id) ON DELETE CASCADE,
    total_spent DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (total_spent >= 0),
    loyalty_points INT NOT NULL DEFAULT 0 CHECK (loyalty_points >= 0),
    current_rank_id INT NULL
        CONSTRAINT FK_customer_profile_rank REFERENCES customer_rank_config(id),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE rank_topup (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT FK_rank_topup_user REFERENCES users(id),
    target_rank VARCHAR(20) NOT NULL
        CHECK (target_rank IN ('SILVER','GOLD','PLATINUM','DIAMOND')),
    amount DECIMAL(12,0) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(10) NOT NULL CHECK (payment_method IN ('VNPAY','MOMO')),
    transaction_ref VARCHAR(100) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','SUCCESS','FAILED')),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE loyalty_transaction (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT FK_loyalty_transaction_user REFERENCES users(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('EARN','REDEEM','TOPUP','RANK_UPGRADE')),
    points_delta INT NOT NULL,
    amount_reference DECIMAL(12,0) NULL,
    description NVARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE event_type (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE area (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,
    price_modifier DECIMAL(10,0) NOT NULL DEFAULT 0 CHECK (price_modifier >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE room (
    id INT IDENTITY(1,1) PRIMARY KEY,
    area_id INT NOT NULL CONSTRAINT FK_room_area REFERENCES area(id),
    room_name NVARCHAR(100) NOT NULL,
    room_type VARCHAR(20) NOT NULL CHECK (room_type IN ('STANDARD','VIP','VVIP')),
    capacity INT NOT NULL CHECK (capacity > 0),
    price_per_session DECIMAL(10,0) NOT NULL DEFAULT 0 CHECK (price_per_session >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE dining_table (
    id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT NOT NULL CONSTRAINT FK_dining_table_room REFERENCES room(id),
    table_code VARCHAR(20) NOT NULL UNIQUE,
    capacity INT NOT NULL CHECK (capacity IN (2,4,6,8,10,12,20)),
    base_price DECIMAL(10,0) NOT NULL DEFAULT 0 CHECK (base_price >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
        CHECK (status IN ('AVAILABLE','RESERVED','OCCUPIED')),
    version INT NOT NULL DEFAULT 0 CHECK (version >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE menu_category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    meal_time VARCHAR(20) NOT NULL
        CHECK (meal_time IN ('BREAKFAST','LUNCH','DINNER','ALL_DAY')),
    category_type VARCHAR(20) NOT NULL
        CHECK (category_type IN ('APPETIZER','MAIN','DESSERT','DRINK','SOUP')),
    sort_order INT NOT NULL DEFAULT 1 CHECK (sort_order > 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE menu_item (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL CONSTRAINT FK_menu_item_category REFERENCES menu_category(id),
    item_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX) NULL,
    image_url VARCHAR(500) NULL,
    base_price DECIMAL(10,0) NOT NULL CHECK (base_price >= 0),
    is_available BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE menu_item_size (
    id INT IDENTITY(1,1) PRIMARY KEY,
    menu_item_id INT NOT NULL
        CONSTRAINT FK_menu_item_size_item REFERENCES menu_item(id) ON DELETE CASCADE,
    size_name NVARCHAR(50) NOT NULL,
    price_modifier DECIMAL(10,0) NOT NULL DEFAULT 0 CHECK (price_modifier >= 0)
);

CREATE TABLE menu_set (
    id INT IDENTITY(1,1) PRIMARY KEY,
    set_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX) NULL,
    meal_time VARCHAR(20) NOT NULL CHECK (meal_time IN ('BREAKFAST','LUNCH','DINNER')),
    original_price DECIMAL(10,0) NOT NULL CHECK (original_price >= 0),
    discounted_price DECIMAL(10,0) NOT NULL CHECK (discounted_price >= 0),
    image_url VARCHAR(500) NULL,
    is_available BIT NOT NULL DEFAULT 1
);

CREATE TABLE menu_set_item (
    id INT IDENTITY(1,1) PRIMARY KEY,
    menu_set_id INT NOT NULL
        CONSTRAINT FK_menu_set_item_set REFERENCES menu_set(id) ON DELETE CASCADE,
    menu_item_id INT NOT NULL CONSTRAINT FK_menu_set_item_item REFERENCES menu_item(id),
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    default_size_id INT NULL CONSTRAINT FK_menu_set_item_size REFERENCES menu_item_size(id)
);

CREATE TABLE addon_service (
    id INT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX) NULL,
    price DECIMAL(10,0) NOT NULL CHECK (price >= 0),
    image_url VARCHAR(500) NULL,
    is_available BIT NOT NULL DEFAULT 1
);

CREATE TABLE holiday_surcharge (
    id INT IDENTITY(1,1) PRIMARY KEY,
    holiday_name NVARCHAR(100) NOT NULL,
    surcharge_date DATE NOT NULL,
    surcharge_percent DECIMAL(5,2) NOT NULL CHECK (surcharge_percent >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE reservation (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NULL CONSTRAINT FK_reservation_user REFERENCES users(id),
    guest_name NVARCHAR(100) NULL,
    guest_phone VARCHAR(20) NULL,
    event_type_id INT NOT NULL CONSTRAINT FK_reservation_event_type REFERENCES event_type(id),
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    adults_count INT NOT NULL DEFAULT 1 CHECK (adults_count >= 1),
    children_count INT NOT NULL DEFAULT 0 CHECK (children_count >= 0),
    has_children BIT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED','NO_SHOW')),
    deposit_amount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (deposit_amount >= 0),
    deposit_paid BIT NOT NULL DEFAULT 0,
    is_online BIT NOT NULL DEFAULT 1,
    created_by_staff_id BIGINT NULL CONSTRAINT FK_reservation_staff REFERENCES users(id),
    checkin_at DATETIME2 NULL,
    has_surcharge BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE reservation_table (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    reservation_id BIGINT NOT NULL
        CONSTRAINT FK_reservation_table_reservation REFERENCES reservation(id) ON DELETE CASCADE,
    dining_table_id INT NOT NULL CONSTRAINT FK_reservation_table_table REFERENCES dining_table(id)
);

CREATE TABLE reservation_menu_item (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    reservation_id BIGINT NOT NULL
        CONSTRAINT FK_reservation_menu_item_reservation REFERENCES reservation(id) ON DELETE CASCADE,
    menu_item_id INT NULL CONSTRAINT FK_reservation_menu_item_item REFERENCES menu_item(id),
    menu_item_size_id INT NULL CONSTRAINT FK_reservation_menu_item_size REFERENCES menu_item_size(id),
    menu_set_id INT NULL CONSTRAINT FK_reservation_menu_item_set REFERENCES menu_set(id),
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price DECIMAL(10,0) NOT NULL CHECK (unit_price >= 0),
    CONSTRAINT CK_reservation_menu_item_choice CHECK (
        menu_item_id IS NOT NULL OR menu_set_id IS NOT NULL
    )
);

CREATE TABLE reservation_addon (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    reservation_id BIGINT NOT NULL
        CONSTRAINT FK_reservation_addon_reservation REFERENCES reservation(id) ON DELETE CASCADE,
    addon_service_id INT NOT NULL CONSTRAINT FK_reservation_addon_service REFERENCES addon_service(id),
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price DECIMAL(10,0) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE invoice (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    reservation_id BIGINT NULL CONSTRAINT FK_invoice_reservation REFERENCES reservation(id),
    user_id BIGINT NULL CONSTRAINT FK_invoice_user REFERENCES users(id),
    guest_name NVARCHAR(100) NULL,
    subtotal DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
    tip_amount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (tip_amount >= 0),
    surcharge_amount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (surcharge_amount >= 0),
    voucher_discount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (voucher_discount >= 0),
    points_discount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (points_discount >= 0),
    total_amount DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    payment_method VARCHAR(10) NULL CHECK (payment_method IN ('CASH','VNPAY','MOMO')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (payment_status IN ('PENDING','PAID','REFUNDED')),
    transaction_ref VARCHAR(100) NULL,
    paid_at DATETIME2 NULL,
    issued_by_staff_id BIGINT NULL CONSTRAINT FK_invoice_staff REFERENCES users(id),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE UNIQUE NONCLUSTERED INDEX UQ_invoice_reservation_id
ON invoice(reservation_id)
WHERE reservation_id IS NOT NULL;

CREATE TABLE voucher (
    id INT IDENTITY(1,1) PRIMARY KEY,
    voucher_code VARCHAR(50) NOT NULL UNIQUE,
    voucher_type VARCHAR(20) NOT NULL
        CHECK (voucher_type IN ('FIRST_ORDER','WEEKDAY','LUNCH','BIRTHDAY_MONTH','RANK_BENEFIT','MANUAL')),
    discount_percent DECIMAL(5,2) NULL CHECK (discount_percent IS NULL OR discount_percent >= 0),
    discount_amount DECIMAL(12,0) NULL CHECK (discount_amount IS NULL OR discount_amount >= 0),
    min_order_value DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (min_order_value >= 0),
    max_discount DECIMAL(12,0) NULL CHECK (max_discount IS NULL OR max_discount >= 0),
    valid_from DATETIME2 NOT NULL,
    valid_to DATETIME2 NOT NULL,
    usage_limit INT NOT NULL DEFAULT 100 CHECK (usage_limit >= 0),
    used_count INT NOT NULL DEFAULT 0 CHECK (used_count >= 0),
    applicable_rank_id INT NULL CONSTRAINT FK_voucher_rank REFERENCES customer_rank_config(id),
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_voucher_discount CHECK (discount_percent IS NOT NULL OR discount_amount IS NOT NULL),
    CONSTRAINT CK_voucher_dates CHECK (valid_to > valid_from)
);

CREATE TABLE voucher_redemption (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    voucher_id INT NOT NULL CONSTRAINT FK_voucher_redemption_voucher REFERENCES voucher(id),
    user_id BIGINT NOT NULL CONSTRAINT FK_voucher_redemption_user REFERENCES users(id),
    invoice_id BIGINT NOT NULL CONSTRAINT FK_voucher_redemption_invoice REFERENCES invoice(id),
    used_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE review (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT FK_review_user REFERENCES users(id),
    reservation_id BIGINT NOT NULL UNIQUE CONSTRAINT FK_review_reservation REFERENCES reservation(id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX) NULL,
    image_url VARCHAR(500) NULL,
    is_visible BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE verification_token (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT FK_verification_token_user REFERENCES users(id),
    token VARCHAR(255) NOT NULL UNIQUE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('EMAIL_VERIFY','PASSWORD_RESET')),
    expires_at DATETIME2 NOT NULL,
    used_at DATETIME2 NULL
);

CREATE TABLE refund_transaction (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    invoice_id BIGINT NOT NULL CONSTRAINT FK_refund_transaction_invoice REFERENCES invoice(id),
    amount DECIMAL(12,0) NOT NULL CHECK (amount >= 0),
    method VARCHAR(10) NOT NULL CHECK (method IN ('CASH','VNPAY','MOMO')),
    transaction_ref VARCHAR(100) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','SUCCESS','FAILED')),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE notification (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT FK_notification_user REFERENCES users(id),
    title NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    is_read BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE audit_log (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NULL CONSTRAINT FK_audit_log_user REFERENCES users(id),
    action NVARCHAR(255) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT NULL,
    old_value NVARCHAR(MAX) NULL,
    new_value NVARCHAR(MAX) NULL,
    ip_address VARCHAR(45) NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO customer_rank_config
    (rank_name, min_spend_threshold, discount_percent, points_per_thousand_vnd, can_book_vip, can_book_vvip)
VALUES
    ('BRONZE', 0, 0.00, 1, 0, 0),
    ('SILVER', 10000000, 5.00, 2, 1, 0),
    ('GOLD', 30000000, 8.00, 3, 1, 0),
    ('PLATINUM', 70000000, 12.00, 4, 1, 1),
    ('DIAMOND', 100000000, 15.00, 5, 1, 1);

INSERT INTO users (username, email, password, full_name, phone, role, status, email_verified)
VALUES
    ('admin', 'admin@restaurant.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Admin User', '0901234567', 'ADMIN', 'ACTIVE', 1),
    ('staff', 'staff@restaurant.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Staff User', '0902345678', 'STAFF', 'ACTIVE', 1),
    ('customer', 'customer@gmail.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Loyal Customer', '0903456789', 'CUSTOMER', 'ACTIVE', 1);

DECLARE @customerId BIGINT = (SELECT id FROM users WHERE email = 'customer@gmail.com');
DECLARE @bronzeRankId INT = (SELECT id FROM customer_rank_config WHERE rank_name = 'BRONZE');
INSERT INTO customer_profile (user_id, total_spent, loyalty_points, current_rank_id)
VALUES (@customerId, 0, 100, @bronzeRankId);

INSERT INTO event_type (name, description)
VALUES
    (N'Casual Dining', N'Family or friends dining experience'),
    (N'Birthday Party', N'Table decoration and cake support'),
    (N'Romantic Date', N'Quiet table with warm lighting'),
    (N'Company Gathering', N'Long table or private room setup'),
    (N'Anniversary', N'Private and elegant dining space');

INSERT INTO area (name, description, price_modifier)
VALUES
    (N'Main Hall', N'Comfortable indoor dining space', 0),
    (N'Garden Patio', N'Open air seating with greenery', 50000),
    (N'Rooftop View', N'Premium city view seating', 100000);

DECLARE @mainHallId INT = (SELECT id FROM area WHERE name = N'Main Hall');
DECLARE @gardenId INT = (SELECT id FROM area WHERE name = N'Garden Patio');
INSERT INTO room (area_id, room_name, room_type, capacity, price_per_session)
VALUES
    (@mainHallId, N'Standard Room A', 'STANDARD', 40, 0),
    (@mainHallId, N'Golden VIP Room', 'VIP', 12, 300000),
    (@gardenId, N'Rose Garden Room', 'STANDARD', 30, 0),
    (@gardenId, N'Royal VVIP Villa', 'VVIP', 20, 1000000);

DECLARE @standardRoomId INT = (SELECT TOP 1 id FROM room WHERE room_type = 'STANDARD' ORDER BY id);
DECLARE @vipRoomId INT = (SELECT TOP 1 id FROM room WHERE room_type = 'VIP' ORDER BY id);
INSERT INTO dining_table (room_id, table_code, capacity, base_price)
VALUES
    (@standardRoomId, 'A01', 2, 0),
    (@standardRoomId, 'A02', 4, 0),
    (@standardRoomId, 'A03', 6, 0),
    (@standardRoomId, 'A04', 8, 0),
    (@vipRoomId, 'VIP-01', 10, 200000),
    (@vipRoomId, 'VIP-02', 12, 200000);

INSERT INTO menu_category (category_name, meal_time, category_type, sort_order)
VALUES
    (N'Appetizers', 'ALL_DAY', 'APPETIZER', 1),
    (N'Main Courses', 'ALL_DAY', 'MAIN', 2),
    (N'Desserts', 'ALL_DAY', 'DESSERT', 3),
    (N'Drinks', 'ALL_DAY', 'DRINK', 4);

DECLARE @appetizerId INT = (SELECT id FROM menu_category WHERE category_type = 'APPETIZER');
DECLARE @mainCourseId INT = (SELECT id FROM menu_category WHERE category_type = 'MAIN');
DECLARE @drinkId INT = (SELECT id FROM menu_category WHERE category_type = 'DRINK');
INSERT INTO menu_item (category_id, item_name, description, base_price)
VALUES
    (@appetizerId, N'Lotus Stem Salad', N'Crisp lotus stem with shrimp and herbs', 120000),
    (@appetizerId, N'Crab Asparagus Soup', N'Warm soup with crab meat and fresh asparagus', 85000),
    (@mainCourseId, N'Black Pepper Beef Tenderloin', N'Grilled beef tenderloin with black pepper sauce', 350000),
    (@mainCourseId, N'Pan Seared Salmon', N'Salmon with butter and passion fruit sauce', 280000),
    (@drinkId, N'Fresh Orange Juice', N'Fresh squeezed orange juice', 55000),
    (@drinkId, N'Bordeaux Red Wine', N'Imported French red wine', 850000);

INSERT INTO addon_service (service_name, description, price)
VALUES
    (N'Rose Table Decoration', N'Fresh roses and candle styling', 250000),
    (N'Premium Birthday Cake', N'Chocolate or fruit cake on request', 350000),
    (N'Table Violin Performance', N'Thirty minute private violin performance', 500000);

INSERT INTO voucher
    (voucher_code, voucher_type, discount_percent, discount_amount, min_order_value, max_discount, valid_from, valid_to, usage_limit)
VALUES
    ('WELCOME10', 'FIRST_ORDER', 10.00, NULL, 300000, 100000, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 1000),
    ('VIPLUNCH', 'LUNCH', 15.00, NULL, 500000, 200000, GETDATE(), DATEADD(MONTH, 6, GETDATE()), 500);
GO

PRINT 'RestaurantManagement database schema and seed data created successfully.';
