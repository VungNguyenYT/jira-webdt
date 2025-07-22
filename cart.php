<?php
require_once 'includes/db.php';
require_once 'includes/header.php';
?>

<h2 style="text-align: center; color: #333;">Giỏ hàng của bạn</h2>

<?php if (!empty($_SESSION['cart'])): ?>
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <thead>
            <tr style="background-color: #f2f2f2;">
                <th style="padding: 10px;">Sản phẩm</th>
                <th style="padding: 10px;">Giá</th>
                <th style="padding: 10px;">Số lượng</th>
                <th style="padding: 10px;">Tổng</th>
            </tr>
        </thead>
        <tbody>
            <?php $total = 0; foreach ($_SESSION['cart'] as $id => $item): 
                $subtotal = $item['price'] * $item['quantity'];
                $total += $subtotal;
            ?>
            <tr>
                <td style="padding: 10px;"><?php echo htmlspecialchars($item['name']); ?></td>
                <td style="padding: 10px;"><?php echo number_format($item['price'], 0, ',', '.'); ?>đ</td>
                <td style="padding: 10px;"><?php echo $item['quantity']; ?></td>
                <td style="padding: 10px;"><?php echo number_format($subtotal, 0, ',', '.'); ?>đ</td>
            </tr>
            <?php endforeach; ?>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" style="text-align: right; font-weight: bold; padding: 10px;">Tổng cộng:</td>
                <td style="padding: 10px;"><?php echo number_format($total, 0, ',', '.'); ?>đ</td>
            </tr>
        </tfoot>
    </table>
    <div style="text-align: right; margin-top: 20px;">
    <a href="checkout.php" style="background-color: #28a745; color: white; padding: 12px 20px; border-radius: 6px; font-size: 16px; text-decoration: none; display: inline-block; transition: background-color 0.3s ease;">Tiến hành thanh toán</a>
</div>

<?php else: ?>
    <p style="text-align: center; color: #777;">Giỏ hàng của bạn đang trống. <a href="index.php" style="color: #007bff;">Tiếp tục mua sắm</a>.</p>
<?php endif; ?>

<?php
require_once 'includes/footer.php';
$conn->close();
?>
