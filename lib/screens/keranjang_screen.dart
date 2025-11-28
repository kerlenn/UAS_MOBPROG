import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Pastikan path ini benar
import 'checkout/checkout_screen.dart'; // Pastikan path ini benar

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  // Opsi storage untuk fitur edit
  final List<String> storageOptions = ['128 GB', '256 GB', '512 GB', '1 TB'];

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Modal Edit Varian (Ganti Storage di dalam keranjang)
  void _showEditVariantDialog(BuildContext context, int index, CartItem item) {
    String tempStorage = item.selectedStorage;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ubah Varian: ${item.name}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text("Pilih Kapasitas:"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: storageOptions.map((storage) {
                      return ChoiceChip(
                        label: Text(storage),
                        selected: tempStorage == storage,
                        selectedColor: const Color(0xFFFF6B35),
                        labelStyle: TextStyle(
                          color: tempStorage == storage ? Colors.white : Colors.black,
                        ),
                        onSelected: (selected) {
                          setModalState(() => tempStorage = storage);
                        },
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35), 
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        // Hitung selisih harga simpel (Simulasi)
                        int priceDiff = 0;
                        if (tempStorage == '256 GB') priceDiff = 1000000;
                        if (tempStorage == '512 GB') priceDiff = 2000000;
                        if (tempStorage == '1 TB') priceDiff = 4000000;
                        
                        // Panggil Provider untuk update data
                        Provider.of<CartProvider>(context, listen: false)
                            .updateVariant(index, tempStorage, item.basePrice + priceDiff);
                        
                        Navigator.pop(context);
                      },
                      child: const Text("Simpan Perubahan"),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);

    // GUNAKAN CONSUMER AGAR UI UPDATE OTOMATIS SAAT DATA BERUBAH
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          
          // 1. HEADER (APP BAR)
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: orange), 
              onPressed: () => Navigator.pop(context)
            ),
            title: const Text(
              "Keranjang Saya", 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
            actions: [
              // Tombol Hapus Sampah di pojok kanan atas
              if (cart.items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                     // Fitur hapus semua atau hapus yg dipilih
                     if (cart.items.any((element) => element.isSelected)) {
                       cart.removeSelectedItems();
                     } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("Pilih barang yang ingin dihapus dulu"))
                       );
                     }
                  },
                )
            ],
          ),

          // 2. ISI KERANJANG (BODY)
          body: cart.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text(
                        "Keranjang masih kosong", 
                        style: TextStyle(color: Colors.grey, fontSize: 16)
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Yuk belanja gadget impianmu!", 
                        style: TextStyle(color: Colors.grey, fontSize: 12)
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05), 
                            blurRadius: 5, 
                            offset: const Offset(0, 2)
                          )
                        ]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          Checkbox(
                            value: item.isSelected,
                            activeColor: orange,
                            onChanged: (val) => cart.toggleSelection(index, val),
                          ),
                          
                          // Gambar Produk
                          Container(
                            width: 70, height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[100], 
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Image.asset(
                              item.image, 
                              fit: BoxFit.contain, 
                              errorBuilder: (c,e,s)=>const Icon(Icons.image)
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Info Produk & Edit
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                
                                // Tombol Edit Varian Kecil
                                GestureDetector(
                                  onTap: () => _showEditVariantDialog(context, index, item),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100], 
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.variant, 
                                          style: const TextStyle(fontSize: 11, color: Colors.black87)
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black54)
                                      ],
                                    ),
                                  ),
                                ),

                                Text(
                                  formatCurrency(item.price), 
                                  style: const TextStyle(color: orange, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                          
                          // Counter (+ -)
                          Column(
                            children: [
                              // Tombol Hapus Item
                              InkWell(
                                onTap: () => cart.removeItem(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.close, color: Colors.grey, size: 18),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100], 
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => cart.updateQuantity(index, -1), 
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      )
                                    ),
                                    Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    InkWell(
                                      onTap: () => cart.updateQuantity(index, 1), 
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text("+", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
          
          // 3. BOTTOM BAR (TOTAL & CHECKOUT)
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5)
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         Checkbox(
                            value: cart.isAllSelected,
                            activeColor: orange,
                            onChanged: (val) => cart.toggleSelectAll(val ?? false),
                          ),
                          const Text("Semua"),
                      ],
                    ),
                    Text(
                      "Total: ${formatCurrency(cart.totalPrice)}", 
                      style: const TextStyle(color: orange, fontSize: 16, fontWeight: FontWeight.bold)
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (cart.totalPrice > 0) {
                      final selectedItems = cart.items.where((i) => i.isSelected).toList();
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            cartItems: selectedItems, 
                            totalPrice: cart.totalPrice,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pilih barang dulu!"))
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: Text("Checkout (${cart.items.where((e)=>e.isSelected).length})"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}