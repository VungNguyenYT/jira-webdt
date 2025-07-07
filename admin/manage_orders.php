<?php
require_once '../includes/db.php';     // Nhúng file kết nối CSDL và khởi tạo session
require_once '../includes/header.php'; // Nhúng header của trang

// Kiểm tra quyền admin
// Điều này đảm bảo chỉ người dùng có vai trò 'admin' mới có thể truy cập trang này.
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    // Đặt thông báo lỗi và chuyển hướng về trang đăng nhập nếu không có quyền
    $_SESSION['message'] = ['type' => 'error', 'text' => 'Bạn không có quyền truy cập trang này. Vui lòng đăng nhập với tài khoản quản trị.'];
    header("Location: ../login.php");
    exit();
}

// Xử lý cập nhật trạng thái đơn hàng khi form được gửi đi (POST request)
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['order_id']) && isset($_POST['new_status'])) {
    $order_id = intval($_POST['order_id']); // Lấy ID đơn hàng và đảm bảo là số nguyên
    $new_status = $_POST['new_status'];      // Lấy trạng thái mới

    // Danh sách các trạng thái hợp lệ để tránh dữ liệu không mong muốn
    $valid_statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];

    // Kiểm tra xem trạng thái mới có hợp lệ không
    if (in_array($new_status, $valid_statuses)) {
        // Chuẩn bị câu lệnh SQL để cập nhật trạng thái đơn hàng
        $stmt = $conn->prepare("UPDATE orders SET order_status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
        $stmt->bind_param("si", $new_status, $order_id); // 's' cho string, 'i' cho integer

        // Thực thi câu lệnh
        if ($stmt->execute()) {
            $_SESSION['message'] = ['type' => 'success', 'text' => 'Trạng thái đơn hàng #' . $order_id . ' đã được cập nhật thành công.'];
        } else {
            $_SESSION['message'] = ['type' => 'error', 'text' => 'Lỗi khi cập nhật trạng thái đơn hàng: ' . $stmt->error];
        }
        $stmt->close(); // Đóng statement

        // Chuyển hướng về chính trang này sau khi cập nhật để làm mới dữ liệu và hiển thị thông báo
        header("Location: manage_orders.php");
        exit();
    } else {
        // Nếu trạng thái không hợp lệ
        $_SESSION['message'] = ['type' => 'error', 'text' => 'Trạng thái không hợp lệ được chọn.'];
        header("Location: manage_orders.php");
        exit();
    }
}

// Lấy danh sách tất cả các đơn hàng từ CSDL để hiển thị
// Sắp xếp theo ngày tạo giảm dần (đơn hàng mới nhất lên đầu)
$sql_orders = "SELECT id, customer_name, total_amount, order_status, payment_method, payment_status, created_at FROM orders ORDER BY created_at DESC";
$result_orders = $conn->query($sql_orders);

?>

<h2>Quản Lý Đơn Hàng</h2>

<?php
// Thông báo (success/error) sẽ được hiển thị bởi display_message() trong header.php
?>

<?php if ($result_orders->num_rows > 0): // Kiểm tra xem có đơn hàng nào để hiển thị không ?>
    <table>
        <thead>
            <tr>
                <th>Mã Đơn hàng</th>
                <th>Khách hàng</th>
                <th>Tổng tiền</th>
                <th>Trạng thái ĐH</th>
                <th>Thanh toán</th>
                <th>Ngày đặt</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($order = $result_orders->fetch_assoc()): // Duyệt qua từng đơn hàng ?>
            <tr>
                <td><?php echo htmlspecialchars($order['id']); ?></td>
                <td><?php echo htmlspecialchars($order['customer_name']); ?></td>
                <td><?php echo number_format($order['total_amount'], 0, ',', '.'); ?>đ</td>
                <td>
                    <form action="manage_orders.php" method="POST" style="display: inline-block;">
                        <input type="hidden" name="order_id" value="<?php echo $order['id']; ?>">
                        <select name="new_status" onchange="this.form.submit()">
                            <option value="pending" <?php echo ($order['order_status'] == 'pending') ? 'selected' : ''; ?>>Chờ xử lý</option>
                            <option value="processing" <?php echo ($order['order_status'] == 'processing') ? 'selected' : ''; ?>>Đang xử lý</option>
                            <option value="shipped" <?php echo ($order['order_status'] == 'shipped') ? 'selected' : ''; ?>>Đã vận chuyển</option>
                            <option value="delivered" <?php echo ($order['order_status'] == 'delivered') ? 'selected' : ''; ?>>Đã giao hàng</option>
                            <option value="cancelled" <?php echo ($order['order_status'] == 'cancelled') ? 'selected' : ''; ?>>Đã hủy</option>
                        </select>
                    </form>
                </td>
                <td><?php echo htmlspecialchars($order['payment_method']); ?> (<?php echo htmlspecialchars($order['payment_status']); ?>)</td>
                <td><?php echo date('d/m/Y H:i', strtotime($order['created_at'])); ?></td>
                <td>
                    <a href="view_order_detail.php?id=<?php echo $order['id']; ?>" class="button" style="background-color: #17a2b8; padding: 5px 10px; font-size: 0.9em;">Xem chi tiết</a>
                </td>
            </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
<?php else: ?>
    <p>Chưa có đơn hàng nào.</p>
<?php endif; ?>

<?php
require_once '../includes/footer.php'; // Nhúng footer của trang
$conn->close(); // Đóng kết nối CSDL
?>