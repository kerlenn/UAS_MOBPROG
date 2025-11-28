import 'package:flutter/material.dart';

// Model Data CartItem
class CartItem {
  final String name;
  final int basePrice;
  int price;
  final String image;
  String variant;
  String selectedStorage;
  String selectedColorName;
  int quantity;
  bool isSelected;

  CartItem({
    required this.name,
    required this.basePrice,
    required this.price,
    required this.image,
    required this.variant,
    this.selectedStorage = "128 GB",
    this.selectedColorName = "Default",
    this.quantity = 1,
    this.isSelected = false,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Tambah Barang
  void addItem(CartItem newItem) {
    _items.add(newItem);
    notifyListeners();
  }

  // Hapus Barang
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Hapus Barang yang dicentang (Checkout selesai)
  void removeSelectedItems() {
    _items.removeWhere((item) => item.isSelected);
    notifyListeners();
  }

  // Update Checkbox
  void toggleSelection(int index, bool? value) {
    _items[index].isSelected = value ?? false;
    notifyListeners();
  }

  // Update Quantity
  void updateQuantity(int index, int change) {
    final item = _items[index];
    if (change > 0) {
      item.quantity++;
    } else if (change < 0 && item.quantity > 1) {
      item.quantity--;
    }
    notifyListeners();
  }

  // Update Varian (Edit di Keranjang)
  void updateVariant(int index, String newStorage, int newPrice) {
    final item = _items[index];
    item.selectedStorage = newStorage;
    item.price = newPrice;
    item.variant = "Warna ${item.selectedColorName}, $newStorage";
    notifyListeners();
  }

  // Hitung Total Harga
  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  // Cek Select All
  bool get isAllSelected {
    if (_items.isEmpty) return false;
    return _items.every((item) => item.isSelected);
  }

  // Toggle Select All
  void toggleSelectAll(bool value) {
    for (var item in _items) {
      item.isSelected = value;
    }
    notifyListeners();
  }
}