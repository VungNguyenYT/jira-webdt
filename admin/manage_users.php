<?php
session_start();
require_once '../includes/db.php';

// Kiểm tra đăng nhập & quyền admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: /jira-webdt/login.php");
    exit();
}

// Lấy danh sách người dùng
$sql = "SELECT * FROM users ORDER BY id DESC";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng - Jira WebBDT</title>
</head>

<body style="font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; background-color: #f8f9fa; color: #343a40;">

    <header style="background-color: #343a40; color: white; padding: 20px 0;">
        <div style="width: 90%; max-width: 1200px; margin: auto;">
            <h1 style="float: left; margin: 0;"><a href="../index.php" style="color: white; text-decoration: none;">Jira
                    WebBDT</a></h1>
            <nav style="float: right;">
                <ul style="list-style: none; margin: 0; padding: 0;">
                    <li style="display: inline-block; margin-left: 20px;"><a href="../index.php"
                            style="color: white; text-decoration: none;">Trang chủ</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="index.php"
                            style="color: white; text-decoration: none;">Admin Panel</a></li>
                    <li style="display: inline-block; margin-left: 20px;"><a href="../logout.php"
                            style="color: white; text-decoration: none;">Đăng xuất</a></li>
                </ul>
            </nav>
            <div style="clear: both;"></div>
        </div>
    </header>

    <main style="padding: 30px 0;">
        <div style="width: 90%; max-width: 1200px; margin: auto;">
            <h2 style="text-align: center; margin-bottom: 30px;">👤 Danh sách người dùng</h2>

            <div style="text-align: right; margin-bottom: 20px;">
                <a href="add_user.php"
                    style="padding: 10px 20px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px;">+
                    Thêm người dùng</a>
            </div>

            <table
                style="width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                <thead style="background-color: #f0f0f0;">
                    <tr>
                        <th style="padding: 12px; border: 1px solid #ddd;">ID</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Tên đăng nhập</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Họ tên</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Email</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Quyền</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if ($result->num_rows > 0): ?>
                        <?php while ($user = $result->fetch_assoc()): ?>
                            <tr style="text-align: center;">
                                <td style="padding: 10px; border: 1px solid #ddd;"><?php echo $user['id']; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo htmlspecialchars($user['username']); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo htmlspecialchars($user['full_name']); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo htmlspecialchars($user['email']); ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <?php echo $user['role'] === 'admin' ? 'Quản trị' : 'Khách hàng'; ?></td>
                                <td style="padding: 10px; border: 1px solid #ddd;">
                                    <a href="edit_user.php?id=<?php echo $user['id']; ?>" style="color: #007bff;">Sửa</a> |
                                    <a href="delete_user.php?id=<?php echo $user['id']; ?>"
                                        onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')"
                                        style="color: red;">Xóa</a>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 20px; color: red;">Không có người dùng nào.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </main>

    <footer style="background-color: #343a40; color: white; text-align: center; padding: 20px 0;">
        <p style="margin: 0;">© <?php echo date('Y'); ?> Jira WebBDT. All rights reserved.</p>
    </footer>

</body>

</html>

<?php $conn->close(); ?>