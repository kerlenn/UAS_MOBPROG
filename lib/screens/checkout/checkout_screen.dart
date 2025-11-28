import 'package:flutter/material.dart';
import '../../providers/cart_provider.dart'; // <--- Import Model dari sini
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? cartItems; // Pakai Model CartItem
  final int? totalPrice;

  // Opsional: Beli Langsung
  final Map<String, dynamic>? product;
  final String? variant;
  final int? quantity;

  const CheckoutScreen({
    super.key,
    this.cartItems,
    this.totalPrice,
    this.product,
    this.variant,
    this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedBank = "BCA";
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = "Yusuf Abdur";
    _phoneController.text = "(+62) 857 1828 6519";
    _addressController.text = "Jalan Dahlia IV Blok ## No. ##, Jakarta";
  }

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);

    List<CartItem> displayItems = [];
    if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
      displayItems = widget.cartItems!;
    } else if (widget.product != null) {
      displayItems.add(CartItem(
        name: widget.product!['name'],
        basePrice: widget.product!['price'],
        price: widget.product!['price'],
        image: widget.product!['image'],
        variant: widget.variant ?? "Default",
        quantity: widget.quantity ?? 1,
      ));
    }

    int finalTotal = widget.totalPrice ?? 0;
    if (finalTotal == 0) {
      for (var item in displayItems) {
        finalTotal += item.price * item.quantity;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: orange),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alamat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Alamat Pengiriman", style: TextStyle(color: orange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: _nameController, decoration: const InputDecoration(isDense: true, hintText: "Nama")),
                  TextField(controller: _phoneController, decoration: const InputDecoration(isDense: true, hintText: "No HP")),
                  TextField(controller: _addressController, maxLines: 2, decoration: const InputDecoration(isDense: true, hintText: "Alamat")),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Produk
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Produk Dipesan", style: TextStyle(color: orange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...displayItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(item.variant, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              Text(formatCurrency(item.price), style: const TextStyle(color: orange, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Text("x${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Total: ${formatCurrency(finalTotal)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bank
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Metode Pembayaran", style: TextStyle(color: orange, fontWeight: FontWeight.bold)),
                  ...['BCA', 'Mandiri', 'BNI', 'SeaBank'].map((bank) => RadioListTile(
                    title: Text(bank),
                    value: bank,
                    groupValue: _selectedBank,
                    activeColor: orange,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _selectedBank = val.toString()),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  totalPrice: finalTotal,
                  selectedBank: _selectedBank,
                ),
              ),
            );
          },
          child: const Text("Buat Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}