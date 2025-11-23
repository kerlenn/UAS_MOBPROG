import 'package:flutter/material.dart';

// ==================== MODEL DATA & GLOBAL VARIABLE ====================
// Kita taruh di sini agar bisa diakses dari file lain
class CartItem {
  final String name;
  final int price;
  final String image;
  final String variant; 
  int quantity;
  bool isSelected;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.variant = "Standard",
    this.quantity = 1,
    this.isSelected = false,
  });
}

// VARIABLE GLOBAL (Keranjang Belanjaan)
List<CartItem> globalCartItems = [];

// ==================== SCREEN UI ====================
class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  
  // Format Rupiah
  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Hitung Total Harga Barang Tercentang
  int get totalHarga {
    int total = 0;
    for (var item in globalCartItems) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  // Cek apakah "Select All" aktif
  bool get isAllSelected {
    if (globalCartItems.isEmpty) return false;
    return globalCartItems.every((item) => item.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Abu muda
      
      // HEADER
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626), // Hitam
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)), // Oranye
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
           height: 40,
           decoration: BoxDecoration(
             color: Colors.white, 
             borderRadius: BorderRadius.circular(20)
           ),
           child: const TextField(
             decoration: InputDecoration(
               hintText: "Search Something Here...", 
               prefixIcon: Icon(Icons.search, color: Colors.grey), 
               border: InputBorder.none,
               contentPadding: EdgeInsets.symmetric(vertical: 9),
             ),
           ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: Text("Keranjang Saya", style: TextStyle(fontSize: 14))),
          )
        ],
      ),

      // ISI KERANJANG
      body: globalCartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  const Text("Keranjang masih kosong", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: globalCartItems.length,
              itemBuilder: (context, index) {
                final item = globalCartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))
                    ]
                  ),
                  child: Row(
                    children: [
                      // Checkbox
                      Checkbox(
                        value: item.isSelected,
                        activeColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() {
                            item.isSelected = val ?? false;
                          });
                        },
                      ),
                      
                      // Gambar Produk
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(item.image, fit: BoxFit.contain,
                          errorBuilder: (c,e,s) => const Icon(Icons.image, color: Colors.grey)),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Info Produk
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(item.variant, 
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 8),
                            Text(formatCurrency(item.price), 
                              style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      
                      // Counter (+ -)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  } else {
                                    // Hapus item jika jumlah jadi 0 (Opsional)
                                    globalCartItems.removeAt(index);
                                  }
                                });
                              },
                              child: const Padding(padding: EdgeInsets.all(8.0), child: Text("-", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  item.quantity++;
                                });
                              },
                              child: const Padding(padding: EdgeInsets.all(8.0), child: Text("+", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),

      // BOTTOM BAR (CHECKOUT)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris Select All & Hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isAllSelected,
                      activeColor: const Color(0xFFFF6B35),
                      onChanged: (val) {
                        setState(() {
                          bool newValue = val ?? false;
                          for (var item in globalCartItems) {
                            item.isSelected = newValue;
                          }
                        });
                      },
                    ),
                    const Text("Semua"),
                  ],
                ),
                if (globalCartItems.any((e) => e.isSelected))
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        globalCartItems.removeWhere((item) => item.isSelected);
                      });
                    }, 
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    label: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  )
              ],
            ),
            
            const Divider(),
            
            // Baris Total & Tombol Checkout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total:", style: TextStyle(color: Colors.grey)),
                    Text(formatCurrency(totalHarga), 
                      style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (totalHarga > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Berhasil Checkout!"), backgroundColor: Colors.green),
                      );
                      setState(() {
                        globalCartItems.removeWhere((item) => item.isSelected);
                      });
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pilih barang dulu."), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: Text("Checkout (${globalCartItems.where((e)=>e.isSelected).length})"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}