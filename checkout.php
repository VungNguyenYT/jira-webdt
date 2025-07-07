<?php
require_once 'includes/db.php';     // Nhúng file kết nối CSDL và khởi tạo session
require_once 'includes/header.php'; // Nhúng header của trang

// Kiểm tra giỏ hàng có trống không trước khi cho phép khách hàng vào trang thanh toán
if (!isset($_SESSION['cart']) || empty($_SESSION['cart'])) {
    $_SESSION['message'] = ['type' => 'error', 'text' => 'Giỏ hàng của bạn trống. Vui lòng thêm sản phẩm trước khi thanh toán.'];
    header("Location: cart.php"); // Chuyển hướng về trang giỏ hàng
    exit(); // Dừng thực thi script
}

// Tính tổng tiền của giỏ hàng hiện tại
$total_amount = 0;
foreach ($_SESSION['cart'] as $item) {
    $total_amount += $item['price'] * $item['quantity'];
}

// Khởi tạo các biến để điền vào form thông tin giao hàng
// Nếu người dùng đã đăng nhập, cố gắng lấy thông tin từ profile của họ để điền sẵn
$customer_name = '';
$customer_email = '';
$customer_phone = '';
$shipping_address = '';

if (isset($_SESSION['user_id'])) {
    $stmt = $conn->prepare("SELECT full_name, email, phone_number, address FROM users WHERE id = ?");
    $stmt->bind_param("i", $_SESSION['user_id']);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $user_info = $result->fetch_assoc();
        $customer_name = $user_info['full_name'] ?? '';
        $customer_email = $user_info['email'] ?? '';
        $customer_phone = $user_info['phone_number'] ?? '';
        $shipping_address = $user_info['address'] ?? '';
    }
    $stmt->close();
}

// Xử lý khi form thanh toán được gửi đi (POST request)
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Lấy dữ liệu từ form và loại bỏ khoảng trắng thừa
    $customer_name_post = trim($_POST['customer_name'] ?? '');
    $customer_email_post = trim($_POST['customer_email'] ?? '');
    $customer_phone_post = trim($_POST['customer_phone'] ?? '');
    $shipping_address_post = trim($_POST['shipping_address'] ?? '');
    $payment_method = $_POST['payment_method'] ?? 'COD'; // Mặc định là 'COD' (Cash On Delivery)

    // Kiểm tra các trường bắt buộc
    if (empty($customer_name_post) || empty($customer_phone_post) || empty($shipping_address_post)) {
        $_SESSION['message'] = ['type' => 'error', 'text' => 'Vui lòng điền đầy đủ các thông tin bắt buộc (Tên, Số điện thoại, Địa chỉ giao hàng).'];
        // Lưu lại dữ liệu đã nhập để người dùng không phải nhập lại sau khi báo lỗi
        $_SESSION['form_data_checkout'] = $_POST;
        header("Location: checkout.php"); // Tải lại trang để hiển thị lỗi và giữ lại dữ liệu form
        exit();
    } else {
        // Bắt đầu một giao dịch (transaction) để đảm bảo tính toàn vẹn dữ liệu.
        // Nếu có bất kỳ bước nào thất bại (ví dụ: không đủ tồn kho), tất cả các thay đổi sẽ được hoàn tác.
        $conn->begin_transaction();
        try {
            // 1. Chèn dữ liệu vào bảng `orders` (tạo một đơn hàng mới)
            $user_id = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : NULL; // Gán user_id nếu người dùng đã đăng nhập
            $order_status = 'pending'; // Trạng thái đơn hàng ban đầu
            $payment_status = ($payment_method == 'COD') ? 'pending' : 'pending'; // Trạng thái thanh toán (có thể là 'paid' nếu tích hợp cổng thanh toán trực tuyến)

            $stmt_order = $conn->prepare("INSERT INTO orders (user_id, customer_name, customer_email, customer_phone, shipping_address, total_amount, order_status, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            // 'issssdsss' là chuỗi định dạng cho các tham số (integer, string, string, string, string, double, string, string, string)
            $stmt_order->bind_param("issssdsss", $user_id, $customer_name_post, $customer_email_post, $customer_phone_post, $shipping_address_post, $total_amount, $order_status, $payment_method, $payment_status);
            $stmt_order->execute();
            $order_id = $conn->insert_id; // Lấy ID của đơn hàng vừa được tạo
            $stmt_order->close();

            // 2. Chèn dữ liệu vào bảng `order_items` (lưu chi tiết từng sản phẩm trong đơn hàng)
            // và cập nhật số lượng tồn kho trong bảng `products`
            foreach ($_SESSION['cart'] as $product_id => $item) {
                // Lấy lại giá sản phẩm và số lượng tồn kho từ CSDL tại thời điểm đặt hàng
                // Điều này quan trọng để đảm bảo giá và tồn kho là chính xác nhất
                $stmt_product_data = $conn->prepare("SELECT price, sale_price, stock_quantity FROM products WHERE id = ?");
                $stmt_product_data->bind_param("i", $product_id);
                $stmt_product_data->execute();
                $product_data = $stmt_product_data->get_result()->fetch_assoc();
                $stmt_product_data->close();

                // Nếu sản phẩm không tồn tại trong CSDL (đã bị xóa), báo lỗi
                if (!$product_data) {
                    throw new Exception("Sản phẩm có ID " . $product_id . " không tồn tại. Đơn hàng không thể tạo.");
                }

                // Xác định giá sản phẩm tại thời điểm đặt hàng (có thể là giá khuyến mãi)
                $price_at_order = ($product_data['sale_price'] !== NULL && $product_data['sale_price'] < $product_data['price']) ? $product_data['sale_price'] : $product_data['price'];

                // Kiểm tra lại số lượng tồn kho ngay trước khi đặt hàng để tránh trường hợp sản phẩm hết trong tích tắc
                if ($item['quantity'] > $product_data['stock_quantity']) {
                    throw new Exception("Sản phẩm **" . htmlspecialchars($item['name']) . "** không đủ số lượng tồn kho. Chỉ còn **" . $product_data['stock_quantity'] . "** sản phẩm.");
                }

                // Chèn chi tiết sản phẩm vào bảng order_items
                $stmt_item = $conn->prepare("INSERT INTO order_items (order_id, product_id, quantity, price_at_order) VALUES (?, ?, ?, ?)");
                $stmt_item->bind_param("iiid", $order_id, $product_id, $item['quantity'], $price_at_order);
                $stmt_item->execute();
                $stmt_item->close();

                // Cập nhật số lượng tồn kho trong bảng products (trừ đi số lượng đã đặt)
                $stmt_update_stock = $conn->prepare("UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?");
                $stmt_update_stock->bind_param("ii", $item['quantity'], $product_id);
                $stmt_update_stock->execute();
                $stmt_update_stock->close();
            }

            $conn->commit(); // Nếu tất cả các bước trên thành công, hoàn tất giao dịch
            unset($_SESSION['cart']); // Xóa giỏ hàng sau khi đặt hàng thành công
            unset($_SESSION['form_data_checkout']); // Xóa dữ liệu form đã lưu

            $_SESSION['message'] = ['type' => 'success', 'text' => 'Đơn hàng của bạn đã được đặt thành công! Mã đơn hàng: **#' . $order_id . '**'];
            header("Location: index.php"); // Chuyển hướng về trang chủ
            exit();

        } catch (Exception $e) {
            $conn->rollback(); // Nếu có bất kỳ lỗi nào xảy ra, hoàn tác tất cả các thay đổi trong giao dịch
            $_SESSION['message'] = ['type' => 'error', 'text' => 'Có lỗi xảy ra khi đặt hàng: ' . $e->getMessage() . '. Vui lòng thử lại.'];
            // Lưu lại dữ liệu form đã nhập để người dùng không phải nhập lại
            $_SESSION['form_data_checkout'] = $_POST;
            header("Location: checkout.php"); // Tải lại trang để hiển thị lỗi
            exit();
        }
    }
}

// Lấy lại dữ liệu form đã nhập nếu có lỗi trước đó để người dùng không phải nhập lại
$old_customer_name = htmlspecialchars($_SESSION['form_data_checkout']['customer_name'] ?? $customer_name);
$old_customer_email = htmlspecialchars($_SESSION['form_data_checkout']['customer_email'] ?? $customer_email);
$old_customer_phone = htmlspecialchars($_SESSION['form_data_checkout']['customer_phone'] ?? $customer_phone);
$old_shipping_address = htmlspecialchars($_SESSION['form_data_checkout']['shipping_address'] ?? $shipping_address);
unset($_SESSION['form_data_checkout']); // Xóa dữ liệu form đã lưu sau khi lấy ra

?>

<h2>Thanh toán</h2>

<div class="form-container">
    <h3>Thông tin giao hàng</h3>
    <form action="checkout.php" method="POST">
        <div class="form-group">
            <label for="customer_name">Họ và tên (<span style="color: red;">*</span>):</label>
            <input type="text" id="customer_name" name="customer_name" value="<?php echo $old_customer_name; ?>" required>
        </div>
        <div class="form-group">
            <label for="customer_email">Email:</label>
            <input type="email" id="customer_email" name="customer_email" value="<?php echo $old_customer_email; ?>">
        </div>
        <div class="form-group">
            <label for="customer_phone">Số điện thoại (<span style="color: red;">*</span>):</label>
            <input type="tel" id="customer_phone" name="customer_phone" value="<?php echo $old_customer_phone; ?>" required>
        </div>
        <div class="form-group">
            <label for="shipping_address">Địa chỉ giao hàng (<span style="color: red;">*</span>):</label>
            <textarea id="shipping_address" name="shipping_address" rows="4" required><?php echo $old_shipping_address; ?></textarea>
        </div>

        <h3>Phương thức thanh toán</h3>
        <div class="form-group">
            <input type="radio" id="cod" name="payment_method" value="COD" checked>
            <label for="cod">Thanh toán khi nhận hàng (COD)</label><br>
            </div>

        <h3>Tổng tiền giỏ hàng: <span style="color: #dc3545;"><?php echo number_format($total_amount, 0, ',', '.'); ?>đ</span></h3>

        <div class="form-group">
            <button type="submit">Đặt hàng</button>
        </div>
    </form>
</div>

<?php
require_once 'includes/footer.php'; // Nhúng footer của trang
$conn->close(); // Đóng kết nối CSDL
?>