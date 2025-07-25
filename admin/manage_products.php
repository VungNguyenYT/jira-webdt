<?php
session_start();
require_once '../includes/db.php';

// Kiểm tra đăng nhập & quyền admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: /jira-webdt/login.php");
    exit();
}

// Lấy dữ liệu sản phẩm
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

<body
    style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f8f9fa; color: #343a40; line-height: 1.6;">

    <header style="background-color: #343a40; color: #fff; padding: 10px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <div style="width: 90%; max-width: 1200px; margin: 0 auto; padding: 20px 0;">
            <h1 style="float: left; margin: 0; font-size: 1.8em;"><a href="../index.php"
                    style="color: #fff; text-decoration: none; font-weight: bold;">Jira WebBDT</a></h1>
            <nav style="float: right;">
                <ul style="margin: 0; padding: 0; list-style: none;">
                    <li style="display: inline-block; margin-left: 20px;"><a href="../index.php"
                            style="color: #fff; text-decoration: none; padding: 8px 15px;">Trang chủ</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="../product.php"
                            style="color: #fff; text-decoration: none; padding: 8px 15px;">Sản phẩm</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="../cart.php"
                            style="color: #fff; text-decoration: none; padding: 8px 15px;">Giỏ hàng</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="index.php"
                            style="color: #fff; padding: 8px 15px;">Admin Panel</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="../logout.php"
                            style="color: #fff; padding: 8px 15px;">Đăng xuất</a></li>
                </ul>
            </nav>
            <div style="clear: both;"></div>
        </div>
    </header>

    <main style="padding: 30px 0; min-height: 600px;">
        <div style="width: 90%; max-width: 1200px; margin: 0 auto;">
            <h2 style="text-align: center; margin-bottom: 30px;">🧾 Danh sách sản phẩm</h2>

            <div style="text-align: right; margin-bottom: 20px;">
                <a href="add_product.php"
                    style="padding: 10px 20px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px;">+
                    Thêm sản phẩm</a>
            </div>

            <table
                style="width: 100%; border-collapse: collapse; box-shadow: 0 0 8px rgba(0,0,0,0.1); background: white;">
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
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $row['id']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo htmlspecialchars($row['name']); ?>
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <img src="../<?php echo $row['image_url']; ?>" alt="Ảnh" width="70"
                                        style="border-radius: 5px;">
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo number_format($row['price'], 0, ',', '.'); ?>₫
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo $row['sale_price'] ? number_format($row['sale_price'], 0, ',', '.') . '₫' : '-'; ?>
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $row['stock_quantity']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $row['category_name']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $row['brand_name']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo ($row['status'] === 'active') ? '<span style="color:green;">Hiển thị</span>' : '<span style="color:gray;">Ẩn</span>'; ?>
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <a href="edit_product.php?id=<?php echo $row['id']; ?>" style="color: #007bff;">Sửa</a> |
                                    <a href="delete_product.php?id=<?php echo $row['id']; ?>"
                                        onclick="return confirm('Bạn có chắc chắn muốn xóa?')" style="color: red;">Xóa</a>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="10" style="padding: 20px; text-align: center; color: red;">Không có sản phẩm nào.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </main>

    <footer style="background-color: #343a40; color: white; padding: 20px 0; text-align: center;">
        <p style="margin: 0;">© <?php echo date('Y'); ?> Jira WebBDT. All rights reserved.</p>
    </footer>

</body>

</html>

<?php $conn->close(); ?>