-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th7 25, 2025 lúc 09:27 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `jira_webdt`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `attributes`
--

CREATE TABLE `attributes` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `attribute_values`
--

CREATE TABLE `attribute_values` (
  `id` int(11) NOT NULL,
  `attribute_id` int(11) NOT NULL,
  `value` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `brands`
--

INSERT INTO `brands` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Apple', 'apple', 'Thương hiệu điện thoại hàng đầu thế giới.', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(2, 'Samsung', 'samsung', 'Hãng điện tử tiêu dùng lớn của Hàn Quốc.', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(3, 'Xiaomi', 'xiaomi', 'Hãng công nghệ phát triển nhanh của Trung Quốc.', '2025-07-08 00:55:03', '2025-07-08 00:55:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Điện thoại iPhone', 'dien-thoai-iphone', 'Các mẫu iPhone mới nhất và cũ hơn từ Apple.', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(2, 'Điện thoại Samsung', 'dien-thoai-samsung', 'Các dòng điện thoại Galaxy từ Samsung.', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(3, 'Điện thoại Xiaomi', 'dien-thoai-xiaomi', 'Điện thoại thông minh giá cả phải chăng từ Xiaomi.', '2025-07-08 00:55:03', '2025-07-08 00:55:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `discount_type` enum('fixed','percentage') NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT 0.00,
  `usage_limit` int(11) DEFAULT 0,
  `used_count` int(11) DEFAULT 0,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `shipping_address` mediumtext NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `order_status` enum('pending','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `customer_name`, `customer_email`, `customer_phone`, `shipping_address`, `total_amount`, `order_status`, `payment_method`, `payment_status`, `created_at`, `updated_at`) VALUES
(1, 5, '', NULL, '', '', 220469999.99, 'pending', NULL, 'pending', '2025-07-22 19:47:07', '2025-07-22 19:47:07'),
(2, 5, '', NULL, '', '', 30990000.00, 'pending', NULL, 'pending', '2025-07-22 19:47:15', '2025-07-22 19:47:15'),
(3, NULL, 'Nguyễn Duy Khang', NULL, '0398970269', 'Tỉnh Vĩnh Long', 99999999.99, 'pending', 'cod', 'pending', '2025-07-22 19:53:05', '2025-07-22 19:53:05'),
(4, NULL, 'Khang Nguyễn', NULL, '0398970269', 'Nguyễn Thiện Thành', 24000000.00, 'shipped', 'cod', 'pending', '2025-07-25 14:26:13', '2025-07-25 14:26:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_at_order` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price_at_order`) VALUES
(6, 4, 23, 1, 24000000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `image_url` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `category_id`, `brand_id`, `short_description`, `description`, `price`, `sale_price`, `stock_quantity`, `image_url`, `status`, `created_at`, `updated_at`) VALUES
(10, 'Samsung Galaxy S24 Ultra 5G', 'samsung-galaxy-s24-ultra-5g', 2, 2, 'Ra mắt tháng 1/2024, là mẫu flagship cao cấp nhất trong dòng Galaxy S24 series của Samsung \r\nThiết kế: Khung titanium cao cấp, màn hình phẳng 6,8 inch Dynamic AMOLED 2X, độ phân giải Quad HD + 3120×1440, tần số quét 120 Hz, mặt kính Gorilla Armor (Victus 2) tăng độ bền, không cong như đời trước \r\nHiệu năng: Chip Snapdragon 8 Gen 3 (dành riêng cho Galaxy), RAM 12GB, bộ nhớ 256/512GB hoặc 1TB, chạy Android 14 với One UI 6.1 và hỗ trợ cập nhật đến 7 năm', '* Camera & Hình ảnh\r\nHệ thống camera sau:\r\n\r\n200 MP (chính, góc rộng),\r\n\r\n50 MP telephoto (5× zoom quang học),\r\n\r\n10 MP telephoto (3× zoom),\r\n\r\n12 MP siêu rộng cùng laser AF và chống rung OIS.\r\n\r\nCamera trước 12 MP góc rộng\r\nQuay video hỗ trợ 8K@24/30fps, 4K@30/60/120fps, slow‑motion đến 960fps và HDR10+\r\ních hợp ProVisual Engine và Galaxy AI giúp tối ưu màu sắc, độ tương phản, xóa vật thể không mong muốn (Magic Eraser), chỉnh sửa ảnh bằng AI... rất tiện ích\r\n* Pin & Các tính năng khác\r\nDung lượng pin 5.000 mAh, hỗ trợ sạc nhanh 45W; thời lượng pin kéo dài đến 2 ngày với mức sử dụng vừa phải\r\nS Pen tích hợp như Galaxy Note – tiện cho ghi chú, chỉnh tài liệu – cùng màn hình dẹt giúp sử dụng dễ dàng hơn\r\nKhông hỗ trợ Qi2 không dây mới, vẫn dùng sạc không dây chuẩn Qi thông thường\r\n* Ưu điểm nổi bật\r\nCamera rất mạnh, zoom quang 5× rõ nét và xử lý ảnh tự nhiên hơn. Hình ảnh zoom xa ít nhiễu hơn thế hệ trước\r\nMàn hình sáng, sắc nét và trải nghiệm S Pen ổn định hơn với thiết kế phẳng\r\nHiệu năng hàng đầu, dẫn đầu các smartphone Android hiện nay\r\nGalaxy AI tích hợp sâu vào hệ thống giúp nhiều thao tác nhanh hơn và thông minh hơn', 29450000.00, 23350000.00, 47, 'uploads/68831ec832b5d-samsung s24 ultra.jpg', 'active', '2025-07-25 13:06:00', '2025-07-25 13:06:00'),
(11, 'Samsung Galaxy S25 Ultra', 'samsung-galaxy-s25-ultra', 2, 2, '- Ra mắt chính thức ngày 22/1/2025, thương mại từ 3/2/2025\r\n- Là phiên bản cao cấp nhất trong dòng Galaxy S25, với máy khung titanium và kính bảo vệ Gorilla Glass Armor 2, màn hình phẳng 6,9″ Dynamic LTPO AMOLED 2X, độ phân giải QHD+ 3120×1440, tần số quét tùy biến 1–120 Hz, độ sáng tối đa lên đến 2.600 nits', '* Hiệu năng & Bộ nhớ\r\n- Trang bị chip Snapdragon 8 Elite for Galaxy (3nm TSMC N3E), tăng khoảng +37% CPU, +30‑32% GPU, +40‑43% NPU so với thế hệ trước \r\n- RAM tiêu chuẩn 12 GB LPDDR5X (hoặc 16 GB cho bản 1 TB tại một số thị trường như Hàn, Trung, Hong Kong, Đài Loan) \r\n- Bộ nhớ trong 256 GB, 512 GB hoặc 1 TB, lưu trữ UFS 4.0 (tùy thị trường) \r\n* Hệ thống camera\r\n- Camera sau gồm: 200 MP chính + 50 MP ultra‑wide (cải tiến macro, tăng chi tiết gấp 4 lần so với S24 Ultra), + 10 MP zoom 3×, + 50 MP tele‑photo zoom 5× (periscope) hỗ trợ zoom kỹ thuật số lên đến 100×, tích hợp OIS, AF đa hướng, ghi video 8K@30fps, 4K@60/120fps, HDR10+ \r\n- Camera trước: 12 MP f/2.2, quay video lên đến 4K@60fps / 8K@30fps\r\n* Pin & Kết nối\r\n- Pin 5.000 mAh, sạc nhanh 45 W có dây, sạc không dây 15 W, hỗ trợ sạc ngược Wireless PowerShare 4.5 W; không có Qi2 magnetic tích hợp nhưng hỗ trợ phụ kiện case tương thích \r\n- Kết nối gồm: 5G (sub‑6 + mmWave), Wi‑Fi 7, Bluetooth 5.4, UWB hỗ trợ, NFC, USB‑C 3.2, eSIM, cảm biến vân tay siêu âm dưới màn hình, Face unlock, IP68 chống nước bụi\r\n* Tính năng mềm & Galaxy AI\r\n- Hệ điều hành Android 15 / One UI 7.0, tích hợp Galaxy AI với nhiều công cụ như Generative edit (xóa vật thể, vẽ sketch to image), Now Bar/Now Brief, Audio Eraser, hỗ trợ Google Gemini cross‑app, mở file, YouTube, ảnh,... \r\n* Ưu điểm nổi bật\r\n- Màn hình lớn, sáng, chi tiết; thiết kế nhẹ hơn với viền mỏng hơn ~15% so với S24 Ultra (trọng lượng ~218 g) \r\n- Camera ultrawide 50 MP cải thiện chi tiết và macro rõ rệt; xử lý ảnh AI mạnh với độ chính xác cao \r\n- Hiệu năng dành cho chơi game, AI và đa nhiệm hàng đầu nhờ chip tùy chỉnh Snapdragon và quản lý nhiệt tốt hơn \r\n- Hỗ trợ cập nhật phần mềm đến 7 năm, cập nhật Android cho đến Android 22 (năm 2031)', 36810000.00, 30990000.00, 25, 'uploads/6883213129ca4-samsung galaxy s25 ultra.jpg', 'active', '2025-07-25 13:16:17', '2025-07-25 13:16:17'),
(12, 'iPhone 15 Pro Max 1TB', 'iphone-15-pro-max-1tb', 1, 1, '- Ra mắt vào ngày 22/9/2023, iPhone 15 Pro Max là mẫu flagship cao cấp nhất của Apple thời điểm đó, thay thế cho iPhone 14 Pro Max\r\n- Thiết kế với khung titan cấp độ hàng không (Grade‑5) nhẹ hơn 19 g so với thế hệ trước và mặt kính Ceramic Shield tăng cường độ bền', '* Hiển thị & thiết kế\r\n- Màn hình Super Retina XDR OLED 6,7‑inch, độ phân giải ~2796×1290 pixels (460 ppi), hỗ trợ Dynamic Island, Always‑On và công nghệ ProMotion adaptive refresh rate đến 120 Hz; độ sáng tối đa ngoài trời lên đến 2000 nits\r\n- Trọng lượng khoảng 221 g, kích thước 159,9×76,7×8,25 mm, sản phẩm có khả năng chống nước bụi chuẩn IP68 (6 mét trong 30 phút)\r\n* Cấu hình & Hiệu năng\r\n- Sử dụng chip Apple A17 Pro (3 nm) với CPU 6 lõi, GPU 6 lõi, Neural Engine 16 lõi – hiệu năng CPU tăng ~10%, Neural Engine gấp đôi so với trước, có hỗ trợ ray tracing cho game và ứng dụng đồ họa cao cấp\r\n- RAM 8 GB LPDDR5, bộ nhớ trong 256 GB / 512 GB / 1 TB NVMe; không hỗ trợ thẻ nhớ gắn ngoài\r\n*Camera & Video\r\n- Hệ thống camera sau gồm:\r\n+ 48 MP chính với ổn định cảm biến (sensor‑shift OIS) và Photonic Engine cải thiện khả năng chụp thiếu sáng,\r\n+ 12 MP siêu rộng (120°),\r\n+ 12 MP telephoto zoom quang 5× với thiết kế tetraprism và autofocus 3D sensor‑shift,\r\n+ Hỗ trợ ổn định quang học và LiDAR cho chế độ chân dung và ban đêm nâng cao\r\n* Kết nối & Tính năng bổ sung\r\n- Các kết nối hiện đại: 5G (mmWave & Sub‑6), Wi‑Fi 6E, Bluetooth 5.3, Ultra-wideband (UWB), NFC, eSIM, và GPS đa băng tần\r\n- Tính năng Action Button mới thay thế công tắc im lặng, có thể tùy chỉnh để kích hoạt Camera, Ghi chú, Flashlight hoặc Shortcuts nhanh trên Dynamic Island\r\n- Hệ điều hành iOS 17, hỗ trợ cập nhật đến iOS 22 (5 năm) cùng hệ sinh thái Apple Intelligence, bảo mật cao', 41190000.00, 38190000.00, 72, 'uploads/6883229d63e98-IP 15 pro max.jpg', 'active', '2025-07-25 13:22:21', '2025-07-25 13:22:21'),
(13, 'Xiaomi 15 Ultra 5G 16GB/1TB', 'xiaomi-15-ultra-5g-16gb-1tb', 3, 3, '* Ra mắt toàn cầu đầu tháng 3/2025, công bố trước sự kiện MWC Barcelona sau khi được giới thiệu tại Trung Quốc vào cuối tháng 2', '* Hiệu năng & Bộ nhớ\r\nChip Snapdragon 8 Elite (3 nm), RAM 16 GB LPDDR5X, bộ nhớ chạy UFS 4.1 (512 GB hoặc 1 TB\r\n- Hệ điều hành Android 15 với HyperOS 2, tối ưu hiệu năng và quản lý nhiệt thông minh thông qua công nghệ HyperCore\r\n* Camera Leica chuyên nghiệp\r\n- Hệ thống camera chính sau:\r\n+ 50 MP cảm biến 1\" (main wide) với OIS,\r\n+ 50 MP ultra-wide 14 mm (115°),\r\n+ 50 MP telephoto 3× (70 mm),\r\n+ 200 MP periscope telephoto (100 mm) với zoom quang 4.3× và hỗ trợ zoom kỹ thuật số rộng hơn\r\n- Camera trước 32 MP, hỗ trợ quay video 4K@60fps, gyro‑EIS\r\n- Tương thích với Photography Kit Legend Edition tạo cảm giác DSLR cổ điển với nút chụp vật lý, ống kính Leica Summilux và tiện ích gắn thêm extra grip (bán kèm) \r\n* Pin & Sạc\r\n- Pin 5.410 mAh (bản toàn cầu), bản Trung Quốc lên đến 6.000 mAh\r\n- Sạc nhanh 90 W có dây, sạc không dây 80 W, hỗ trợ reverse wireless 10 W; sạc đầy khoảng 56 phút\r\n* Ưu điểm nổi bật\r\n- Camera tuyệt đỉnh: cảm biến lớn, zoom 200 MP chuyên biệt, màu sắc và xử lý ảnh dạng máy ảnh thực thụ với độ chi tiết cao\r\n- Màn hình cực sáng và mượt, phù hợp dùng ngoài trời, nội dung HDR\r\n- Hiệu năng vượt trội, ổn định trong chơi game, đa nhiệm, AI tasks nhờ Snapdragon 8 Elite & HyperOS 2\r\n- Pin và sạc nhanh tốt, thời lượng kéo dài và sạc đầy nhanh chỉ trong vài chục phút', 38290000.00, 33590000.00, 24, 'uploads/6883257f0abf5-xiaomi 15 ultra.png', 'active', '2025-07-25 13:34:39', '2025-07-25 13:34:39'),
(14, 'Samsung Galaxy A35 5G 8GB/256GB', 'samsung-galaxy-a35-5g-8gb-256gb', 2, 2, '- Ra mắt ngày 11–15/3/2024, sử dụng hệ điều hành Android 14, One UI 6.1, với cam kết nhận 4 bản cập nhật Android và 5 năm bảo mật\r\n- Màn hình Super AMOLED 6.6″, độ phân giải FHD+ (2340×1080), tần số quét 120 Hz, độ sáng tối đa ~1000 nits, hiển thị mượt mà và sắc nét\r\n- Thiết kế sử dụng mặt kính Gorilla Glass Victus+ ở mặt trước, mặt sau bằng kính, khung bằng nhựa; đạt chuẩn IP67 (chống nước bụi trong 30 phút ở 1 m), trọng lượng ~209 g, dày ~8.2 mm', '* Hiệu năng & Bộ nhớ\r\n- Chip Exynos 1380 (5 nm), GPU Mali‑G68 MP5, RAM có các tùy chọn 6 GB hoặc 8 GB, bộ nhớ trong 128 GB hoặc 256 GB, hỗ trợ microSD mở rộng đến 1 TB\r\n- Đáng chú ý hỗ trợ Wi‑Fi 6, Bluetooth 5.3, NFC, eSIM; cảm biến vân tay quang học dưới màn hình; loa stereo và GNSS (GPS, GLONASS…) \r\n* Camera & Video\r\nCamera sau gồm:\r\n- 50 MP (góc rộng) với OIS,\r\n- 8 MP siêu rộng (123°),\r\n- 5 MP macro; hỗ trợ quay video lên đến 4K@30fps, gyro‑EIS và HDR\r\n* Pin & Sạc\r\n- Pin lớn 5.000 mAh, thời lượng sử dụng trung bình lên đến hơn 12 giờ liên tục; hỗ trợ sạc nhanh 25 W (không đi kèm củ sạc trong hộp)\r\n* Ưu điểm nổi bật\r\n- Màn hình AMOLED 120 Hz sắc nét, hiển thị nội dung mượt và sống động\r\n- Thiết kế bền vững, cảm giác cao cấp so với mức giá với kính Victus+ và kháng nước IP67\r\n- Chính sách cập nhật phần mềm dài hạn so với nhiều smartphone tầm trung khác\r\n- Camera chính 50 MP có OIS + video 4K; selfie ổn định trong điều kiện đủ sáng', 9130000.00, 7830000.00, 34, 'uploads/688326d9deeab-samsung A35 5G.jpg', 'active', '2025-07-25 13:40:25', '2025-07-25 13:40:25'),
(15, 'Samsung Galaxy Z Fold6 5G 12GB/256GB', 'samsung-galaxy-z-fold6-5g-12gb-256gb', 2, 2, '- Ra mắt tại sự kiện Galaxy Unpacked ngày 10/7/2024, có mặt từ cuối tháng 7 cùng với Galaxy Z Flip6 và các thiết bị Galaxy AI khác\r\n- Thiết kế sang trọng hơn, mỏng nhẹ hơn: trọng lượng chỉ 239 g, gọn gàng hơn so với Z Fold5 khoảng 14 g \r\n- Khung nhôm Armor mới, màn hình gập mảnh 5.6 mm khi mở, và chuẩn IP48 (chống nước 1.5 m)', '* Màn hình\r\n- Màn hình chính: 7.6″ Dynamic AMOLED 2X LTPO, độ phân giải 1856×2160 (374 ppi), tần số quét 1–120 Hz, độ sáng tối đa lên đến 2600 nits ➜ nhìn rõ điều kiện ngoài trời\r\n- Màn hình phụ (cover screen): 6.3″ Dynamic AMOLED 2X (410 ppi), tần số quét 1–120 Hz, độ sáng ~1600 nits, dễ dùng bằng 1 tay hơn so với đời trước nhờ tỷ lệ 22.1:9 rộng rãi\r\n* Hiệu năng & Bộ nhớ\r\n- Chip Snapdragon 8 Gen 3 for Galaxy (4 nm) — cải tiến so với Gen2, hiệu năng CPU tăng ~14%, GPU lên ~25%, NPU tăng ~41%\r\n- RAM 12 GB LPDDR5X + bộ nhớ 256 GB UFS 4.0 (có phiên bản 512 GB, 1 TB)\r\n- Hệ thống tản nhiệt buồng hơi lớn hơn 1.6 lần hỗ trợ hoạt động mát và ổn định khi chơi game hoặc multitasking nặng\r\n- One UI 6.1.1 trên nền Android 14 (có thể cập nhật lên Android 15 + One UI 7)\r\n* Camera\r\n- Cụm camera sau gồm:\r\n+ 50 MP (chính) với OIS và Dual Pixel AF,\r\n+ 10 MP telephoto zoom quang 3×,\r\n+ 12 MP ultra-wide 123\r\n-Camera selfie: 10 MP màn hình ngoài, 4 MP dưới màn hình chính (dùng cho video call, livestream – chất lượng trung bình)\r\n-Quay video lên đến 8K@30fps, hỗ trợ HDR10+, gyro‑EIS ổn định khung hình\r\n* Pin & Sạc\r\n- Pin 4500–4400 mAh, hỗ trợ sạc nhanh 25 W có dây, 15 W không dây, sạc ngược 4.5 W\r\n* Các tính năng đặc biệt & Galaxy AI\r\n- ích hợp Galaxy AI nổi bật với các công cụ như: Circle to Search, Sketch to Image, Photo Assist, Note Assist hỗ trợ sáng tạo hình ảnh, chuyển nét vẽ tay thành ảnh chuyên nghiệp, tổng hợp thông tin nhanh bằng AI… đặc biệt tích hợp tốt với S Pen \r\n- Giao diện Flex Mode, Multi‑Window, hỗ trợ Samsung DeX, chế độ sử dụng bút S Pen tiện lợi trên màn hình gập', 43190000.00, 34390000.00, 21, 'uploads/6883285410b3d-Samsung Galaxy Z Fold6.jpg', 'active', '2025-07-25 13:46:44', '2025-07-25 13:46:44'),
(16, 'Samsung Galaxy Z Flip7 5G', 'samsung-galaxy-z-flip7-5g', 2, 2, '- Giới thiệu chính thức: Samsung Unpacked ngày 9/7/2025, bán ra từ 25/7/2025 (có thể sớm hơn tùy thị trường)\r\n- Giá khởi điểm tại Mỹ và Anh là $1.099 / £1.049 cho bản 12 GB / 256 GB và $1.219 / £1.149 cho bản 512 GB', '* Thiết kế & Màn hình\r\n- Màn hình chính 6.9″ Dynamic AMOLED 2X (FHD+, 2520×1080) với tần số quét linh hoạt 1–120 Hz và độ sáng tối đa đến 2600 nits, đảm bảo hiển thị sắc nét và mượt mà ngay ngoài trời\r\n- Vật liệu cao cấp gồm khung Armor Aluminum, bản lề FlexHinge mới, và kính Gorilla Glass Victus 2, đạt chuẩn IPX8 kháng nước bụi (1.5 m trong 30 phút) \r\n- Máy rất mỏng nhẹ: 6.5 mm khi mở, 13.7 mm khi gập, nặng 188 g – là phiên bản Z Flip nhẹ nhất từ trước đến nay \r\n- Màn hình phụ (FlexWindow) mới cải tiến, tràn viền 4.1″ Super AMOLED, 120 Hz, hỗ trợ widget, selfie, AI nhanh mà không cần mở máy \r\n* Cấu hình & Hiệu năng\r\n- Vi xử lý Exynos 2500 3 nm (chip Samsung tùy chỉnh mới nhất), RAM 12 GB, bộ nhớ 256 GB hoặc 512 GB, chuẩn UFS 4.0 nhưng không hỗ trợ thẻ nhớ mở rộng\r\n- Hệ điều hành Android 16 với giao diện One UI 8, hỗ trợ cập nhật tới 7 năm phần mềm và bảo mật tương tự flagship dòng S và Z cao cấp\r\n* Camera\r\n- Cụm camera sau gồm: 50 MP (góc rộng, OIS, Dual Pixel AF) và 12 MP siêu rộng (123°) — hỗ trợ quay video 4K@60fps, HDR10+, chế độ ProVisual Engine AI xử lý ảnh nâng cao\r\n- Camera selfie trước 10 MP, dùng cho livestream và chụp Selfie, hỗ trợ HDR và quay 4K@30/60fps\r\n* Pin & Sạc\r\n- Pin 4.300 mAh (điển hình) — cải thiện hơn so với Flip6, dùng liên tục được đến 31 giờ xem video\r\n- Hỗ trợ sạc nhanh có dây 25 W (50% trong 30 phút), sạc không dây 15 W, và sạc ngược 4.5 W\r\n* Tính năng Galaxy AI & FlexWindow\r\n- Màn hình ngoài hỗ trợ Google AI Pro, Now Bar / Now Brief, Circle to Search, dịch tức thì và điều khiển AI tiện lợi mà không cần mở máy\r\n- Tích hợp tính năng Samsung DeX, xử lý sáng tạo ảnh/video bằng Galaxy AI, hỗ trợ đa task và trải nghiệm như máy tính nhỏ gọn', 28990000.00, NULL, 100, 'uploads/6883297d2743c-Samsung Galaxy Z Flip7 5G.jpg', 'active', '2025-07-25 13:51:41', '2025-07-25 13:51:41'),
(17, 'iPhone 16 Pro 128GB', 'iphone-16-pro-128gb', 1, 1, '- Apple ra mắt iPhone 16 Pro vào ngày 9/9/2024, bán từ 20/9/2024\r\n-Tại Việt Nam, giá mới đầy đủ màu khoảng 22.9 đến 23.6 triệu ₫ (đã bao gồm VAT, chưa tính ưu đãi)\r\n- Bản 128GB tại Mỹ khởi điểm khoảng $999 (khoảng 1.218 € tại châu Âu)', '* Thiết kế & Màn hình\r\n- Mặt lưng titan siêu bền, khung titan nhẹ hơn nhôm truyền thống, đạt chuẩn IP68 (chống nước sâu đến 6 m trong 30 phút)\r\n- Màn hình Super Retina XDR OLED 6.3″, độ phân giải 2622 × 1206, mật độ ~458 ppi, tần số quét 120 Hz, độ sáng lên đến 2.000 nits, hỗ trợ Always‑On, HDR10+, True Tone, Dynamic Island và phủ chống vân tay Oleophobic\r\n* Hiệu năng & Bộ nhớ\r\n- Chip Apple A18 Pro (3 nm), CPU 6 lõi (2 hiệu năng + 4 tiết kiệm), GPU 6 lõi, và Neural Engine 16 lõi, tăng đến +20% năng lực xử lý so với A17 \r\nthaianhmobile.com\r\n- RAM 8 GB LPDDR5X, bộ nhớ trong 128 GB NVMe, không hỗ trợ thẻ nhớ mở rộng\r\n* Camera & Video\r\n-48 MP chính (Fusion camera) khẩu f/1.78, OIS cảm biến dịch chuyển thế hệ 2;\r\n- Ultra-wide 48 MP (120° góc rộng);\r\n- Telephoto 12 MP với zoom quang 5× và tele 2×, phụ hỗ trợ lấy nét 3D LiDAR;\r\n- Ghi hình video 4K@120fps Dolby Vision; nhiều tính năng như Photonic Engine, Deep Fusion, Smart HDR 5, chụp macro 48MP, ProRAW, panorama đến 63MP, Portrait Lighting...\r\n-Camera trước 12 MP, tự động lấy nét, quay video 4K@60fps \r\n* Pin & Sạc\r\n- Pin ~3.577 mAh, thời lượng sử dụng ổn định (xem video ~27 giờ)\r\n- Hỗ trợ USB‑C 3.2 Gen 2 tốc độ cao, sạc có dây lên đến ~40 W, sạc không dây MagSafe 25 W, Qi2 lẫn Qi tiêu chuẩn thấp hơn (7.5 W)\r\n* Tính năng & Galaxy AI tương đương\r\n- Tích hợp Apple Intelligence hỗ trợ viết văn bản, tóm tắt cuộc họp, khai thác tính năng Camera Control chuyên dụng để truy cập nhanh chức năng camera nâng cao\r\n- Có Action Button tùy chỉnh, hỗ trợ Siri, ghi chú, camera hoặc shortcuts nhanh tiện lợi', 28390000.00, 25090000.00, 84, 'uploads/68832a9b2a4e8-iPhone 16 Pro 128GB.jpg', 'active', '2025-07-25 13:56:27', '2025-07-25 13:56:27'),
(18, 'iPhone 15 Plus 128GB', 'iphone-15-plus-128gb', 1, 1, '- Ra mắt ngày 12/9/2023, bán ra từ ngày 22/9/2023 với giá khởi điểm 899 USD cho bản 128GB\r\n- Màu sắc đa dạng pastel cực thời trang: Đen, Xanh dương, Xanh lá, Vàng và Hồng', '* Màn hình\r\n- Kích thước 6.7 inch, tấm nền Super Retina XDR OLED.\r\n- Độ phân giải 2796 x 1290 pixels, HDR10, Dolby Vision.\r\n- Độ sáng tối đa lên đến 2000 nits (ngoài trời).\r\n✳ Hiệu năng\r\n- Chip Apple A16 Bionic 6 nhân mạnh mẽ, tiết kiệm pin.\r\n- RAM 6GB, bộ nhớ trong 128GB.\r\n- iOS 17 mượt mà, hỗ trợ cập nhật lâu dài.\r\n✳ Camera\r\n- Cụm camera kép: 48MP (chính) + 12MP (siêu rộng).\r\n- Camera selfie 12MP hỗ trợ quay 4K, chụp ban đêm tốt.\r\n- Tính năng chụp chân dung, Smart HDR 5, Photonic Engine.\r\n✳ Pin & Sạc\r\n- Dung lượng pin khoảng 4383mAh (theo thực nghiệm).\r\n- Hỗ trợ sạc nhanh 20W, sạc không dây MagSafe 15W.\r\n✳ Kết nối & Tính năng\r\n- Hỗ trợ 5G, WiFi 6, Bluetooth 5.3.\r\n- Có Dynamic Island hiển thị thông báo thông minh.\r\n- Chống nước IP68, eSIM + nano SIM.', 22490000.00, 19090000.00, 15, 'uploads/68832b8d0fed9-Điện thoại iPhone 15 Plus 128GB.jpg', 'active', '2025-07-25 14:00:29', '2025-07-25 14:00:29'),
(19, 'iPhone 16e 128GB', 'iphone-16e-128gb', 1, 1, '- Thiết kế bằng nhôm hàng không với mặt kính Ceramic Shield cho độ bền cao, chống nước IP68\r\n- Màn hình Super Retina XDR OLED 6.1″, viền mỏng, không có Dynamic Island, tần số 60 Hz, độ sáng cao', '✳ Hiệu năng & Bộ nhớ\r\n• Chip Apple A18 – vi xử lý mới nhất từ Apple với hiệu năng vượt trội và tiết kiệm năng lượng\r\n• RAM khoảng 8 GB và bộ nhớ 128 GB, không hỗ trợ thẻ nhớ\r\n✳ Camera\r\n• Camera chính 48 MP hỗ trợ zoom quang học 2×, quay video 4K chất lượng cao\r\n• Camera trước TrueDepth 12 MP hỗ trợ Face ID và chụp ảnh selfie sắc nét\r\n✳ Pin & Sạc\r\n• Thời lượng pin cao: xem video liên tục đến 26 giờ\r\n• Sạc nhanh qua cổng USB-C, hỗ trợ sạc không dây tiêu chuẩn Qi\r\n✳ Phần mềm & Tính năng AI\r\n• Hỗ trợ Apple Intelligence: tóm tắt cuộc họp, tạo hình ảnh bằng AI, Genmoji…\r\n• Có nút Action Button tùy chỉnh để gọi nhanh các tính năng như camera hoặc tìm kiếm hình ảnh\r\n✳ Kết nối & Tính năng khác\r\n• Hỗ trợ 5G, Wi Fi, Bluetooth, SOS khẩn cấp qua vệ tinh, Face ID, eSIM\r\n• Thiết kế thân thiện môi trường, sử dụng vật liệu tái chế\r\n✳ Giá & Thời điểm ra mắt\r\n• Công bố ngày 19/2/2025, mở bán chính thức từ 28/2/2025\r\n• Giá khởi điểm từ 599 USD cho bản 128 GB', 16690000.00, 16290000.00, 32, 'uploads/68832c7e96c0c-iPhone 16e 128GB.jpg', 'active', '2025-07-25 14:04:30', '2025-07-25 14:04:30'),
(20, 'iPhone 16 Pro Max 256GB', 'iphone-16-pro-max-256gb', 1, 1, '* Thiết kế & Màn hình\r\n- Khung bằng titanium và mặt trước Ceramic Shield, mặt sau kính mờ, giúp vừa bền vừa sang trọng.\r\n- Màn hình Super Retina XDR OLED lớn 6.9″, độ phân giải 2868 × 1320 px (460 ppi), hỗ trợ Dynamic Island, Always‑On, tần số quét 1–120 Hz, độ tương phản cao, độ sáng tối đa 2.000 nits.', '✳ Hiệu năng & Bộ nhớ\r\n• Trang bị chip A18 Pro (6 core CPU, 6 core GPU, 16 core Neural Engine) – hiệu năng vượt trội và tiết kiệm điện.\r\n• RAM 8 GB LPDDR5X, bộ nhớ trong 256 GB NVMe.\r\n________________________________________\r\n✳ Camera\r\n• Hệ thống camera sau gồm:\r\n • 48 MP (camera chính)\r\n • 48 MP (ultra wide 120°)\r\n • 12 MP telephoto 5× (tetraprism)\r\n • Zoom quang lên đến 5×, zoom kỹ thuật số tối đa 25×\r\n• Hỗ trợ các tính năng nâng cao: Photonic Engine, Deep Fusion, Smart HDR 5, Apple ProRAW, Panorama 63 MP, Macro 48 MP, Lidar.\r\n• Có nút Camera Control cho phép điều khiển nhanh camera và chuyển ống kính dễ dàng.\r\n________________________________________\r\n✳ Pin & Sạc\r\n• Dung lượng pin 4.685 mAh – thời gian xem video lên tới 33 giờ.\r\n• Hỗ trợ sạc nhanh có dây 27W, MagSafe 25W, sạc không dây chuẩn Qi2.\r\n________________________________________\r\n✳ Apple Intelligence & Phần mềm\r\n• Tích hợp Apple Intelligence trên iOS 18 – có khả năng tóm tắt nội dung, tạo emoji bằng AI, tìm kiếm thông minh, chỉnh sửa ảnh AI, ghi chú tự động...\r\n________________________________________\r\n✳ Kết nối & Tính năng khác\r\n• Hỗ trợ 5G, Wi Fi 7, Bluetooth 5.3, NFC, Face ID, dual eSIM.\r\n• Trang bị cổng USB C 3.2, chuẩn kháng nước IP68, hỗ trợ T Satellite SOS.\r\n________________________________________\r\n✳ Kích thước & Trọng lượng\r\n• Kích thước: 163 × 77.6 × 8.25 mm\r\n• Trọng lượng: 227 g\r\n________________________________________\r\n✳ Giá & Ngày ra mắt\r\n• Chính thức ra mắt và mở bán toàn cầu vào tháng 9/2024.\r\n• Giá khởi điểm bản 256GB: khoảng 1.199 USD.\r\n________________________________________\r\n✳ Đánh giá người dùng\r\n• Hiệu năng mượt, nhiệt độ máy ổn định, khả năng xử lý tốt mọi tác vụ.\r\n• Pin rất tốt, có thể dùng 1.5–2 ngày ở cường độ thông thường.\r\n• Một số người dùng phản ánh lỗi phần mềm nhỏ, như camera không phản hồi tức thời khi bấm nút hoặc hiển thị bị giật nhẹ.', 34390000.00, 30090000.00, 10, 'uploads/68832d872ac48-iPhone 16 Pro Max 256GB.jpg', 'active', '2025-07-25 14:08:55', '2025-07-25 14:08:55'),
(21, 'Xiaomi Redmi Note 14 Pro 8GB/256GB', 'xiaomi-redmi-note-14-pro-8gb-256gb', 3, 3, '✳ Thiết kế & Màn hình\r\n• Màn hình cong đẹp mắt kích thước 6.67″ AMOLED, độ phân giải 2712×1220, tần số quét 120Hz, hỗ trợ HDR10+ và Dolby Vision, độ sáng tối đa 3000 nits.\r\n• Màn hình bảo vệ bằng kính Gorilla Glass Victus 2, viền cong mỏng, hạn chế chạm nhầm.\r\n• Thiết kế khung nhựa hoặc da sinh thái, chuẩn kháng nước bụi IP68, trọng lượng khoảng 190g, mỏng 8.2mm.', '✳ Thiết kế & Màn hình\r\n•	Màn hình cong đẹp mắt kích thước 6.67″ AMOLED, độ phân giải 2712×1220, tần số quét 120Hz, hỗ trợ HDR10+ và Dolby Vision, độ sáng tối đa 3000 nits.\r\n•	Màn hình bảo vệ bằng kính Gorilla Glass Victus 2, viền cong mỏng, hạn chế chạm nhầm.\r\n•	Thiết kế khung nhựa hoặc da sinh thái, chuẩn kháng nước bụi IP68, trọng lượng khoảng 190g, mỏng 8.2mm.\r\n✳ Hiệu năng & Bộ nhớ\r\n•	Trang bị chip MediaTek Dimensity 7300 Ultra (4nm), 8 nhân gồm 4× Cortex-A78 và 4× Cortex-A55, GPU Mali-G615.\r\n•	RAM 8GB LPDDR4X, bộ nhớ trong 256GB UFS 2.2, không hỗ trợ thẻ nhớ mở rộng.\r\n•	Cài sẵn Android 14 với giao diện HyperOS.\r\n________________________________________\r\n✳ Camera\r\n•	Camera chính 200MP hỗ trợ chống rung quang học OIS, cảm biến lớn 1/1.4\".\r\n•	Camera góc siêu rộng 8MP và camera macro 2MP.\r\n•	Camera trước 20MP, quay video Full HD, hỗ trợ HDR và panorama.\r\n•	Quay video sau đạt 4K@30fps, có chống rung điện tử EIS và chống rung quang học.\r\n________________________________________\r\n✳ Pin & Sạc\r\n•	Dung lượng pin 5110mAh, thời lượng sử dụng từ 1.5–2 ngày.\r\n•	Hỗ trợ sạc nhanh 45W, đầy pin trong khoảng 45 phút.\r\n•	Củ sạc đi kèm trong hộp.\r\n________________________________________\r\n✳ Tính năng AI & Giải trí\r\n•	Tích hợp AI Erase Pro, AI Sky, AI chân dung, quay video cùng lúc 2 camera.\r\n•	Hệ thống loa kép stereo, chất lượng âm thanh lớn và rõ.\r\n________________________________________\r\n✳ Kết nối & Tính năng khác\r\n•	Hỗ trợ 5G, Wi Fi 6, Bluetooth 5.4, NFC, cổng hồng ngoại, cảm biến vân tay trong màn hình.\r\n•	Hỗ trợ eSIM (tùy thị trường).\r\n•	Giao diện HyperOS cập nhật ổn định.\r\n________________________________________\r\n✳ Giá & Ngày ra mắt\r\n•	Ra mắt tháng 9/2024.\r\n•	Giá khoảng 5.6 triệu đồng (Trung Quốc) hoặc 6.3–6.9 triệu đồng (Việt Nam).', 7850000.00, 7650000.00, 23, 'uploads/68832e2a2acb2-Xiaomi Redmi Note 14 Pro.jpg', 'active', '2025-07-25 14:11:38', '2025-07-25 14:11:38'),
(22, 'Xiaomi Redmi 13x 6GB/128GB', 'xiaomi-redmi-13x-6gb-128gb', 3, 3, '', '✳ Thiết kế & Màn hình\r\n\r\nMàn hình 6.79 inch FHD+, độ phân giải 2460×1080, tần số quét 90Hz\r\n\r\nĐộ sáng cao, hỗ trợ bảo vệ mắt, viền mỏng, thiết kế trẻ trung\r\n\r\nKích thước: 168.6 × 76.3 × 8.3 mm, nặng khoảng 198g\r\n\r\n✳ Hiệu năng & Bộ nhớ\r\n\r\nChip MediaTek Helio G91 Ultra, hiệu suất ổn định cho tác vụ hằng ngày\r\n\r\nRAM 6GB, bộ nhớ trong 128GB, hỗ trợ thẻ nhớ microSD đến 1TB\r\n\r\n✳ Camera\r\n\r\nCamera chính 108MP, hỗ trợ zoom kỹ thuật số 3× không mất chi tiết\r\n\r\nCamera phụ macro 2MP\r\n\r\nCamera trước 13MP, có chế độ làm đẹp, chụp selfie tốt\r\n\r\n✳ Pin & Sạc\r\n\r\nPin dung lượng 5030mAh, dùng cả ngày thoải mái\r\n\r\nSạc nhanh 33W, sạc 50% trong khoảng 26 phút\r\n\r\n✳ Hệ điều hành & Phần mềm\r\n\r\nChạy Android 14 với giao diện HyperOS mới\r\n\r\nGiao diện nhẹ, nhiều tùy chọn tối ưu, dễ sử dụng\r\n\r\n✳ Kết nối & Tính năng\r\n\r\nHỗ trợ 5G, Bluetooth 5.4, Wi-Fi băng tần kép, GPS, NFC\r\n\r\nCổng tai nghe 3.5mm, cổng hồng ngoại, mở khóa vân tay cạnh bên\r\n\r\n✳ Giá bán & Ra mắt\r\n\r\nGiá khoảng 4.69 triệu đồng (bản 6GB/128GB)\r\n\r\nRa mắt cuối tháng 3 năm 2025 tại Việt Nam', 4220000.00, 3620000.00, 58, 'uploads/68832f1157456-xiaomi-redmi-13x-titanium-thumbn-600x600.jpg', 'active', '2025-07-25 14:15:29', '2025-07-25 14:15:29'),
(23, 'Xiaomi 15 5G 12GB/512GB', 'xiaomi-15-5g-12gb-512gb', 3, 3, '', '✳ Thiết kế & Màn hình\r\n•	Màn hình 6.36″ LTPO OLED độ phân giải 1200 × 2670 (~460 ppi), tỉ lệ 20:9, tần số quét 120 Hz, độ sáng đỉnh lên đến ~3200 nits\r\n•	Vỏ ngoài bằng khung hợp kim nhôm hàng không và kính cường lực cao cấp, chuẩn kháng nước IP68, thân máy nhẹ khoảng 189–192 g và mỏng tương đương ~8.1 mm\r\n________________________________________\r\n✳ Hiệu năng & Bộ nhớ\r\n•	Chip Snapdragon 8 Elite (3 nm) kết hợp GPU Adreno 830 cho hiệu suất xử lý cực cao, ít nóng khi sử dụng thường dùng\r\n•	RAM 12 GB LPDDR5X + bộ nhớ UFS 4.0 512 GB, không hỗ trợ thẻ nhớ ngoài\r\n________________________________________\r\n✳ Camera\r\n•	Cụm camera sau 3 ống kính 50 MP: camera chính f/1.6 (1/1.31″) + tele 3× f/2.0 + ultrawide 115° f/2.2\r\n•	Camera trước 32 MP f/2.0, quay video chất lượng cao\r\n•	Hỗ trợ quay video lên đến 8K HDR, 4K Dolby Vision, slow motion, và chống rung điện tử EIS\r\n________________________________________\r\n✳ Pin & Sạc\r\n•	Pin dung lượng 5240 mAh (bản global), hỗ trợ sạc nhanh có dây 90 W, sạc nhanh không dây 50 W, sạc ngược 10 W\r\n•	Cần dùng củ sạc 90 W riêng để đạt tốc độ tối đa, sạc từ 0 → 100% dưới 50 phút\r\n________________________________________\r\n✳ Hệ điều hành & Tính năng AI\r\n•	Chạy Android 15 với giao diện HyperOS 2 tối ưu hiệu năng và tiết kiệm điện\r\n•	Được Xiaomi cam kết cập nhật 4 bản Android lớn và 6 năm bảo mật\r\n•	Tích hợp các tính năng AI như xử lý ảnh tự động, tạo hình ảnh bằng AI, điều chỉnh hệ thống thông minh\r\n________________________________________\r\n✳ Kết nối & Âm thanh\r\n•	Hỗ trợ đầy đủ 5G, Wi Fi 7, Bluetooth 5.4, NFC, cổng hồng ngoại, USB-C 3.2, loa stereo chất lượng cao\r\n•	Cảm biến vân tay siêu âm dưới màn hình, eSIM, hài hòa thiết kế và tốc độ kết nối mạnh mẽ\r\n________________________________________\r\n✳ Kích thước & Trọng lượng\r\n•	Kích thước tổng thể máy khoảng 152.3 × 71.2 × 8.1 mm; trọng lượng 189–192 g\r\n________________________________________\r\n✳ Giá & Ngày ra mắt\r\n•	Ra mắt toàn cầu vào đầu tháng 3/2025, đặt bán tại MWC Barcelona\r\n•	Giá khởi điểm quốc tế khoảng 999 USD / 1 000 € cho bản 12 GB/256 GB; bản 12 GB/512 GB có giá cao hơn, bản ultra lên tới 1 499 € tùy thị trường', 26500000.00, 24000000.00, 42, 'uploads/6883300ecf740-Xiaomi 15 5G .jpg', 'active', '2025-07-25 14:19:42', '2025-07-25 14:19:42'),
(24, 'Điện thoại Xiaomi Redmi 14C 6GB/128GB', 'i-n-tho-i-xiaomi-redmi-14c-6gb-128gb', 3, 3, '', '✳ Thiết kế & Màn hình\r\n•	Màn hình 6.88″ IPS LCD, độ phân giải 720 × 1.640 (HD+), tần số quét 120 Hz, độ sáng cao (~600 nits), hỗ trợ giảm ánh sáng xanh & giảm nhấp nháy.\r\n•	Thiết kế mỏng khoảng 8.22 mm, trọng lượng ~204 g, mặt lưng nhựa giả kính mờ, cụm camera tròn hiện đại.\r\n________________________________________\r\n✳ Hiệu năng & Bộ nhớ\r\n•	Chip MediaTek Helio G81 Ultra (2× Cortex-A75 2.0 GHz + 6× Cortex-A55 1.8 GHz), GPU Mali G52 MC2 – đủ dùng các tác vụ cơ bản.\r\n•	RAM 6 GB LPDDR4X + bộ nhớ trong 128 GB eMMC 5.1, hỗ trợ mở rộng bằng thẻ microSD đến 1 TB.\r\n________________________________________\r\n✳ Camera\r\n•	Camera sau chính 50 MP + sensor phụ 0.08 MP (depth), hỗ trợ AI Basic.\r\n•	Camera trước 13 MP dùng cho selfie và video call.\r\n•	Hỗ trợ quay video Full HD, không có chống rung quang học.\r\n________________________________________\r\n✳ Pin & Sạc\r\n•	Pin dung lượng 5.160 mAh, cho thời gian xem video khoảng 22 giờ, sử dụng thông thường khoảng 1.5 ngày.\r\n•	Hỗ trợ sạc nhanh có dây 18 W qua cổng USB-C.\r\n________________________________________\r\n✳ Hệ điều hành & Phần mềm\r\n•	Cài sẵn Android 14 với giao diện HyperOS nhẹ và dễ sử dụng.\r\n•	Có hỗ trợ mở rộng RAM ảo (Virtual RAM) đến thêm 2–4 GB tùy thị trường.\r\n________________________________________\r\n✳ Kết nối & Tính năng\r\n•	Hỗ trợ LTE (4G), Wi Fi ac (2.4 GHz + 5 GHz), Bluetooth 5.4, NFC (tuỳ thị trường), USB C.\r\n•	Cảm biến vân tay ở cạnh bên, jack tai nghe 3.5 mm, đài FM, không hỗ trợ IR hoặc xoay cảm biến gyroscope.', 3630000.00, 3230000.00, 65, 'uploads/6883307cd4ddc-download.jpg', 'active', '2025-07-25 14:21:32', '2025-07-25 14:21:32');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_variations`
--

CREATE TABLE `product_variations` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` mediumtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` mediumtext DEFAULT NULL,
  `role` enum('admin','customer') DEFAULT 'customer',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `full_name`, `phone_number`, `address`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admin_user', '$2y$10$wTf2tQxWf.q2H4D0F8L.UOu.V/xZ6d5hJ7B8I9K0L1M2N3O4P5Q6R7S8T9U0V1W2X3Y4Z5', 'admin@example.com', 'Admin Website', '0901234567', '123 Đường ABC, Quận 1, TP.HCM', 'admin', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(2, 'nguyenvanhieu', '$2y$10$wTf2tQxWf.q2H4D0F8L.UOu.V/xZ6d5hJ7B8I9K0L1M2N3O4P5Q6R7S8T9U0V1W2X3Y4Z5', 'hieu.nv@example.com', 'Nguyễn Văn Hiếu', '0912345678', '456 Đường XYZ, Quận 3, TP.HCM', 'customer', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(3, 'phamthihuong', '$2y$10$wTf2tQxWf.q2H4D0F8L.UOu.V/xZ6d5hJ7B8I9K0L1M2N3O4P5Q6R7S8T9U0V1W2X3Y4Z5', 'huong.pt@example.com', 'Phạm Thị Hương', '0987654321', '789 Lê Lợi, Quận 5, TP.HCM', 'customer', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(4, 'admin', '$2y$10$sjO04dzkJIDhd83txf.zDOavKSAJMNh6WDSdhTxowAKMeg1JjlYiW', '123@gmail.com', 'admin', '123456', '123a', 'admin', '2025-07-08 02:16:41', '2025-07-08 02:18:35'),
(5, 'duykhang', '$2y$10$zFJpMrB.dxpTA8nkSySkCeT3b/ripTLB3Nt3hmN.U6PF..ChCvkZa', 'nguyenduykhangtvh12@gmail.com', 'Khang Nguyễn', '0398970269', 'Nguyễn Thiện Thành', 'admin', '2025-07-22 16:58:05', '2025-07-25 12:56:55'),
(8, 'alo', '$2y$10$1JUdOs1rJ/7sBlwVf5nKveqss8JAlv.mjZ./ARWDFhy.TZyahS1ge', '12345@gmail.com', 'Khang', NULL, NULL, 'customer', '2025-07-25 14:25:54', '2025-07-25 14:25:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `variation_attribute_values`
--

CREATE TABLE `variation_attribute_values` (
  `variation_id` int(11) NOT NULL,
  `attribute_value_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Chỉ mục cho bảng `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attribute_id` (`attribute_id`);

--
-- Chỉ mục cho bảng `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `product_variations`
--
ALTER TABLE `product_variations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `variation_attribute_values`
--
ALTER TABLE `variation_attribute_values`
  ADD PRIMARY KEY (`variation_id`,`attribute_value_id`),
  ADD KEY `attribute_value_id` (`attribute_value_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `attribute_values`
--
ALTER TABLE `attribute_values`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_variations`
--
ALTER TABLE `product_variations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `attribute_values`
--
ALTER TABLE `attribute_values`
  ADD CONSTRAINT `attribute_values_ibfk_1` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `product_variations`
--
ALTER TABLE `product_variations`
  ADD CONSTRAINT `product_variations_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `variation_attribute_values`
--
ALTER TABLE `variation_attribute_values`
  ADD CONSTRAINT `variation_attribute_values_ibfk_1` FOREIGN KEY (`variation_id`) REFERENCES `product_variations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `variation_attribute_values_ibfk_2` FOREIGN KEY (`attribute_value_id`) REFERENCES `attribute_values` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
