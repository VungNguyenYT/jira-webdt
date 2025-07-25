<?php
require_once 'includes/db.php';
require_once 'includes/header.php';

$keyword = isset($_GET['keyword']) ? trim($_GET['keyword']) : '';

if ($keyword !== '') {
    $stmt = $conn->prepare("SELECT * FROM products WHERE status = 'active' AND name LIKE CONCAT('%', ?, '%')");
    $stmt->bind_param("s", $keyword);
} else {
    $stmt = $conn->prepare("SELECT * FROM products WHERE status = 'active'");
}
$stmt->execute();
$result = $stmt->get_result();
?>

<div style="max-width: 1200px; margin: 0 auto; padding: 30px; font-family: Arial, sans-serif;">
    <h2 style="text-align: center; color: #333; margin-bottom: 30px;">Danh sách sản phẩm</h2>

    <form method="get" style="display: flex; justify-content: center; margin-bottom: 30px;">
        <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..."
            value="<?php echo htmlspecialchars($keyword); ?>"
            style="padding: 10px 15px; width: 300px; border: 1px solid #ccc; border-radius: 5px 0 0 5px; outline: none;">
        <button type="submit"
            style="padding: 10px 20px; border: none; background-color: #007bff; color: white; border-radius: 0 5px 5px 0; cursor: pointer;">
            Tìm kiếm
        </button>
    </form>

    <?php if ($result->num_rows > 0): ?>
        <div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
            <?php while ($product = $result->fetch_assoc()): ?>
                <div
                    style="width: 280px; border: 1px solid #ddd; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); background-color: #fff;">
                    <img src="<?php echo $product['image_url']; ?>" alt="<?php echo htmlspecialchars($product['name']); ?>"
                        style="width: 100%; height: 200px; object-fit: cover;">

                    <div style="padding: 15px;">
                        <h4 style="font-size: 18px; color: #333; margin-bottom: 10px;">
                            <?php echo htmlspecialchars($product['name']); ?></h4>

                        <?php if (!empty($product['sale_price'])): ?>
                            <p style="margin: 5px 0;">
                                <del style="color: #999;"><?php echo number_format($product['price'], 0, ',', '.'); ?>₫</del>
                                <span
                                    style="color: red; font-weight: bold;"><?php echo number_format($product['sale_price'], 0, ',', '.'); ?>₫</span>
                            </p>
                        <?php else: ?>
                            <p style="margin: 5px 0; font-weight: bold;">
                                <?php echo number_format($product['price'], 0, ',', '.'); ?>₫</p>
                        <?php endif; ?>

                        <p style="font-size: 14px; color: #666;">Tồn kho: <?php echo $product['stock_quantity']; ?></p>

                        <a href="product_detail.php?product_id=<?php echo $product['id']; ?>"
                            style="display: inline-block; margin-top: 10px; padding: 10px 15px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; text-align: center;">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            <?php endwhile; ?>
        </div>
    <?php else: ?>
        <p style="text-align: center; color: red;">Không tìm thấy sản phẩm nào phù hợp.</p>
    <?php endif; ?>
</div>

<?php
require_once 'includes/footer.php';
$conn->close();
?>