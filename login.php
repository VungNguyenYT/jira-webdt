<?php
require_once 'includes/db.php'; // Nhúng file kết nối CSDL và khởi tạo session (session_start() có trong db.php)
require_once 'includes/header.php'; // Nhúng header của trang

// Kiểm tra xem người dùng đã đăng nhập chưa.
// Nếu đã đăng nhập (có user_id trong session), chuyển hướng về trang chủ để tránh truy cập lại trang đăng nhập.
if (isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit(); // Dừng thực thi script sau khi chuyển hướng
}

// Xử lý khi form đăng nhập được gửi đi (phương thức POST)
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Lấy tên đăng nhập và mật khẩu từ form, loại bỏ khoảng trắng thừa
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? ''; // Mật khẩu không nên trim vì có thể chứa khoảng trắng có chủ đích

    // Chuẩn bị câu lệnh SQL để tìm người dùng theo tên đăng nhập
    // Sử dụng Prepared Statement để ngăn chặn SQL Injection
    $stmt = $conn->prepare("SELECT id, username, password, role, full_name FROM users WHERE username = ?");
    $stmt->bind_param("s", $username); // 's' nghĩa là tham số là kiểu string
    $stmt->execute();                  // Thực thi câu lệnh
    $result = $stmt->get_result();     // Lấy kết quả trả về

    // Kiểm tra xem có tìm thấy người dùng nào không
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc(); // Lấy dữ liệu người dùng dưới dạng mảng kết hợp

        // Xác minh mật khẩu:
        // password_verify() là hàm chuẩn của PHP để so sánh mật khẩu người dùng nhập vào
        // với mật khẩu đã được mã hóa (hash) lưu trong CSDL.
        if (password_verify($password, $user['password'])) {
            // Đăng nhập thành công: Lưu thông tin người dùng vào session
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
            $_SESSION['full_name'] = $user['full_name'] ?? $user['username']; // Lưu tên đầy đủ (nếu có), nếu không dùng username

            // Đặt thông báo thành công vào session để hiển thị trên trang chủ
            $_SESSION['message'] = ['type' => 'success', 'text' => 'Đăng nhập thành công! Chào mừng ' . htmlspecialchars($_SESSION['full_name']) . '.'];

            // Chuyển hướng người dùng về trang chủ
            header("Location: index.php");
            exit();
        } else {
            // Mật khẩu không đúng: Đặt thông báo lỗi vào session
            $_SESSION['message'] = ['type' => 'error', 'text' => 'Tên đăng nhập hoặc mật khẩu không đúng.'];
            header("Location: login.php"); // Tải lại trang với thông báo lỗi
            exit();
        }
    } else {
        // Không tìm thấy người dùng: Đặt thông báo lỗi vào session
        $_SESSION['message'] = ['type' => 'error', 'text' => 'Tên đăng nhập hoặc mật khẩu không đúng.'];
        header("Location: login.php"); // Tải lại trang với thông báo lỗi
        exit();
    }
    $stmt->close(); // Đóng statement
}
?>

<div class="form-container">
    <h2>Đăng nhập</h2>
    <form action="login.php" method="POST">
        <div class="form-group">
            <label for="username">Tên đăng nhập:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <button type="submit">Đăng nhập</button>
        </div>
        <p style="text-align: center;">Chưa có tài khoản? <a href="register.php">Đăng ký ngay</a></p>
    </form>
</div>

<?php
require_once 'includes/footer.php'; // Nhúng footer của trang
$conn->close(); // Đóng kết nối CSDL
?>