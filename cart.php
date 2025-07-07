<?php
require_once 'includes/db.php'; // Includes database connection and starts session
require_once 'includes/header.php'; // Includes the header for the page

// Handle updates to quantities or removal of items from the cart
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if the "Update Cart" button was clicked
    if (isset($_POST['update_cart'])) {
        // Loop through each product's quantity submitted via the form
        foreach ($_POST['quantity'] as $product_id => $quantity) {
            $product_id = intval($product_id); // Ensure product ID is an integer
            $quantity = intval($quantity);     // Ensure quantity is an integer

            // If quantity is 0 or less, remove the item from the cart
            if ($quantity <= 0) {
                if (isset($_SESSION['cart'][$product_id])) {
                    unset($_SESSION['cart'][$product_id]);
                    $_SESSION['message'] = ['type' => 'success', 'text' => 'Đã xóa sản phẩm khỏi giỏ hàng.'];
                }
            } else {
                // If the product exists in the cart, update its quantity
                if (isset($_SESSION['cart'][$product_id])) {
                    // Before updating, verify stock quantity from the database to prevent overselling
                    $stmt = $conn->prepare("SELECT stock_quantity FROM products WHERE id = ?");
                    $stmt->bind_param("i", $product_id);
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $product_info = $result->fetch_assoc();
                    $stmt->close();

                    // If product exists in DB and new quantity is within stock limits
                    if ($product_info && $quantity <= $product_info['stock_quantity']) {
                        $_SESSION['cart'][$product_id]['quantity'] = $quantity; // Update quantity in session
                        $_SESSION['message'] = ['type' => 'success', 'text' => 'Giỏ hàng đã được cập nhật.'];
                    } else {
                        // If new quantity exceeds stock, adjust to max available stock
                        if ($product_info) {
                            $_SESSION['cart'][$product_id]['quantity'] = $product_info['stock_quantity'];
                            $_SESSION['message'] = ['type' => 'error', 'text' => 'Số lượng sản phẩm "' . htmlspecialchars($_SESSION['cart'][$product_id]['name']) . '" vượt quá số lượng tồn kho. Đã tự động điều chỉnh về ' . $product_info['stock_quantity'] . '.'];
                        } else {
                            // If product does not exist in DB (e.g., deleted), remove from cart
                            unset($_SESSION['cart'][$product_id]);
                            $_SESSION['message'] = ['type' => 'error', 'text' => 'Sản phẩm không tồn tại và đã được xóa khỏi giỏ hàng.'];
                        }
                    }
                }
            }
        }
    } 
    // Check if a specific "Remove" button was clicked
    elseif (isset($_POST['remove_item'])) {
        $product_id_to_remove = intval($_POST['remove_item']); // Get the ID of the product to remove
        if (isset($_SESSION['cart'][$product_id_to_remove])) {
            unset($_SESSION['cart'][$product_id_to_remove]); // Remove the item from the session cart
            $_SESSION['message'] = ['type' => 'success', 'text' => 'Sản phẩm đã được xóa khỏi giỏ hàng.'];
        }
    }
    // Redirect back to the cart page after processing POST request to prevent re-submission issues
    header("Location: cart.php");
    exit();
}
?>

<h2>Giỏ hàng của bạn</h2>

<?php
// Check if the cart exists and is not empty
if (isset($_SESSION['cart']) && !empty($_SESSION['cart'])):
?>
    <form action="cart.php" method="POST">
        <table>
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Tổng</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $total_cart_amount = 0; // Initialize total cart amount
                // Loop through each item in the session cart
                foreach ($_SESSION['cart'] as $product_id => $item):
                    $subtotal = $item['price'] * $item['quantity']; // Calculate subtotal for the item
                    $total_cart_amount += $subtotal; // Add to overall cart total
                ?>
                <tr>
                    <td>
                        <img src="<?php echo htmlspecialchars($item['image_url']); ?>" alt="<?php echo htmlspecialchars($item['name']); ?>" style="width: 50px; height: 50px; object-fit: contain; vertical-align: middle;">
                        <?php echo htmlspecialchars($item['name']); ?>
                    </td>
                    <td><?php echo number_format($item['price'], 0, ',', '.') . 'đ'; ?></td>
                    <td>
                        <input type="number" name="quantity[<?php echo $product_id; ?>]" value="<?php echo $item['quantity']; ?>" min="0" style="width: 70px;">
                    </td>
                    <td><?php echo number_format($subtotal, 0, ',', '.') . 'đ'; ?></td>
                    <td>
                        <button type="submit" name="remove_item" value="<?php echo $product_id; ?>" title="Xóa sản phẩm này">Xóa</button>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" style="text-align: right;">Tổng cộng:</td>
                    <td><?php echo number_format($total_cart_amount, 0, ',', '.') . 'đ'; ?></td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
        <div style="text-align: right; margin-top: 20px;">
            <button type="submit" name="update_cart" class="button" style="background-color: #007bff;">Cập nhật giỏ hàng</button>
            <a href="checkout.php" class="button" style="background-color: #28a745; margin-left: 10px;">Tiến hành thanh toán</a>
        </div>
    </form>
<?php else: ?>
    <p>Giỏ hàng của bạn đang trống. Vui lòng <a href="index.php">quay lại trang chủ</a> để thêm sản phẩm.</p>
<?php endif; ?>

<?php
require_once 'includes/footer.php'; // Includes the footer
$conn->close(); // Closes the database connection
?>