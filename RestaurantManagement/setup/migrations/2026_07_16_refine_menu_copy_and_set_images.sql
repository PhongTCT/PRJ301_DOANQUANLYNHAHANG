USE RestaurantManagement;
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE menu_set
    SET image_url = CASE set_name_vi
        WHEN N'Non Xanh Nước Biếc' THEN 'assets/img/le-royal/menu/garden-herb-tartlet.jpg'
        WHEN N'Trăng Trôi Trên Sóng' THEN 'assets/img/le-royal/menu/scallop-carpaccio.jpg'
        WHEN N'Lửa Ấm Cuối Vườn' THEN 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'
        WHEN N'Sao Biển Ra Khơi' THEN 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'
        WHEN N'Mùa Vàng Giữ Gió' THEN 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg'
        ELSE image_url END
    WHERE set_name_vi IN (N'Non Xanh Nước Biếc', N'Trăng Trôi Trên Sóng', N'Lửa Ấm Cuối Vườn', N'Sao Biển Ra Khơi', N'Mùa Vàng Giữ Gió');

    UPDATE menu_item
    SET description_vi = CASE id
            WHEN 1 THEN N'Một mở đầu xanh và giòn, có vị chua nhẹ kéo món ăn trở nên sáng hơn.'
            WHEN 3 THEN N'Món chính ấm và sâu vị, có độ nướng rõ, hậu cay nhẹ và cảm giác chắc gọn.'
            WHEN 5 THEN N'Một ly mát, sáng vị, dùng để làm sạch khẩu vị giữa các món đậm hơn.'
            WHEN 6 THEN N'Ly vang đỏ tròn vị, có chiều sâu và chút ấm mềm ở cuối ngụm.'
            WHEN 9 THEN N'Một lớp vị biển mát, sáng, mở ra bằng độ béo nhẹ và hậu vị trong.'
            WHEN 10 THEN N'Món khai vị mảnh và lạnh, gợi cảm giác mặt biển yên dưới ánh trăng.'
            WHEN 11 THEN N'Một miếng nhỏ xanh vị, thơm dịu, đủ nhẹ để mở đầu nhịp tasting.'
            WHEN 12 THEN N'Một điểm vàng béo nhẹ, giòn và mặn thanh, đánh thức khẩu vị đầu bữa.'
            WHEN 13 THEN N'Hương khói mỏng đi cùng vị mềm, tối màu, làm nhịp đầu bữa trầm xuống.'
            WHEN 14 THEN N'Một ngụm nước dùng trong, ấm và sạch, để lại dư vị khoáng nhẹ.'
            WHEN 15 THEN N'Tầng vị ấm, mịn và ngọt dịu, như khoảng lặng giữa các món đầu.'
            WHEN 16 THEN N'Một bát soup biển ấm, mượt và béo vừa, giữ vị sâu nhưng không nặng.'
            WHEN 17 THEN N'Món chính có độ nướng rõ, thơm bơ nhẹ và hậu vị biển sáng.'
            WHEN 18 THEN N'Món hải vị lớn, ngọt chắc, giữ cảm giác sang nhưng không phô.'
            WHEN 19 THEN N'Món chính mềm, ấm, có chút chua ngọt sâu để kéo dài hậu vị.'
            WHEN 20 THEN N'Một món đậm và tối vị, chậm rãi, hợp với nhịp dinner dài.'
            WHEN 21 THEN N'Món cá trắng mềm, thanh và sạch vị, đi theo hướng nhẹ nhưng sâu.'
            WHEN 22 THEN N'Một món ấm, thơm và tròn vị, gợi cảm giác bếp nhỏ cuối buổi tối.'
            WHEN 23 THEN N'Món chính mềm, sáng màu, có độ béo vừa và hậu vị dịu.'
            WHEN 24 THEN N'Món chính tròn vị, có sắc vàng ấm và cảm giác giàu nhưng vẫn thanh.'
            WHEN 27 THEN N'Món ngọt mát, mềm và nhẹ, dùng để khép lại bữa ăn một cách sạch vị.'
            WHEN 28 THEN N'Món ngọt sáng, có vị chua thơm và độ béo nhẹ ở cuối.'
            WHEN 29 THEN N'Món chocolate sâu vị, có độ đắng mềm và cảm giác giòn nhẹ.'
            WHEN 30 THEN N'Bánh matcha nhiều lớp, xanh vị, mềm và có hậu ngọt đắng thanh.'
            WHEN 31 THEN N'Một ly sủi mảnh, sáng và khô, hợp để nâng nhịp chúc mừng.'
            WHEN 32 THEN N'Ly cocktail cuối bữa, có sắc cam chanh và hậu vị thơm nhẹ.'
            WHEN 34 THEN N'Một mở đầu thanh và sáng, có hương hoa rất nhẹ trên nền vị dịu.'
            WHEN 35 THEN N'Bốn miếng nhỏ theo mùa, đặt cạnh nhau như lời giới thiệu của bếp.'
            WHEN 36 THEN N'Một miếng ấm, thơm khói nhẹ, tạo điểm nhấn trước các món sâu hơn.'
            WHEN 37 THEN N'Món nước dùng trầm, ấm và có chút vị rang ở tầng sau.'
            WHEN 38 THEN N'Một bát soup nhạt màu, mềm và yên, hợp với nhịp fine dining nhẹ.'
            WHEN 39 THEN N'Nước dùng vàng ấm, có vị ngọt sâu và chút gia vị rất nhẹ.'
            WHEN 40 THEN N'Món biển được dựng gọn, sáng vị, có hậu thảo mộc mềm.'
            WHEN 41 THEN N'Một món biển thanh và sạch, để lại cảm giác xanh ở cuối.'
            WHEN 43 THEN N'Món chính nhẹ, sáng và có độ chua mềm để cân bằng bữa tối.'
            WHEN 44 THEN N'Món chính tối màu, có nốt rang và chiều sâu của xốt.'
            WHEN 45 THEN N'Món chính nhiều tầng umami, tối giản trên đĩa nhưng sâu vị.'
            WHEN 46 THEN N'Một món biển kín đáo, mặn ngọt nhẹ và có hương thảo mộc tươi.'
            WHEN 47 THEN N'Món ngọt xanh, mát và mịn, kết lại bằng một lớp giòn nhẹ.'
            WHEN 48 THEN N'Món tráng miệng nhỏ, mát, có vị quả mọng và cảm giác sau mưa.'
            WHEN 49 THEN N'Món ngọt sáng màu, chua thanh, mát và gọn vị.'
            WHEN 50 THEN N'Món tráng miệng xanh trầm, mềm và có hương thảo mộc ở cuối.'
            WHEN 51 THEN N'Ly rượu reserve dành cho các set đậm vị, giữ dư âm dài hơn.'
            WHEN 52 THEN N'Wine pairing tại bàn, chọn theo nhịp món và độ đậm của buổi tối.'
            ELSE description_vi END,
        description = CASE id
            WHEN 1 THEN N'A crisp green opening with gentle acidity and a clean lift.'
            WHEN 3 THEN N'A warm, deep main course with clear roasted notes and a soft pepper finish.'
            WHEN 5 THEN N'A bright chilled glass to refresh the palate between richer courses.'
            WHEN 6 THEN N'A rounded red wine with quiet depth and a warm finish.'
            WHEN 9 THEN N'A cool sea-led opening with a light richness and clean aftertaste.'
            WHEN 10 THEN N'A delicate chilled bite, calm and bright like moonlight over water.'
            WHEN 11 THEN N'A small green prelude, aromatic and light enough to begin the tasting.'
            WHEN 12 THEN N'A golden, crisp, lightly savoury note to wake the palate.'
            WHEN 13 THEN N'A thin veil of smoke over a soft, darker first-course rhythm.'
            WHEN 14 THEN N'A clear, warm broth with a mineral finish and quiet depth.'
            WHEN 15 THEN N'A smooth, warm and gently sweet pause between opening courses.'
            WHEN 16 THEN N'A warm shellfish soup, silky and rounded without feeling heavy.'
            WHEN 17 THEN N'A roasted sea course with butter warmth and a bright finish.'
            WHEN 18 THEN N'A generous shellfish main course, polished and naturally sweet.'
            WHEN 19 THEN N'A soft, warm main course with deep fruit acidity and a long finish.'
            WHEN 20 THEN N'A dark, slow main course for a longer dinner rhythm.'
            WHEN 21 THEN N'A pale fish course, clean and gentle but still deep.'
            WHEN 22 THEN N'A warm, aromatic course with the feeling of a small evening kitchen.'
            WHEN 23 THEN N'A soft, light-coloured main course with gentle richness.'
            WHEN 24 THEN N'A rounded golden main course, rich but still refined.'
            WHEN 27 THEN N'A cool, soft dessert that closes the palate cleanly.'
            WHEN 28 THEN N'A bright dessert with fragrant acidity and a soft creamy end.'
            WHEN 29 THEN N'A deep chocolate dessert with gentle bitterness and a crisp accent.'
            WHEN 30 THEN N'A layered matcha cake with soft cream and a clean bittersweet finish.'
            WHEN 31 THEN N'A fine, dry sparkling glass for a quiet celebration.'
            WHEN 32 THEN N'A citrus-led closing cocktail with a soft aromatic finish.'
            WHEN 34 THEN N'A light floral opening with a quiet, bright lift.'
            WHEN 35 THEN N'Four seasonal small bites arranged as the kitchen’s first note.'
            WHEN 36 THEN N'A warm smoky bite before the deeper courses begin.'
            WHEN 37 THEN N'A grounded warm broth with toasted depth.'
            WHEN 38 THEN N'A pale, soft soup with a calm fine-dining rhythm.'
            WHEN 39 THEN N'A golden warm broth with layered sweetness and gentle spice.'
            WHEN 40 THEN N'A composed sea course with clean brightness and soft herbs.'
            WHEN 41 THEN N'A clean ocean course with a green finish.'
            WHEN 43 THEN N'A gentle, bright main course balanced by soft acidity.'
            WHEN 44 THEN N'A dark roasted main course with a deeper sauce note.'
            WHEN 45 THEN N'A layered umami main course, minimal on the plate and deep in taste.'
            WHEN 46 THEN N'A discreet coastal course with light briny sweetness.'
            WHEN 47 THEN N'A cool green dessert with soft cream and a crisp ending.'
            WHEN 48 THEN N'A small cool dessert with berry notes and a rain-washed feeling.'
            WHEN 49 THEN N'A bright jewel-like dessert, fresh and clean.'
            WHEN 50 THEN N'A quiet green dessert with a soft herbal finish.'
            WHEN 51 THEN N'A reserve pour for richer tasting menus, with a longer finish.'
            WHEN 52 THEN N'A tableside wine pairing chosen around the rhythm of the dinner.'
            ELSE description END
    WHERE is_available = 1;

    UPDATE menu_item
    SET item_name_vi = N'Sắc Đỏ Trong Hầm',
        item_name = N'Cellar Red',
        description_vi = N'Ly vang đỏ tròn vị, có chiều sâu và chút ấm mềm ở cuối ngụm.',
        description = N'A rounded red wine with quiet depth and a warm finish.'
    WHERE image_url = 'assets/img/le-royal/menu/bordeaux-red-wine.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Sóng Kem Ấm',
        item_name = N'Warm Cream Tide',
        description_vi = N'Một bát soup biển ấm, mượt và béo vừa, giữ vị sâu nhưng không nặng.',
        description = N'A warm shellfish soup, silky and rounded without feeling heavy.'
    WHERE image_url = 'assets/img/le-royal/menu/lobster-bisque.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Ánh Bạc Khai Tiệc',
        item_name = N'Silver Toast',
        description_vi = N'Một ly sủi mảnh, sáng và khô, hợp để nâng nhịp chúc mừng.',
        description = N'A fine, dry sparkling glass for a quiet celebration.'
    WHERE image_url = 'assets/img/le-royal/menu/champagne-pairing.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Đêm Trà Xanh',
        item_name = N'Matcha Nightfall',
        description_vi = N'Bánh matcha nhiều lớp, xanh vị, mềm và có hậu ngọt đắng thanh.',
        description = N'A layered matcha cake with soft cream and a clean bittersweet finish.'
    WHERE image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Rượu Đêm Dài'
    WHERE image_url = 'assets/img/le-royal/menu/nocturne-reserve.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Nến Rượu Bên Bàn'
    WHERE image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg';

    COMMIT TRANSACTION;
    PRINT 'Refined menu copy and switched set menu thumbnails to representative dishes.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
