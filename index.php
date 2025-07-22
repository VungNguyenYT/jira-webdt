<?php
require_once 'includes/db.php'; // Nhúng file kết nối CSDL và khởi tạo session
require_once 'includes/header.php'; // Nhúng header

// Lấy danh sách sản phẩm mới nhất (giới hạn 8 sản phẩm)
$sql = "SELECT id, name, slug, price, sale_price, image_url FROM products WHERE status = 'active' ORDER BY created_at DESC LIMIT 8";
$result = $conn->query($sql);

?>

<h2 style="color: #343a40; text-align: center; margin-bottom: 30px; font-weight: 600;">Sản phẩm nổi bật</h2>
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px;">
    <?php
    if ($result->num_rows > 0) {
        // Duyệt qua từng sản phẩm và hiển thị
        while($row = $result->fetch_assoc()) {
            ?>
            <div style="background-color: #fff; border: 1px solid #e0e0e0; border-radius: 10px; padding: 20px; text-align: center; box-shadow: 0 4px 8px rgba(0,0,0,0.05); transition: transform 0.2s ease, box-shadow 0.2s ease;">
                <a href="product.php?slug=<?php echo htmlspecialchars($row['slug']); ?>" style="text-decoration: none; color: inherit;">
                    <img src="<?php echo htmlspecialchars($row['image_url']); ?>" alt="<?php echo htmlspecialchars($row['name']); ?>" style="max-width: 100%; height: 220px; object-fit: contain; margin-bottom: 15px;">
                    <h3 style="font-size: 1.3em; margin: 10px 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: center; color: #343a40;"><?php echo htmlspecialchars($row['name']); ?></h3>
                </a>
                <p style="font-size: 1.2em; color: #dc3545; font-weight: bold; margin-bottom: 15px;">
                    <?php if ($row['sale_price'] !== NULL && $row['sale_price'] < $row['price']): ?>
                        <span style="text-decoration: line-through; color: #6c757d; font-size: 0.9em; margin-right: 8px;"><?php echo number_format($row['price'], 0, ',', '.'); ?>đ</span>
                        <?php echo number_format($row['sale_price'], 0, ',', '.'); ?>đ
                    <?php else: ?>
                        <?php echo number_format($row['price'], 0, ',', '.'); ?>đ
                    <?php endif; ?>
                </p>
                <a href="add_to_cart.php?product_id=<?php echo $row['id']; ?>" style="display: inline-block; background-color: #007bff; color: #fff; text-decoration: none; padding: 12px 25px; border-radius: 5px; font-size: 1em; transition: background-color 0.3s ease;">Thêm vào giỏ</a>
            </div>
            <?php
        }
    } else {
        echo "<p style=\"text-align: center; color: #6c757d;\">Chưa có sản phẩm nào được hiển thị.</p>";
    }
    ?>
</div>

<?php
require_once 'includes/footer.php'; // Nhúng footer
$conn->close(); // Đóng kết nối CSDL
?>