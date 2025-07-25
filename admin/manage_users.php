<?php
session_start();
require_once '../includes/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: /jira-webdt/login.php");
    exit();
}

$result = $conn->query("SELECT * FROM users ORDER BY created_at DESC");
?>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
</head>

<body style="font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; padding: 0; background-color: #f8f9fa;">

    <header style="background-color: #343a40; color: white; padding: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <div
            style="width: 90%; max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
            <h1 style="margin: 0; font-size: 1.8em;"><a href="../index.php"
                    style="color: white; text-decoration: none;">Jira WebBDT</a></h1>
            <nav>
                <a href="manage_products.php" style="margin-left: 20px; color: white; text-decoration: none;">Sản
                    phẩm</a>
                <a href="manage_users.php" style="margin-left: 20px; color: white; font-weight: bold;">Người dùng</a>
                <a href="../logout.php" style="margin-left: 20px; color: white;">Đăng xuất</a>
            </nav>
        </div>
    </header>

    <main style="padding: 40px 0; min-height: 600px;">
        <div style="width: 90%; max-width: 1200px; margin: 0 auto;">
            <h2 style="text-align: center; margin-bottom: 30px;">👤 Danh sách người dùng</h2>

            <div style="text-align: right; margin-bottom: 20px;">
                <a href="add_user.php"
                    style="padding: 10px 20px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px;">+
                    Thêm tài khoản</a>
            </div>

            <table
                style="width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <thead style="background-color: #f1f1f1;">
                    <tr>
                        <th style="padding: 12px; border: 1px solid #ddd;">ID</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Tên</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Email</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">SĐT</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Địa chỉ</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Vai trò</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Ngày tạo</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if ($result->num_rows > 0): ?>
                        <?php while ($user = $result->fetch_assoc()): ?>
                            <tr style="text-align: center;">
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $user['id']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo htmlspecialchars($user['full_name'] ?? $user['username']); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo htmlspecialchars($user['email']); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $user['phone_number']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $user['address']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <span style="color: <?= $user['role'] === 'admin' ? 'green' : '#555'; ?>;">
                                        <?= $user['role'] === 'admin' ? 'Admin' : 'Khách hàng'; ?>
                                    </span>
                                </td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo date('d/m/Y H:i', strtotime($user['created_at'])); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <a href="edit_user.php?id=<?php echo $user['id']; ?>" style="color:#007bff;">Sửa</a> |
                                    <a href="delete_user.php?id=<?php echo $user['id']; ?>"
                                        onclick="return confirm('Bạn có chắc muốn xóa tài khoản này?')"
                                        style="color:red;">Xóa</a>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="8" style="padding: 20px; text-align: center; color: red;">Không có người dùng nào.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </main>

    <footer style="background-color: #343a40; color: white; text-align: center; padding: 20px 0;">
        <p style="margin: 0;">© <?php echo date('Y'); ?> Jira WebBDT</p>
    </footer>

</body>

</html>

<?php $conn->close(); ?>