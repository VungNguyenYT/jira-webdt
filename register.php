<?php
require_once 'includes/db.php'; // Nhúng file kết nối CSDL và khởi tạo session
require_once 'includes/header.php'; // Nhúng header của trang

// Kiểm tra xem người dùng đã đăng nhập chưa.
// Nếu đã đăng nhập, chuyển hướng về trang chủ để tránh đăng ký lại.
if (isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

// Xử lý khi form đăng ký được gửi đi (phương thức POST)
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Lấy dữ liệu từ form và loại bỏ khoảng trắng ở đầu/cuối
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirm_password = $_POST['confirm_password'] ?? '';
    $email = trim($_POST['email'] ?? '');
    $full_name = trim($_POST['full_name'] ?? '');
    $phone_number = trim($_POST['phone_number'] ?? '');
    $address = trim($_POST['address'] ?? '');

    $errors = []; // Mảng để lưu các lỗi phát sinh trong quá trình validate

    // 1. Kiểm tra các trường bắt buộc không được để trống
    if (empty($username)) $errors[] = "Tên đăng nhập không được để trống.";
    if (empty($password)) $errors[] = "Mật khẩu không được để trống.";
    if (empty($confirm_password)) $errors[] = "Xác nhận mật khẩu không được để trống.";
    if (empty($email)) $errors[] = "Email không được để trống.";

    // 2. Kiểm tra mật khẩu và xác nhận mật khẩu
    if ($password !== $confirm_password) $errors[] = "Mật khẩu xác nhận không khớp.";
    if (strlen($password) < 6) $errors[] = "Mật khẩu phải có ít nhất 6 ký tự.";

    // 3. Kiểm tra định dạng email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = "Email không hợp lệ.";

    // Nếu có lỗi trong quá trình validate ban đầu, lưu vào session và chuyển hướng
    if (!empty($errors)) {
        $_SESSION['message'] = ['type' => 'error', 'text' => implode('<br>', $errors)];
        // Lưu lại dữ liệu đã nhập để người dùng không phải nhập lại (trừ mật khẩu)
        $_SESSION['form_data'] = $_POST;
        header("Location: register.php");
        exit();
    } else {
        // Nếu không có lỗi validate, tiến hành kiểm tra trùng lặp trong CSDL
        // Chuẩn bị câu lệnh SQL để kiểm tra username hoặc email đã tồn tại chưa
        $stmt_check = $conn->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
        $stmt_check->bind_param("ss", $username, $email);
        $stmt_check->execute();
        $result_check = $stmt_check->get_result();

        if ($result_check->num_rows > 0) {
            // Nếu tìm thấy người dùng với username hoặc email đã tồn tại
            $_SESSION['message'] = ['type' => 'error', 'text' => "Tên đăng nhập hoặc Email đã được sử dụng. Vui lòng chọn cái khác."];
            // Lưu lại dữ liệu đã nhập (trừ mật khẩu)
            $_SESSION['form_data'] = $_POST;
            header("Location: register.php");
            exit();
        } else {
            // Username và email chưa tồn tại, tiến hành mã hóa mật khẩu và chèn vào CSDL
            // password_hash() là hàm chuẩn để mã hóa mật khẩu an toàn
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);

            // Chuẩn bị câu lệnh SQL để chèn dữ liệu người dùng mới
            $stmt_insert = $conn->prepare("INSERT INTO users (username, password, email, full_name, phone_number, address, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')");
            // 'ssssss' là định dạng kiểu dữ liệu cho các tham số (tất cả là string)
            $stmt_insert->bind_param("ssssss", $username, $hashed_password, $email, $full_name, $phone_number, $address);

            if ($stmt_insert->execute()) {
                // Đăng ký thành công
                $_SESSION['message'] = ['type' => 'success', 'text' => "Đăng ký thành công! Bạn có thể <a href='login.php'>đăng nhập</a> ngay bây giờ."];
                unset($_SESSION['form_data']); // Xóa dữ liệu form đã lưu
                header("Location: register.php"); // Chuyển hướng để xóa dữ liệu form cũ và hiển thị thông báo
                exit();
            } else {
                // Lỗi khi chèn vào CSDL
                $_SESSION['message'] = ['type' => 'error', 'text' => "Có lỗi xảy ra khi đăng ký tài khoản: " . $stmt_insert->error];
                // Lưu lại dữ liệu đã nhập (trừ mật khẩu)
                $_SESSION['form_data'] = $_POST;
                header("Location: register.php"); // Tải lại trang với lỗi
                exit();
            }
            $stmt_insert->close(); // Đóng statement chèn
        }
        $stmt_check->close(); // Đóng statement kiểm tra trùng lặp
    }
}

// Lấy lại dữ liệu form đã nhập nếu có lỗi trước đó để người dùng không phải nhập lại
$old_username = htmlspecialchars($_SESSION['form_data']['username'] ?? '');
$old_email = htmlspecialchars($_SESSION['form_data']['email'] ?? '');
$old_full_name = htmlspecialchars($_SESSION['form_data']['full_name'] ?? '');
$old_phone_number = htmlspecialchars($_SESSION['form_data']['phone_number'] ?? '');
$old_address = htmlspecialchars($_SESSION['form_data']['address'] ?? '');
unset($_SESSION['form_data']); // Xóa dữ liệu form đã lưu sau khi lấy ra để tránh hiển thị lại

?>

<div class="form-container">
    <h2>Đăng ký tài khoản mới</h2>
    <form action="register.php" method="POST">
        <div class="form-group">
            <label for="username">Tên đăng nhập (<span style="color: red;">*</span>):</label>
            <input type="text" id="username" name="username" required value="<?php echo $old_username; ?>">
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu (<span style="color: red;">*</span>):</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="confirm_password">Xác nhận mật khẩu (<span style="color: red;">*</span>):</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
        </div>
        <div class="form-group">
            <label for="email">Email (<span style="color: red;">*</span>):</label>
            <input type="email" id="email" name="email" required value="<?php echo $old_email; ?>">
        </div>
        <div class="form-group">
            <label for="full_name">Họ và tên:</label>
            <input type="text" id="full_name" name="full_name" value="<?php echo $old_full_name; ?>">
        </div>
        <div class="form-group">
            <label for="phone_number">Số điện thoại:</label>
            <input type="tel" id="phone_number" name="phone_number" value="<?php echo $old_phone_number; ?>">
        </div>
        <div class="form-group">
            <label for="address">Địa chỉ:</label>
            <textarea id="address" name="address" rows="3"><?php echo $old_address; ?></textarea>
        </div>
        <div class="form-group">
            <button type="submit">Đăng ký</button>
        </div>
        <p style="text-align: center;">Đã có tài khoản? <a href="login.php">Đăng nhập</a></p>
    </form>
</div>

<?php
require_once 'includes/footer.php'; // Nhúng footer của trang
$conn->close(); // Đóng kết nối CSDL
?>