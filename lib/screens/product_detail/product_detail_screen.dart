import 'package:flutter/material.dart';

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
  // State untuk Pilihan
  int _selectedStorage = 0;
  int _selectedColor = 0;
  int _quantity = 1;
  
  // State untuk Galeri Gambar
  int _selectedImageIndex = 0; 
  late List<String> _productImages;

  @override
  void initState() {
    super.initState();
    // LOGIKA GALERI:
    // Jika di data 'product' nanti ada key ['images'] (list foto banyak), kita pakai itu.
    // Jika tidak ada, kita pakai foto utama ('image') dan kita duplikasi 4 kali 
    // supaya terlihat seperti ada galerinya (untuk keperluan UI demo).
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
    const orange = Color(0xFFFF6B35);
    const darkBar = Color(0xFF262626);
    const lightGrey = Color(0xFFE3E3E3);

    final List<String> storageOptions =
        widget.product['storage'] ?? ['256 GB', '512 GB', '1 TB', '2 TB'];
    final List<Color> colorOptions = widget.product['colors'] != null
        ? List<Color>.from(widget.product['colors'])
        : [Colors.orange, Colors.blue, Colors.white];

    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // ================= 1. HEADER (FIXED) =================
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
                          hintText: 'Search Something Here...',
                          hintStyle: TextStyle(color: orange, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.shopping_cart, color: orange, size: 26),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.product['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("SKU: 821892182921", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                              const Text("Bebas Ongkir", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                          const Text("Stok Tersedia", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8BC34A))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- GAMBAR UTAMA (DINAMIS) ---
                    // Gambar berubah sesuai _selectedImageIndex
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
                          // Menggunakan gambar dari List berdasarkan index yang dipilih
                          child: Image.asset(
                            _productImages[_selectedImageIndex], 
                            fit: BoxFit.contain,
                            errorBuilder: (c,e,s) => const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- THUMBNAIL STRIP (INTERAKTIF) ---
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
                          // Generate Thumbnail dari List _productImages
                          ...List.generate(_productImages.length, (index) {
                            bool isSelected = _selectedImageIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImageIndex = index;
                                });
                              },
                              child: Container(
                                width: 40, height: 50,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  // Border Merah/Pink jika dipilih, Transparan jika tidak
                                  border: Border.all(
                                    color: isSelected ? Colors.pinkAccent : Colors.transparent, 
                                    width: 1.5
                                  ),
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Image.asset(
                                  _productImages[index], 
                                  fit: BoxFit.contain
                                ),
                              ),
                            );
                          }),
                          const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatCurrency(widget.product['price']),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Warna", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kapasitas", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Column(
                            children: storageOptions.asMap().entries.map((entry) {
                              int idx = entry.key;
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
                                      color: idx == _selectedStorage ? Colors.black : Colors.black26,
                                      width: idx == _selectedStorage ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Jumlah", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
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
                                Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Detail Produk", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product['description'] ?? "Deskripsi produk belum tersedia.", 
                                  style: const TextStyle(fontSize: 11, color: Colors.black, height: 1.3),
                                ),
                                const SizedBox(height: 12),
                                const Text("Isi Kotak:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                                const Text("• Unit Smartphone\n• Kabel USB-C ke USB-C\n• Buku manual dan dokumentasi lain.", 
                                  style: TextStyle(fontSize: 11, color: Colors.black, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown,
                            side: const BorderSide(color: Colors.brown, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("+ Keranjang", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE86E25),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Beli Langsung", style: TextStyle(fontWeight: FontWeight.bold)),
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