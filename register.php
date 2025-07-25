<?php
session_start();
require_once 'includes/db.php';

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $full_name = trim($_POST['full_name']);
    $username = trim($_POST['username']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];
    $confirm = $_POST['confirm_password'];

    if ($password !== $confirm) {
        $error = "Mật khẩu xác nhận không khớp.";
    } else {
        // Kiểm tra username/email đã tồn tại chưa
        $stmt = $conn->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
        $stmt->bind_param("ss", $username, $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $error = "Tên đăng nhập hoặc email đã tồn tại.";
        } else {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("INSERT INTO users (username, password, email, full_name, role) VALUES (?, ?, ?, ?, 'customer')");
            $stmt->bind_param("ssss", $username, $hash, $email, $full_name);
            if ($stmt->execute()) {
                $success = "Đăng ký thành công. Bạn có thể <a href='login.php'>đăng nhập</a> ngay.";
            } else {
                $error = "Đã xảy ra lỗi. Vui lòng thử lại.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - Jira WebBDT</title>
</head>
<body style="font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f8f9fa; margin: 0; padding: 0;">

<div style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
    <div style="background-color: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 100%; max-width: 450px;">
        <h2 style="text-align: center; margin-bottom: 25px; color: #343a40;">📝 Đăng ký tài khoản</h2>

        <?php if ($error): ?>
                <div style="background-color: #f8d7da; color: #721c24; padding: 10px 15px; border-radius: 5px; margin-bottom: 20px;">
                    <?php echo htmlspecialchars($error); ?>
                </div>
        <?php elseif ($success): ?>
                <div style="background-color: #d4edda; color: #155724; padding: 10px 15px; border-radius: 5px; margin-bottom: 20px;">
                    <?php echo $success; ?>
                </div>
        <?php endif; ?>

        <form method="post">
            <label for="full_name" style="font-weight: bold;">Họ và tên:</label>
            <input type="text" name="full_name" id="full_name" required
                   style="width: 100%; padding: 10px; margin: 8px 0 15px; border: 1px solid #ccc; border-radius: 5px;">

            <label for="username" style="font-weight: bold;">Tên đăng nhập:</label>
            <input type="text" name="username" id="username" required
                   style="width: 100%; padding: 10px; margin: 8px 0 15px; border: 1px solid #ccc; border-radius: 5px;">

            <label for="email" style="font-weight: bold;">Email:</label>
            <input type="email" name="email" id="email" required
                   style="width: 100%; padding: 10px; margin: 8px 0 15px; border: 1px solid #ccc; border-radius: 5px;">

            <label for="password" style="font-weight: bold;">Mật khẩu:</label>
            <input type="password" name="password" id="password" required
                   style="width: 100%; padding: 10px; margin: 8px 0 15px; border: 1px solid #ccc; border-radius: 5px;">

            <label for="confirm_password" style="font-weight: bold;">Xác nhận mật khẩu:</label>
            <input type="password" name="confirm_password" id="confirm_password" required
                   style="width: 100%; padding: 10px; margin: 8px 0 20px; border: 1px solid #ccc; border-radius: 5px;">

            <button type="submit"
                    style="width: 100%; padding: 12px; background-color: #28a745; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer;">
                Đăng ký
            </button>
        </form>

        <p style="text-align: center; margin-top: 20px; font-size: 14px;">Đã có tài khoản? <a href="login.php" style="color: #007bff;">Đăng nhập</a></p>
    </div>
</div>

</body>
</html>
