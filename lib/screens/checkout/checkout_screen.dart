import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Wajib import provider

// Import Provider dan Model yang dibutuhkan
import '../../providers/cart_provider.dart';  
import '../../providers/order_provider.dart'; 
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  // Menerima List dari Keranjang (Opsional)
  final List<CartItem>? cartItems;
  final int? totalPrice;

  // Menerima Single Product dari Beli Langsung (Opsional)
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
    // Data Dummy User
    _nameController.text = "Yusuf Abdur";
    _phoneController.text = "(+62) 857 1828 6519";
    _addressController.text = "Jalan Dahlia IV Blok ## No. ##, Jakarta";
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);

    // --- LOGIKA GABUNGAN DATA (Keranjang vs Beli Langsung) ---
    List<CartItem> displayItems = [];

    if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
      // Kasus 1: Dari Keranjang (Banyak Barang)
      displayItems = widget.cartItems!;
    } else if (widget.product != null) {
      // Kasus 2: Beli Langsung (1 Barang -> Konversi ke CartItem sementara)
      displayItems.add(CartItem(
        name: widget.product!['name'],
        basePrice: widget.product!['price'],
        price: widget.product!['price'],
        image: widget.product!['image'],
        variant: widget.variant ?? "Default",
        quantity: widget.quantity ?? 1,
      ));
    }

    // Hitung Total jika belum dikirim
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
            // 1. Alamat Pengiriman
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Alamat Pengiriman", style: TextStyle(color: orange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: _nameController, decoration: const InputDecoration(isDense: true, hintText: "Nama Penerima")),
                  TextField(controller: _phoneController, decoration: const InputDecoration(isDense: true, hintText: "Nomor Telepon")),
                  TextField(controller: _addressController, maxLines: 2, decoration: const InputDecoration(isDense: true, hintText: "Alamat Lengkap")),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Produk Dipesan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Produk Dipesan", style: TextStyle(color: orange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Tampilkan semua item
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

            // 3. Metode Pembayaran (Bank)
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

      // 4. Tombol Buat Pesanan
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
            // A. Validasi
            if (_addressController.text.isEmpty || _nameController.text.isEmpty) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi alamat pengiriman!")));
               return;
            }

            // B. Simpan ke OrderProvider (Logika Temanmu)
            // Kita harus cek apakah OrderProvider sudah ada/didaftarkan di main.dart
            // Jika belum ada filenya, bagian ini bisa di-comment dulu.
            try {
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              
              // Konversi CartItem ke format Map untuk OrderProvider
              final List<Map<String, dynamic>> orderItems = displayItems.map((item) => {
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
                'image': item.image,
                'variant': item.variant,
              }).toList();

              orderProvider.addOrder(
                cartItems: orderItems,
                paymentMethod: 'Transfer $_selectedBank',
                shippingAddress: _addressController.text,
                recipientName: _nameController.text,
                recipientPhone: _phoneController.text,
              );
            } catch (e) {
              // Abaikan error jika OrderProvider belum siap
              print("Order Provider belum siap: $e");
            }

            // C. Tampilkan Pop-up Sukses -> Lalu ke Payment
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: const Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                    SizedBox(height: 12),
                    Text("Pesanan Dibuat!", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                content: const Text("Silakan lakukan pembayaran.", textAlign: TextAlign.center),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: orange, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(ctx); // Tutup Dialog
                        
                        // Pindah ke Payment Screen
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
                      child: const Text("Bayar Sekarang"),
                    ),
                  )
                ],
              ),
            );
          },
          child: const Text("Buat Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}