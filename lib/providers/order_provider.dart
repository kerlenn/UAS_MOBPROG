import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  // Get orders sorted by date (newest first)
  List<Order> get sortedOrders {
    final sorted = List<Order>.from(_orders);
    sorted.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return sorted;
  }

  // Add new order (dipanggil dari checkout saat buat pesanan)
  void addOrder({
    required List<Map<String, dynamic>> cartItems,
    required String paymentMethod,
    required String shippingAddress,
    String? recipientName,
    String? recipientPhone,
  }) {
    // Generate order ID
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    // Convert cart items to order items
    final orderItems = cartItems.map((item) {
      return OrderItem(
        productName: item['name'],
        price: item['price'],
        quantity: item['quantity'] ?? 1,
        image: item['image'],
        brand: item['brand'] ?? 'Unknown',
      );
    }).toList();

    // Calculate total
    final totalAmount = orderItems.fold(0, (sum, item) => sum + item.totalPrice);

    // Format shipping address dengan nama dan telepon jika ada
    String fullAddress = shippingAddress;
    if (recipientName != null && recipientPhone != null) {
      fullAddress = '$recipientName | $recipientPhone\n$shippingAddress';
    }

    // Create order
    final order = Order(
      orderId: orderId,
      orderDate: DateTime.now(),
      items: orderItems,
      totalAmount: totalAmount,
      status: 'pending',
      paymentMethod: paymentMethod,
      shippingAddress: fullAddress,
    );

    _orders.add(order);
    notifyListeners();
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      final oldOrder = _orders[index];
      _orders[index] = Order(
        orderId: oldOrder.orderId,
        orderDate: oldOrder.orderDate,
        items: oldOrder.items,
        totalAmount: oldOrder.totalAmount,
        status: newStatus,
        paymentMethod: oldOrder.paymentMethod,
        shippingAddress: oldOrder.shippingAddress,
      );
      notifyListeners();
    }
  }

  // Cancel order
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, 'cancelled');
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Clear all orders (for testing)
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  // Add dummy orders for testing
  void addDummyOrders() {
    final dummyOrders = [
      Order(
        orderId: 'ORD001',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        items: [
          OrderItem(
            productName: 'Apple iPhone 17 Pro Max',
            price: 25749000,
            quantity: 1,
            image: 'assets/images/products/iphone_17_pro_max.jpg',
            brand: 'Apple',
          ),
        ],
        totalAmount: 25749000,
        status: 'delivered',
        paymentMethod: 'Transfer Bank',
        shippingAddress: 'Jl. Sudirman No. 123, Jakarta',
      ),
      Order(
        orderId: 'ORD002',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        items: [
          OrderItem(
            productName: 'Samsung Galaxy S25',
            price: 14999000,
            quantity: 1,
            image: 'assets/images/products/samsung_s25.jpg',
            brand: 'Samsung',
          ),
          OrderItem(
            productName: 'Xiaomi Redmi Note 13',
            price: 2799000,
            quantity: 2,
            image: 'assets/images/products/redmi_note_13.jpg',
            brand: 'Xiaomi',
          ),
        ],
        totalAmount: 20597000,
        status: 'shipped',
        paymentMethod: 'COD',
        shippingAddress: 'Jl. Gatot Subroto No. 456, Jakarta',
      ),
      Order(
        orderId: 'ORD003',
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
        items: [
          OrderItem(
            productName: 'Google Pixel 9 Pro',
            price: 25790000,
            quantity: 1,
            image: 'assets/images/products/pixel_9.jpg',
            brand: 'Google',
          ),
        ],
        totalAmount: 25790000,
        status: 'processing',
        paymentMethod: 'E-Wallet',
        shippingAddress: 'Jl. Thamrin No. 789, Jakarta',
      ),
    ];

    _orders.addAll(dummyOrders);
    notifyListeners();
  }
}
