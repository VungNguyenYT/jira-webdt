<?php
session_start();
require_once '../includes/db.php';

// Kiểm tra quyền admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: /jira-webdt/login.php");
    exit();
}

// Truy vấn sản phẩm
$sql = "SELECT products.*, categories.name AS category_name, brands.name AS brand_name
        FROM products
        LEFT JOIN categories ON products.category_id = categories.id
        LEFT JOIN brands ON products.brand_id = brands.id
        ORDER BY products.created_at DESC";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm - Jira WebBDT</title>
</head>

<body style="font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #f8f9fa; color: #343a40;">

    <header style="background-color: #343a40; color: white; padding: 20px;">
        <div style="max-width: 1200px; margin: auto; display: flex; justify-content: space-between;">
            <h1 style="margin: 0;"><a href="../index.php" style="color: white; text-decoration: none;">Jira WebBDT</a>
            </h1>
            <nav>
                <a href="../index.php" style="color: white; margin-left: 20px;">Trang chủ</a>
                <a href="../product.php" style="color: white; margin-left: 20px;">Sản phẩm</a>
                <a href="../cart.php" style="color: white; margin-left: 20px;">Giỏ hàng</a>
                <a href="index.php" style="color: white; margin-left: 20px;">Admin Panel</a>
                <a href="../logout.php" style="color: white; margin-left: 20px;">Đăng xuất</a>
            </nav>
        </div>
    </header>

    <main style="padding: 40px 0; max-width: 1200px; margin: auto;">
        <h2 style="text-align: center;">🧾 Danh sách sản phẩm</h2>

        <div style="text-align: right; margin: 20px 0;">
            <a href="add_product.php"
                style="padding: 10px 20px; background-color: #28a745; color: white; border-radius: 5px; text-decoration: none;">
                + Thêm sản phẩm mới
            </a>
        </div>

        <table style="width: 100%; border-collapse: collapse; background: white; box-shadow: 0 0 8px rgba(0,0,0,0.1);">
            <thead style="background-color: #f0f0f0;">
                <tr>
                    <th style="padding: 12px; border: 1px solid #ddd;">ID</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Tên</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Ảnh</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Giá</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">KM</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Tồn kho</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Danh mục</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Thương hiệu</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Trạng thái</th>
                    <th style="padding: 12px; border: 1px solid #ddd;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <?php if ($result->num_rows > 0): ?>
                    <?php while ($row = $result->fetch_assoc()): ?>
                        <tr style="text-align: center;">
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= $row['id'] ?></td>
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= htmlspecialchars($row['name']) ?></td>
                            <td style="padding: 10px; border: 1px solid #ddd;">
                                <?php if (!empty($row['image_url'])): ?>
                                    <img src="../<?= $row['image_url'] ?>" alt="Ảnh" width="70" style="border-radius: 5px;">
                                <?php else: ?>
                                    <span style="color: gray;">Chưa có ảnh</span>
                                <?php endif; ?>
                            </td>
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= number_format($row['price'], 0, ',', '.') ?>₫
                            </td>
                            <td style="padding: 10px; border: 1px solid #ddd;">
                                <?= $row['sale_price'] ? number_format($row['sale_price'], 0, ',', '.') . '₫' : '-' ?>
                            </td>
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= $row['stock_quantity'] ?></td>
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= $row['category_name'] ?></td>
                            <td style="padding: 10px; border: 1px solid #ddd;"><?= $row['brand_name'] ?></td>
                            <td style="padding: 10px; border: 1px solid #ddd;">
                                <?= $row['status'] === 'active' ? '<span style="color:green;">Hiển thị</span>' : '<span style="color:gray;">Ẩn</span>' ?>
                            </td>
                            <td style="padding: 10px; border: 1px solid #ddd;">
                                <a href="edit_product.php?id=<?= $row['id'] ?>" style="color: #007bff;">Sửa</a> |
                                <form method="POST" action="delete_product.php" style="display:inline;"
                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="id" value="<?= $row['id'] ?>">
                                    <button type="submit"
                                        style="border:none; background:none; color:red; cursor:pointer;">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <?php endwhile; ?>
                <?php else: ?>
                    <tr>
                        <td colspan="10" style="text-align: center; padding: 20px; color: red;">Không có sản phẩm nào.</td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </main>

    <footer style="background-color: #343a40; color: white; text-align: center; padding: 20px;">
        <p style="margin: 0;">© <?= date('Y') ?> Jira WebBDT</p>
    </footer>

</body>

</html>

<?php $conn->close(); ?>