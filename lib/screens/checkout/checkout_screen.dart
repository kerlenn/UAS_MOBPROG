import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String variant; // Gabungan Warna & Kapasitas
  final int quantity;

  const CheckoutScreen({
    super.key,
    required this.product,
    required this.variant,
    required this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Controller untuk input alamat
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // State untuk pilihan bank
  String _selectedBank = 'BCA';
  final List<String> _banks = ['BCA', 'Mandiri', 'SeaBank', 'BNI', 'BSI'];

  @override
  void initState() {
    super.initState();
    // Default data dummy untuk alamat (bisa diedit user)
    _nameController.text = "Yusuf Abdur";
    _phoneController.text = "(+62) 857 1828 6519";
    _addressController.text = "Jalan Dahlia IV Blok ## No. ##, RT.##/RW.##, Cengkareng, KOTA JAKARTA BARAT - CENGKARENG, DKI JAKARTA, ID 11720";
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Helper format currency
  String formatCurrency(dynamic amount) {
    int price = amount is int
        ? amount
        : int.tryParse(amount.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final str = price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $str';
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total harga
    int unitPrice = widget.product['price'] is int 
        ? widget.product['price'] 
        : int.tryParse(widget.product['price'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int totalPrice = unitPrice * widget.quantity;

    const orange = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              errorBuilder: (c, e, s) => const Icon(Icons.store, color: orange),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 24, color: Colors.grey[300]),
            const SizedBox(width: 12),
            const Text(
              "Checkout",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= 1. ALAMAT PENGIRIMAN (INPUT) =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: orange, size: 20),
                      SizedBox(width: 8),
                      Text("Alamat Pengiriman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: orange)),
                    ],
                  ),
                  const Divider(height: 24),
                  // Input Nama Penerima
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "Nama Penerima",
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Input No HP
                  TextField(
                    controller: _phoneController,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "Nomor Telepon",
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Input Alamat Lengkap
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan alamat lengkap pengiriman...",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= 2. PRODUK DIPESAN =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Produk Dipesan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: orange)),
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto Produk
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            widget.product['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Detail Produk
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.variant,
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatCurrency(unitPrice),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text("x${widget.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Pesanan:", style: TextStyle(fontSize: 14)),
                      Text(
                        formatCurrency(totalPrice),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= 3. TRANSFER BANK =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: orange)),
                  const SizedBox(height: 4),
                  const Text("Transfer Bank (Verifikasi Manual)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(height: 24),
                  
                  ..._banks.map((bank) {
                    return RadioListTile<String>(
                      title: Text(bank, style: const TextStyle(fontWeight: FontWeight.w600)),
                      value: bank,
                      groupValue: _selectedBank,
                      activeColor: orange,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedBank = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            
            const SizedBox(height: 100), // Space untuk bottom bar
          ],
        ),
      ),

      // ================= 4. BOTTOM BAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Pembayaran", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    formatCurrency(totalPrice),
                    style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Validasi Input
                    if(_addressController.text.isEmpty || _nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mohon lengkapi alamat pengiriman")),
                      );
                      return;
                    }

                    // 2. Tampilkan Pop-up (Dialog) Sukses
                    showDialog(
                      context: context,
                      barrierDismissible: false, // User tidak bisa tutup paksa dengan klik luar
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        title: Column(
                          children: const [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                            SizedBox(height: 12),
                            Text("Pesanan Dibuat!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                        content: const Text(
                          "Pesanan Anda berhasil diproses.\nSilakan lanjutkan untuk pelunasan.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        actionsPadding: const EdgeInsets.all(16),
                        actions: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35), // Warna Orange
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx); // 1. Tutup Pop-up
                                
                                // 2. Pindah ke Halaman Pembayaran
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      totalPrice: totalPrice,
                                      selectedBank: _selectedBank,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Bayar Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  child: const Text("Buat Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}