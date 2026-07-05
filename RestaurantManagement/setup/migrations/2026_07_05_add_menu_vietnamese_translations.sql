USE RestaurantManagement;
GO

IF COL_LENGTH('menu_category', 'category_name_vi') IS NULL
BEGIN
    ALTER TABLE menu_category ADD category_name_vi NVARCHAR(100) NULL;
END;
GO

IF COL_LENGTH('menu_item', 'item_name_vi') IS NULL
BEGIN
    ALTER TABLE menu_item ADD item_name_vi NVARCHAR(150) NULL;
END;
GO

IF COL_LENGTH('menu_item', 'description_vi') IS NULL
BEGIN
    ALTER TABLE menu_item ADD description_vi NVARCHAR(MAX) NULL;
END;
GO

UPDATE menu_category
SET category_name_vi = CASE category_name
    WHEN 'Appetizers' THEN N'Khai vị'
    WHEN 'Soups' THEN N'Súp'
    WHEN 'Main Courses' THEN N'Món chính'
    WHEN 'Desserts' THEN N'Tráng miệng'
    WHEN 'Drinks' THEN N'Đồ uống'
    ELSE category_name_vi
END
WHERE category_name_vi IS NULL OR LTRIM(RTRIM(category_name_vi)) = '';
GO

UPDATE menu_item SET item_name_vi = N'Khúc Dạo Đầu Vườn Lụa', description_vi = N'Ngó sen giòn với tôm, rau thơm, đậu phộng rang và xốt chanh' WHERE id = 1;
UPDATE menu_item SET item_name_vi = N'Dòng Rót Hổ Phách', description_vi = N'Súp ấm với thịt cua và măng tây xanh tươi' WHERE id = 2;
UPDATE menu_item SET item_name_vi = N'Than Hồng Nửa Đêm', description_vi = N'Thăn bò nướng với xốt tiêu đen và rau củ theo mùa' WHERE id = 3;
UPDATE menu_item SET item_name_vi = N'Dòng Chảy Vàng', description_vi = N'Cá hồi áp chảo với bơ vàng và xốt chanh dây' WHERE id = 4;
UPDATE menu_item SET item_name_vi = N'Nghi Thức Xế Chiều', description_vi = N'Trà phục vụ tại bàn cùng những miếng trái cây và thảo mộc nhỏ' WHERE id = 5;
UPDATE menu_item SET item_name_vi = N'Hoàng Hôn Hầm Rượu', description_vi = N'Rượu vang đỏ Pháp nhập khẩu với hương quả mọng đậm và tannin mượt' WHERE id = 6;
UPDATE menu_item SET item_name_vi = N'Món thử nghiệm', description_vi = N'' WHERE id = 7;
UPDATE menu_item SET item_name_vi = N'Món thử nghiệm 02', description_vi = N'' WHERE id = 8;
UPDATE menu_item SET item_name_vi = N'Triều Đỏ', description_vi = N'Cá ngừ cắt hạt lựu ướp lạnh, gel cam chanh, dầu hành và caviar kiểu oscietra' WHERE id = 9;
UPDATE menu_item SET item_name_vi = N'Bờ Trăng', description_vi = N'Sò điệp lát mỏng với yuzu kosho, dầu thảo mộc và rong nho' WHERE id = 10;
UPDATE menu_item SET item_name_vi = N'Tiểu Khúc Xanh', description_vi = N'Tartlet mỏng với thảo mộc, phô mai đánh bông và rau xanh ngâm nhẹ' WHERE id = 11;
UPDATE menu_item SET item_name_vi = N'Miếng Cua Ánh Vàng', description_vi = N'Canapé cua nhỏ với xốt gạch cua béo và vụn bánh nướng' WHERE id = 12;
UPDATE menu_item SET item_name_vi = N'Vườn Nhung', description_vi = N'Ức vịt hun khói, lá non, vinaigrette mận và hạt rang' WHERE id = 13;
UPDATE menu_item SET item_name_vi = N'Triều Êm', description_vi = N'Nước dùng trong thoảng hương truffle với cá trắng và rau thơm' WHERE id = 14;
UPDATE menu_item SET item_name_vi = N'Ánh Thu', description_vi = N'Súp bí đỏ mịn với kem, dầu hạt bí và hạnh nhân nướng' WHERE id = 15;
UPDATE menu_item SET item_name_vi = N'Nhung Biển Sâu', description_vi = N'Nước dùng hải sản đậm vị hoàn thiện bằng kem, bơ thảo mộc và hải sản' WHERE id = 16;
UPDATE menu_item SET item_name_vi = N'Rạn Đỏ', description_vi = N'Tôm hùm nướng than với bơ tỏi thảo mộc và chanh vàng' WHERE id = 17;
UPDATE menu_item SET item_name_vi = N'Vương Miện Vỏ Biển', description_vi = N'Cua hoàng đế hấp dùng cùng bơ thảo mộc ấm và muối cam chanh' WHERE id = 18;
UPDATE menu_item SET item_name_vi = N'Hoàng Hôn Mận', description_vi = N'Ức vịt nướng hồng với xốt mận gia vị và rau củ rễ' WHERE id = 19;
UPDATE menu_item SET item_name_vi = N'Cánh Quạt Đêm Đen', description_vi = N'Sườn non Wagyu nấu chậm với xốt vang đỏ và purée nấm' WHERE id = 20;
UPDATE menu_item SET item_name_vi = N'Dòng Sông Nhạt', description_vi = N'Cá tuyết trắng ướp miso, dùng cùng xốt bơ dashi' WHERE id = 21;
UPDATE menu_item SET item_name_vi = N'Mộng Niêu Đất', description_vi = N'Tôm, sò điệp và cá om trong xốt niêu đất thơm gia vị' WHERE id = 22;
UPDATE menu_item SET item_name_vi = N'Cuộn Nắng', description_vi = N'Gà cuộn nhân gan ngỗng, xốt thảo mộc và purée cà rốt' WHERE id = 23;
UPDATE menu_item SET item_name_vi = N'Đầm Ngọc', description_vi = N'Risotto saffron kem với bào ngư, parmesan và dầu hẹ' WHERE id = 24;
UPDATE menu_item SET item_name_vi = N'Mây Trên Sứ Lam', description_vi = N'Meringue giòn với kem chanh dây, kem tươi và rau thơm' WHERE id = 25;
UPDATE menu_item SET item_name_vi = N'Vườn Ruby', description_vi = N'Sorbet phúc bồn tử với compote quả mọng, hoa ăn được và tuile giòn' WHERE id = 26;
UPDATE menu_item SET item_name_vi = N'Ngọc Sương', description_vi = N'Panna cotta dừa với trái cây nhiệt đới và bọt chanh' WHERE id = 27;
UPDATE menu_item SET item_name_vi = N'Vương Miện Mật Ong', description_vi = N'Đế tart bơ với kem yuzu, meringue và gel húng quế' WHERE id = 28;
UPDATE menu_item SET item_name_vi = N'Nhật Thực Atlas', description_vi = N'Mousse chocolate đen với praline hạt phỉ và vụn cacao' WHERE id = 29;
UPDATE menu_item SET item_name_vi = N'Đêm Quả Mọng', description_vi = N'Compote quả mọng với kem sữa chua, hạt giòn và meringue' WHERE id = 30;
UPDATE menu_item SET item_name_vi = N'Lễ Bạc', description_vi = N'Một ly champagne brut được chọn cho tasting menu' WHERE id = 31;
UPDATE menu_item SET item_name_vi = N'Kết Màn Hổ Phách', description_vi = N'Cocktail cam chanh nhà làm với siro thảo mộc và hậu vị sủi nhẹ' WHERE id = 32;
UPDATE menu_item SET item_name_vi = N'Quỹ Đạo Saffron', description_vi = N'Món mở đầu sáng vị với kết cấu giòn và nốt saffron ấm' WHERE id = 33;
UPDATE menu_item SET item_name_vi = N'Cánh Ngà', description_vi = N'Món khai vị tinh tế với hương hoa nhẹ và hậu vị cam chanh' WHERE id = 34;
UPDATE menu_item SET item_name_vi = N'Tứ Khúc Theo Mùa', description_vi = N'Bốn miếng nhỏ theo mùa được sắp đặt như lời mở đầu tasting' WHERE id = 35;
UPDATE menu_item SET item_name_vi = N'Đốm Than Nhỏ', description_vi = N'Một miếng ấm với hương khói và lớp men thảo mộc' WHERE id = 36;
UPDATE menu_item SET item_name_vi = N'Nở Hoa Từ Đất', description_vi = N'Món nước dùng trầm ấm với hương rang và phần garnish mềm' WHERE id = 37;
UPDATE menu_item SET item_name_vi = N'Lời Thì Thầm Sứ Trắng', description_vi = N'Súp kem nhạt màu với thảo mộc vườn và nốt khoáng nhẹ' WHERE id = 38;
UPDATE menu_item SET item_name_vi = N'Nước Dùng Vàng Hồng', description_vi = N'Nước dùng vàng ấm với vị ngọt nhiều tầng và gia vị dịu' WHERE id = 39;
UPDATE menu_item SET item_name_vi = N'Lá Bạc Đêm', description_vi = N'Đĩa hải sản được dựng tinh tế với xốt sáng và dầu thảo mộc mềm' WHERE id = 40;
UPDATE menu_item SET item_name_vi = N'Vương Miện Ngọc', description_vi = N'Món biển thanh nhã với nốt thảo mộc xanh và hậu vị sạch' WHERE id = 41;
UPDATE menu_item SET item_name_vi = N'Mặt Trời Saffron', description_vi = N'Món chính ánh vàng với gia vị ấm, bơ và xốt cam chanh' WHERE id = 42;
UPDATE menu_item SET item_name_vi = N'Quỹ Đạo Nhạt', description_vi = N'Món chính dịu với độ chua trái cây và xốt kem nhẹ' WHERE id = 43;
UPDATE menu_item SET item_name_vi = N'Khu Vườn Đen', description_vi = N'Món chính sâu vị đất với nốt rang và xốt jus đậm' WHERE id = 44;
UPDATE menu_item SET item_name_vi = N'Sen Nửa Đêm', description_vi = N'Món chính trên nền đĩa tối với hoa trang trí và umami nhiều tầng' WHERE id = 45;
UPDATE menu_item SET item_name_vi = N'Vịnh Ẩn', description_vi = N'Món chính ven biển với thảo mộc tươi và vị mặn ngọt kín đáo' WHERE id = 46;
UPDATE menu_item SET item_name_vi = N'Dải Lụa Xanh', description_vi = N'Món ngọt xanh thanh với kem mềm, hương lá và hậu vị giòn' WHERE id = 47;
UPDATE menu_item SET item_name_vi = N'Khu Rừng Nhỏ', description_vi = N'Món tráng miệng lấy cảm hứng từ rừng với quả mọng, kem và vụn rang' WHERE id = 48;
UPDATE menu_item SET item_name_vi = N'Giọt Ruby', description_vi = N'Món ngọt như viên ngọc với độ chua quả mọng và vị mát' WHERE id = 49;
UPDATE menu_item SET item_name_vi = N'Ngọc Rêu', description_vi = N'Món tráng miệng xanh trầm với mousse mềm và hương thảo mộc tinh tế' WHERE id = 50;
UPDATE menu_item SET item_name_vi = N'Dự Trữ Đêm', description_vi = N'Ly rượu reserve do sommelier chọn cho tasting menu đậm vị' WHERE id = 51;
UPDATE menu_item SET item_name_vi = N'Ánh Nến Sommelier', description_vi = N'Wine pairing cao cấp tại bàn, chọn theo các món của buổi tối' WHERE id = 52;
GO

PRINT 'Menu Vietnamese translation columns and seed data synchronized.';
GO
