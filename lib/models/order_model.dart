class OrderItem {
  final String productName;
  final int price;
  final int quantity;
  final String image;
  final String brand;

  OrderItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
    required this.brand,
  });

  int get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'image': image,
      'brand': brand,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'],
      price: json['price'],
      quantity: json['quantity'],
      image: json['image'],
      brand: json['brand'],
    );
  }
}

class Order {
  final String orderId;
  final DateTime orderDate;
  final List<OrderItem> items;
  final int totalAmount;
  final String status;
  final String paymentMethod;
  final String shippingAddress;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      orderDate: DateTime.parse(json['orderDate']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      shippingAddress: json['shippingAddress'],
    );
  }

  String getStatusText() {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'processing':
        return 'Sedang Diproses';
      case 'shipped':
        return 'Dalam Pengiriman';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Unknown';
    }
  }

  String getStatusColor() {
    switch (status) {
      case 'pending':
        return 'FFA726'; // Orange
      case 'processing':
        return '42A5F5'; // Blue
      case 'shipped':
        return '7E57C2'; // Purple
      case 'delivered':
        return '66BB6A'; // Green
      case 'cancelled':
        return 'EF5350'; // Red
      default:
        return '9E9E9E'; // Grey
    }
  }
}
