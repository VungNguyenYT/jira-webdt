-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th7 25, 2025 lúc 07:42 AM
-- Phiên bản máy phục vụ: 10.4.27-MariaDB
-- Phiên bản PHP: 7.4.33

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
(1, NULL, 'Nguyễn Văn Vửng', NULL, '0347482012', 'Trà Vinh', '30990000.00', 'shipped', 'cod', 'pending', '2025-07-22 19:56:34', '2025-07-25 12:00:53');

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
(1, 1, 1, 1, '30990000.00');

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
(1, 'iPhone 15 Pro Max', 'iphone-15-pro-max', 1, 1, 'Mẫu iPhone cao cấp nhất với chip A17 Bionic và camera đỉnh cao.', 'Chi tiết về iPhone 15 Pro Max, camera, hiệu năng, pin...', '32990000.00', '30990000.00', 50, 'https://example.com/iphone15promax.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(2, 'Samsung Galaxy S24 Ultra', 'samsung-galaxy-s24-ultra', 2, 2, 'Siêu phẩm Android với S Pen tích hợp và khả năng AI vượt trội.', 'Chi tiết về Samsung Galaxy S24 Ultra, tính năng AI, màn hình...', '28990000.00', '27500000.00', 45, 'https://example.com/galaxys24ultra.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(3, 'Xiaomi 14 Ultra', 'xiaomi-14-ultra', 3, 3, 'Điện thoại cao cấp của Xiaomi với camera Leica và hiệu năng mạnh mẽ.', 'Chi tiết về Xiaomi 14 Ultra, công nghệ camera, sạc nhanh...', '22990000.00', NULL, 30, 'https://example.com/xiaomi14ultra.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(4, 'iPhone 14', 'iphone-14', 1, 1, 'Mẫu iPhone tiêu chuẩn với hiệu năng ổn định và camera cải tiến.', 'Chi tiết về iPhone 14, màu sắc, hiệu năng, camera...', '17990000.00', '16500000.00', 70, 'https://example.com/iphone14.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(5, 'Samsung Galaxy A55', 'samsung-galaxy-a55', 2, 2, 'Điện thoại tầm trung của Samsung với thiết kế đẹp và pin trâu.', 'Chi tiết về Galaxy A55, màn hình, camera, thời lượng pin...', '9990000.00', '9200000.00', 80, 'https://example.com/galaxya55.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(6, 'Xiaomi Redmi Note 13 Pro', 'xiaomi-redmi-note-13-pro', 3, 3, 'Điện thoại tầm trung đáng giá của Xiaomi với màn hình AMOLED.', 'Chi tiết về Redmi Note 13 Pro, hiệu năng, màn hình, sạc nhanh...', '6990000.00', '6500000.00', 90, 'https://example.com/redminote13pro.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(7, 'iPhone SE 2022', 'iphone-se-2022', 1, 1, 'iPhone nhỏ gọn với chip A15 Bionic mạnh mẽ.', 'Chi tiết về iPhone SE 2022, kích thước, hiệu năng, giá cả...', '10990000.00', NULL, 60, 'https://example.com/iphonese2022.jpg', 'active', '2025-07-08 00:55:03', '2025-07-08 00:55:03'),
(8, 'Realme 3 Pro', 'realme-3-pro', 3, 3, 'test', 'test', '99999999.99', '99999999.99', 3, 'uploads/686c1eaae6daf-Apple-iPhone-15-Pro-lineup-hero-230912.jpg.news_app_ed.jpg', 'active', '2025-07-08 02:23:22', '2025-07-08 02:23:22'),
(9, 'Điện thoại Samsung Galaxy A26 5G 6GB/128G', 'i-n-tho-i-samsung-galaxy-a26-5g-6gb-128g', 2, 2, '', 'Cấu hình & Bộ nhớ\r\nHệ điều hành: Android 15\r\nChip xử lý (CPU): Exynos 1380 8 nhân\r\nTốc độ CPU: 4 nhân 2.4 GHz & 4 nhân 2 GHz\r\nChip đồ họa (GPU): Mali-G68\r\nRAM: 6 GB\r\nDung lượng lưu trữ: 128 GB\r\nDung lượng còn lại (khả dụng) khoảng: 106.5 GB\r\nThẻ nhớ: MicroSD, hỗ trợ tối đa 2 TB\r\nDanh bạ: Không giới hạn', '6470000.00', '5670000.00', 99, 'uploads/6883179b959ea-samsung-galaxy-a26-6gb-128gb638827524374111984.jpg', 'active', '2025-07-25 12:35:23', '2025-07-25 12:35:23');

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
(5, 'VungNguyenYT', '$2y$10$v2MsIFf.9vBxOWZ6IOIhy.lxSVxgSz/n8FVg94sNkT3YQ79ubRrFG', 'nguyenvanvung252@gmail.com', 'Nguyễn Văn Vửng', '0347482012', 'Ấp Phú lân, Song Lộc, Châu Thành, Trà Vinh', 'admin', '2025-07-22 14:44:43', '2025-07-22 14:45:37');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
