<?php
require_once 'includes/db.php';     // Nhúng file kết nối CSDL và khởi tạo session (session_start() có trong db.php)
require_once 'includes/header.php'; // Nhúng header của trang

$product = null; // Khởi tạo biến $product là null

// Kiểm tra xem có tham số 'slug' được truyền qua URL (GET request) không
if (isset($_GET['slug'])) {
    $product_slug = $_GET['slug']; // Lấy giá trị slug từ URL

    // Chuẩn bị câu lệnh SQL để lấy thông tin chi tiết sản phẩm dựa trên slug
    // Sử dụng JOIN để lấy tên danh mục và tên thương hiệu từ các bảng liên quan
    $stmt = $conn->prepare("SELECT p.*, c.name as category_name, b.name as brand_name
                            FROM products p
                            LEFT JOIN categories c ON p.category_id = c.id
                            LEFT JOIN brands b ON p.brand_id = b.id
                            WHERE p.slug = ? AND p.status = 'active'"); // Lấy sản phẩm đang hoạt động
    $stmt->bind_param("s", $product_slug); // 's' nghĩa là tham số là kiểu string
    $stmt->execute();                       // Thực thi câu lệnh
    $result = $stmt->get_result();          // Lấy kết quả trả về

    // Kiểm tra xem có tìm thấy sản phẩm nào không
    if ($result->num_rows > 0) {
        $product = $result->fetch_assoc(); // Lấy dữ liệu sản phẩm dưới dạng mảng kết hợp
    }
    $stmt->close(); // Đóng statement
}

// Nếu không tìm thấy sản phẩm (hoặc không có slug hợp lệ), hiển thị thông báo lỗi và dừng script
if (!$product) {
    echo "<p class='message error'>Sản phẩm không tồn tại hoặc không còn được kinh doanh.</p>";
    require_once 'includes/footer.php'; // Nhúng footer
    $conn->close();                    // Đóng kết nối CSDL
    exit();                            // Dừng thực thi script
}
?>

<div class="product-detail">
    <div class="image-gallery">
        <img src="<?php echo htmlspecialchars($product['image_url']); ?>" alt="<?php echo htmlspecialchars($product['name']); ?>">
        </div>
    <div class="info">
        <h2><?php echo htmlspecialchars($product['name']); ?></h2>
        <p class="category">Danh mục: <strong><?php echo htmlspecialchars($product['category_name'] ?? 'N/A'); ?></strong></p>
        <p class="brand">Thương hiệu: <strong><?php echo htmlspecialchars($product['brand_name'] ?? 'N/A'); ?></strong></p>
        <p class="price">
            <?php
            // Kiểm tra nếu có giá khuyến mãi và nó nhỏ hơn giá gốc thì hiển thị cả hai giá
            if ($product['sale_price'] !== NULL && $product['sale_price'] < $product['price']): ?>
                <span class="old-price"><?php echo number_format($product['price'], 0, ',', '.'); ?>đ</span>
                <?php echo number_format($product['sale_price'], 0, ',', '.'); ?>đ
            <?php else: ?>
                <?php echo number_format($product['price'], 0, ',', '.'); ?>đ
            <?php endif; ?>
        </p>
        <p class="stock">Tình trạng:
            <?php if ($product['stock_quantity'] > 0): ?>
                <span style="color: green;">Còn hàng (<?php echo $product['stock_quantity']; ?>)</span>
            <?php else: ?>
                <span style="color: red;">Hết hàng</span>
            <?php endif; ?>
        </p>
        <p class="short-description"><?php echo nl2br(htmlspecialchars($product['short_description'])); ?></p>
        <div class="description">
            <h3>Mô tả chi tiết</h3>
            <?php echo nl2br(htmlspecialchars($product['description'])); ?>
        </div>
        <?php if ($product['stock_quantity'] > 0): ?>
            <button onclick="window.location.href='add_to_cart.php?product_id=<?php echo $product['id']; ?>'">Thêm vào giỏ hàng</button>
        <?php else: ?>
            <button disabled style="background-color: #6c757d; cursor: not-allowed;">Hết hàng</button>
        <?php endif; ?>
    </div>
</div>

<h3>Đánh giá sản phẩm</h3>
<p>Chức năng đánh giá sẽ được phát triển sau.</p>

<?php
require_once 'includes/footer.php'; // Nhúng footer của trang
$conn->close();                    // Đóng kết nối CSDL
?>