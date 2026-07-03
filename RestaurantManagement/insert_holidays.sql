USE [RestaurantManagement];
GO

-- Xóa dữ liệu cũ (nếu có)
DELETE FROM holiday_surcharge;
GO

-- Thêm các ngày lễ lớn của Việt Nam (năm 2026)
INSERT INTO holiday_surcharge (holiday_name, surcharge_date, surcharge_percent, is_active)
VALUES 
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

PRINT 'Thêm danh sách các ngày lễ thành công!';
