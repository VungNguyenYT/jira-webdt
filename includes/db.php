<?php
// Bắt đầu session cho toàn bộ website. Rất quan trọng cho giỏ hàng, đăng nhập.
// Luôn đặt ở đầu các tệp PHP cần sử dụng session.
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Cấu hình kết nối cơ sở dữ liệu
define('DB_SERVER', 'localhost'); // Tên máy chủ CSDL (thường là localhost)
define('DB_USERNAME', 'root');   // Tên người dùng CSDL của bạn (mặc định XAMPP là root)
define('DB_PASSWORD', '');       // Mật khẩu CSDL của bạn (mặc định XAMPP là rỗng)
define('DB_NAME', 'jira_webdt'); // Tên cơ sở dữ liệu đã tạo trước đó

// Tạo kết nối MySQLi
$conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối cơ sở dữ liệu thất bại: " . $conn->connect_error);
}

// RẤT QUAN TRỌNG: Thiết lập bộ ký tự cho kết nối để hỗ trợ tiếng Việt (UTF-8)
$conn->set_charset("utf8mb4");

// Hàm tiện ích để hiển thị thông báo
function display_message() {
    if (isset($_SESSION['message'])) {
        echo '<p class="message ' . $_SESSION['message']['type'] . '">' . $_SESSION['message']['text'] . '</p>';
        unset($_SESSION['message']); // Xóa thông báo sau khi hiển thị
    }
}
?>