import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart'; // Import Provider Cart
import '../checkout/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // ================= STATE VARIABLES =================
  int _selectedStorage = 0;
  int _selectedColor = 0;
  int _quantity = 1;
  int _selectedImageIndex = 0;
  late List<String> _productImages;

  @override
  void initState() {
    super.initState();
    // LOGIKA GALERI:
    if (widget.product['images'] != null) {
      _productImages = List<String>.from(widget.product['images']);
    } else {
      String mainImg = widget.product['image'];
      _productImages = [mainImg, mainImg, mainImg, mainImg];
    }
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
    // Warna UI
    const orange = Color(0xFFFF6B35);
    const darkBar = Color(0xFF262626);
    const lightGrey = Color(0xFFE3E3E3);

    // Persiapan Data Pilihan (Fallback jika data kosong)
    final List<String> storageOptions = widget.product['storage'] is List
        ? List<String>.from(widget.product['storage'])
        : ['128 GB', '256 GB', '512 GB', '1 TB'];

    final List<Color> colorOptions = widget.product['colors'] is List
        ? List<Color>.from(widget.product['colors'])
        : [Colors.black, Colors.grey, Colors.white];

    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // ================= 1. HEADER =================
            Container(
              color: darkBar,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: orange,
                      radius: 18,
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black87, size: 20),
                          hintText: 'Cari produk...',
                          hintStyle: TextStyle(color: orange, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Cart dengan Badge (Optional)
                  Consumer<CartProvider>(
                    builder: (context, cart, child) => Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart, color: orange, size: 26),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                        if (cart.items.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                '${cart.items.length}', 
                                style: const TextStyle(fontSize: 10, color: Colors.white)
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= 2. KONTEN SCROLL =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Judul Produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.product['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),

                    // Info SKU & Stok
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("SKU: 821892182921",
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                              const Text("Bebas Ongkir",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          const Text("Stok Tersedia",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8BC34A))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- GAMBAR UTAMA ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 320,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Hero(
                          tag: widget.product['name'],
                          child: Image.asset(
                            _productImages[_selectedImageIndex],
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- THUMBNAIL STRIP ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.chevron_left, size: 20, color: Colors.black54),
                          ...List.generate(_productImages.length, (index) {
                            bool isSelected = _selectedImageIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedImageIndex = index),
                              child: Container(
                                width: 40,
                                height: 50,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isSelected ? orange : Colors.transparent,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Image.asset(_productImages[index],
                                    fit: BoxFit.contain),
                              ),
                            );
                          }),
                          const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Harga
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatCurrency(widget.product['price']),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Pilihan Warna
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Warna",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Row(
                            children: colorOptions.asMap().entries.map((entry) {
                              int idx = entry.key;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = idx),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: entry.value,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 1),
                                  ),
                                  child: idx == _selectedColor
                                      ? const Icon(Icons.check, color: Colors.white)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pilihan Kapasitas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kapasitas",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Column(
                            children: storageOptions.asMap().entries.map((entry) {
                              int idx = entry.key;
                              bool isSelected = idx == _selectedStorage;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedStorage = idx),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? Colors.black : Colors.black26,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Jumlah (Quantity)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Jumlah",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20, color: Colors.black),
                                  onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                Text('$_quantity',
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20, color: Colors.black),
                                  onPressed: () => setState(() => _quantity++),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ================= 3. BOTTOM BAR =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatCurrency(widget.product['price']),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // TOMBOL + KERANJANG
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // 1. Ambil Nama Storage
                            String storageName = storageOptions.isNotEmpty 
                                ? storageOptions[_selectedStorage] 
                                : "128 GB";

                            // 2. Ambil Nama Warna (Manual karena warna asli berupa Color object)
                            String colorName = "Warna ${_selectedColor + 1}";
                            
                            // 3. Gabungkan Varian String
                            String variantName = "$storageName, $colorName";

                            // 4. Buat Object CartItem
                            final newItem = CartItem(
                              name: widget.product['name'],
                              basePrice: widget.product['price'],
                              price: widget.product['price'],
                              image: widget.product['image'],
                              variant: variantName, // Varian gabungan
                              selectedStorage: storageName,
                              selectedColorName: colorName,
                              quantity: _quantity,
                            );

                            // 5. PANGGIL PROVIDER (INI KUNCINYA)
                            Provider.of<CartProvider>(context, listen: false).addItem(newItem);

                            // 6. Notifikasi Sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasil menambahkan ${widget.product['name']}"),
                                backgroundColor: darkBar,
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: 'LIHAT',
                                  textColor: orange,
                                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown,
                            side: const BorderSide(color: Colors.brown, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("+ Keranjang",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // TOMBOL BELI LANGSUNG
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Persiapan Data untuk Checkout Langsung (Tanpa masuk keranjang)
                            String storageName = storageOptions.isNotEmpty 
                                ? storageOptions[_selectedStorage] 
                                : "128 GB";
                            String colorName = "Warna ${_selectedColor + 1}";
                            String variantName = "$storageName, $colorName";

                            // Buat Item sementara hanya untuk dilempar ke CheckoutScreen
                            final tempItem = CartItem(
                              name: widget.product['name'],
                              basePrice: widget.product['price'],
                              price: widget.product['price'],
                              image: widget.product['image'],
                              variant: variantName,
                              quantity: _quantity,
                              isSelected: true, // Auto select agar terhitung di checkout
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  cartItems: [tempItem],
                                  totalPrice: tempItem.price * tempItem.quantity,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE86E25),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Beli Langsung",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}