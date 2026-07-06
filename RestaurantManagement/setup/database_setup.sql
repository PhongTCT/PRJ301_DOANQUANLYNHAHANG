-- ============================================================================
-- RESTAURANT MANAGEMENT & ONLINE BOOKING SYSTEM DATABASE SCRIPT
-- SQL Server 2014+ | JPA/Hibernate/EclipseLink compatible | UTF-8 source
-- ============================================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

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
    min_point_threshold INT NOT NULL CHECK (min_point_threshold >= 0),
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
    coin_balance DECIMAL(12,0) NOT NULL DEFAULT 0 CHECK (coin_balance >= 0),
    current_rank_id INT NULL
        CONSTRAINT FK_customer_profile_rank REFERENCES customer_rank_config(id),
    last_activity_at DATETIME2 NULL,
    last_decay_at DATETIME2 NULL,
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
    type VARCHAR(20) NOT NULL CHECK (type IN ('EARN','REDEEM','TOPUP','RANK_UPGRADE','POINTS_DECAY','RANK_DOWNGRADE')),
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
    capacity INT NOT NULL CHECK (capacity > 0),
    base_price DECIMAL(10,0) NOT NULL DEFAULT 0 CHECK (base_price >= 0),
    image_url VARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
        CHECK (status IN ('AVAILABLE','RESERVED','OCCUPIED')),
    version INT NOT NULL DEFAULT 0 CHECK (version >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

CREATE TABLE menu_category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    category_name_vi NVARCHAR(100) NULL,
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
    item_name_vi NVARCHAR(150) NULL,
    description NVARCHAR(MAX) NULL,
    description_vi NVARCHAR(MAX) NULL,
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
    set_name_vi NVARCHAR(150) NULL,
    description NVARCHAR(MAX) NULL,
    description_vi NVARCHAR(MAX) NULL,
    meal_time VARCHAR(20) NOT NULL CHECK (meal_time IN ('BREAKFAST','LUNCH','DINNER','ALL_DAY')),
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
    course_name NVARCHAR(150) NULL,
    course_name_vi NVARCHAR(150) NULL,
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
    (rank_name, min_point_threshold, discount_percent, points_per_thousand_vnd, can_book_vip, can_book_vvip, is_active)
VALUES
    ('BRONZE', 0, 0.00, 1, 0, 0, 1),
    ('SILVER', 5000, 5.00, 1, 0, 0, 1),
    ('GOLD', 20000, 10.00, 2, 1, 0, 1),
    ('PLATINUM', 50000, 15.00, 3, 1, 1, 1),
    ('DIAMOND', 100000, 20.00, 5, 1, 1, 1);

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (username, email, password, full_name, phone, role, status, email_verified)
    VALUES
        ('admin', 'admin@restaurant.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Admin User', '0901234567', 'ADMIN', 'ACTIVE', 1),
        ('staff', 'staff@restaurant.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Staff User', '0902345678', 'STAFF', 'ACTIVE', 1),
        ('customer', 'customer@gmail.com', '$2a$10$Ew8wW/w.u/Q.E.R.T.Y.U.I.O.P.A.S.D.F.G.H.J.K.L.Z.X.C.V', N'Loyal Customer', '0903456789', 'CUSTOMER', 'ACTIVE', 1);

    DECLARE @customerId BIGINT = (SELECT id FROM users WHERE email = 'customer@gmail.com');
    DECLARE @bronzeRankId INT = (SELECT id FROM customer_rank_config WHERE rank_name = 'BRONZE');
    INSERT INTO customer_profile (user_id, total_spent, loyalty_points, current_rank_id)
    VALUES (@customerId, 0, 100, @bronzeRankId);
END

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
INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url)
VALUES
    (@standardRoomId, 'A01', 2, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
    (@standardRoomId, 'A02', 4, 0, 'assets/img/le-royal/seating/private-table.jpg'),
    (@standardRoomId, 'A03', 6, 0, 'assets/img/le-royal/seating/counter-seat.jpg'),
    (@standardRoomId, 'A04', 8, 0, 'assets/img/le-royal/seating/salon-table.jpg'),
    (@vipRoomId, 'VIP-01', 10, 200000, 'assets/img/le-royal/seating/private-table.jpg'),
    (@vipRoomId, 'VIP-02', 12, 200000, 'assets/img/le-royal/seating/salon-table.jpg');

INSERT INTO menu_category (category_name, meal_time, category_type, sort_order)
VALUES
    (N'Appetizers', 'ALL_DAY', 'APPETIZER', 1),
    (N'Soups', 'ALL_DAY', 'SOUP', 2),
    (N'Main Courses', 'ALL_DAY', 'MAIN', 3),
    (N'Desserts', 'ALL_DAY', 'DESSERT', 4),
    (N'Drinks', 'ALL_DAY', 'DRINK', 5);

DECLARE @appetizerId INT = (SELECT id FROM menu_category WHERE category_type = 'APPETIZER');
DECLARE @soupId INT = (SELECT id FROM menu_category WHERE category_type = 'SOUP');
DECLARE @mainCourseId INT = (SELECT id FROM menu_category WHERE category_type = 'MAIN');
DECLARE @dessertId INT = (SELECT id FROM menu_category WHERE category_type = 'DESSERT');
DECLARE @drinkId INT = (SELECT id FROM menu_category WHERE category_type = 'DRINK');
INSERT INTO menu_item (category_id, item_name, description, image_url, base_price)
VALUES
    (@appetizerId, N'Silk Garden Prelude', N'Crisp lotus stem with shrimp, herbs, roasted peanut and lime dressing', 'assets/img/le-royal/menu/lotus-stem-salad.jpg', 300000),
    (@appetizerId, N'Crimson Tide', N'Cold diced tuna, citrus gel, shallot oil and oscietra-style caviar', 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg', 420000),
    (@appetizerId, N'Moonlit Shore', N'Thin scallop slices with yuzu kosho, herb oil and sea grapes', 'assets/img/le-royal/menu/scallop-carpaccio.jpg', 450000),
    (@appetizerId, N'Little Green Sonata', N'Fine pastry tart with herbs, whipped cheese and pickled greens', 'assets/img/le-royal/menu/garden-herb-tartlet.jpg', 320000),
    (@appetizerId, N'Golden Ember Bites', N'Petite crab canapes with creamy roe sauce and toasted crumbs', 'assets/img/le-royal/menu/crab-caviar-bites.jpg', 460000),
    (@appetizerId, N'Velvet Orchard', N'Smoked duck breast, young leaves, plum vinaigrette and toasted seeds', 'assets/img/le-royal/menu/smoked-duck-salad.jpg', 380000),
    (@soupId, N'Amber Pour', N'Warm soup with crab meat and fresh green asparagus', 'assets/img/le-royal/menu/crab-asparagus-soup.jpg', 300000),
    (@soupId, N'Quiet Tide', N'Clear truffle-scented broth with white fish and herbs', 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg', 360000),
    (@soupId, N'Autumn Glow', N'Silky pumpkin soup with cream, pumpkin seed oil and toasted almond', 'assets/img/le-royal/menu/pumpkin-veloute.jpg', 300000),
    (@soupId, N'Deep Sea Velvet', N'Rich shellfish broth finished with cream, herb butter and seafood garnish', 'assets/img/le-royal/menu/lobster-bisque.jpg', 480000),
    (@mainCourseId, N'Midnight Ember', N'Grilled beef tenderloin with black pepper jus and seasonal vegetables', 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg', 780000),
    (@mainCourseId, N'Golden Current', N'Salmon with golden butter and passion fruit sauce', 'assets/img/le-royal/menu/pan-seared-salmon.jpg', 680000),
    (@mainCourseId, N'Red Reef', N'Charcoal grilled lobster with garlic herb butter and lemon', 'assets/img/le-royal/menu/grilled-spiny-lobster.jpg', 1380000),
    (@mainCourseId, N'Royal Shell Bloom', N'Steamed king crab served with warm herb butter and citrus salt', 'assets/img/le-royal/menu/king-crab-herb-butter.jpg', 1480000),
    (@mainCourseId, N'Plum Dusk', N'Pink roasted duck breast with spiced plum jus and root vegetables', 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg', 720000),
    (@mainCourseId, N'Black Fan Nocturne', N'Slow cooked wagyu short rib with red wine sauce and mushroom puree', 'assets/img/le-royal/menu/wagyu-short-rib.jpg', 1200000),
    (@mainCourseId, N'Pale River', N'White cod marinated in miso, served with dashi butter sauce', 'assets/img/le-royal/menu/miso-cod.jpg', 820000),
    (@mainCourseId, N'Clay Pot Reverie', N'Prawns, scallop and fish simmered in aromatic clay pot sauce', 'assets/img/le-royal/menu/seafood-clay-pot.jpg', 860000),
    (@mainCourseId, N'Sunlit Roulade', N'Chicken roulade with foie gras stuffing, herb jus and carrot puree', 'assets/img/le-royal/menu/roasted-chicken-roulade.jpg', 650000),
    (@mainCourseId, N'Jade Lagoon', N'Creamy saffron risotto with abalone, parmesan and chive oil', 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg', 980000),
    (@dessertId, N'Cloud on Blue Porcelain', N'Crisp meringue with passion fruit curd, cream and fresh herbs', 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg', 320000),
    (@dessertId, N'Ruby Garden', N'Raspberry sorbet with berry compote, edible flowers and crisp tuile', 'assets/img/le-royal/menu/berry-sorbet-garden.jpg', 300000),
    (@dessertId, N'Mist Pearl', N'Coconut panna cotta with tropical fruit and lime espuma', 'assets/img/le-royal/menu/coconut-panna-cotta.jpg', 300000),
    (@dessertId, N'Honeyed Crown', N'Buttery tart shell with yuzu cream, meringue and basil gel', 'assets/img/le-royal/menu/yuzu-cream-tart.jpg', 340000),
    (@dessertId, N'Atlas Eclipse', N'Dark chocolate mousse with hazelnut praline and cocoa crumble', 'assets/img/le-royal/menu/chocolate-hazelnut-sphere.jpg', 380000),
    (@dessertId, N'Berry Nightfall', N'Berry compote with yogurt cream, crisp pearls and meringue', 'assets/img/le-royal/menu/matcha-opera-cake.jpg', 360000),
    (@drinkId, N'Afternoon Ritual', N'Tableside tea pairing served with small fruit and herb bites', 'assets/img/le-royal/menu/fresh-orange-juice.jpg', 300000),
    (@drinkId, N'Cellar Twilight', N'Imported French red wine with dark berry notes and smooth tannin', 'assets/img/le-royal/menu/bordeaux-red-wine.jpg', 1200000),
    (@drinkId, N'Silver Celebration', N'One glass of brut champagne selected for tasting menus', 'assets/img/le-royal/menu/champagne-pairing.jpg', 580000),
    (@drinkId, N'Amber Finale', N'House citrus cocktail with herbal syrup and sparkling finish', 'assets/img/le-royal/menu/signature-citrus-cocktail.jpg', 300000),
    (@appetizerId, N'Saffron Orbit', N'A bright first course with crisp textures and warm saffron notes', 'assets/img/le-royal/menu/saffron-orbit.jpg', 360000),
    (@appetizerId, N'Ivory Petal', N'A delicate plated opening with floral lift and light citrus finish', 'assets/img/le-royal/menu/ivory-petal.jpg', 380000),
    (@appetizerId, N'Seasonal Quartet', N'Four small seasonal bites arranged as a tasting prelude', 'assets/img/le-royal/menu/seasonal-quartet.jpg', 520000),
    (@appetizerId, N'Ember Petite', N'A single warm bite with smoked aroma and herb glaze', 'assets/img/le-royal/menu/ember-petite.jpg', 340000),
    (@soupId, N'Earthen Bloom', N'A grounded broth course with toasted aromatics and tender garnish', 'assets/img/le-royal/menu/earthen-bloom.jpg', 330000),
    (@soupId, N'Porcelain Whisper', N'A pale, creamy soup served with garden herbs and soft mineral notes', 'assets/img/le-royal/menu/porcelain-whisper.jpg', 340000),
    (@soupId, N'Rose Gold Broth', N'A warm golden broth with layered sweetness and gentle spice', 'assets/img/le-royal/menu/rose-gold-broth.jpg', 360000),
    (@mainCourseId, N'Silver Leaf Nocturne', N'A composed seafood plate with bright sauce and soft herb oil', 'assets/img/le-royal/menu/silver-leaf.jpg', 720000),
    (@mainCourseId, N'Jade Crown', N'A refined ocean course with green herb notes and a clean finish', 'assets/img/le-royal/menu/jade-crown.jpg', 780000),
    (@mainCourseId, N'Saffron Sun', N'A golden main course with warm spice, butter and citrus sauce', 'assets/img/le-royal/menu/saffron-sun.jpg', 760000),
    (@mainCourseId, N'Pale Orbit', N'A gentle main course with fruit acidity and a light cream sauce', 'assets/img/le-royal/menu/pale-orbit.jpg', 680000),
    (@mainCourseId, N'Black Garden', N'A deep, earthy main course with roasted notes and dark jus', 'assets/img/le-royal/menu/black-garden.jpg', 900000),
    (@mainCourseId, N'Midnight Lotus', N'A dark-plated main course with floral garnish and layered umami', 'assets/img/le-royal/menu/midnight-lotus.jpg', 840000),
    (@mainCourseId, N'Hidden Cove', N'A coastal main course with fresh herbs and quiet briny sweetness', 'assets/img/le-royal/menu/hidden-cove.jpg', 820000),
    (@dessertId, N'Green Ribbon', N'A clean green dessert with soft cream, leaf aroma and crisp finish', 'assets/img/le-royal/menu/green-ribbon.jpg', 320000),
    (@dessertId, N'Tiny Forest', N'A small forest-inspired dessert with berry, cream and roasted crumble', 'assets/img/le-royal/menu/tiny-forest.jpg', 340000),
    (@dessertId, N'Ruby Drop', N'A jewel-like dessert with bright berry acidity and cool sweetness', 'assets/img/le-royal/menu/ruby-drop.jpg', 360000),
    (@dessertId, N'Moss Pearl', N'A quiet green dessert with soft mousse and delicate herbal finish', 'assets/img/le-royal/menu/moss-pearl.jpg', 330000),
    (@drinkId, N'Nocturne Reserve', N'A sommelier-selected reserve pour for richer tasting menus', 'assets/img/le-royal/menu/nocturne-reserve.jpg', 1350000),
    (@drinkId, N'Sommelier Candle', N'A premium table-side wine pairing chosen for the evening courses', 'assets/img/le-royal/menu/sommelier-candle.jpg', 980000);

INSERT INTO menu_set (set_name, description, meal_time, original_price, discounted_price, image_url)
VALUES
    (N'Le Royal Moonlit Journey', N'A poised evening tasting menu moving from garden freshness to a warm ember finish.', 'DINNER', 0, 0, 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg'),
    (N'Garden of Quiet Tides', N'A soft coastal progression with bright sauces, gentle broth and a silver finish.', 'DINNER', 0, 0, 'assets/img/le-royal/menu/pan-seared-salmon.jpg'),
    (N'Ember and Velvet Tasting', N'A darker, rounded menu built around smoke, fruit, roasted depth and quiet sweetness.', 'DINNER', 0, 0, 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'),
    (N'Royal Shell Nocturne', N'A premium seafood-led tasting menu with deep broth, shellfish and reserve pairing.', 'DINNER', 0, 0, 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'),
    (N'The Amber Finale Course', N'A celebratory course menu with saffron warmth, jade richness and candlelit wine.', 'DINNER', 0, 0, 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg');

UPDATE menu_item SET item_name_vi = N'Gỏi Ngó Sen Tôm' WHERE image_url = 'assets/img/le-royal/menu/lotus-stem-salad.jpg';
UPDATE menu_item SET item_name_vi = N'Súp Cua Măng Tây' WHERE image_url = 'assets/img/le-royal/menu/crab-asparagus-soup.jpg';
UPDATE menu_item SET item_name_vi = N'Thăn Bò Tiêu Đen' WHERE image_url = 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg';
UPDATE menu_item SET item_name_vi = N'Cá Hồi Sốt Chanh Dây' WHERE image_url = 'assets/img/le-royal/menu/pan-seared-salmon.jpg';
UPDATE menu_item SET item_name_vi = N'Nước Cam Tươi' WHERE image_url = 'assets/img/le-royal/menu/fresh-orange-juice.jpg';
UPDATE menu_item SET item_name_vi = N'Rượu Vang Bordeaux' WHERE image_url = 'assets/img/le-royal/menu/bordeaux-red-wine.jpg';
UPDATE menu_item SET item_name_vi = N'Cá Ngừ Caviar' WHERE image_url = 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg';
UPDATE menu_item SET item_name_vi = N'Sò Điệp Carpaccio' WHERE image_url = 'assets/img/le-royal/menu/scallop-carpaccio.jpg';
UPDATE menu_item SET item_name_vi = N'Salad Vịt Hun Khói' WHERE image_url = 'assets/img/le-royal/menu/smoked-duck-salad.jpg';
UPDATE menu_item SET item_name_vi = N'Nước Dùng Nấm Truffle' WHERE image_url = 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg';
UPDATE menu_item SET item_name_vi = N'Súp Bí Đỏ Kem Mịn' WHERE image_url = 'assets/img/le-royal/menu/pumpkin-veloute.jpg';
UPDATE menu_item SET item_name_vi = N'Súp Tôm Hùm' WHERE image_url = 'assets/img/le-royal/menu/lobster-bisque.jpg';
UPDATE menu_item SET item_name_vi = N'Cua Hoàng Đế Bơ Thảo Mộc' WHERE image_url = 'assets/img/le-royal/menu/king-crab-herb-butter.jpg';
UPDATE menu_item SET item_name_vi = N'Ức Vịt Sốt Mận' WHERE image_url = 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg';
UPDATE menu_item SET item_name_vi = N'Bào Ngư Risotto Saffron' WHERE image_url = 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg';
UPDATE menu_item SET item_name_vi = N'Pavlova Chanh Dây' WHERE image_url = 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg';
UPDATE menu_item SET item_name_vi = N'Sorbet Dâu Rừng' WHERE image_url = 'assets/img/le-royal/menu/berry-sorbet-garden.jpg';
UPDATE menu_item SET item_name_vi = N'Panna Cotta Dừa' WHERE image_url = 'assets/img/le-royal/menu/coconut-panna-cotta.jpg';
UPDATE menu_item SET item_name_vi = N'Tart Kem Yuzu' WHERE image_url = 'assets/img/le-royal/menu/yuzu-cream-tart.jpg';
UPDATE menu_item SET item_name_vi = N'Bánh Opera Matcha' WHERE image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg';
UPDATE menu_item SET item_name_vi = N'Champagne Pairing' WHERE image_url = 'assets/img/le-royal/menu/champagne-pairing.jpg';
UPDATE menu_item SET item_name_vi = N'Nocturne Reserve' WHERE image_url = 'assets/img/le-royal/menu/nocturne-reserve.jpg';
UPDATE menu_item SET item_name_vi = N'Sommelier Candle' WHERE image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg';

DECLARE @moonlitSetId INT = (SELECT id FROM menu_set WHERE set_name = N'Le Royal Moonlit Journey');
DECLARE @quietTidesSetId INT = (SELECT id FROM menu_set WHERE set_name = N'Garden of Quiet Tides');
DECLARE @emberVelvetSetId INT = (SELECT id FROM menu_set WHERE set_name = N'Ember and Velvet Tasting');
DECLARE @shellNocturneSetId INT = (SELECT id FROM menu_set WHERE set_name = N'Royal Shell Nocturne');
DECLARE @amberFinaleSetId INT = (SELECT id FROM menu_set WHERE set_name = N'The Amber Finale Course');

INSERT INTO menu_set_item (menu_set_id, menu_item_id, quantity)
VALUES
    (@moonlitSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/lotus-stem-salad.jpg'), 1),
    (@moonlitSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/crab-asparagus-soup.jpg'), 1),
    (@moonlitSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg'), 1),
    (@moonlitSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg'), 1),
    (@moonlitSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/bordeaux-red-wine.jpg'), 1),
    (@quietTidesSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/scallop-carpaccio.jpg'), 1),
    (@quietTidesSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg'), 1),
    (@quietTidesSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/pan-seared-salmon.jpg'), 1),
    (@quietTidesSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/berry-sorbet-garden.jpg'), 1),
    (@quietTidesSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/champagne-pairing.jpg'), 1),
    (@emberVelvetSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/smoked-duck-salad.jpg'), 1),
    (@emberVelvetSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/pumpkin-veloute.jpg'), 1),
    (@emberVelvetSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'), 1),
    (@emberVelvetSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/yuzu-cream-tart.jpg'), 1),
    (@emberVelvetSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/fresh-orange-juice.jpg'), 1),
    (@shellNocturneSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg'), 1),
    (@shellNocturneSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/lobster-bisque.jpg'), 1),
    (@shellNocturneSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'), 1),
    (@shellNocturneSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg'), 1),
    (@shellNocturneSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/nocturne-reserve.jpg'), 1),
    (@amberFinaleSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/saffron-orbit.jpg'), 1),
    (@amberFinaleSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/rose-gold-broth.jpg'), 1),
    (@amberFinaleSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg'), 1),
    (@amberFinaleSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/coconut-panna-cotta.jpg'), 1),
    (@amberFinaleSetId, (SELECT id FROM menu_item WHERE image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg'), 1);

UPDATE menu_set
SET set_name_vi = N'Trăng Về Vĩ Dạ',
    description_vi = N'Một thực đơn tối lấy cảm hứng từ ánh trăng, khu vườn và màn sương xứ Huế.'
WHERE set_name = N'Le Royal Moonlit Journey';

UPDATE menu_set
SET set_name_vi = N'Dữ Dội Và Dịu Êm',
    description_vi = N'Một nhịp biển mềm, đi từ vị tươi mát đến dư âm lấp lánh như sóng.'
WHERE set_name = N'Garden of Quiet Tides';

UPDATE menu_set
SET set_name_vi = N'Bếp Lửa Ấp Iu',
    description_vi = N'Một tasting menu ấm, sâu và có khói, gợi cảm giác bữa tối bên bếp lửa.'
WHERE set_name = N'Ember and Velvet Tasting';

UPDATE menu_set
SET set_name_vi = N'Đoàn Thuyền Sao Biển',
    description_vi = N'Một hành trình hải vị đêm, từ mặt biển tối đến khoang thuyền đầy sao.'
WHERE set_name = N'Royal Shell Nocturne';

UPDATE menu_set
SET set_name_vi = N'Tắt Nắng Buộc Gió',
    description_vi = N'Một thực đơn tiệc sáng rực, giữ lại hương vàng, men say và khoảnh khắc đang chín.'
WHERE set_name = N'The Amber Finale Course';

;WITH course_names AS (
    SELECT N'Le Royal Moonlit Journey' AS set_name, 'assets/img/le-royal/menu/lotus-stem-salad.jpg' AS image_url, N'Vườn Ai Mướt Quá' AS course_name_vi UNION ALL
    SELECT N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/crab-asparagus-soup.jpg', N'Sương Khói Mờ Nhân Ảnh' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg', N'Thuyền Ai Đậu Bến Trăng' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg', N'Áo Em Trắng Quá' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/bordeaux-red-wine.jpg', N'Gió Theo Lối Gió' UNION ALL
    SELECT N'Garden of Quiet Tides', 'assets/img/le-royal/menu/scallop-carpaccio.jpg', N'Con Sóng Dưới Lòng Sâu' UNION ALL
    SELECT N'Garden of Quiet Tides', 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg', N'Sóng Tìm Ra Tận Bể' UNION ALL
    SELECT N'Garden of Quiet Tides', 'assets/img/le-royal/menu/pan-seared-salmon.jpg', N'Ngày Xưa Và Ngày Sau' UNION ALL
    SELECT N'Garden of Quiet Tides', 'assets/img/le-royal/menu/berry-sorbet-garden.jpg', N'Ngàn Con Sóng Nhỏ' UNION ALL
    SELECT N'Garden of Quiet Tides', 'assets/img/le-royal/menu/champagne-pairing.jpg', N'Bờ Xa Vỗ Mãi' UNION ALL
    SELECT N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/smoked-duck-salad.jpg', N'Chờn Vờn Sương Sớm' UNION ALL
    SELECT N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/pumpkin-veloute.jpg', N'Ấp Iu Nồng Đượm' UNION ALL
    SELECT N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg', N'Một Ngọn Lửa Lòng' UNION ALL
    SELECT N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/yuzu-cream-tart.jpg', N'Thương Về Bếp Lửa' UNION ALL
    SELECT N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/fresh-orange-juice.jpg', N'Dậy Mùi Khói Bếp' UNION ALL
    SELECT N'Royal Shell Nocturne', 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg', N'Mặt Trời Xuống Biển' UNION ALL
    SELECT N'Royal Shell Nocturne', 'assets/img/le-royal/menu/lobster-bisque.jpg', N'Câu Hát Căng Buồm' UNION ALL
    SELECT N'Royal Shell Nocturne', 'assets/img/le-royal/menu/king-crab-herb-butter.jpg', N'Cá Bạc Biển Đông' UNION ALL
    SELECT N'Royal Shell Nocturne', 'assets/img/le-royal/menu/matcha-opera-cake.jpg', N'Sao Mờ Kéo Lưới' UNION ALL
    SELECT N'Royal Shell Nocturne', 'assets/img/le-royal/menu/nocturne-reserve.jpg', N'Bình Minh Nâng Chén' UNION ALL
    SELECT N'The Amber Finale Course', 'assets/img/le-royal/menu/saffron-orbit.jpg', N'Nắng Hạ Chưa Phai' UNION ALL
    SELECT N'The Amber Finale Course', 'assets/img/le-royal/menu/rose-gold-broth.jpg', N'Hương Mật Tháng Giêng' UNION ALL
    SELECT N'The Amber Finale Course', 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg', N'Vội Vàng Giữ Ngọc' UNION ALL
    SELECT N'The Amber Finale Course', 'assets/img/le-royal/menu/coconut-panna-cotta.jpg', N'Mây Gần Môi' UNION ALL
    SELECT N'The Amber Finale Course', 'assets/img/le-royal/menu/sommelier-candle.jpg', N'Men Say Rất Vội'
)
UPDATE msi
SET course_name_vi = course_names.course_name_vi
FROM menu_set_item msi
JOIN menu_set ms ON ms.id = msi.menu_set_id
JOIN menu_item mi ON mi.id = msi.menu_item_id
JOIN course_names ON course_names.set_name = ms.set_name
    AND course_names.image_url = mi.image_url;

;WITH set_totals AS (
    SELECT
        msi.menu_set_id,
        SUM((mi.base_price + ISNULL(ms.price_modifier, 0)) * msi.quantity) AS total_price
    FROM menu_set_item msi
    JOIN menu_item mi ON mi.id = msi.menu_item_id
    LEFT JOIN menu_item_size ms ON ms.id = msi.default_size_id
    GROUP BY msi.menu_set_id
)
UPDATE menu_set
SET original_price = st.total_price,
    discounted_price = st.total_price
FROM menu_set
JOIN set_totals st ON st.menu_set_id = menu_set.id;

INSERT INTO addon_service (service_name, description, price, image_url)
VALUES
    (N'Rose Table Decoration', N'Fresh roses and candle styling', 250000, 'assets/img/le-royal/Signature Red Rose Bouquet.jpg'),
    (N'Premium Birthday Cake', N'Chocolate or fruit cake on request', 350000, 'assets/img/le-royal/Champagne Welcome Service.jpg'),
    (N'Table Violin Performance', N'Thirty minute private violin performance', 500000, 'assets/img/le-royal/Private Live Pianist.jpg');

IF NOT EXISTS (SELECT 1 FROM customer_rank_config WHERE rank_name = 'BRONZE')
BEGIN
    INSERT INTO customer_rank_config (rank_name, min_point_threshold, discount_percent, points_per_thousand_vnd, can_book_vip, can_book_vvip, is_active)
    VALUES
        ('BRONZE', 0, 0, 1, 0, 0, 1),
        ('SILVER', 5000, 5.00, 1, 0, 0, 1),
        ('GOLD', 20000, 10.00, 2, 1, 0, 1),
        ('PLATINUM', 50000, 15.00, 3, 1, 1, 1),
        ('DIAMOND', 100000, 20.00, 5, 1, 1, 1);
END
GO

INSERT INTO voucher
    (voucher_code, voucher_type, discount_percent, discount_amount, min_order_value, max_discount, valid_from, valid_to, usage_limit)
VALUES
    ('WELCOME10', 'FIRST_ORDER', 10.00, NULL, 300000, 100000, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 1000),
    ('VIPLUNCH', 'LUNCH', 15.00, NULL, 500000, 200000, GETDATE(), DATEADD(MONTH, 6, GETDATE()), 500);
GO

PRINT 'RestaurantManagement database schema and seed data created successfully.';


-- Xóa dữ liệu cũ (nếu có)
DELETE FROM holiday_surcharge;
GO

INSERT INTO holiday_surcharge (holiday_name, surcharge_date, surcharge_percent, is_active) VALUES
(N'Tết Dương Lịch', '2026-01-01', 15.00, 1),
(N'Mùng 1 Tết Nguyên Đán', '2026-02-17', 20.00, 1),
(N'Mùng 2 Tết Nguyên Đán', '2026-02-18', 20.00, 1),
(N'Mùng 3 Tết Nguyên Đán', '2026-02-19', 20.00, 1),
(N'Quốc tế Phụ nữ', '2026-03-08', 10.00, 1),
(N'Giỗ Tổ Hùng Vương', '2026-04-26', 15.00, 1),
(N'Giải phóng Miền Nam', '2026-04-30', 15.00, 1),
(N'Quốc tế Lao động', '2026-05-01', 15.00, 1),
(N'Quốc khánh Việt Nam', '2026-09-02', 15.00, 1),
(N'Phụ nữ Việt Nam', '2026-10-20', 10.00, 1),
(N'Lễ Giáng Sinh', '2026-12-24', 15.00, 1);
GO
