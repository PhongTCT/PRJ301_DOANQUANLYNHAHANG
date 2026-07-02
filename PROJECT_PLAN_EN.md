# Restaurant Management & Online Booking System — Project Plan v4

> **Production-Grade Plan** — PRJ301, FPT University, Semester 4  
> **Tech:** JDK 8 | Tomcat 9 | NetBeans 13 Ant | JPA/Hibernate | SQL Server | Bootstrap 5  
> **Prompt Version:** 2.0 — Refined & Comprehensive

---

## TABLE OF CONTENTS

1. [Tech Stack & Constraints](#1-tech-stack--constraints)
2. [Architecture Overview](#2-architecture-overview)
3. [OUTPUT 1 — JPA Entities (24 entities)](#3-output-1--24-jpa-entities)
4. [OUTPUT 2 — WBS (4 Devs)](#4-output-2--wbs-4-devs)
5. [OUTPUT 3 — Flowcharts (5 flows)](#5-output-3--5-flowcharts)
6. [OUTPUT 4 — Folder Structure](#6-output-4--folder-structure)
7. [Design Constraints Documentation](#7-design-constraints)
8. [Milestones & Timeline](#8-milestones)
9. [Optional Improvements](#9-optional-improvements)

---

## 1. TECH STACK & CONSTRAINTS

### 1.1 Back-end

| Constraint  | Value                                                                                             |
| ----------- | ------------------------------------------------------------------------------------------------- |
| Runtime     | JDK 8 — NO JDK 9+ APIs                                                                            |
| Server      | Apache Tomcat 9                                                                                   |
| IDE / Build | NetBeans 13, Ant Build (NO Maven, NO Gradle)                                                      |
| Namespace   | `javax.*` ONLY — NO `jakarta.*`                                                                   |
| ORM         | Hibernate-core 5.x (JDK 8 compatible), `persistence.xml` at `src/META-INF/`, JPA Annotations only |
| JSON        | Jackson 2.x (`com.fasterxml.jackson`) + `ObjectMapper`                                            |
| File Upload | Apache Commons FileUpload → Cloudinary SDK → store `secure_url` only                              |
| Payment     | VNPay Sandbox + MoMo Sandbox, IPN bypasses AuthFilter                                             |
| Email       | JavaMail (`javax.mail`) via SMTP, async via `ExecutorService` fixed thread pool                   |
| Password    | jBCrypt 0.4 — NO SHA/MD5                                                                          |

### 1.2 Front-end

| Constraint    | Value                                                               |
| ------------- | ------------------------------------------------------------------- |
| CSS Framework | Bootstrap 5 (CDN) — NO Bootstrap 3/4, NO Tailwind, NO Materialize   |
| UI Components | Modal, Toast, Card, Grid (col-\*), Offcanvas (optional cart drawer) |
| AJAX          | Fetch API (native) — NO jQuery AJAX, NO Axios                       |
| Session Cart  | `HttpSession["bookingDraft"]` — preserved across login modal        |
| Rendering     | JSP + JSTL (`c:`, `fmt:`) — NO scriptlets                           |

### 1.3 Database

| Constraint         | Value                                                    |
| ------------------ | -------------------------------------------------------- |
| RDBMS              | SQL Server 2014+                                         |
| Normalization      | 3NF / BCNF                                               |
| Script             | Re-runnable (DROP IF EXISTS → CREATE → INSERT seed)      |
| Naming             | `snake_case`                                             |
| Unicode            | `NVARCHAR` for all Vietnamese text                       |
| Enum Storage       | `VARCHAR(50)` with `@Enumerated(EnumType.STRING)`        |
| Auto-increment     | `IDENTITY(1,1)` → `@GeneratedValue(strategy = IDENTITY)` |
| Optimistic Locking | `INT NOT NULL DEFAULT 0` for `@Version`                  |

### 1.4 Architecture MVC-V2

**Pattern:** FrontController — single `DispatcherServlet` mapped to `/*` in `web.xml`.  
**Routing:** `DispatcherServlet` reads `action` parameter → forwards to Controller.  
**No `@WebServlet`, `@WebFilter`, or `@WebListener` annotations** — all declared in `web.xml`.

**Layer stack:**

- **Filter** (`javax.servlet.Filter`): AuthFilter, RememberMeFilter, RoleFilter, HolidaySurchargeNotifyFilter
- **Controller** (Servlet): receives request, validates input, calls Service
- **Service** (POJO): all business logic — Controller never calls DAO directly
- **DAO** (POJO): JPA CRUD only — no business logic, one DAO per Entity
- **Entity** (`@Entity` class): JPA mapping — no business logic
- **DTO** (POJO): data transfer between Controller ↔ View / JSON response
- **View** (JSP): display only — never queries DB

**Package structure:** Flat — max 2 levels deep from `java/`.

---

## 3. OUTPUT 1 — 24 JPA ENTITIES

### Entity 1 — User

- **Entity Name:** `User`
- **Table Name:** `users`
- **Mô tả nghiệp vụ:** Tài khoản người dùng hệ thống, hỗ trợ đăng ký thường và Google OAuth2, lưu token remember me và email verification.

| Attribute (Java) | Column (SQL)       | SQL Server Type      | JPA Annotation                              | Ghi chú                                     |
| ---------------- | ------------------ | -------------------- | ------------------------------------------- | ------------------------------------------- |
| id               | id                 | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                          |
| email            | email              | NVARCHAR(255)        | @Column(nullable=false, unique=true)        | Login identifier                            |
| password         | password           | VARCHAR(255)         | @Column(nullable=true)                      | BCrypt hash; nullable for Google-only users |
| fullName         | full_name          | NVARCHAR(100)        | @Column(nullable=false)                     |                                             |
| phone            | phone              | VARCHAR(20)          | @Column(nullable=true)                      |                                             |
| dateOfBirth      | date_of_birth      | DATE                 | @Column(nullable=true)                      | Used for BIRTHDAY_MONTH voucher             |
| googleId         | google_id          | VARCHAR(255)         | @Column(nullable=true, unique=true)         | Google OAuth2 sub claim                     |
| avatarUrl        | avatar_url         | VARCHAR(500)         | @Column(nullable=true)                      | Google avatar or uploaded                   |
| role             | role               | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | ADMIN / STAFF / CUSTOMER                    |
| status           | status             | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | PENDING / NEEDS_INFO / ACTIVE / BANNED      |
| emailVerifyToken | email_verify_token | VARCHAR(255)         | @Column(nullable=true)                      | UUID for email verification                 |
| emailVerified    | email_verified     | BIT                  | @Column(nullable=false)                     | Whether email has been verified             |
| firstOrderUsed   | first_order_used   | BIT                  | @Column(nullable=false)                     | Whether FIRST_ORDER voucher was consumed    |
| rememberToken    | remember_token     | VARCHAR(255)         | @Column(nullable=true)                      | Remember Me persistent token                |
| tokenExpiry      | token_expiry       | DATETIME2            | @Column(nullable=true)                      | Remember Me token expiry                    |
| createdAt        | created_at         | DATETIME2            | @Column(nullable=false, updatable=false)    | Default GETDATE()                           |
| updatedAt        | updated_at         | DATETIME2            | @Column(nullable=false)                     |                                             |

**Quan hệ JPA:**

- `@OneToOne(mappedBy = "user")` → `CustomerProfile` — FetchType.LAZY — Profile is loaded only when needed, not on every User query.
- `@OneToMany(mappedBy = "user")` → `Reservation` — FetchType.LAZY — Reservations are numerous; eager load would cause N+1 or massive joins.
- `@OneToMany(mappedBy = "user")` → `Review` — FetchType.LAZY — Same reason.
- `@OneToMany(mappedBy = "user")` → `LoyaltyTransaction` — FetchType.LAZY.
- `@OneToMany(mappedBy = "user")` → `VoucherRedemption` — FetchType.LAZY.

---

### Entity 2 — CustomerProfile

- **Entity Name:** `CustomerProfile`
- **Table Name:** `customer_profile`
- **Mô tả nghiệp vụ:** Extended customer info: loyalty points (for rank), coin balance (for payment), current rank, activity tracking for decay.

| Attribute (Java) | Column (SQL)      | SQL Server Type      | JPA Annotation                           | Ghi chú                                   |
| ---------------- | ----------------- | -------------------- | ---------------------------------------- | ----------------------------------------- |
| id               | id                | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      | PK                                        |
| userId           | user_id           | BIGINT               | @Column(nullable=false, unique=true)     | FK to User                                |
| totalSpent       | total_spent       | DECIMAL(12,0)        | @Column(nullable=false)                  | Total paid (reference only, not for rank) |
| loyaltyPoints    | loyalty_points    | INT                  | @Column(nullable=false)                  | Points (determines rank)                  |
| coinBalance      | coin_balance      | DECIMAL(12,0)        | @Column(nullable=false)                  | Virtual coins for payment (1 coin = 10K)  |
| currentRankId    | current_rank_id   | INT                  | @Column(nullable=true)                   | FK to CustomerRankConfig                  |
| lastActivityAt   | last_activity_at  | DATETIME2            | @Column(nullable=true)                   | Last transaction timestamp                |
| lastDecayAt      | last_decay_at     | DATETIME2            | @Column(nullable=true)                   | Last points decay timestamp               |
| createdAt        | created_at        | DATETIME2            | @Column(nullable=false, updatable=false) |                                           |
| updatedAt        | updated_at        | DATETIME2            | @Column(nullable=false)                  |                                           |

**Quan hệ JPA:**

- `@OneToOne` → `User` — FetchType.LAZY — FK userId references User.
- `@ManyToOne` → `CustomerRankConfig` — FetchType.EAGER — Rank is tiny, rarely changes, and is needed on every profile display; eager avoids extra query.

---

### Entity 3 — CustomerRankConfig

- **Entity Name:** `CustomerRankConfig`
- **Table Name:** `customer_rank_config`
- **Mô tả nghiệp vụ:** Rank configuration managed by Admin: point thresholds, discount %, earning rates, VIP access.

| Attribute (Java)     | Column (SQL)             | SQL Server Type   | JPA Annotation                                           | Ghi chú                                     |
| -------------------- | ------------------------ | ----------------- | -------------------------------------------------------- | ------------------------------------------- |
| id                   | id                       | INT IDENTITY(1,1) | @Id @GeneratedValue                                      | PK                                          |
| rankName             | rank_name                | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false, unique=true) | BRONZE / SILVER / GOLD / PLATINUM / DIAMOND |
| minPointThreshold    | min_point_threshold      | INT               | @Column(nullable=false)                                  | Minimum points required for this rank       |
| discountPercent      | discount_percent         | DECIMAL(5,2)      | @Column(nullable=false)                                  | Bill discount %                             |
| pointsPerThousandVnd | points_per_thousand_vnd  | INT               | @Column(nullable=false)                                  | Points earned per 1000 VND spent            |
| canBookVip           | can_book_vip             | BIT               | @Column(nullable=false)                                  | Whether rank can book VIP rooms             |
| canBookVvip          | can_book_vvip            | BIT               | @Column(nullable=false)                                  | Whether rank can book VVIP rooms            |
| isActive             | is_active                | BIT               | @Column(nullable=false)                                  |                                             |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "currentRank")` → `CustomerProfile` — FetchType.LAZY — Many customers can share one rank config; loaded on demand.

---

### Entity 4 — RankTopUp

- **Entity Name:** `RankTopUp`
- **Table Name:** `rank_topup`
- **Mô tả nghiệp vụ:** Lịch sử nạp tiền lên hạng của khách hàng, ghi nhận phương thức thanh toán và trạng thái giao dịch.

| Attribute (Java) | Column (SQL)    | SQL Server Type      | JPA Annotation                              | Ghi chú                            |
| ---------------- | --------------- | -------------------- | ------------------------------------------- | ---------------------------------- |
| id               | id              | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                 |
| userId           | user_id         | BIGINT               | @Column(nullable=false)                     | FK to User                         |
| targetRank       | target_rank     | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | SILVER / GOLD / PLATINUM / DIAMOND |
| amount           | amount          | DECIMAL(12,0)        | @Column(nullable=false)                     | Amount paid                        |
| paymentMethod    | payment_method  | VARCHAR(10)          | @Enumerated(STRING) @Column(nullable=false) | VNPAY / MOMO                       |
| transactionRef   | transaction_ref | VARCHAR(100)         | @Column(nullable=true)                      | Payment gateway reference          |
| status           | status          | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | PENDING / SUCCESS / FAILED         |
| createdAt        | created_at      | DATETIME2            | @Column(nullable=false, updatable=false)    |                                    |

**Quan hệ JPA:**

- `@ManyToOne` → `User` — FetchType.LAZY — Load user only when traversing top-up history.

---

### Entity 5 — LoyaltyTransaction

- **Entity Name:** `LoyaltyTransaction`
- **Table Name:** `loyalty_transaction`
- **Mô tả nghiệp vụ:** Audit log cho mọi thay đổi điểm và hạng của khách hàng (tích điểm, đổi điểm, nạp hạng, lên hạng).

| Attribute (Java) | Column (SQL)     | SQL Server Type      | JPA Annotation                              | Ghi chú                                |
| ---------------- | ---------------- | -------------------- | ------------------------------------------- | -------------------------------------- |
| id               | id               | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                     |
| userId           | user_id          | BIGINT               | @Column(nullable=false)                     | FK to User                             |
| type             | type             | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | EARN / REDEEM / TOPUP / RANK_UPGRADE / POINTS_DECAY / RANK_DOWNGRADE |
| pointsDelta      | points_delta     | INT                  | @Column(nullable=false)                     | Positive for earn, negative for redeem |
| amountReference  | amount_reference | DECIMAL(12,0)        | @Column(nullable=true)                      | Monetary amount that triggered this    |
| description      | description      | NVARCHAR(255)        | @Column(nullable=true)                      | Human-readable reason                  |
| createdAt        | created_at       | DATETIME2            | @Column(nullable=false, updatable=false)    |                                        |

**Quan hệ JPA:**

- `@ManyToOne` → `User` — FetchType.LAZY — Many transactions per user; lazy is mandatory.

---

### Entity 6 — EventType

- **Entity Name:** `EventType`
- **Table Name:** `event_type`
- **Mô tả nghiệp vụ:** Danh mục loại sự kiện đặt bàn (sinh nhật, hẹn hò, họp mặt, v.v.).

| Attribute (Java) | Column (SQL) | SQL Server Type   | JPA Annotation          | Ghi chú                |
| ---------------- | ------------ | ----------------- | ----------------------- | ---------------------- |
| id               | id           | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                     |
| name             | name         | NVARCHAR(100)     | @Column(nullable=false) | E.g., "Tiệc sinh nhật" |
| description      | description  | NVARCHAR(255)     | @Column(nullable=true)  |                        |
| isActive         | is_active    | BIT               | @Column(nullable=false) |                        |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "eventType")` → `Reservation` — FetchType.LAZY.

---

### Entity 7 — Area

- **Entity Name:** `Area`
- **Table Name:** `area`
- **Mô tả nghiệp vụ:** Khu vực ngồi trong nhà hàng (sân vườn, trong nhà, hiên, v.v.), có price_modifier riêng.

| Attribute (Java) | Column (SQL)   | SQL Server Type   | JPA Annotation          | Ghi chú                        |
| ---------------- | -------------- | ----------------- | ----------------------- | ------------------------------ |
| id               | id             | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                             |
| name             | name           | NVARCHAR(100)     | @Column(nullable=false) | E.g., "Sân vườn ngoài trời"    |
| description      | description    | NVARCHAR(255)     | @Column(nullable=true)  |                                |
| priceModifier    | price_modifier | DECIMAL(10,0)     | @Column(nullable=false) | Extra VND added to table price |
| isActive         | is_active      | BIT               | @Column(nullable=false) |                                |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "area")` → `Room` — FetchType.LAZY — One area has many rooms.

---

### Entity 8 — Room

- **Entity Name:** `Room`
- **Table Name:** `room`
- **Mô tả nghiệp vụ:** Phòng ăn thuộc một khu vực, có loại (STANDARD/VIP/VVIP), sức chứa và phí thuê phòng.

| Attribute (Java) | Column (SQL)      | SQL Server Type   | JPA Annotation                              | Ghi chú               |
| ---------------- | ----------------- | ----------------- | ------------------------------------------- | --------------------- |
| id               | id                | INT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                    |
| areaId           | area_id           | INT               | @Column(nullable=false)                     | FK to Area            |
| roomName         | room_name         | NVARCHAR(100)     | @Column(nullable=false)                     | E.g., "Phòng VIP 1"   |
| roomType         | room_type         | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false) | STANDARD / VIP / VVIP |
| capacity         | capacity          | INT               | @Column(nullable=false)                     | Max persons           |
| pricePerSession  | price_per_session | DECIMAL(10,0)     | @Column(nullable=false)                     | Room rental fee       |
| isActive         | is_active         | BIT               | @Column(nullable=false)                     |                       |

**Quan hệ JPA:**

- `@ManyToOne` → `Area` — FetchType.EAGER — Area is a tiny reference loaded every time a room is displayed; eager avoids N+1.
- `@OneToMany(mappedBy = "room")` → `DiningTable` — FetchType.LAZY — Many tables per room.

---

### Entity 9 — DiningTable

- **Entity Name:** `DiningTable`
- **Table Name:** `dining_table`
- **Mô tả nghiệp vụ:** Bàn ăn cụ thể trong phòng, có sức chứa, giá thuê, trạng thái và @Version cho Optimistic Locking.

| Attribute (Java) | Column (SQL) | SQL Server Type        | JPA Annotation                              | Ghi chú                               |
| ---------------- | ------------ | ---------------------- | ------------------------------------------- | ------------------------------------- |
| id               | id           | INT IDENTITY(1,1)      | @Id @GeneratedValue                         | PK                                    |
| roomId           | room_id      | INT                    | @Column(nullable=false)                     | FK to Room                            |
| tableCode        | table_code   | VARCHAR(20)            | @Column(nullable=false, unique=true)        | E.g., "A01", "VIP-B03"                |
| capacity         | capacity     | INT                    | @Column(nullable=false)                     | 2 / 4 / 6 / 8 / 10                    |
| basePrice        | base_price   | DECIMAL(10,0)          | @Column(nullable=false)                     | Price per session                     |
| status           | status       | VARCHAR(20)            | @Enumerated(STRING) @Column(nullable=false) | AVAILABLE / RESERVED / OCCUPIED       |
| version          | version      | INT NOT NULL DEFAULT 0 | @Version                                    | Optimistic Locking for race condition |
| isActive         | is_active    | BIT                    | @Column(nullable=false)                     |                                       |

**Quan hệ JPA:**

- `@ManyToOne` → `Room` — FetchType.EAGER — Room reference needed when displaying table; eager avoids N+1 on small lookup.
- `@OneToMany(mappedBy = "diningTable")` → `ReservationTable` — FetchType.LAZY.

---

### Entity 10 — MenuCategory

- **Entity Name:** `MenuCategory`
- **Table Name:** `menu_category`
- **Mô tả nghiệp vụ:** Phân loại món ăn theo bữa (sáng/trưa/tối) và loại món (khai vị, món chính, tráng miệng).

| Attribute (Java) | Column (SQL)  | SQL Server Type   | JPA Annotation                              | Ghi chú                                   |
| ---------------- | ------------- | ----------------- | ------------------------------------------- | ----------------------------------------- |
| id               | id            | INT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                        |
| categoryName     | category_name | NVARCHAR(100)     | @Column(nullable=false)                     | E.g., "Khai vị", "Món chính"              |
| mealTime         | meal_time     | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false) | BREAKFAST / LUNCH / DINNER / ALL_DAY      |
| categoryType     | category_type | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false) | APPETIZER / MAIN / DESSERT / DRINK / SOUP |
| sortOrder        | sort_order    | INT               | @Column(nullable=false)                     | Display order                             |
| isActive         | is_active     | BIT               | @Column(nullable=false)                     |                                           |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "category")` → `MenuItem` — FetchType.LAZY.

---

### Entity 11 — MenuItem

- **Entity Name:** `MenuItem`
- **Table Name:** `menu_item`
- **Mô tả nghiệp vụ:** Món ăn đơn lẻ trong thực đơn, có ảnh Cloudinary, mô tả nguyên liệu, thuộc một MenuCategory.

| Attribute (Java) | Column (SQL) | SQL Server Type   | JPA Annotation                           | Ghi chú                         |
| ---------------- | ------------ | ----------------- | ---------------------------------------- | ------------------------------- |
| id               | id           | INT IDENTITY(1,1) | @Id @GeneratedValue                      | PK                              |
| categoryId       | category_id  | INT               | @Column(nullable=false)                  | FK to MenuCategory              |
| itemName         | item_name    | NVARCHAR(150)     | @Column(nullable=false)                  |                                 |
| description      | description  | NVARCHAR(MAX)     | @Column(nullable=true)                   | Ingredients description         |
| imageUrl         | image_url    | VARCHAR(500)      | @Column(nullable=true)                   | Cloudinary secure_url           |
| basePrice        | base_price   | DECIMAL(10,0)     | @Column(nullable=false)                  | Base price before size modifier |
| isAvailable      | is_available | BIT               | @Column(nullable=false)                  |                                 |
| createdAt        | created_at   | DATETIME2         | @Column(nullable=false, updatable=false) |                                 |

**Quan hệ JPA:**

- `@ManyToOne` → `MenuCategory` — FetchType.EAGER — Category is a small reference, needed when displaying menu items.
- `@OneToMany(mappedBy = "menuItem")` → `MenuItemSize` — FetchType.LAZY.
- `@OneToMany(mappedBy = "menuItem")` → `MenuSetItem` — FetchType.LAZY.

---

### Entity 12 — MenuItemSize

- **Entity Name:** `MenuItemSize`
- **Table Name:** `menu_item_size`
- **Mô tả nghiệp vụ:** Các size khác nhau của một món ăn (Nhỏ/Vừa/Lớn), mỗi size có price_modifier riêng.

| Attribute (Java) | Column (SQL)   | SQL Server Type   | JPA Annotation          | Ghi chú                       |
| ---------------- | -------------- | ----------------- | ----------------------- | ----------------------------- |
| id               | id             | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                            |
| menuItemId       | menu_item_id   | INT               | @Column(nullable=false) | FK to MenuItem                |
| sizeName         | size_name      | NVARCHAR(50)      | @Column(nullable=false) | E.g., "Nhỏ", "Vừa", "Lớn"     |
| priceModifier    | price_modifier | DECIMAL(10,0)     | @Column(nullable=false) | Extra VND added to base_price |

**Quan hệ JPA:**

- `@ManyToOne` → `MenuItem` — FetchType.EAGER — Size is always accessed via its parent item; eager avoids N+1.

---

### Entity 13 — MenuSet

- **Entity Name:** `MenuSet`
- **Table Name:** `menu_set`
- **Mô tả nghiệp vụ:** Set combo theo bữa, có giá gốc và giá ưu đãi, có ảnh Cloudinary.

| Attribute (Java) | Column (SQL)     | SQL Server Type   | JPA Annotation                              | Ghi chú                       |
| ---------------- | ---------------- | ----------------- | ------------------------------------------- | ----------------------------- |
| id               | id               | INT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                            |
| setName          | set_name         | NVARCHAR(150)     | @Column(nullable=false)                     |                               |
| description      | description      | NVARCHAR(MAX)     | @Column(nullable=true)                      |                               |
| mealTime         | meal_time        | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false) | BREAKFAST / LUNCH / DINNER    |
| originalPrice    | original_price   | DECIMAL(10,0)     | @Column(nullable=false)                     | Sum of individual item prices |
| discountedPrice  | discounted_price | DECIMAL(10,0)     | @Column(nullable=false)                     | Promotional price             |
| imageUrl         | image_url        | VARCHAR(500)      | @Column(nullable=true)                      | Cloudinary secure_url         |
| isAvailable      | is_available     | BIT               | @Column(nullable=false)                     |                               |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "menuSet")` → `MenuSetItem` — FetchType.LAZY.

---

### Entity 14 — MenuSetItem

- **Entity Name:** `MenuSetItem`
- **Table Name:** `menu_set_item`
- **Mô tả nghiệp vụ:** Bảng join giữa MenuSet và MenuItem, xác định món nào thuộc set nào với số lượng và size mặc định.

| Attribute (Java) | Column (SQL)    | SQL Server Type   | JPA Annotation          | Ghi chú                       |
| ---------------- | --------------- | ----------------- | ----------------------- | ----------------------------- |
| id               | id              | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                            |
| menuSetId        | menu_set_id     | INT               | @Column(nullable=false) | FK to MenuSet                 |
| menuItemId       | menu_item_id    | INT               | @Column(nullable=false) | FK to MenuItem                |
| quantity         | quantity        | INT               | @Column(nullable=false) | Default quantity in set       |
| defaultSizeId    | default_size_id | INT               | @Column(nullable=true)  | FK to MenuItemSize (optional) |

**Quan hệ JPA:**

- `@ManyToOne` → `MenuSet` — FetchType.LAZY.
- `@ManyToOne` → `MenuItem` — FetchType.LAZY.
- `@ManyToOne` → `MenuItemSize` — FetchType.LAZY.

---

### Entity 15 — AddonService

- **Entity Name:** `AddonService`
- **Table Name:** `addon_service`
- **Mô tả nghiệp vụ:** Dịch vụ thêm kèm khi đặt bàn (trang trí, hoa, nhạc sống, bánh kem, v.v.).

| Attribute (Java) | Column (SQL) | SQL Server Type   | JPA Annotation          | Ghi chú               |
| ---------------- | ------------ | ----------------- | ----------------------- | --------------------- |
| id               | id           | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                    |
| serviceName      | service_name | NVARCHAR(150)     | @Column(nullable=false) |                       |
| description      | description  | NVARCHAR(MAX)     | @Column(nullable=true)  |                       |
| price            | price        | DECIMAL(10,0)     | @Column(nullable=false) |                       |
| imageUrl         | image_url    | VARCHAR(500)      | @Column(nullable=true)  | Cloudinary secure_url |
| isAvailable      | is_available | BIT               | @Column(nullable=false) |                       |

**Quan hệ JPA:**

- `@OneToMany(mappedBy = "addonService")` → `ReservationAddon` — FetchType.LAZY.

---

### Entity 16 — HolidaySurcharge

- **Entity Name:** `HolidaySurcharge`
- **Table Name:** `holiday_surcharge`
- **Mô tả nghiệp vụ:** Cấu hình ngày lễ có phụ thu, admin bật/tắt trạng thái active cho từng ngày.

| Attribute (Java) | Column (SQL)      | SQL Server Type   | JPA Annotation          | Ghi chú                |
| ---------------- | ----------------- | ----------------- | ----------------------- | ---------------------- |
| id               | id                | INT IDENTITY(1,1) | @Id @GeneratedValue     | PK                     |
| holidayName      | holiday_name      | NVARCHAR(100)     | @Column(nullable=false) | E.g., "Tết Dương lịch" |
| surchargeDate    | surcharge_date    | DATE              | @Column(nullable=false) | The specific date      |
| surchargePercent | surcharge_percent | DECIMAL(5,2)      | @Column(nullable=false) | E.g., 10.00 = 10%      |
| isActive         | is_active         | BIT               | @Column(nullable=false) | Toggle on/off          |

**Quan hệ JPA:**

- No associations to other entities (standalone lookup table).

---

### Entity 17 — Reservation

- **Entity Name:** `Reservation`
- **Table Name:** `reservation`
- **Mô tả nghiệp vụ:** Đặt bàn chính — hỗ trợ cả online và offline (walk-in), lưu thông tin khách (nullable), trạng thái đa dạng.

| Attribute (Java) | Column (SQL)        | SQL Server Type      | JPA Annotation                              | Ghi chú                                                            |
| ---------------- | ------------------- | -------------------- | ------------------------------------------- | ------------------------------------------------------------------ |
| id               | id                  | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                                                 |
| userId           | user_id             | BIGINT               | @Column(nullable=true)                      | FK to User; NULL for walk-in                                       |
| guestName        | guest_name          | NVARCHAR(100)        | @Column(nullable=true)                      | Walk-in guest name                                                 |
| guestPhone       | guest_phone         | VARCHAR(20)          | @Column(nullable=true)                      | Walk-in guest phone                                                |
| eventTypeId      | event_type_id       | INT                  | @Column(nullable=false)                     | FK to EventType                                                    |
| reservationDate  | reservation_date    | DATE                 | @Column(nullable=false)                     |                                                                    |
| reservationTime  | reservation_time    | TIME                 | @Column(nullable=false)                     | Slot-based (30-min intervals)                                      |
| adultsCount      | adults_count        | INT                  | @Column(nullable=false)                     | Min 1                                                              |
| childrenCount    | children_count      | INT                  | @Column(nullable=false)                     |                                                                    |
| hasChildren      | has_children        | BIT                  | @Column(nullable=false)                     | Whether children are included                                      |
| status           | status              | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | PENDING / CONFIRMED / CHECKED_IN / COMPLETED / CANCELLED / NO_SHOW |
| depositAmount    | deposit_amount      | DECIMAL(12,0)        | @Column(nullable=false)                     | Deposit required (0 for walk-in)                                   |
| depositPaid      | deposit_paid        | BIT                  | @Column(nullable=false)                     | Whether deposit was paid                                           |
| isOnline         | is_online           | BIT                  | @Column(nullable=false)                     | true = online booking, false = staff-created                       |
| createdByStaffId | created_by_staff_id | INT                  | @Column(nullable=true)                      | FK to User (STAFF); NULL for online                                |
| checkinAt        | checkin_at          | DATETIME2            | @Column(nullable=true)                      | Timestamp when guest checked in                                    |
| hasSurcharge     | has_surcharge       | BIT                  | @Column(nullable=false)                     | Whether holiday surcharge applies                                  |
| createdAt        | created_at          | DATETIME2            | @Column(nullable=false, updatable=false)    |                                                                    |
| updatedAt        | updated_at          | DATETIME2            | @Column(nullable=false)                     |                                                                    |

**Quan hệ JPA:**

- `@ManyToOne` → `User` — FetchType.LAZY — User MAY be null (walk-in).
- `@ManyToOne` → `EventType` — FetchType.EAGER — Event type is a tiny reference needed on every reservation display.
- `@OneToMany(mappedBy = "reservation")` → `ReservationTable` — FetchType.LAZY.
- `@OneToMany(mappedBy = "reservation")` → `ReservationMenuItem` — FetchType.LAZY.
- `@OneToMany(mappedBy = "reservation")` → `ReservationAddon` — FetchType.LAZY.
- `@OneToOne(mappedBy = "reservation")` → `Invoice` — FetchType.LAZY.
- `@OneToOne(mappedBy = "reservation")` → `Review` — FetchType.LAZY.

---

### Entity 18 — ReservationTable

- **Entity Name:** `ReservationTable`
- **Table Name:** `reservation_table`
- **Mô tả nghiệp vụ:** Bảng join giữa Reservation và DiningTable — một reservation có thể đặt nhiều bàn (ghép bàn).

| Attribute (Java) | Column (SQL)    | SQL Server Type      | JPA Annotation          | Ghi chú           |
| ---------------- | --------------- | -------------------- | ----------------------- | ----------------- |
| id               | id              | BIGINT IDENTITY(1,1) | @Id @GeneratedValue     | PK                |
| reservationId    | reservation_id  | BIGINT               | @Column(nullable=false) | FK to Reservation |
| diningTableId    | dining_table_id | INT                  | @Column(nullable=false) | FK to DiningTable |

**Quan hệ JPA:**

- `@ManyToOne` → `Reservation` — FetchType.LAZY.
- `@ManyToOne` → `DiningTable` — FetchType.LAZY.

---

### Entity 19 — ReservationMenuItem

- **Entity Name:** `ReservationMenuItem`
- **Table Name:** `reservation_menu_item`
- **Mô tả nghiệp vụ:** Chi tiết món ăn (lẻ hoặc set) trong reservation. Các FK menu_item_id, menu_item_size_id, menu_set_id có thể NULL vì một dòng có thể là món lẻ hoặc set.

| Attribute (Java) | Column (SQL)      | SQL Server Type      | JPA Annotation          | Ghi chú                    |
| ---------------- | ----------------- | -------------------- | ----------------------- | -------------------------- |
| id               | id                | BIGINT IDENTITY(1,1) | @Id @GeneratedValue     | PK                         |
| reservationId    | reservation_id    | BIGINT               | @Column(nullable=false) | FK to Reservation          |
| menuItemId       | menu_item_id      | INT                  | @Column(nullable=true)  | NULL if this is a set item |
| menuItemSizeId   | menu_item_size_id | INT                  | @Column(nullable=true)  | NULL if set                |
| menuSetId        | menu_set_id       | INT                  | @Column(nullable=true)  | NULL if à la carte         |
| quantity         | quantity          | INT                  | @Column(nullable=false) |                            |
| unitPrice        | unit_price        | DECIMAL(10,0)        | @Column(nullable=false) | Price at time of order     |

**Quan hệ JPA:**

- `@ManyToOne` → `Reservation` — FetchType.LAZY.
- `@ManyToOne` → `MenuItem` — FetchType.LAZY.
- `@ManyToOne` → `MenuItemSize` — FetchType.LAZY.
- `@ManyToOne` → `MenuSet` — FetchType.LAZY.

---

### Entity 20 — ReservationAddon

- **Entity Name:** `ReservationAddon`
- **Table Name:** `reservation_addon`
- **Mô tả nghiệp vụ:** Chi tiết dịch vụ thêm trong reservation.

| Attribute (Java) | Column (SQL)     | SQL Server Type      | JPA Annotation          | Ghi chú                |
| ---------------- | ---------------- | -------------------- | ----------------------- | ---------------------- |
| id               | id               | BIGINT IDENTITY(1,1) | @Id @GeneratedValue     | PK                     |
| reservationId    | reservation_id   | BIGINT               | @Column(nullable=false) | FK to Reservation      |
| addonServiceId   | addon_service_id | INT                  | @Column(nullable=false) | FK to AddonService     |
| quantity         | quantity         | INT                  | @Column(nullable=false) |                        |
| unitPrice        | unit_price       | DECIMAL(10,0)        | @Column(nullable=false) | Price at time of order |

**Quan hệ JPA:**

- `@ManyToOne` → `Reservation` — FetchType.LAZY.
- `@ManyToOne` → `AddonService` — FetchType.LAZY.

---

### Entity 21 — Invoice

- **Entity Name:** `Invoice`
- **Table Name:** `invoice`
- **Mô tả nghiệp vụ:** Hoá đơn thanh toán — hỗ trợ cả reservation và walk-in anonymous, ghi nhận chi tiết các khoản tiền và trạng thái thanh toán.

| Attribute (Java) | Column (SQL)       | SQL Server Type      | JPA Annotation                              | Ghi chú                               |
| ---------------- | ------------------ | -------------------- | ------------------------------------------- | ------------------------------------- |
| id               | id                 | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                    |
| reservationId    | reservation_id     | BIGINT               | @Column(nullable=true, unique=true)         | FK to Reservation; NULL for walk-in B |
| userId           | user_id            | BIGINT               | @Column(nullable=true)                      | FK to User; NULL for anonymous        |
| guestName        | guest_name         | NVARCHAR(100)        | @Column(nullable=true)                      | For walk-in identification            |
| subtotal         | subtotal           | DECIMAL(12,0)        | @Column(nullable=false)                     | Sum of items + table + room           |
| tipAmount        | tip_amount         | DECIMAL(12,0)        | @Column(nullable=false)                     | 10% service charge                    |
| surchargeAmount  | surcharge_amount   | DECIMAL(12,0)        | @Column(nullable=false)                     | Holiday surcharge if any              |
| voucherDiscount  | voucher_discount   | DECIMAL(12,0)        | @Column(nullable=false)                     | Discount from voucher                 |
| pointsDiscount   | points_discount    | DECIMAL(12,0)        | @Column(nullable=false)                     | Discount from points                  |
| totalAmount      | total_amount       | DECIMAL(12,0)        | @Column(nullable=false)                     | Final payable amount                  |
| paymentMethod    | payment_method     | VARCHAR(10)          | @Enumerated(STRING) @Column(nullable=true)  | CASH / VNPAY / MOMO                   |
| paymentStatus    | payment_status     | VARCHAR(20)          | @Enumerated(STRING) @Column(nullable=false) | PENDING / PAID / REFUNDED             |
| transactionRef   | transaction_ref    | VARCHAR(100)         | @Column(nullable=true)                      | VNPay/MoMo transaction ref            |
| paidAt           | paid_at            | DATETIME2            | @Column(nullable=true)                      | Timestamp of payment                  |
| issuedByStaffId  | issued_by_staff_id | INT                  | @Column(nullable=true)                      | FK to User (STAFF); NULL for online   |
| createdAt        | created_at         | DATETIME2            | @Column(nullable=false, updatable=false)    |                                       |
| updatedAt        | updated_at         | DATETIME2            | @Column(nullable=false)                     |                                       |

**Quan hệ JPA:**

- `@OneToOne` → `Reservation` — FetchType.LAZY — Invoice may exist without reservation (walk-in B).
- `@ManyToOne` → `User` — FetchType.LAZY — User may be null (anonymous).
- `@OneToMany(mappedBy = "invoice")` → `VoucherRedemption` — FetchType.LAZY.

---

### Entity 22 — Voucher

- **Entity Name:** `Voucher`
- **Table Name:** `voucher`
- **Mô tả nghiệp vụ:** Mã khuyến mãi với 6 loại (FIRST_ORDER, WEEKDAY, LUNCH, BIRTHDAY_MONTH, RANK_BENEFIT, MANUAL), có điều kiện áp dụng riêng.

| Attribute (Java) | Column (SQL)       | SQL Server Type   | JPA Annotation                              | Ghi chú                                                                |
| ---------------- | ------------------ | ----------------- | ------------------------------------------- | ---------------------------------------------------------------------- |
| id               | id                 | INT IDENTITY(1,1) | @Id @GeneratedValue                         | PK                                                                     |
| voucherCode      | voucher_code       | VARCHAR(50)       | @Column(nullable=false, unique=true)        | Manual code or auto-generated                                          |
| voucherType      | voucher_type       | VARCHAR(20)       | @Enumerated(STRING) @Column(nullable=false) | FIRST_ORDER / WEEKDAY / LUNCH / BIRTHDAY_MONTH / RANK_BENEFIT / MANUAL |
| discountPercent  | discount_percent   | DECIMAL(5,2)      | @Column(nullable=true)                      | Null if using fixed amount                                             |
| discountAmount   | discount_amount    | DECIMAL(12,0)     | @Column(nullable=true)                      | Null if using percent                                                  |
| minOrderValue    | min_order_value    | DECIMAL(12,0)     | @Column(nullable=false)                     | Minimum subtotal to apply                                              |
| maxDiscount      | max_discount       | DECIMAL(12,0)     | @Column(nullable=true)                      | Cap on discount amount                                                 |
| validFrom        | valid_from         | DATETIME2         | @Column(nullable=false)                     |                                                                        |
| validTo          | valid_to           | DATETIME2         | @Column(nullable=false)                     |                                                                        |
| usageLimit       | usage_limit        | INT               | @Column(nullable=false)                     | Max times this voucher can be used                                     |
| usedCount        | used_count         | INT               | @Column(nullable=false)                     | Current usage count                                                    |
| applicableRankId | applicable_rank_id | INT               | @Column(nullable=true)                      | FK to CustomerRankConfig; NULL = all ranks                             |
| isActive         | is_active          | BIT               | @Column(nullable=false)                     |                                                                        |
| createdAt        | created_at         | DATETIME2         | @Column(nullable=false, updatable=false)    |                                                                        |

**Quan hệ JPA:**

- `@ManyToOne` → `CustomerRankConfig` — FetchType.LAZY.
- `@OneToMany(mappedBy = "voucher")` → `VoucherRedemption` — FetchType.LAZY.

---

### Entity 23 — VoucherRedemption

- **Entity Name:** `VoucherRedemption`
- **Table Name:** `voucher_redemption`
- **Mô tả nghiệp vụ:** Lịch sử mỗi lần sử dụng voucher, ghi nhận user, invoice và thời điểm dùng.

| Attribute (Java) | Column (SQL) | SQL Server Type      | JPA Annotation                           | Ghi chú       |
| ---------------- | ------------ | -------------------- | ---------------------------------------- | ------------- |
| id               | id           | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      | PK            |
| voucherId        | voucher_id   | INT                  | @Column(nullable=false)                  | FK to Voucher |
| userId           | user_id      | BIGINT               | @Column(nullable=false)                  | FK to User    |
| invoiceId        | invoice_id   | BIGINT               | @Column(nullable=false)                  | FK to Invoice |
| usedAt           | used_at      | DATETIME2            | @Column(nullable=false, updatable=false) |               |

**Quan hệ JPA:**

- `@ManyToOne` → `Voucher` — FetchType.LAZY.
- `@ManyToOne` → `User` — FetchType.LAZY.
- `@ManyToOne` → `Invoice` — FetchType.LAZY.

---

### Entity 24 — Review

- **Entity Name:** `Review`
- **Table Name:** `review`
- **Mô tả nghiệp vụ:** Đánh giá của khách hàng sau khi đặt bàn completed. Mỗi reservation chỉ được review một lần.

| Attribute (Java) | Column (SQL)   | SQL Server Type      | JPA Annotation                           | Ghi chú                                       |
| ---------------- | -------------- | -------------------- | ---------------------------------------- | --------------------------------------------- |
| id               | id             | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      | PK                                            |
| userId           | user_id        | BIGINT               | @Column(nullable=false)                  | FK to User                                    |
| reservationId    | reservation_id | BIGINT               | @Column(nullable=false, unique=true)     | FK to Reservation; one review per reservation |
| rating           | rating         | INT                  | @Column(nullable=false)                  | 1–5                                           |
| comment          | comment        | NVARCHAR(MAX)        | @Column(nullable=true)                   |                                               |
| imageUrl         | image_url      | VARCHAR(500)         | @Column(nullable=true)                   | Cloudinary optional                           |
| isVisible        | is_visible     | BIT                  | @Column(nullable=false)                  | Admin moderation                              |
| createdAt        | created_at     | DATETIME2            | @Column(nullable=false, updatable=false) |                                               |

**Quan hệ JPA:**

- `@ManyToOne` → `User` — FetchType.LAZY.
- `@OneToOne` → `Reservation` — FetchType.LAZY — Unique constraint ensures one review per reservation.

---

### Supplementary Entities (Optional but recommended)

#### VerificationToken

| Attribute (Java) | Column (SQL) | SQL Server Type      | JPA Annotation                       |
| ---------------- | ------------ | -------------------- | ------------------------------------ |
| id               | id           | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                  |
| userId           | user_id      | BIGINT               | @Column(nullable=false)              |
| token            | token        | VARCHAR(255)         | @Column(nullable=false, unique=true) |
| type             | type         | VARCHAR(20)          | @Enumerated(STRING)                  |
| expiresAt        | expires_at   | DATETIME2            | @Column(nullable=false)              |
| usedAt           | used_at      | DATETIME2            | @Column(nullable=true)               |

#### RefundTransaction

| Attribute (Java) | Column (SQL)    | SQL Server Type      | JPA Annotation                           |
| ---------------- | --------------- | -------------------- | ---------------------------------------- |
| id               | id              | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      |
| invoiceId        | invoice_id      | BIGINT               | @Column(nullable=false)                  |
| amount           | amount          | DECIMAL(12,0)        | @Column(nullable=false)                  |
| method           | method          | VARCHAR(10)          | @Enumerated(STRING)                      |
| transactionRef   | transaction_ref | VARCHAR(100)         | @Column(nullable=true)                   |
| status           | status          | VARCHAR(20)          | @Enumerated(STRING)                      |
| createdAt        | created_at      | DATETIME2            | @Column(nullable=false, updatable=false) |

#### Notification

| Attribute (Java) | Column (SQL) | SQL Server Type      | JPA Annotation                           |
| ---------------- | ------------ | -------------------- | ---------------------------------------- |
| id               | id           | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      |
| userId           | user_id      | BIGINT               | @Column(nullable=false)                  |
| title            | title        | NVARCHAR(200)        | @Column(nullable=false)                  |
| message          | message      | NVARCHAR(MAX)        | @Column(nullable=false)                  |
| isRead           | is_read      | BIT                  | @Column(nullable=false)                  |
| createdAt        | created_at   | DATETIME2            | @Column(nullable=false, updatable=false) |

#### AuditLog

| Attribute (Java) | Column (SQL) | SQL Server Type      | JPA Annotation                           |
| ---------------- | ------------ | -------------------- | ---------------------------------------- |
| id               | id           | BIGINT IDENTITY(1,1) | @Id @GeneratedValue                      |
| userId           | user_id      | BIGINT               | @Column(nullable=true)                   |
| action           | action       | NVARCHAR(255)        | @Column(nullable=false)                  |
| entityType       | entity_type  | VARCHAR(50)          | @Column(nullable=false)                  |
| entityId         | entity_id    | BIGINT               | @Column(nullable=true)                   |
| oldValue         | old_value    | NVARCHAR(MAX)        | @Column(nullable=true)                   |
| newValue         | new_value    | NVARCHAR(MAX)        | @Column(nullable=true)                   |
| ipAddress        | ip_address   | VARCHAR(45)          | @Column(nullable=true)                   |
| createdAt        | created_at   | DATETIME2            | @Column(nullable=false, updatable=false) |

---

## 4. OUTPUT 2 — WBS (4 DEVS)

---

### Dev A — Authentication + User + Rank System

**Entities phụ trách:** User, CustomerProfile, CustomerRankConfig, RankTopUp, LoyaltyTransaction

**Screens/Controllers:**

- `[PUBLIC] Register page` — `/common/register.jsp`: Form đăng ký email + password → POST `/auth/register`
- `[PUBLIC] Login modal` — Bootstrap Modal trên mọi trang: Form login email/password hoặc Google OAuth2 button → Fetch POST `/api/auth/login`
- `[PUBLIC] Verify email` — `/common/verify-email.jsp` (hoặc redirect trang thông báo): GET `/auth/verify-email?token=...`
- `[PUBLIC] Complete profile` — `/common/complete-profile.jsp`: Bổ sung SĐT, Ngày sinh sau Google OAuth2 → POST `/auth/complete-profile`
- `[CUSTOMER] Profile page` — `/customer/profile.jsp`: Xem/sửa thông tin, đổi mật khẩu, xem hạng, điểm → GET/POST `/customer/profile`
- `[CUSTOMER] Rank top-up page` — `/customer/rank-topup.jsp`: Chọn hạng mục tiêu → POST `/customer/rank-topup` → redirect VNPay/MoMo
- `[ADMIN] User management` — `/admin/users.jsp`: CRUD user, ban/unban, reset password, change role → Fetch API endpoints
- `[ADMIN] Rank config` — `/admin/rank-config.jsp`: CRUD ngưỡng hạng, tỷ lệ tích điểm, quyền VIP/VVIP → Fetch API endpoints

**Business Logic phụ trách:**

- Đăng ký: BCrypt hash password, tạo `email_verify_token` UUID, lưu User status = PENDING, gửi email async qua ExecutorService
- Google OAuth2: Verify ID token via google-api-client, liên kết hoặc tạo mới User
- Remember Me: Tạo/cookie/rotate token, RememberMeFilter auto-login từ cookie
- Profile: CRUD thông tin, đổi mật khẩu (verify old password first)
- Rank evaluation (Points-based): On invoice PAID, calc points = FLOOR(totalAmount / 1000), add to loyaltyPoints, check point threshold → auto-upgrade rank
- Rank top-up: Calc coins = amount / 10000, create VNPay/MoMo payment, handle IPN → add points + coins, upgrade rank
- Loyalty points: Convert VND → points (bill: 1K = 1pt, top-up: 10K = 1pt), REDEEM when using points at payment
- Points decay: ScheduledExecutorService runs 24h, scans profiles inactive > 3 months → reduce 20% points, check downgrade + send notification

**API Endpoints (Fetch API):**

- `POST /api/auth/login` → Xác thực, trả JSON {success, user, redirect}
- `POST /api/auth/register` → Tạo tài khoản, trả JSON {success, message}
- `GET /api/auth/check-session` → Kiểm tra session còn sống không
- `GET /api/rank/my-rank` → Lấy thông tin hạng + điểm của user hiện tại
- `POST /api/rank/topup` → Tạo lệnh nạp tiền lên hạng, trả payment URL
- `GET /api/admin/users` → Danh sách users (phân trang)
- `POST /api/admin/users/{id}/ban` → Ban/unban user
- `PUT /api/admin/rank-config` → Cập nhật cấu hình hạng
- `GET /api/notifications` → Danh sách thông báo của user
- `POST /api/notifications/{id}/read` → Đánh dấu đã đọc

**Dependencies với Dev khác:**

- Cần Invoice.PAID event từ Dev D để trigger cộng points
- Cần biết room_type privileges (VIP/VVIP) từ Dev B để hiển thị/tooltip
- Cần Notification entity để gửi thông báo lên/tụt hạng cho khách

---

### Dev B — Restaurant Setup + Menu Management

**Entities phụ trách:** Area, Room, DiningTable, MenuCategory, MenuItem, MenuItemSize, MenuSet, MenuSetItem, AddonService

**Screens/Controllers:**

- `[ADMIN] Area management` — `/admin/areas.jsp`: CRUD khu vực, set price_modifier → Fetch API
- `[ADMIN] Room management` — `/admin/rooms.jsp`: CRUD phòng theo area, set room_type/capacity/price → Fetch API
- `[ADMIN] Table management` — `/admin/tables.jsp`: CRUD bàn theo phòng, set capacity/base_price/status → Fetch API
- `[ADMIN] Category management` — `/admin/categories.jsp`: CRUD MenuCategory → Fetch API
- `[ADMIN] Menu item management` — `/admin/menu-items.jsp`: CRUD MenuItem + upload ảnh (Cloudinary) + quản lý sizes → Fetch API
- `[ADMIN] Menu set management` — `/admin/menu-sets.jsp`: CRUD MenuSet + chọn món trong set (MenuSetItem) + upload ảnh → Fetch API
- `[ADMIN] Addon service management` — `/admin/addon-services.jsp`: CRUD AddonService + upload ảnh → Fetch API
- `[PUBLIC] Menu browsing` — `/common/menu.jsp`: Xem thực đơn theo category/set, dùng trong Bước 3 booking (tích hợp sẵn vào wizard)
- `[PUBLIC] Area/Room/Table display` — Dùng trong Bước 2 booking wizard (hiển thị grid bàn)

**Business Logic phụ trách:**

- CRUD toàn bộ entity + Cloudinary upload qua Commons FileUpload
- Query bàn trống theo khung giờ: JOIN ReservationTable + Reservation để loại trừ bàn đã đặt
- Hold table với Optimistic Locking: UPDATE DiningTable.status = RESERVED WHERE id = ? AND version = ?
- Validate room_type access dựa trên rank của user (VIP/VVIP gating)
- Menu browsing filter theo meal_time (dựa trên giờ đặt bàn)
- Tính original_price của MenuSet từ tổng MenuItem giá lẻ

**API Endpoints (Fetch API):**

- `GET /api/areas` → Danh sách area active
- `GET /api/areas/{id}/rooms` → Danh sách phòng trong area
- `GET /api/rooms/{id}/tables` → Danh sách bàn trống theo thời gian
- `GET /api/tables/available?date=...&time=...&capacity=...` → Bàn trống theo filter
- `POST /api/booking/hold-table` → Giữ bàn (Optimistic Locking), trả 409 nếu conflict
- `GET /api/menu/categories?mealTime=...` → Danh sách category
- `GET /api/menu/items?categoryId=...` → Menu items with sizes
- `GET /api/menu/sets?mealTime=...` → Menu sets
- `GET /api/addon-services` → Addon services
- `POST /api/admin/upload-image` → Upload lên Cloudinary, trả secure_url

**Dependencies với Dev khác:**

- Cần rank info từ Dev A để check room_type access (VIP/VVIP)
- Cần reservation status từ Dev C để query bàn trống
- Cần cung cấp dữ liệu menu/addon cho Dev C (Bước 3) và Dev D (tính tiền)

---

### Dev C — Reservation & Operations

**Entities phụ trách:** EventType, Reservation, ReservationTable, ReservationMenuItem, ReservationAddon, HolidaySurcharge

**Screens/Controllers:**

- `[PUBLIC] Booking Step 1` — `/common/booking-step1.jsp`: Form ngày giờ, sự kiện, số người, check phụ thu → Fetch API surcharge check
- `[PUBLIC] Booking Step 2` — `/common/booking-step2.jsp`: Chọn area/room/table grid → Fetch API hold-table
- `[PUBLIC] Booking Step 3` — `/common/booking-step3.jsp`: Chọn menu items + sets + addon services → Fetch API
- `[PUBLIC] Booking Step 4 (shared)` — `/common/booking-step4.jsp`: Review + thanh toán (do Dev D)
- `[STAFF] Staff dashboard` — `/staff/dashboard.jsp`: Timeline reservations today, filter by status → Fetch API
- `[STAFF] Check-in checklist` — `/staff/checkin.jsp`: Danh sách confirmed trong ngày, checkbox check-in → Fetch POST
- `[STAFF] Walk-in booking (Type A)` — `/staff/walkin-booking.jsp`: Form tạo reservation offline → POST
- `[STAFF] Walk-in quick bill (Type B)` — `/staff/quick-bill.jsp`: Chọn bàn trống + thêm món → xuất bill
- `[STAFF] Walk-in create account (Type C)` — `/staff/create-customer.jsp`: Form tạo tài khoản cho khách
- `[STAFF] Holiday surcharge view` — `/staff/surcharges.jsp`: Xem danh sách phụ thu ngày lễ (read-only)
- `[ADMIN] Holiday surcharge management` — `/admin/surcharges.jsp`: CRUD HolidaySurcharge → Fetch API
- `[CUSTOMER] My reservations` — `/customer/my-reservations.jsp`: Lịch sử đặt bàn, trạng thái, nút huỷ → Fetch API

**Business Logic phụ trách:**

- 4-step booking wizard: BookingDraftDTO lưu trong session, validate từng bước, chỉ ghi DB ở bước 4
- Login guard Bước 1: Lưu draft vào session → hiện Modal → login AJAX → restore draft → sang Bước 2
- Holiday surcharge check: Fetch `/api/surcharge?date=...` ở Bước 1 → Modal nếu có surcharge
- Hold table: Optimistic Locking với @Version, catch OptimisticLockException → 409 Conflict → Toast
- Create reservation (Bước 4): Ghi Reservation + ReservationTable + ReservationMenuItem + ReservationAddon trong 1 transaction
- Staff dashboard: Query reservation theo ngày, filter status
- Check-in: Update Reservation.status = CHECKED_IN + checkin_at timestamp
- No-show: Staff click → status = NO_SHOW, DiningTable.status = AVAILABLE
- Walk-in Type A: Tạo reservation với user_id = NULL, guest_name/phone filled
- Walk-in Type B: Tạo Invoice trực tiếp (không qua Reservation), user_id = NULL
- Walk-in Type C: Tạo User + CustomerProfile, link invoice với user_id mới, auto-issue FIRST_ORDER voucher
- Auto-cancellation: ScheduledExecutorService (ServletContextListener) scan mỗi 5 phút, cancel reservation quá 15 phút no-show
- Cancellation: Kiểm tra 3 tiếng trước giờ đặt → nếu đủ, gọi Refund Factory (Dev D), cập nhật status

**API Endpoints (Fetch API):**

- `GET /api/event-types` → Danh sách EventType
- `GET /api/surcharge?date=...` → Kiểm tra phụ thu cho ngày
- `GET /api/booking/draft` → Lấy BookingDraftDTO hiện tại
- `POST /api/booking/save-step1` → Lưu Bước 1 vào session draft
- `POST /api/booking/save-step2` → Lưu Bước 2 (tables) vào draft
- `POST /api/booking/save-step3` → Lưu Bước 3 (menu/addon) vào draft
- `POST /api/booking/confirm` → Bước 4: Ghi DB, tạo reservation
- `GET /api/staff/reservations?date=...&status=...` → Danh sách reservation cho staff
- `POST /api/staff/checkin/{id}` → Check-in
- `POST /api/staff/no-show/{id}` → Đánh dấu no-show
- `POST /api/staff/walkin` → Tạo walk-in reservation
- `POST /api/staff/quick-bill` → Tạo hoá đơn nhanh (walk-in B)
- `POST /api/staff/create-customer` → Tạo tài khoản (walk-in C)
- `POST /api/customer/reservations/{id}/cancel` → Huỷ reservation

**Dependencies với Dev khác:**

- Cần menu/addon/table data từ Dev B để hiển thị Bước 2+3
- Cần rank info từ Dev A để gating VIP/VVIP room
- Cần Refund Factory + VNPay/MoMo IPN từ Dev D cho hủy + hoàn tiền
- Cần Invoice creation từ Dev D ở Bước 4 confirm

---

### Dev D — Billing + Voucher + Review

**Entities phụ trách:** Invoice, Voucher, VoucherRedemption, Review, RefundTransaction

**Screens/Controllers:**

- `[PUBLIC] Booking Step 4 (Order Review)` — `/common/booking-step4.jsp`: Tổng hợp đơn hàng, nhập voucher, dùng điểm, chọn payment method → Fetch API
- `[PUBLIC] Booking confirmation` — `/common/booking-confirmation.jsp`: Sau khi thanh toán thành công, hiển thị mã đặt bàn
- `[CUSTOMER] My reviews` — `/customer/my-reviews.jsp`: Danh sách reservation completed → form review → Fetch POST
- `[CUSTOMER] My vouchers` — `/customer/my-vouchers.jsp`: Danh sách voucher đang có
- `[ADMIN] Voucher management` — `/admin/vouchers.jsp`: CRUD voucher code → Fetch API
- `[ADMIN] Review moderation` — `/admin/reviews.jsp`: Duyệt/ẩn review → Fetch API
- `[ADMIN] Reports & Statistics` — `/admin/reports.jsp`: Biểu đồ doanh thu, top món, top khách → Fetch API
- `[STAFF] Invoice history` — `/staff/invoices.jsp`: Tra cứu hoá đơn → Fetch API

**Business Logic phụ trách:**

- Bước 4: Tính subtotal (items + table + room), surcharge (nếu có), tip 10%, voucher discount, points discount → total_amount
- Voucher auto-apply: FIRST_ORDER (nếu chưa dùng), WEEKDAY (nếu T2-T6), LUNCH (nếu 11:00-14:00), BIRTHDAY_MONTH (nếu tháng hiện tại == tháng sinh), RANK_BENEFIT (tự động theo hạng)
- Voucher manual: User nhập mã → validate (còn hạn, còn lượt, đủ min_order, chưa dùng quá giới hạn)
- Points redemption: Kiểm tra điểm hiện có, quy đổi theo tỷ lệ, không vượt quá tổng bill
- VNPay/MoMo payment: Tạo payment request, redirect user, xử lý IPN callback (BY-PASS AuthFilter)
- Refund Factory Pattern: VNPayRefundProcessor / MoMoRefundProcessor — gọi API hoàn tiền
- Invoice PAID → gửi event cho Dev A (cộng totalSpent + points + auto rank-up)
- Đánh giá: Chỉ cho reservation COMPLETED, một lần duy nhất, Admin duyệt is_visible
- Báo cáo doanh thu: Tổng hợp theo ngày/tháng/quý, tỷ lệ huỷ/no-show, top món

**API Endpoints (Fetch API):**

- `POST /api/booking/apply-voucher` → Validate + áp dụng voucher, trả tổng bill mới
- `POST /api/booking/apply-points` → Áp dụng điểm, trả tổng bill mới
- `POST /api/booking/pay` → Tạo payment request, trả payment URL
- `POST /api/payment/vnpay/ipn` → VNPay IPN (bypass AuthFilter)
- `POST /api/payment/momo/ipn` → MoMo IPN (bypass AuthFilter)
- `GET /api/payment/status?ref=...` → Kiểm tra trạng thái giao dịch
- `POST /api/customer/reviews` → Gửi review
- `GET /api/admin/reports/revenue?from=...&to=...` → Doanh thu theo khoảng
- `GET /api/admin/reports/top-items` → Top món ăn
- `GET /api/admin/reports/top-customers` → Top khách hàng
- `GET /api/staff/invoices?keyword=...` → Tra cứu hoá đơn

**Dependencies với Dev khác:**

- Cần BookingDraftDTO từ Dev C để lấy thông tin reservation trước khi tạo invoice
- Cần rank info + points info từ Dev A để tính discount và points
- Cần room/table/menu giá từ Dev B để tính subtotal
- Khi invoice PAID, cần notify Dev A qua service call (cùng JVM)

---

## 5. OUTPUT 3 — 5 FLOWCHARTS

---

### Flowchart 1 — Persistent Login (Remember Me)

```
[HTTP REQUEST arrives]
    │
    ├─ RememberMeFilter.doFilter()  ← mapped to /*, runs BEFORE AuthFilter
    │
    ├─ Session.getAttribute("currentUser") != null?
    │   │
    │   ├── CÓ → chain.doFilter() → [AUTHENTICATED] → Controller → View
    │   │
    │   └── KHÔNG → Đọc cookie "remember_me" từ request.getCookies()
    │       │
    │       ├── Cookie == null? → chain.doFilter() → [GUEST] → Controller → View
    │       │
    │       └── Cookie != null? → Query DB:
    │           JPQL: "FROM User WHERE rememberToken = :token
    │                  AND tokenExpiry > CURRENT_TIMESTAMP
    │                  AND status = 'ACTIVE'"
    │           SQL:  "SELECT id, email, full_name, role, status, ...
    │                   FROM users WHERE remember_token = ?
    │                   AND token_expiry > GETDATE()
    │                   AND status = 'ACTIVE'"
    │           │
    │           ├── User == null (token expired/invalid)?
    │           │   → Xoá cookie: Cookie.setMaxAge(0); response.addCookie(c)
    │           │   → chain.doFilter() → [GUEST]
    │           │
    │           └── User found?
    │               │
    │               1. Rotate token:
    │                  String newToken = UUID.randomUUID().toString();
    │                  user.setRememberToken(newToken);
    │                  user.setTokenExpiry(new Timestamp(
    │                    System.currentTimeMillis() + 30L*24*60*60*1000));
    │                  UserDAO.update(user);
    │                  SQL: "UPDATE users SET remember_token = ?,
    │                        token_expiry = DATEADD(DAY, 30, GETDATE())
    │                        WHERE id = ?"
    │               │
    │               2. Tạo session mới:
    │                  request.getSession(true);
    │                  session.setAttribute("currentUser", user);
    │               │
    │               3. Set cookie mới:
    │                  Cookie c = new Cookie("remember_me", newToken);
    │                  c.setMaxAge(30 * 24 * 3600);   // 30 days
    │                  c.setHttpOnly(true);
    │                  c.setSecure(true);              // production only
    │                  c.setAttribute("SameSite", "Strict");
    │                  response.addCookie(c);
    │               │
    │               4. chain.doFilter() → [AUTHENTICATED]
    │
    └─ [LOGOUT]
        POST /auth/logout
        → session.invalidate()
        → Cookie c = new Cookie("remember_me", ""); c.setMaxAge(0);
          response.addCookie(c)
        → UserDAO.updateRememberToken(userId, NULL, NULL)
          SQL: "UPDATE users SET remember_token = NULL,
                token_expiry = NULL WHERE id = ?"
        → redirect /index.jsp
```

---

### Flowchart 2### Flowchart 2 — Đặt bàn Online (4 bước)

```
[BẮT ĐẦU] User click "Đặt bàn" trên navbar
    │
    ▼
┌────────────────────────────────────────────────────────────┐
│ BƯỚC 1 — Form Thông tin Cơ bản (booking-step1.jsp)        │
│                                                            │
│ Input: [ngày (DATE)] [giờ (TIME, dropdown 30ph slot)]      │
│        [loại sự kiện (EventType dropdown)]                 │
│        [số người lớn (INT≥1)] [checkbox "Có trẻ em?"]      │
│        [số trẻ em (INT, conditional)]                      │
│                                                            │
│ Validation: ngày ≥ hôm nay, giờ trong giờ hoạt động        │
└──────────────────────────┬─────────────────────────────────┘
                           │
                           ▼
    User chọn ngày → Fetch API:
        GET /api/surcharge?date=2026-06-27
        Response JSON: {hasSurcharge: true/false,
                        holidayName: "Tết Dương lịch",
                        surchargePercent: 10.00}
    │
    ├── hasSurcharge == true?
    │   │
    │   → Hiển thị Bootstrap Modal cảnh báo:
    │     "Ngày 27/06/2026 là Tết Dương lịch.
    │      Tổng bill sẽ tính thêm phụ thu 10%."
    │     [Tiếp tục] [Chọn ngày khác]
    │   │
    │   ├── "Tiếp tục" → BookingDraftDTO.hasSurcharge = true
    │   │                → Tiếp tục xuống dưới
    │   │
    │   └── "Chọn ngày khác" → focus lại field ngày → STOP
    │
    └── hasSurcharge == false? → Tiếp tục
    │
    ▼
    Kiểm tra: HttpSession có "currentUser" không?
    │
    ├── KHÔNG (chưa login)?
    │   │
    │   1. Lưu toàn bộ Bước 1 vào session:
    │      BookingDraftDTO draft = new BookingDraftDTO();
    │      draft.setReservationDate(...);
    │      draft.setReservationTime(...);
    │      draft.setEventTypeId(...);
    │      draft.setAdultsCount(...);
    │      draft.setHasChildren(...);
    │      draft.setChildrenCount(...);
    │      draft.setHasSurcharge(hasSurcharge);
    │      session.setAttribute("bookingDraft", draft);
    │   │
    │   2. Hiển thị Bootstrap Modal Login (không redirect)
    │   │
    │   3. User nhập email/password → Fetch API:
    │      POST /api/auth/login  Body: JSON {email, password}
    │      Response: {success: true, user: {...}, redirect: null}
    │   │
    │   ├── success == false?
    │   │   → Hiển thị Toast lỗi trong Modal ("Sai mật khẩu")
    │   │   → User nhập lại
    │   │
    │   └── success == true?
    │       → session.setAttribute("currentUser", user)
    │       → Đóng Modal
    │       → Đọc lại BookingDraftDTO từ session
    │       → Tự động chuyển Bước 2 (không mất dữ liệu)
    │
    └── CÓ (đã login)? → Chuyển Bước 2
    │
    ▼
┌────────────────────────────────────────────────────────────┐
│ BƯỚC 2 — Chọn Khu vực, Phòng & Bàn (booking-step2.jsp)    │
│                                                            │
│ Fetch API lấy danh sách bàn trống:                         │
│ GET /api/tables/available?date=...&time=...&capacity=...   │
│                                                            │
│ Backend query:                                             │
│  JPQL: "SELECT t FROM DiningTable t                        │
│         WHERE t.capacity >= :capacity                      │
│         AND t.status = 'AVAILABLE'                         │
│         AND t.id NOT IN (                                  │
│           SELECT rt.diningTable.id FROM ReservationTable rt │
│           JOIN rt.reservation r                            │
│           WHERE r.reservationDate = :date                  │
│           AND r.reservationTime = :time                    │
│           AND r.status IN ('CONFIRMED','CHECKED_IN')       │
│         )"                                                 │
│                                                            │
│ Cấu trúc hiển thị: Area tabs → Room cards → Table grid    │
│ - STANDARD: tất cả đều chọn được                           │
│ - VIP: chỉ hiển thị nếu user rank >= SILVER               │
│ - VVIP: chỉ hiển thị nếu user rank = DIAMOND              │
│   (Nếu không đủ rank: card mờ + tooltip)                  │
│                                                            │
│ Hết bàn? → "Nhà hàng đã đầy. Vui lòng chọn giờ/ngày khác" │
│            → Nút "Quay lại Bước 1"                         │
└──────────────────────────┬─────────────────────────────────┘
                           │
    User click vào một Card bàn trống → Fetch API:
        POST /api/booking/hold-table
        Body: {tableId: 42, sessionId: session.getId()}
    │
    ├── Backend xử lý:
    │   1. Đọc DiningTable từ DB (version hiện tại = V)
    │   2. UPDATE SQL (JPA tự sinh):
    │      "UPDATE dining_table SET status = 'RESERVED',
    │       version = V+1 WHERE id = 42 AND version = V"
    │   3. JPA returns rows updated:
    │      │
    │      ├── rows == 1 (thành công)?
    │      │   → Commit
    │      │   → Response 200: {success: true}
    │      │   → Client: đánh dấu bàn đã chọn (RESERVED)
    │      │   → Lưu tableId vào BookingDraftDTO
    │      │   → Sang Bước 3
    │      │
    │      └── rows == 0 (OptimisticLockException)?
    │          → Rollback
    │          → Response 409: {success: false, message: "Conflict"}
    │          → Client: hiển thị Bootstrap Toast
    │            "Bàn vừa được người khác chọn,
    │             vui lòng chọn bàn khác"
    │          → Tự động refresh danh sách bàn
    │            (Fetch lại /api/tables/available)
    │
    ▼
┌────────────────────────────────────────────────────────────┐
│ BƯỚC 3 — Chọn Menu & Dịch vụ (booking-step3.jsp)          │
│                                                            │
│ 3 tabs: [Món lẻ] [Set Menu] [Dịch vụ thêm]                │
│                                                            │
│ Tab "Món lẻ":                                              │
│   Fetch GET /api/menu/categories?mealTime=LUNCH            │
│   Fetch GET /api/menu/items?categoryId=...                 │
│   Mỗi item dạng Card: ảnh Cloudinary + tên + giá theo size│
│   User chọn size → click "Thêm vào giỏ" →                  │
│     Fetch POST /api/booking/save-step3 (cập nhật session)  │
│     → Hiển thị Toast "Đã thêm [món] vào giỏ hàng"         │
│                                                            │
│ Tab "Set Menu":                                            │
│   Fetch GET /api/menu/sets?mealTime=LUNCH                  │
│   Mỗi set dạng Card: tên, ảnh, danh sách món kèm size,    │
│   giá gốc (gạch ngang), giá ưu đãi (màu cam), badge       │
│   "Tiết kiệm X%"                                           │
│                                                            │
│ Tab "Dịch vụ thêm":                                        │
│   Fetch GET /api/addon-services                            │
│   Trang trí, hoa, nhạc sống... mỗi dịch vụ có ảnh + giá   │
│                                                            │
│ Offcanvas sidebar (phải): giỏ hàng real-time               │
│   - Danh sách món lẻ (tên + size + SL + đơn giá)          │
│   - Danh sách set (tên set + SL)                           │
│   - Danh sách dịch vụ                                      │
│   - Tổng tạm tính                                          │
└──────────────────────────┬─────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│ BƯỚC 4 — Xem lại & Thanh toán (booking-step4.jsp)         │
│                                                            │
│ Hiển thị toàn bộ đơn hàng:                                │
│ - Thông tin đặt bàn (ngày, giờ, sự kiện, số người,        │
│   khu vực, phòng, bàn số...)                               │
│ - Danh sách món lẻ + set + dịch vụ                        │
│                                                            │
│ Cột tính tiền (breakdown):                                 │
│   Subtotal (món + set + dịch vụ + phí bàn + phí khu vực)  │
│   + Phụ thu ngày lễ (nếu có): surchargePercent% × Subtotal │
│   + Phí phục vụ (10%): tipAmount = Subtotal × 0.1         │
│   - Giảm giá Voucher: (do Fetch API tính)                 │
│   - Điểm sử dụng: points × points_to_vnd_rate             │
│   ──────────────────────────────────────────────────       │
│   = TOTAL (làm nổi bật, font lớn)                          │
│                                                            │
│ Ô nhập Voucher: Input + nút "Áp dụng"                      │
│   → Fetch POST /api/booking/apply-voucher                  │
│     Body: {voucherCode: "WELCOME10", subtotal: 500000}     │
│     Backend validate:                                      │
│       - Voucher tồn tại? isActive?                         │
│       - validFrom <= NOW <= validTo?                       │
│       - usedCount < usageLimit?                            │
│       - subtotal >= minOrderValue?                         │
│       - applicableRankId = null HOẶC user rank match?     │
│       - User chưa dùng voucher này lần nào?               │
│         (kiểm tra VoucherRedemption)                       │
│     Response: {valid: true, discountAmount: 50000,        │
│                discountPercent: 10, maxDiscount: null}     │
│   → Cập nhật real-time tổng bill (không reload)           │
│                                                            │
│ Ô dùng Điểm: Input số điểm + "Áp dụng"                     │
│   → Fetch POST /api/booking/apply-points                   │
│     Body: {points: 100, totalBeforePoints: 500000}         │
│     Backend validate:                                      │
│       - points <= user.loyaltyPoints?                      │
│       - points × rate <= totalBeforePoints?                │
│     Response: {valid: true, pointsDiscount: 10000,        │
│                remainingPoints: 50}                        │
│                                                            │
│ Radio: Phương thức thanh toán cọc                          │
│   [VNPay] [MoMo] [Tiền mặt] (tuỳ cấu hình)                │
│                                                            │
│ Nút "Xác nhận & Đặt bàn"                                   │
│   → Fetch POST /api/booking/confirm                        │
│     Body: toàn bộ BookingDraftDTO                          │
│   │                                                        │
│   ├── Backend xử lý (1 transaction):                       │
│   │   1. INSERT INTO reservation (...) VALUES (...)        │
│   │   2. INSERT INTO reservation_table (...)               │
│   │   3. INSERT INTO reservation_menu_item (...)           │
│   │   4. INSERT INTO reservation_addon (...)               │
│   │   5. INSERT INTO invoice (...) VALUES (...)            │
│   │      (paymentStatus = 'PENDING')                      │
│   │   6. INSERT INTO voucher_redemption (nếu có voucher)  │
│   │   7. INSERT INTO loyalty_transaction (nếu dùng điểm) │
│   │   8. UPDATE voucher SET usedCount = usedCount + 1     │
│   │   9. UPDATE user SET loyaltyPoints = loyaltyPoints - X│
│   │  10. Xoá BookingDraftDTO khỏi session                 │
│   │                                                        │
│   │   → Commit → Response {success: true,                 │
│   │      reservationId: 123, paymentUrl: "..."}           │
│   │                                                        │
│   ├── Payment method == VNPay/MoMo?                       │
│   │   → Redirect user đến paymentUrl                      │
│   │   → User thanh toán trên VNPay/MoMo gateway           │
│   │   → VNPay/MoMo gửi IPN callback đến:                  │
│   │     POST /api/payment/vnpay/ipn (BY-PASS AuthFilter)  │
│   │     POST /api/payment/momo/ipn (BY-PASS AuthFilter)   │
│   │   │                                                    │
│   │   └── Backend xử lý IPN:                              │
│   │       1. Verify checksum/chữ ký                        │
│   │       2. Kiểm tra amount khớp depositAmount            │
│   │       3. UPDATE invoice SET paymentStatus = 'PAID',   │
│   │          transactionRef = ?, paidAt = GETDATE()       │
│   │       4. UPDATE reservation SET depositPaid = true,   │
│   │          status = 'CONFIRMED'                         │
│   │       5. Trả HTTP 200 cho VNPay/MoMo                  │
│   │       6. GỌI Dev A SERVICE:                           │
│   │          rankService.processPaidInvoice(invoiceId)    │
│   │          → Cộng totalSpent (reference only)          │
│   │          → Cập nhật last_activity_at = NOW           │
│   │          → Tính điểm từ bill:                         │
│   │            pointsEarned = FLOOR(invoice.totalAmount   │
│   │              / 1000 * config.pointsPerThousandVnd)    │
│   │            → Cộng vào loyalty_points                 │
│   │            → INSERT loyalty_transaction (EARN)        │
│   │          → Check rank upgrade theo ngưỡng điểm        │
│   │                                                        │
│   └── Payment method == Tiền mặt?                         │
│       → Reservation.status = 'CONFIRMED'                  │
│       → Invoice.paymentStatus = 'PENDING'                │
│       → Staff sẽ update thành PAID khi khách đến          │
│                                                            │
│   → Hiển thị trang xác nhận:                              │
│     /common/booking-confirmation.jsp                       │
│     "Mã đặt bàn: RS-12345 | Ngày: 27/06/2026 |            │
│      Bàn: A01 (Tầng 1) | Tổng cọc: 100,000đ |             │
│      Trạng thái: Đã xác nhận"                              │
```

---

### Flowchart 3### Flowchart 3 — Khách Offline (3 loại A/B/C)

```
[KHÁCH ĐẾN NHÀ HÀNG] → Staff đăng nhập (role = STAFF/ADMIN)
    │
    ├─────────────────┬─────────────────┐
    │                 │                 │
    ▼                 ▼                 ▼
┌──────────────────────────────────────────────────────────────┐
│ LOẠI A: Đặt bàn Offline                                      │
│ (Qua điện thoại / khách đến trực tiếp đặt cho giờ sau)       │
│                                                              │
│ URL: /staff/walkin-booking.jsp                                │
│ Form nhập: [Tên khách] [SĐT] [Email (optional)]              │
│            [Số người] [Loại phòng/bàn] [Ngày] [Giờ]          │
│                                                              │
│ Holiday surcharge check:                                      │
│   Nếu ngày đặt có phụ thu → Modal xác nhận trước khi tạo     │
│                                                              │
│ Backend xử lý (1 transaction):                               │
│   INSERT INTO reservation (                                  │
│     user_id,         = NULL                                  │
│     guest_name,      = form.guestName                        │
│     guest_phone,     = form.guestPhone                       │
│     event_type_id,   = 'OTHER'                               │
│     reservation_date,= form.date                             │
│     reservation_time,= form.time                             │
│     adults_count,    = form.adultsCount                      │
│     children_count,  = 0                                     │
│     has_children,    = false                                 │
│     status,          = 'CONFIRMED'                           │
│     deposit_amount,  = 0                                     │
│     deposit_paid,    = false                                 │
│     is_online,       = false                                 │
│     created_by_staff_id, = currentStaff.id                   │
│     checkin_at,      = NULL                                  │
│     has_surcharge,   = hasSurcharge                          │
│     created_at,      = GETDATE()                             │
│   ) VALUES (...)                                             │
│   INSERT INTO reservation_table (reservation_id, table_id)   │
│   ← deposit=0, không cần thanh toán                          │
│                                                              │
│ Scheduled job (ServletContextListener + ScheduledExecutorService): │
│   Scan mỗi 15 phút: "SELECT * FROM reservation               │
│     WHERE is_online = false AND created_by_staff IS NOT NULL  │
│     AND status = 'CONFIRMED'                                 │
│     AND reservation_date = CAST(GETDATE() AS DATE)           │
│     AND DATEDIFF(MINUTE, reservation_time, GETDATE())        │
│         BETWEEN 0 AND admin_reminder_minutes"                │
│   → Gửi SMS/email nhắc nhở (nếu tích hợp Twilio/ESMS)        │
│                                                              │
│ No-show handling (Staff manual):                              │
│   Sau giờ đặt 15 phút, Staff click "Đánh dấu No-show"        │
│   → UPDATE reservation SET status = 'NO_SHOW'                │
│   → UPDATE dining_table SET status = 'AVAILABLE'             │
│     WHERE id IN (SELECT dining_table_id FROM reservation_table│
│                   WHERE reservation_id = ?)                   │
│   → Không mất cọc (deposit=0)                                 │
│   → Không có review sau                                      │
│                                                              │
│ Check-in khi khách đến:                                       │
│   Staff click "Check-in"                                      │
│   → UPDATE reservation SET status = 'CHECKED_IN',            │
│     checkin_at = GETDATE() WHERE id = ?                       │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│ LOẠI B: Khách Anonymous (ăn ngay, không tài khoản)           │
│                                                              │
│ URL: /staff/quick-bill.jsp                                    │
│                                                              │
│ 1. Staff chọn bàn trống:                                      │
│    SELECT * FROM dining_table WHERE status = 'AVAILABLE'     │
│    → UPDATE dining_table SET status = 'OCCUPIED' WHERE id=?  │
│                                                              │
│ 2. Staff thêm món ăn (dùng menu browsing từ Dev B):          │
│    Tạm lưu trong session (không có Reservation entity)        │
│                                                              │
│ 3. Staff click "Xuất bill":                                   │
│    INSERT INTO invoice (                                      │
│      reservation_id,   = NULL                                │
│      user_id,          = NULL                                │
│      guest_name,       = NULL                                │
│      subtotal,         = sum(items_price)                    │
│      tip_amount,       = 0                                   │
│      surcharge_amount, = (tính nếu hôm nay có phụ thu active)│
│        Check: "SELECT * FROM holiday_surcharge               │
│                 WHERE surcharge_date = CAST(GETDATE() AS DATE)│
│                 AND is_active = 1"                           │
│        Nếu có: surchargeAmount = subtotal * percent / 100    │
│      voucher_discount, = 0                                   │
│      points_discount,  = 0                                   │
│      total_amount,     = subtotal + tip + surcharge          │
│      payment_method,   = 'CASH'                              │
│      payment_status,   = 'PAID'                              │
│      transaction_ref,  = NULL                                │
│      paid_at,          = GETDATE()                            │
│      issued_by_staff_id, = currentStaff.id                   │
│      created_at,       = GETDATE()                           │
│    )                                                          │
│    → UPDATE dining_table SET status = 'AVAILABLE' WHERE id=? │
│    → Hiển thị bill (in hoặc màn hình)                        │
│                                                              │
│   → Bill chỉ có: danh sách món + tổng tiền + timestamp      │
│     + số bàn. KHÔNG có tên khách.                            │
│   → Invoice lưu lại cho mục đích báo cáo doanh thu.          │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│ LOẠI C: Khách walk-in muốn tạo tài khoản                     │
│                                                              │
│ URL: /staff/create-customer.jsp                               │
│                                                              │
│ 1. Staff điền form: [Họ tên] [SĐT] [Email] [Ngày sinh]      │
│                                                              │
│ 2. Backend xử lý (1 transaction):                            │
│    a. Tạo User:                                              │
│       INSERT INTO users (                                    │
│         email,         = form.email                          │
│         password,      = BCrypt.hashpw(tempPassword, salt)   │
│         full_name,     = form.fullName                       │
│         phone,         = form.phone                          │
│         date_of_birth, = form.dateOfBirth                    │
│         role,          = 'CUSTOMER'                          │
│         status,        = 'ACTIVE'        ← Staff tạo, không  │
│         first_order_used = false          cần verify email   │
│       ) VALUES (...)                                         │
│    b. Tạo CustomerProfile:                                   │
│       INSERT INTO customer_profile (                         │
│         user_id, total_spent, loyalty_points,                │
│         current_rank_id                                      │
│       ) VALUES (newUser.id, 0, 0, BRONZE.id)                │
│    c. Gửi email mật khẩu tạm (async):                        │
│       EmailService.send(form.email,                          │
│         "Mật khẩu tạm thời: " + tempPassword +              │
│         "\nVui lòng đổi mật khẩu sau khi đăng nhập.")       │
│    d. Auto-issue FIRST_ORDER voucher:                        │
│       INSERT INTO voucher_redemption (user_id, voucher_id,   │
│         invoice_id = NULL, used_at = NULL)                   │
│       (chỉ mark là đã được cấp, chưa dùng)                   │
│                                                              │
│ 3. Nếu khách ĐANG ĂN (có bàn OCCUPIED + bill tạm):          │
│    → UPDATE invoice SET user_id = newUser.id                 │
│      WHERE id = currentDraftId                               │
│    → Tính điểm cho invoice đó:                               │
│      LoyaltyTransaction(EARN, points, ...)                   │
│    → Link total_spent + tích điểm ngay                       │
│                                                              │
│ 4. Kết thúc: "Tài khoản [email] đã được tạo.                │
│    Mật khẩu tạm đã gửi qua email."                           │
└──────────────────────────────────────────────────────────────┘
```

---

### Flowchart 4 — Points, Rank & Decay

```
┌──────────────────────────────────────────────────────────────────┐
│                  POINTS-BASED RANK SYSTEM                         │
│                                                                  │
│ Ranks: BRONZE(0pt) → SILVER(5K) → GOLD(20K) → PLATINUM(50K)    │
│        → DIAMOND(100K)                                           │
│ Thresholds stored in customer_rank_config, admin-configurable    │
│                                                                  │
│ POINT CALCULATION:                                               │
│   From bill: points = floor(bill_total / 1000)                   │
│     Eg: bill 750K → 750 pts                                      │
│   From top-up: points = floor(amount / 10000)                    │
│     Eg: deposit 1M → 100 pts + 100 coins (1 coin = 10K VND)     │
│                                                                  │
│ COINS (Xu): virtual currency for bill payment                    │
│   NEVER decay, NEVER confiscated                                 │
│   Only lost when: spent by customer or account deletion          │
└──────────────────────────┬───────────────────────────────────────┘
                           │
          ┌────────────────┴────────────────┐
          │                                 │
          ▼                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│ METHOD 1 — Earn points from bills (auto)                         │
│                                                                  │
│ Trigger: Invoice paymentStatus = 'PAID'                          │
│   (Dev D calls rankService.processPaidInvoice(invoiceId))        │
│                                                                  │
│ 1. Read Invoice:                                                 │
│    SELECT * FROM invoice WHERE id = ? AND payment_status = 'PAID'│
│                                                                  │
│ 2. Read CustomerProfile:                                         │
│    SELECT * FROM customer_profile WHERE user_id = invoice.user_id│
│                                                                  │
│ 3. Update totalSpent (reference) + last_activity_at:             │
│    UPDATE customer_profile SET                                   │
│      total_spent = total_spent + invoice.totalAmount,            │
│      last_activity_at = GETDATE()                                │
│    WHERE user_id = ?                                             │
│                                                                  │
│ 4. Calculate points from bill:                                   │
│    Formula: pointsEarned = FLOOR(invoice.totalAmount             │
│                  / 1000 * config.pointsPerThousandVnd)           │
│    Eg: totalAmount = 500,000 VND, pointsPerThousandVnd = 1       │
│        → pointsEarned = FLOOR(500000 / 1000 * 1) = 500 pts       │
│    UPDATE customer_profile SET                                   │
│      loyalty_points = loyalty_points + pointsEarned,             │
│      last_activity_at = GETDATE()                                │
│    WHERE user_id = ?                                             │
│    INSERT INTO loyalty_transaction (                             │
│      user_id, type='EARN', pointsDelta=+pointsEarned,            │
│      amountReference=invoice.totalAmount,                        │
│      description='Points from invoice #' + invoice.id           │
│    )                                                             │
│                                                                  │
│ 5. Check rank upgrade (based on loyalty_points, NOT VND):        │
│    SELECT * FROM customer_rank_config WHERE is_active = 1        │
│      ORDER BY min_point_threshold ASC                            │
│    For each rankConfig:                                          │
│      IF profile.loyalty_points >= rankConfig.minPointThreshold   │
│         AND (profile.currentRank IS NULL                         │
│              OR profile.currentRank.minPointThreshold            │
│                 < rankConfig.minPointThreshold):                 │
│       → UPDATE customer_profile SET current_rank_id = rankConfig │
│         WHERE user_id = ?                                        │
│       → INSERT INTO loyalty_transaction (                        │
│           user_id, type='RANK_UPGRADE',                          │
│           pointsDelta=0,                                         │
│           description='Upgraded to ' + rankConfig.rankName)      │
│       → INSERT INTO notification (user_id, title, message, ...)  │
│       → EmailService.sendAsync(email, templateRankUpgrade)       │
│       (Chain: if points meet higher rank → continue)             │
│                                                                  │
│ 6. Apply new rank benefits:                                      │
│    - canBookVip/canBookVvip → gate room selection                │
│    - discountPercent → auto-apply RANK_BENEFIT voucher           │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│ METHOD 2 — Top-up: buy coins + earn points                       │
│                                                                  │
│ URL: /customer/rank-topup.jsp                                    │
│                                                                  │
│ 1. Customer views target ranks (SILVER→DIAMOND)                  │
│    Each rank shows:                                              │
│      - Name + benefits (discount %, VIP access)                  │
│      - Required: X,XXX points                                    │
│      - Your points: Y,YYY (loyaltyPoints)                        │
│      - Gap: threshold - currentPoints                            │
│        Amount to deposit = gap * 10000 VND                       │
│        (If gap <= 0 → "You already qualify, dine to maintain")   │
│                                                                  │
│ 2. Customer selects rank → click "Deposit"                       │
│    Fetch POST /api/rank/topup                                    │
│      Body: {targetRank: 'GOLD', amount: gap * 10000}             │
│                                                                  │
│ 3. Backend creates payment:                                      │
│    a. INSERT INTO rank_topup (                                   │
│         user_id, target_rank='GOLD',                             │
│         amount = gap * 10000,                                    │
│         payment_method='VNPAY', status='PENDING'                 │
│       )                                                          │
│    b. Create VNPay/MoMo payment request                          │
│       txnRef = "TOPUP_" + rankTopup.id + "_" + System.currentTime│
│    c. Response {paymentUrl: "https://sandbox.vnpay.vn/..."}     │
│    → Redirect customer to VNPay/MoMo                             │
│                                                                  │
│ 4. IPN callback (BY-PASS AuthFilter):                            │
│    POST /api/payment/topup-callback                              │
│    │                                                             │
│    Backend processing (1 transaction):                           │
│    a. Verify signature                                           │
│    b. Verify amount matches rank_topup.amount                    │
│    c. UPDATE rank_topup SET status = 'SUCCESS',                  │
│         transaction_ref = ? WHERE id = ?                         │
│    d. Calculate points from top-up:                              │
│       pointsEarned = FLOOR(amount / 10000)                       │
│       coinsEarned = FLOOR(amount / 10000)  (= pointsEarned)      │
│    e. UPDATE customer_profile SET                                │
│         loyalty_points = loyalty_points + pointsEarned,          │
│         coin_balance = coin_balance + coinsEarned,               │
│         total_spent = total_spent + amount,                      │
│         last_activity_at = GETDATE()                             │
│       WHERE user_id = ?                                          │
│    f. INSERT INTO loyalty_transaction (                          │
│         user_id, type='TOPUP',                                   │
│         pointsDelta=+pointsEarned,                               │
│         amountReference=amount,                                  │
│         description='Top-up: +' + pointsEarned + ' points')      │
│    g. Check chain upgrade (using step 5 of Method 1)            │
│    h. INSERT notification + Email about successful deposit       │
│                                                                  │
│ 5. If IPN fails:                                                 │
│    UPDATE rank_topup SET status = 'FAILED'                       │
│    → Show "Transaction failed" on dashboard                      │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│ METHOD 3 — Points Decay (auto, runs every 24h)                   │
│                                                                  │
│ Trigger: ScheduledExecutorService in AutoCancelService           │
│   (ServletContextListener.init → scheduleAtFixedRate 24h)        │
│                                                                  │
│ Each run:                                                        │
│                                                                  │
│ 1. Query customers inactive > 3 months:                          │
│    SELECT cp FROM customer_profile cp                            │
│    WHERE cp.lastActivityAt < DATEADD(MONTH, -3, GETDATE())       │
│      AND cp.loyaltyPoints > 0                                    │
│      AND (cp.lastDecayAt IS NULL                                 │
│           OR cp.lastDecayAt < DATEADD(MONTH, -3, GETDATE()))     │
│                                                                  │
│ 2. FOR each profile:                                             │
│    │                                                             │
│    a. Calculate new points after decay:                          │
│       newPoints = profile.loyaltyPoints * 0.8  (reduce 20%)     │
│       pointsLost = profile.loyaltyPoints - newPoints             │
│    │                                                             │
│    b. Record decay:                                              │
│       INSERT INTO loyalty_transaction (                          │
│         user_id, type='POINTS_DECAY',                            │
│         pointsDelta=-pointsLost,                                 │
│         description='20% points decay due to inactivity'         │
│       )                                                          │
│    │                                                             │
│    c. Update profile:                                            │
│       UPDATE customer_profile SET                                │
│         loyalty_points = newPoints,                              │
│         last_decay_at = GETDATE()                                │
│       WHERE user_id = ?                                          │
│    │                                                             │
│    d. Check rank downgrade:                                      │
│       SELECT * FROM customer_rank_config WHERE is_active = 1     │
│         ORDER BY min_point_threshold DESC                        │
│       Find highest rank where newPoints >= minPointThreshold     │
│       │                                                          │
│       ├── If new rank differs from current (lower):             │
│       │   UPDATE customer_profile SET current_rank_id = newRank  │
│       │   INSERT INTO loyalty_transaction (                      │
│       │     type='RANK_DOWNGRADE',                               │
│       │     description='Downgraded to ' + newRank.rankName)    │
│       │   INSERT INTO notification (title='Rank changed',        │
│       │     message='You have been downgraded to ...', ...)      │
│       │   EmailService.sendAsync(templateRankDown)              │
│       │                                                          │
│       └── If rank unchanged → skip, no notification             │
│    │                                                             │
│    e. If newPoints = 0:                                          │
│       → Reset rank to BRONZE (default)                           │
│       → Coins remain unchanged (never confiscated)               │
│       → Only rank benefits are lost                              │
│                                                                  │
│ 3. Done: log processed profiles count                            │
│                                                                  │
│ PRE-DOWNGRADE NOTIFICATION:                                      │
│   (Same scheduled job, check one cycle earlier)                  │
│   Query profiles with lastActivityAt > DATEADD(MONTH, -2, ...)   │
│     AND < DATEADD(MONTH, -3, ...)  (about to expire)            │
│   → "Your points will decay soon due to inactivity.              │
│      Visit the restaurant to maintain your rank!"                │
└──────────────────────────────────────────────────────────────────┘
```

---

### Flowchart 5 — Cancellation & Refund

```
[USER] click "Huỷ đặt bàn" trên /customer/my-reservations.jsp
[STAFF] click "Huỷ" trên /staff/dashboard.jsp
    │
    ▼
  Kiểm tra: Reservation có deposit_paid = true?
    │
    ├── deposit_paid == false (Walk-in A, deposit = 0)?
    │   → Cho phép huỷ ngay (không hoàn tiền)
    │   → UPDATE reservation SET status = 'CANCELLED' WHERE id = ?
    │   → UPDATE dining_table SET status = 'AVAILABLE'
    │     WHERE id IN (SELECT dining_table_id FROM reservation_table
    │                   WHERE reservation_id = ?)
    │   → Hiển thị Toast "Đã huỷ đặt bàn thành công"
    │
    └── deposit_paid == true?
        │
        ▼
      Kiểm tra điều kiện 3 tiếng:
      SQL: "SELECT DATEDIFF(HOUR, GETDATE(),
                   CAST(reservation_date AS DATETIME)
                   + CAST(reservation_time AS DATETIME))
            FROM reservation WHERE id = ?"
      │
      ├── hoursUntilReservation >= 3?
      │   │ → Cho phép huỷ, hoàn 100% cọc
      │   │
      │   │ Bước 1 — Cập nhật trạng thái:
      │   │   BEGIN TRANSACTION
      │   │     UPDATE reservation SET status = 'CANCELLED' WHERE id = ?
      │   │     UPDATE invoice SET payment_status = 'REFUNDING'
      │   │       WHERE reservation_id = ?
      │   │     UPDATE dining_table SET status = 'AVAILABLE'
      │   │       WHERE id IN (SELECT dining_table_id FROM reservation_table
      │   │                      WHERE reservation_id = ?)
      │   │   COMMIT
      │   │
      │   │ Bước 2 — Gọi Refund Factory Pattern:
      │   │   RefundProcessor processor =
      │   │     RefundFactory.getProcessor(invoice.paymentMethod);
      │   │   │
      │   │   ├── paymentMethod == 'VNPAY'?
      │   │   │   → VNPayRefundProcessor.refund(invoice)
      │   │   │     API: POST https://sandbox.vnpayment.vn/merchant/refund
      │   │   │     Params: vnp_RequestId, vnp_TxnRef,
      │   │   │             vnp_Amount, vnp_TransactionDate,
      │   │   │             vnp_CreateBy, vnp_CreateDate
      │   │   │     Response: vnp_ResponseCode
      │   │   │       = "00" → SUCCESS
      │   │   │       ≠ "00" → FAILED (ghi log, cần xử lý thủ công)
      │   │   │
      │   │   └── paymentMethod == 'MOMO'?
      │   │     → MoMoRefundProcessor.refund(invoice)
      │   │       API: POST https://test-payment.momo.vn/v2/gateway/refund
      │   │       Params: partnerCode, orderId, requestId, amount,
      │   │               transId, lang
      │   │       Response: resultCode
      │   │         = 0 → SUCCESS
      │   │         ≠ 0 → FAILED (ghi log, cần xử lý thủ công)
      │   │
      │   │ Bước 3 — Ghi RefundTransaction:
      │   │   INSERT INTO refund_transaction (
      │   │     invoice_id, amount, method, transaction_ref, status
      │   │   ) VALUES (?, invoice.depositAmount, invoice.paymentMethod,
      │   │             response.transactionId, 'SUCCESS'/'FAILED')
      │   │
      │   │ Bước 4 — Cập nhật invoice status:
      │   │   IF refund success:
      │   │     UPDATE invoice SET payment_status = 'REFUNDED',
      │   │       updated_at = GETDATE() WHERE reservation_id = ?
      │   │   ELSE:
      │   │     UPDATE invoice SET payment_status = 'PAID',
      │   │       updated_at = GETDATE() WHERE reservation_id = ?
      │   │     (giữ nguyên PAID, cần Admin xử lý thủ công)
      │   │
      │   │ Bước 5 — Thông báo:
      │   │   → INSERT INTO notification (user_id, title, message,
      │   │       is_read, created_at)
      │   │     VALUES (?, 'Đã huỷ đặt bàn',
      │   │       'Đặt bàn RS-12345 đã được huỷ.
      │   │        Tiền cọc sẽ được hoàn trong 3-5 ngày làm việc.',
      │   │       false, GETDATE())
      │   │   → EmailService.send(user.email, "Xác nhận huỷ đặt bàn")
      │   │
      │   └── hoursUntilReservation < 3?
      │       → Chặn huỷ qua hệ thống
      │       → Nút "Huỷ" disabled
      │       → Tooltip: "Vui lòng gọi điện cho nhà hàng để huỷ.
      │                    Đặt bàn trong vòng 3 tiếng không được
      │                    hoàn tiền qua hệ thống."
      │       → Gợi ý: Hiển thị số điện thoại nhà hàng
      │
    └─ [STAFF — NO-SHOW]
        Trigger: auto-cancel hoặc Staff manual
        │
        ├── Auto-cancel (ScheduledExecutorService):
        │   ServletContextListener khởi tạo ScheduledExecutorService
        │   scan mỗi 5 phút:
        │     "SELECT id FROM reservation
        │      WHERE status = 'CONFIRMED'
        │      AND reservation_date = CAST(GETDATE() AS DATE)
        │      AND DATEDIFF(MINUTE,
        │            CAST(reservation_time AS DATETIME),
        │            CAST(GETDATE() AS DATETIME)) >= 15"
        │   FOR mỗi result:
        │     UPDATE reservation SET status = 'NO_SHOW' WHERE id = ?
        │     UPDATE dining_table SET status = 'AVAILABLE'
        │       WHERE id IN (SELECT dining_table_id FROM reservation_table
        │               WHERE reservation_id = ?)
        │     → Nếu có deposit → mất cọc (giữ nguyên PAID)
        │
        └── Staff manual:
            Staff click "Đánh dấu No-show" trên /staff/checkin.jsp
            → Cùng logic UPDATE như auto-cancel
            → Hiển thị Toast "Đã đánh dấu No-show"
```

---

## 6. OUTPUT 4 — FOLDER STRUCTURE

```
RestaurantManagement/
│
├── build.xml                              ← NetBeans Ant build file
├── nbproject/                             ← NetBeans project configuration
│   ├── project.properties
│   ├── project.xml
│   └── build-impl.xml
│
├── src/
│   ├── META-INF/
│   │   └── persistence.xml                ← JPA config: Hibernate 5 + SQL Server dialect
│   │
│   └── java/
│       │
│       ├── controller/
│       │   ├── dispatcher/
│       │   │   └── DispatcherServlet.java ← FrontController: mapped to /* in web.xml
│       │   │                                reads "action" param, forwards to controller
│       │   │
│       │   ├── common/
│       │   │   ├── AuthController.java     ← Register, Login, Logout, VerifyEmail, CompleteProfile
│       │   │   ├── BookingStep1Controller.java  ← Step 1: Basic info + surcharge check
│       │   │   ├── BookingStep2Controller.java  ← Step 2: Area/Room/Table selection
│       │   │   ├── BookingStep3Controller.java  ← Step 3: Menu + Addon selection
│       │   │   ├── BookingStep4Controller.java  ← Step 4: Review + payment
│       │   │   ├── PaymentVNPayController.java  ← VNPay IPN callback handler
│       │   │   ├── PaymentMoMoController.java   ← MoMo IPN callback handler
│       │   │   └── OAuth2GoogleCallback.java    ← Google OAuth2 redirect handler
│       │   │
│       │   ├── admin/
│       │   │   ├── AdminUserController.java     ← CRUD users, ban/unban
│       │   │   ├── AdminRankConfigController.java ← CRUD rank thresholds
│       │   │   ├── AdminCategoryController.java ← CRUD MenuCategory
│       │   │   ├── AdminMenuItemController.java ← CRUD MenuItem + image upload
│       │   │   ├── AdminMenuSetController.java  ← CRUD MenuSet + set composition
│       │   │   ├── AdminAddonController.java    ← CRUD AddonService
│       │   │   ├── AdminAreaController.java     ← CRUD Area
│       │   │   ├── AdminRoomController.java     ← CRUD Room
│       │   │   ├── AdminTableController.java    ← CRUD DiningTable
│       │   │   ├── AdminVoucherController.java  ← CRUD Voucher
│       │   │   ├── AdminSurchargeController.java← CRUD HolidaySurcharge
│       │   │   ├── AdminReviewController.java   ← Moderate reviews
│       │   │   └── AdminReportController.java   ← Revenue reports + statistics
│       │   │
│       │   ├── staff/
│       │   │   ├── StaffDashboardController.java ← Today's reservations timeline
│       │   │   ├── StaffCheckinController.java   ← Check-in checklist + no-show
│       │   │   ├── StaffWalkinController.java    ← Walk-in Type A (booking) + B (quick bill) + C (create account)
│       │   │   ├── StaffInvoiceController.java   ← Invoice lookup
│       │   │   └── StaffSurchargeController.java ← View holiday surcharges (read-only)
│       │   │
│       │   └── customer/
│       │       ├── CustomerProfileController.java ← Profile CRUD + change password
│       │       ├── CustomerReservationController.java ← My reservations + cancel
│       │       ├── CustomerRankTopupController.java ← Rank top-up flow
│       │       ├── CustomerReviewController.java ← Submit review
│       │       └── CustomerVoucherController.java ← My vouchers list
│       │
│       ├── entity/
│       │   ├── User.java
│       │   ├── CustomerProfile.java
│       │   ├── CustomerRankConfig.java
│       │   ├── RankTopUp.java
│       │   ├── LoyaltyTransaction.java
│       │   ├── EventType.java
│       │   ├── Area.java
│       │   ├── Room.java
│       │   ├── DiningTable.java
│       │   ├── MenuCategory.java
│       │   ├── MenuItem.java
│       │   ├── MenuItemSize.java
│       │   ├── MenuSet.java
│       │   ├── MenuSetItem.java
│       │   ├── AddonService.java
│       │   ├── HolidaySurcharge.java
│       │   ├── Reservation.java
│       │   ├── ReservationTable.java
│       │   ├── ReservationMenuItem.java
│       │   ├── ReservationAddon.java
│       │   ├── Invoice.java
│       │   ├── Voucher.java
│       │   ├── VoucherRedemption.java
│       │   ├── Review.java
│       │   ├── VerificationToken.java         ← Supplementary: email verification
│       │   ├── RefundTransaction.java         ← Supplementary: refund history
│       │   ├── Notification.java              ← Supplementary: user notifications
│       │   └── AuditLog.java                  ← Supplementary: admin audit trail
│       │
│       ├── dao/
│       │   ├── UserDAO.java
│       │   ├── CustomerProfileDAO.java
│       │   ├── CustomerRankConfigDAO.java
│       │   ├── RankTopUpDAO.java
│       │   ├── LoyaltyTransactionDAO.java
│       │   ├── EventTypeDAO.java
│       │   ├── AreaDAO.java
│       │   ├── RoomDAO.java
│       │   ├── DiningTableDAO.java
│       │   ├── MenuCategoryDAO.java
│       │   ├── MenuItemDAO.java
│       │   ├── MenuItemSizeDAO.java
│       │   ├── MenuSetDAO.java
│       │   ├── MenuSetItemDAO.java
│       │   ├── AddonServiceDAO.java
│       │   ├── HolidaySurchargeDAO.java
│       │   ├── ReservationDAO.java
│       │   ├── ReservationTableDAO.java
│       │   ├── ReservationMenuItemDAO.java
│       │   ├── ReservationAddonDAO.java
│       │   ├── InvoiceDAO.java
│       │   ├── VoucherDAO.java
│       │   ├── VoucherRedemptionDAO.java
│       │   ├── ReviewDAO.java
│       │   ├── VerificationTokenDAO.java
│       │   ├── RefundTransactionDAO.java
│       │   ├── NotificationDAO.java
│       │   └── AuditLogDAO.java
│       │
│       ├── service/
│       │   ├── AuthService.java              ← Register, login, BCrypt, token verification
│       │   ├── GoogleOAuth2Service.java      ← Google ID token verification
│       │   ├── RememberMeService.java        ← Token create, rotate, validate
│       │   ├── EmailService.java             ← JavaMail async via ExecutorService
│       │   ├── CloudinaryService.java        ← Image upload to Cloudinary
│       │   ├── RankService.java              ← Rank evaluation, upgrade, top-up
│       │   ├── LoyaltyService.java           ← Point earning, redemption
│       │   ├── MenuService.java              ← Menu query, filtering by meal time
│       │   ├── TableService.java             ← Available table query, hold/release
│       │   ├── BookingService.java           ← Booking wizard draft management, reservation creation
│       │   ├── SurchargeService.java         ← Holiday surcharge check + calculation
│       │   ├── StaffService.java             ← Check-in, no-show, walk-in operations
│       │   ├── InvoiceService.java           ← Invoice creation, payment processing
│       │   ├── VoucherService.java           ← Voucher validation, auto-apply, redemption
│       │   ├── PaymentService.java           ← VNPay/MoMo integration, IPN handling
│       │   ├── RefundService.java            ← Refund Factory (VNPay/MoMo processors)
│       │   ├── ReviewService.java            ← Review submission, moderation
│       │   ├── ReportService.java            ← Revenue statistics, top items/customers
│       │   ├── AutoCancelService.java        ← ScheduledExecutorService for no-show auto-cancel
│       │   └── NotificationService.java      ← In-app notification creation
│       │
│       ├── dto/
│       │   ├── BookingDraftDTO.java          ← Wizard session state (4 steps combined)
│       │   ├── LoginRequestDTO.java          ← Login form data
│       │   ├── RegisterRequestDTO.java       ← Registration form data
│       │   ├── UserResponseDTO.java          ← User info for JSON response (no password)
│       │   ├── ReservationResponseDTO.java   ← Reservation data for staff/customer views
│       │   ├── InvoiceResponseDTO.java       ← Invoice breakdown for display
│       │   ├── VoucherValidationDTO.java     ← Voucher apply result
│       │   ├── TableAvailabilityDTO.java     ← Table with availability status
│       │   ├── MenuItemResponseDTO.java      ← Menu item with sizes for JSON
│       │   ├── PaymentRequestDTO.java        ← Payment initiation data
│       │   ├── PaymentResponseDTO.java       ← Payment URL + transaction ref
│       │   ├── RankTopupDTO.java             ← Top-up calculation result
│       │   ├── ReportDTO.java                ← Revenue statistics data
│       │   ├── HolidaySurchargeDTO.java      ← Surcharge check response
│       │   └── ApiResponseDTO.java           ← Standard JSON wrapper {success, message, data}
│       │
│       ├── filter/
│       │   ├── AuthFilter.java               ← Check session for protected routes
│       │   ├── RememberMeFilter.java         ← Auto-login from remember_me cookie
│       │   ├── RoleFilter.java               ← Check role for /admin/*, /staff/*, /customer/*
│       │   ├── HolidaySurchargeNotifyFilter.java ← Banner alert for today's surcharge
│       │   ├── SessionFilter.java            ← Session management, prevent fixation
│       │   └── EncodingFilter.java           ← UTF-8 request/response encoding
│       │
│       ├── util/
│       │   ├── BCryptUtil.java               ← jBCrypt wrapper
│       │   ├── JPAUtil.java                  ← EntityManagerFactory singleton
│       │   ├── CloudinaryUtil.java           ← Cloudinary SDK configuration
│       │   ├── DateTimeUtil.java             ← Date/time helper, slot generation
│       │   ├── RandomUtil.java               ← UUID generator for tokens
│       │   ├── CookieUtil.java               ← Cookie read/write/delete helpers
│       │   ├── ValidationUtil.java           ← Input validation (email, phone, etc.)
│       │   ├── JsonUtil.java                 ← ObjectMapper singleton + JSON helpers
│       │   └── AuditLogger.java              ← Audit log helper
│       │
│       └── enums/
│           ├── UserRole.java                 ← ADMIN, STAFF, CUSTOMER
│           ├── UserStatus.java               ← PENDING, NEEDS_INFO, ACTIVE, BANNED
│           ├── ReservationStatus.java        ← PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED, NO_SHOW
│           ├── PaymentMethod.java            ← CASH, VNPAY, MOMO
│           ├── PaymentStatus.java            ← PENDING, PAID, REFUNDED
│           ├── RoomType.java                 ← STANDARD, VIP, VVIP
│           ├── TableStatus.java              ← AVAILABLE, RESERVED, OCCUPIED
│           ├── MealTime.java                 ← BREAKFAST, LUNCH, DINNER, ALL_DAY
│           ├── CategoryType.java             ← APPETIZER, MAIN, DESSERT, DRINK, SOUP
│           ├── EventTypeEnum.java            ← (values from DB EventType table)
│           ├── RankName.java                 ← BRONZE, SILVER, GOLD, PLATINUM, DIAMOND
│           ├── VoucherType.java              ← FIRST_ORDER, WEEKDAY, LUNCH, BIRTHDAY_MONTH, RANK_BENEFIT, MANUAL
│           ├── LoyaltyTransactionType.java   ← EARN, REDEEM, TOPUP, RANK_UPGRADE, POINTS_DECAY, RANK_DOWNGRADE
│           └── RankTopupStatus.java          ← PENDING, SUCCESS, FAILED
│
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                          ← ALL servlet, filter, listener mappings
│   │   │                                       NO @WebServlet / @WebFilter / @WebListener
│   │   │
│   │   └── views/                           ← JSP files (not accessible directly)
│   │       ├── common/
│   │       │   ├── index.jsp                ← Landing page (public)
│   │       │   ├── login.jsp                ← Login form fragment (for Modal)
│   │       │   ├── register.jsp             ← Registration form
│   │       │   ├── complete-profile.jsp     ← Post-Google OAuth2 profile completion
│   │       │   ├── verify-email.jsp         ← Email verification result page
│   │       │   ├── booking-step1.jsp        ← Step 1: date, time, event, guest count
│   │       │   ├── booking-step2.jsp        ← Step 2: area/room/table grid
│   │       │   ├── booking-step3.jsp        ← Step 3: menu + addon selection
│   │       │   ├── booking-step4.jsp        ← Step 4: order review + payment
│   │       │   ├── booking-confirmation.jsp ← Success page after booking
│   │       │   ├── menu.jsp                 ← Public menu browsing page
│   │       │   ├── about.jsp                ← Restaurant info + reviews
│   │       │   ├── contact.jsp              ← Contact page
│   │       │   ├── 404.jsp                  ← Not found
│   │       │   ├── 500.jsp                  ← Server error
│   │       │   └── components/              ← Reusable JSP fragments
│   │       │       ├── header.jsp           ← Navbar with login/logout
│   │       │       ├── footer.jsp           ← Site footer
│   │       │       ├── login-modal.jsp      ← Bootstrap Modal for login
│   │       │       ├── toast.jsp            ← Toast notification container
│   │       │       ├── surcharge-banner.jsp ← Holiday surcharge banner
│   │       │       └── cart-sidebar.jsp     ← Offcanvas cart summary
│   │       │
│   │       ├── admin/
│   │       │   ├── dashboard.jsp            ← Admin dashboard with stats
│   │       │   ├── users.jsp                ← User CRUD
│   │       │   ├── rank-config.jsp          ← Rank threshold configuration
│   │       │   ├── categories.jsp           ← Menu category CRUD
│   │       │   ├── menu-items.jsp           ← Menu item CRUD + image upload
│   │       │   ├── menu-sets.jsp            ← Menu set CRUD
│   │       │   ├── addon-services.jsp       ← Addon service CRUD
│   │       │   ├── areas.jsp                ← Area CRUD
│   │       │   ├── rooms.jsp                ← Room CRUD
│   │       │   ├── tables.jsp               ← Dining table CRUD
│   │       │   ├── vouchers.jsp             ← Voucher CRUD
│   │       │   ├── surcharges.jsp           ← Holiday surcharge management
│   │       │   ├── reviews.jsp              ← Review moderation
│   │       │   ├── reports.jsp              ← Revenue reports + charts
│   │       │   └── audit-log.jsp            ← Audit trail viewer
│   │       │
│   │       ├── staff/
│   │       │   ├── dashboard.jsp            ← Today's timeline + filters
│   │       │   ├── checkin.jsp              ← Check-in checklist
│   │       │   ├── walkin-booking.jsp       ← Walk-in Type A form
│   │       │   ├── quick-bill.jsp           ← Walk-in Type B quick invoice
│   │       │   ├── create-customer.jsp      ← Walk-in Type C account creation
│   │       │   ├── invoices.jsp             ← Invoice history lookup
│   │       │   └── surcharges.jsp           ← Holiday surcharge view (read-only)
│   │       │
│   │       └── customer/
│   │           ├── dashboard.jsp            ← Customer home (my reservations)
│   │           ├── profile.jsp              ← Edit profile, change password
│   │           ├── my-reservations.jsp      ← Reservation history + cancel
│   │           ├── my-reviews.jsp           ← Write review for completed reservations
│   │           ├── my-vouchers.jsp          ← Available vouchers list
│   │           └── rank-topup.jsp           ← Rank upgrade purchase
│   │
│   ├── assets/
│   │   ├── css/
│   │   │   ├── style.css                   ← Custom styles (Bootstrap overrides)
│   │   │   └── booking.css                 ← Booking wizard-specific styles
│   │   ├── js/
│   │   │   ├── app.js                      ← Global: auth check, toast, modal helpers
│   │   │   ├── auth.js                     ← Login/register AJAX via Fetch API
│   │   │   ├── booking-step1.js            ← Step 1: date/time validation, surcharge check
│   │   │   ├── booking-step2.js            ← Step 2: table grid, hold-table AJAX
│   │   │   ├── booking-step3.js            ← Step 3: cart management via Fetch API
│   │   │   ├── booking-step4.js            ← Step 4: voucher apply, points, payment
│   │   │   ├── staff-dashboard.js          ← Dashboard filters, check-in AJAX
│   │   │   ├── admin-users.js              ← User CRUD AJAX
│   │   │   ├── admin-menu.js               ← Menu item CRUD + image upload
│   │   │   ├── admin-vouchers.js           ← Voucher CRUD AJAX
│   │   │   ├── admin-reports.js            ← Report charts (Chart.js)
│   │   │   └── utils.js                    ← Common: Fetch wrapper, form validation
│   │   └── images/                         ← Local static images ONLY
│   │       ├── logo.png
│   │       ├── favicon.ico
│   │       └── default-food.jpg            ← Fallback when Cloudinary URL is null
│   │
│   └── index.jsp                           ← Landing page (public, redirect to /WEB-INF/views/common/)
│
├── lib/                                    ← All dependency JARs (added manually to WEB-INF/lib/)
│   ├── hibernate-core-5.6.15.Final.jar
│   ├── hibernate-commons-annotations-5.1.2.Final.jar
│   ├── classmate-1.5.1.jar
│   ├── jandex-2.4.2.Final.jar
│   ├── javassist-3.29.2-GA.jar
│   ├── mssql-jdbc-12.4.1.jre8.jar
│   ├── jackson-databind-2.16.1.jar
│   ├── jackson-core-2.16.1.jar
│   ├── jackson-annotations-2.16.1.jar
│   ├── commons-fileupload-1.5.jar
│   ├── commons-io-2.15.1.jar
│   ├── cloudinary-http44-1.38.0.jar
│   ├── cloudinary-core-1.38.0.jar
│   ├── jbcrypt-0.4.jar
│   ├── google-api-client-1.35.2.jar
│   ├── google-oauth-client-1.35.0.jar
│   ├── google-http-client-1.44.1.jar
│   ├── google-http-client-gson-1.44.1.jar
│   ├── google-api-client-gson-1.35.2.jar
│   ├── javax.mail-1.6.2.jar
│   ├── javax.activation-1.2.0.jar
│   └── jstl-1.2.jar
│
└── database/
    ├── 01-drop-tables.sql                  ← DROP TABLE IF EXISTS (re-runnable)
    ├── 02-create-tables.sql                ← CREATE TABLE with IDENTITY, constraints
    ├── 03-seed-data.sql                    ← INSERT default data (event types, ranks, admin account)
    └── 04-indexes.sql                      ← Performance indexes
```

---

## 7. DESIGN CONSTRAINTS

### 7.1 JPA / Hibernate

| Rule               | Implementation                                                                                            |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| LAZY default       | `@OneToMany` and `@ManyToMany` ALL use `FetchType.LAZY` — never EAGER for collections                     |
| EAGER exceptions   | `@ManyToOne` on small lookup entities only (Area, Room type, EventType, CustomerRankConfig, MenuCategory) |
| No JDBC + JPA mix  | All persistence via JPA EntityManager; JDBC (pure SQL) NOT used in same transaction                       |
| Optimistic Locking | `DiningTable.version` — `try/catch OptimisticLockException` → HTTP 409 → client Toast                     |

### 7.2 Security

| Rule                | Implementation                                          |
| ------------------- | ------------------------------------------------------- |
| Password hashing    | BCrypt via `jbcrypt-0.4.jar` — NO SHA/MD5               |
| Remember token      | UUID random, rotated each use                           |
| IPN bypass          | VNPay/MoMo IPN endpoints EXCLUDED from AuthFilter scope |
| SQL Injection       | JPQL / Criteria API — NO string concatenation           |
| Input sanitize      | `guest_phone`, `guest_name` sanitized before storage    |
| Password visibility | Never log or return password/rememberToken in JSON      |

### 7.3 SQL Server Specifics

| Feature        | Implementation                                                             |
| -------------- | -------------------------------------------------------------------------- |
| Auto-increment | `IDENTITY(1,1)` → `@GeneratedValue(strategy = GenerationType.IDENTITY)`    |
| Date/Time      | `DATETIME2` for timestamps, `DATE` for dates, `TIME` for reservation slots |
| Unicode        | `NVARCHAR` for all Vietnamese text                                         |
| Enums          | `VARCHAR(50)` + `@Enumerated(EnumType.STRING)` — NO SQL Server ENUM        |
| Version        | `INT NOT NULL DEFAULT 0` for `@Version`                                    |

### 7.4 Package Architecture

| Rule        | Implementation                                                                              |
| ----------- | ------------------------------------------------------------------------------------------- |
| Depth       | Max 2 levels from `java/` (e.g., `controller/admin/` is OK, `controller/admin/sub/` is NOT) |
| Imports     | `import entity.*` covers only direct subpackage; explicit imports for each class            |
| Refactoring | Use NetBeans Refactor → Move for package changes to avoid broken imports                    |

### 7.5 Servlet / Filter Registration

| Rule              | Implementation                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------- |
| No annotations    | `@WebServlet`, `@WebFilter`, `@WebListener` are **FORBIDDEN**                                                             |
| web.xml only      | ALL servlets and filters declared in `web.xml` with `<servlet>` / `<servlet-mapping>` and `<filter>` / `<filter-mapping>` |
| DispatcherServlet | Mapped to `/*`, reads `action` parameter for routing                                                                      |
| AuthFilter        | Mapped to `/admin/*`, `/staff/*`, `/customer/*` — checks session for `currentUser`                                        |
| RememberMeFilter  | Mapped to `/*` — placed BEFORE AuthFilter in chain                                                                        |
| RoleFilter        | Mapped to `/admin/*`, `/staff/*`, `/customer/*` — checks role after authentication                                        |
| IPN bypass        | VNPay/MoMo IPN URL patterns excluded from AuthFilter via `<dispatcher>` or filter logic                                   |

---

## 8. MILESTONES

| Milestone                       | W Duration | Deliverables                                                                                         |
| ------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------- |
| **M1: Foundation**              | W1         | Database scripts, persistence.xml, JPA entities + DAOs, DispatcherServlet, Filters, JPAUtil          |
| **M2: Auth System**             | W1         | User entity, AuthService, Google OAuth2, RememberMe, Email verification, Login/Register, Profile     |
| **M3: Menu + Restaurant Setup** | W2         | CRUD Areas/Rooms/Tables, Menu CRUD + Cloudinary, Menu browsing, Addon services                       |
| **M4: Booking Wizard**          | W3         | 4-step wizard (session draft), table selection with Optimistic Locking, menu cart, holiday surcharge |
| **M5: Staff Operations**        | W3         | Dashboard, Check-in/No-show, Walk-in A/B/C, Invoice history                                          |
| **M6: Billing + Payment**       | W4         | Invoice creation, VNPay/MoMo integration, IPN handlers, Refund Factory, Voucher system, Points       |
| **M7: Rank + Loyalty**          | W4         | Points-based rank eval, auto-upgrade/downgrade, top-up, points decay job, LoyaltyTransaction, notification |
| **M8: Reviews + Reports**       | W5         | Review submission/moderation, revenue reports, Chart.js, audit log                                   |
| **M9: Testing + Polish**        | W5         | Integration test flows, edge cases (race condition, no-show, cancellation), UI polish                |

---

## 9. OPTIONAL IMPROVEMENTS

- **QR Code for reservations** — ZXing library (JDK 8 compatible) generates QR for booking confirmation
- **Real-time notifications** — Simple Long Polling (setInterval + Fetch API) instead of WebSocket
- **Ehcache for menu items** — Cache menu queries since menu data changes infrequently but is read often
- **Scheduled job for offline booking reminders** — `ServletContextListener` + `ScheduledExecutorService` scans upcoming walk-in reservations and sends SMS/email reminders
- **Birthday voucher auto-issuance** — Scheduled job checks users whose birth month is current month and auto-creates BIRTHDAY_MONTH voucher
- **Pagination for all list views** — All admin/staff list pages use pagination via `LIMIT/OFFSET` in JPQL

---

## 10. SAMPLE CODE & UI COMPONENT MAPPING

### 10.1 Sample Entity — User.java (Full Annotation Example)

```java
package entity;

import enums.UserRole;
import enums.UserStatus;
import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "email", nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password", nullable = true, length = 60)  // BCrypt hash; null for Google users
    private String password;

    @Column(name = "full_name", nullable = false, columnDefinition = "NVARCHAR(100)")
    private String fullName;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "date_of_birth")
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;

    @Column(name = "google_id", unique = true, nullable = true, length = 255)
    private String googleId;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false, length = 20)
    private UserRole role;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private UserStatus status;   // PENDING / NEEDS_INFO / ACTIVE / BANNED

    @Column(name = "email_verify_token", length = 255)
    private String emailVerifyToken;

    @Column(name = "email_verified", nullable = false)
    private Boolean emailVerified = false;

    @Column(name = "first_order_used", nullable = false)
    private Boolean firstOrderUsed = false;

    @Column(name = "remember_token", length = 255)
    private String rememberToken;

    @Column(name = "token_expiry")
    @Temporal(TemporalType.TIMESTAMP)
    private Date tokenExpiry;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "updated_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    // Relationships — all LAZY to avoid N+1
    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private CustomerProfile profile;                     // Profile loaded only on profile page

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<Reservation> reservations;              // Many reservations, never eager

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<Review> reviews;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<LoyaltyTransaction> loyaltyTransactions;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<VoucherRedemption> voucherRedemptions;

    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        updatedAt = new Date();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
    }
}
```

### 10.2 Sample Entity — DiningTable.java (@Version Optimistic Locking)

```java
@Entity
@Table(name = "dining_table")
public class DiningTable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(name = "table_code", nullable = false, unique = true, length = 20)
    private String tableCode;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "base_price", nullable = false)
    private Long basePrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private TableStatus status;    // AVAILABLE / RESERVED / OCCUPIED

    @Version
    @Column(name = "version", nullable = false)
    private Integer version;       // 🛡️ Optimistic Locking for race condition

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    // Holding a table (service layer):
    public boolean tryHold(EntityManager em) {
        // JPA automatically generates:
        // UPDATE dining_table SET status = 'RESERVED', version = version + 1
        // WHERE id = ? AND version = currentVersion
        // If 0 rows affected → OptimisticLockException thrown
        this.status = TableStatus.RESERVED;
        return true;  // Caller must catch OptimisticLockException
    }
}
```

### 10.3 Sample DDL — CREATE TABLE Scripts

```sql
-- ============================================
-- 01-drop-tables.sql (re-runnable)
-- ============================================
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS refund_transaction;
DROP TABLE IF EXISTS verification_token;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS voucher_redemption;
DROP TABLE IF EXISTS voucher;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS reservation_addon;
DROP TABLE IF EXISTS reservation_menu_item;
DROP TABLE IF EXISTS reservation_table;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS holiday_surcharge;
DROP TABLE IF EXISTS addon_service;
DROP TABLE IF EXISTS menu_set_item;
DROP TABLE IF EXISTS menu_set;
DROP TABLE IF EXISTS menu_item_size;
DROP TABLE IF EXISTS menu_item;
DROP TABLE IF EXISTS menu_category;
DROP TABLE IF EXISTS dining_table;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS area;
DROP TABLE IF EXISTS event_type;
DROP TABLE IF EXISTS loyalty_transaction;
DROP TABLE IF EXISTS rank_topup;
DROP TABLE IF EXISTS customer_rank_config;
DROP TABLE IF EXISTS customer_profile;
DROP TABLE IF EXISTS users;

-- ============================================
-- 02-create-tables.sql
-- ============================================
CREATE TABLE users (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    email           NVARCHAR(255) NOT NULL UNIQUE,
    password        VARCHAR(60),                    -- BCrypt hash; NULL for Google OAuth
    full_name       NVARCHAR(100) NOT NULL,
    phone           VARCHAR(20),
    date_of_birth   DATE,
    google_id       VARCHAR(255) UNIQUE,
    avatar_url      VARCHAR(500),
    role            VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',   -- ADMIN/STAFF/CUSTOMER
    status          VARCHAR(20) NOT NULL DEFAULT 'PENDING',    -- PENDING/NEEDS_INFO/ACTIVE/BANNED
    email_verify_token  VARCHAR(255),
    email_verified  BIT NOT NULL DEFAULT 0,
    first_order_used    BIT NOT NULL DEFAULT 0,
    remember_token  VARCHAR(255),
    token_expiry    DATETIME2,
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE customer_profile (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id         BIGINT NOT NULL UNIQUE REFERENCES users(id),
    total_spent     DECIMAL(12,0) NOT NULL DEFAULT 0,
    loyalty_points  INT NOT NULL DEFAULT 0,
    current_rank_id INT REFERENCES customer_rank_config(id),
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE customer_rank_config (
    id                      INT IDENTITY(1,1) PRIMARY KEY,
    rank_name               VARCHAR(20) NOT NULL UNIQUE,   -- BRONZE/SILVER/GOLD/PLATINUM/DIAMOND
    min_point_threshold     INT NOT NULL,                  -- Points required (not VND)
    discount_percent        DECIMAL(5,2) NOT NULL,
    points_per_thousand_vnd INT NOT NULL,
    can_book_vip            BIT NOT NULL DEFAULT 0,
    can_book_vvip           BIT NOT NULL DEFAULT 0,
    is_active               BIT NOT NULL DEFAULT 1
);

CREATE TABLE dining_table (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    room_id     INT NOT NULL REFERENCES room(id),
    table_code  VARCHAR(20) NOT NULL UNIQUE,
    capacity    INT NOT NULL CHECK (capacity IN (2,4,6,8,10)),
    base_price  DECIMAL(10,0) NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE', -- AVAILABLE/RESERVED/OCCUPIED
    version     INT NOT NULL DEFAULT 0,                    -- @Version for Optimistic Locking
    is_active   BIT NOT NULL DEFAULT 1
);

CREATE TABLE reservation (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id             BIGINT REFERENCES users(id),              -- NULL for walk-in
    guest_name          NVARCHAR(100),                            -- NULL for online
    guest_phone         VARCHAR(20),                              -- NULL for online
    event_type_id       INT NOT NULL REFERENCES event_type(id),
    reservation_date    DATE NOT NULL,
    reservation_time    TIME NOT NULL,
    adults_count        INT NOT NULL CHECK (adults_count >= 1),
    children_count      INT NOT NULL DEFAULT 0,
    has_children        BIT NOT NULL DEFAULT 0,
    status              VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    deposit_amount      DECIMAL(12,0) NOT NULL DEFAULT 0,
    deposit_paid        BIT NOT NULL DEFAULT 0,
    is_online           BIT NOT NULL DEFAULT 1,
    created_by_staff_id INT REFERENCES users(id),                 -- NULL for online
    checkin_at          DATETIME2,
    has_surcharge       BIT NOT NULL DEFAULT 0,
    created_at          DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at          DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE invoice (
    id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    reservation_id  BIGINT UNIQUE REFERENCES reservation(id),     -- NULL for walk-in B
    user_id         BIGINT REFERENCES users(id),                  -- NULL for anonymous
    guest_name      NVARCHAR(100),
    subtotal        DECIMAL(12,0) NOT NULL,
    tip_amount      DECIMAL(12,0) NOT NULL DEFAULT 0,
    surcharge_amount DECIMAL(12,0) NOT NULL DEFAULT 0,
    voucher_discount DECIMAL(12,0) NOT NULL DEFAULT 0,
    points_discount DECIMAL(12,0) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(12,0) NOT NULL,
    payment_method  VARCHAR(10),                                  -- CASH/VNPAY/MOMO
    payment_status  VARCHAR(20) NOT NULL DEFAULT 'PENDING',       -- PENDING/PAID/REFUNDED
    transaction_ref VARCHAR(100),
    paid_at         DATETIME2,
    issued_by_staff_id INT REFERENCES users(id),                  -- NULL for online
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- 03-seed-data.sql
-- ============================================
INSERT INTO customer_rank_config (rank_name, min_point_threshold, discount_percent,
    points_per_thousand_vnd, can_book_vip, can_book_vvip, is_active)
VALUES
    ('BRONZE',   0,      0,  1, 0, 0, 1),
    ('SILVER',   5000,   5,  1, 1, 0, 1),
    ('GOLD',     20000,  8,  2, 1, 0, 1),
    ('PLATINUM', 50000,  12, 3, 1, 0, 1),
    ('DIAMOND',  100000, 15, 5, 1, 1, 1);

INSERT INTO users (email, password, full_name, role, status, email_verified)
VALUES ('admin@restaurant.com',
        '$2a$10$...',  -- BCrypt hash of "admin123"
        N'Quản trị viên', 'ADMIN', 'ACTIVE', 1);
```

### 10.4 Sample — Cloudinary Image Upload (Java)

```java
// File: util/CloudinaryUtil.java
package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;

public class CloudinaryUtil {
    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", System.getenv("CLOUDINARY_CLOUD_NAME"),
            "api_key",    System.getenv("CLOUDINARY_API_KEY"),
            "api_secret", System.getenv("CLOUDINARY_API_SECRET"),
            "secure",     true
        ));
    }

    public static String upload(InputStream inputStream, String folder) {
        try {
            Map<?, ?> uploadResult = cloudinary.uploader().upload(inputStream,
                ObjectUtils.asMap("folder", "restaurant/" + folder));
            return (String) uploadResult.get("secure_url");  // Store this VARCHAR in DB
        } catch (IOException e) {
            throw new RuntimeException("Cloudinary upload failed", e);
        }
    }

    public static Map<?, ?> delete(String publicId) {
        try {
            return cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (IOException e) {
            throw new RuntimeException("Cloudinary delete failed", e);
        }
    }
}

// File: util/CloudinaryService.java (used in AdminMenuItemController)
package service;

import util.CloudinaryUtil;

public class CloudinaryService {
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    public String uploadImage(InputStream inputStream, String originalFileName, String folder) {
        // Validate content type at Servlet level (FileUpload)
        // The stream is passed directly — no temp file, no Base64
        return CloudinaryUtil.upload(inputStream, folder);
    }
}
```

### 10.5 Sample — Ajax Fetch Pattern (JavaScript)

```javascript
// ============================================
// Global Fetch wrapper — utils.js
// ============================================
async function apiFetch(url, method = "GET", body = null) {
  const options = {
    method: method,
    headers: { Accept: "application/json" },
  };
  if (body) {
    if (body instanceof FormData) {
      // For file uploads — let browser set Content-Type (multipart)
      options.body = body;
    } else {
      options.headers["Content-Type"] = "application/json";
      options.body = JSON.stringify(body);
    }
  }
  try {
    const response = await fetch(url, options);
    const data = await response.json();
    if (!response.ok) {
      if (response.status === 409) {
        showToast("warning", data.message || "Conflict — please retry");
      } else {
        showToast("error", data.message || "Server error");
      }
    }
    return data;
  } catch (error) {
    showToast("error", "Network error: " + error.message);
    return { success: false, message: error.message };
  }
}

// ============================================
// Example: Hold table with Optimistic Locking
// ============================================
async function holdTable(tableId) {
  const result = await apiFetch("/api/booking/hold-table", "POST", {
    tableId: tableId,
    sessionId: getSessionId(), // read from JSESSIONID cookie or hidden input
  });
  if (result.success) {
    document
      .querySelector(`.table-card[data-id="${tableId}"]`)
      .classList.add("selected");
    showToast("success", "Table selected!");
  }
  // If 409, apiFetch already shows the Toast warning
}

// ============================================
// Example: Login via Modal
// ============================================
async function login(event) {
  event.preventDefault();
  const email = document.getElementById("loginEmail").value;
  const password = document.getElementById("loginPassword").value;

  const result = await apiFetch("/api/auth/login", "POST", { email, password });
  if (result.success) {
    bootstrap.Modal.getInstance(document.getElementById("loginModal")).hide();
    window.location.reload(); // Server side will redirect to booking step 2
  } else {
    document.getElementById("loginError").textContent = result.message;
  }
}
```

### 10.6 UI Component Mapping — Bootstrap 5

| Screen           | JSP                                  | Bootstrap Components                                               | Fetch API Endpoints                                     |
| ---------------- | ------------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------- |
| Landing Page     | `/common/index.jsp`                  | Carousel, Card, Grid, Badge, Navbar                                | —                                                       |
| Login (Modal)    | `/common/components/login-modal.jsp` | Modal, Form, Button (Google), Alert                                | POST /api/auth/login                                    |
| Register         | `/common/register.jsp`               | Form, Validation feedback, Button                                  | POST /api/auth/register                                 |
| Menu Browsing    | `/common/menu.jsp`                   | Nav/Pills (tabs), Card, Badge, Grid                                | GET /api/menu/categories, /api/menu/items               |
| Booking Step 1   | `/common/booking-step1.jsp`          | Form (date/time/select), Modal (surcharge), Toast                  | GET /api/surcharge                                      |
| Booking Step 2   | `/common/booking-step2.jsp`          | Tabs (Area), Card (Room), Card grid (Table), Toast                 | GET /api/tables/available, POST /api/booking/hold-table |
| Booking Step 3   | `/common/booking-step3.jsp`          | Nav/Pills (3 tabs), Card, Offcanvas (cart), Toast                  | GET /api/menu/items, POST /api/booking/save-step3       |
| Booking Step 4   | `/common/booking-step4.jsp`          | List group, Table (breakdown), Form (voucher/points), Button radio | POST /api/booking/apply-voucher, /api/booking/confirm   |
| Staff Dashboard  | `/staff/dashboard.jsp`               | List group (timeline), Dropdown (filter), Badge, Toast             | GET /api/staff/reservations                             |
| Staff Check-in   | `/staff/checkin.jsp`                 | Table, Checkbox (check-in), Button (no-show)                       | POST /api/staff/checkin/{id}                            |
| Admin Users      | `/admin/users.jsp`                   | Table (responsive), Modal (CRUD), Pagination, Badge (role)         | GET/POST /api/admin/users                               |
| Admin Menu Items | `/admin/menu-items.jsp`              | Card grid, Form + File input (Cloudinary preview), Modal, Toast    | POST /api/admin/upload-image                            |
| Admin Reports    | `/admin/reports.jsp`                 | Card (KPI), Table, Chart.js (canvas)                               | GET /api/admin/reports/revenue                          |

### 10.7 Entity Relationship Diagram (Summary)

```
users (1) ──── (1) customer_profile (N) ──── (1) customer_rank_config
  │
  ├── (1:N) reservation ──┬── (N:1) event_type
  │                       ├── (N:1) dining_table ── (N:1) room ── (N:1) area
  │                       └── (1:1) invoice
  │
  ├── (1:N) review
  ├── (1:N) loyalty_transaction
  └── (1:N) voucher_redemption ── (N:1) voucher

menu_category (1) ──── (1:N) menu_item (1) ──── (1:N) menu_item_size
                              │
                              └── (N:N) menu_set ── via ── menu_set_item
                                                              (N:1)

addon_service (1) ──── (1:N) reservation_addon ── (N:1) reservation

holiday_surcharge (standalone lookup)

reservation (1) ──── (1:N) reservation_table ── (N:1) dining_table
reservation (1) ──── (1:N) reservation_menu_item
reservation (1) ──── (1:N) reservation_addon
```

---

> **End of Project Plan v4** — This plan is self-contained and supersedes all previous versions (v1, v2, v3).  
> **24 mandatory JPA entities + 4 supplementary entities = 28 total.**  
> **All 5 flowcharts, 4-dev WBS, folder structure with specific filenames included.**
