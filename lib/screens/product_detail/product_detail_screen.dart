import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart'; // Import Provider

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
  int _selectedStorage = 0;
  int _selectedColor = 0;
  int _quantity = 1;
  int _selectedImageIndex = 0;
  late List<String> _productImages;

  @override
  void initState() {
    super.initState();
    if (widget.product['images'] != null) {
      _productImages = List<String>.from(widget.product['images']);
    } else {
      String mainImg = widget.product['image'];
      _productImages = [mainImg, mainImg, mainImg, mainImg];
    }
  }

  int get _currentPrice {
    int basePrice = widget.product['price'];
    return basePrice + (_selectedStorage * 1000000); 
  }

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
            // HEADER
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
                  const Spacer(),
                  const Text("Detail Produk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: const Icon(Icons.shopping_cart, color: orange, size: 26),
                  ),
                ],
              ),
            ),

            // KONTEN
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
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    
                    Container(
                      height: 280,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Hero(
                        tag: widget.product['name'],
                        child: Image.asset(
                          _productImages[_selectedImageIndex],
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),

                    // Thumbnail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_productImages.length, (index) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedImageIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: _selectedImageIndex == index ? orange : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(image: AssetImage(_productImages[index]), fit: BoxFit.cover)
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      formatCurrency(_currentPrice),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),

                    const SizedBox(height: 20),

                    // Storage
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pilih Varian:", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: storageOptions.asMap().entries.map((entry) {
                              int idx = entry.key;
                              bool isSelected = idx == _selectedStorage;
                              return ChoiceChip(
                                label: Text(entry.value),
                                selected: isSelected,
                                selectedColor: orange,
                                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedStorage = idx;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Warna
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text("Warna:", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          ...colorOptions.asMap().entries.map((entry) {
                            int idx = entry.key;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = idx),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 30, height: 30,
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: idx == _selectedColor ? Colors.black : Colors.grey, width: 2),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quantity
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                           const Text("Jumlah:", style: TextStyle(fontWeight: FontWeight.bold)),
                           const SizedBox(width: 16),
                           Container(
                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                             child: Row(
                               children: [
                                 IconButton(onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null), icon: const Icon(Icons.remove)),
                                 Text("$_quantity", style: const TextStyle(fontWeight: FontWeight.bold)),
                                 IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add)),
                               ],
                             ),
                           )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Text(widget.product['description'] ?? "Tidak ada deskripsi", style: const TextStyle(fontSize: 13, height: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM BAR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final selectedStorageName = storageOptions[_selectedStorage];
                        final variantName = "Warna $_selectedColor, $selectedStorageName";

                        // ADD TO CART VIA PROVIDER
                        Provider.of<CartProvider>(context, listen: false).addItem(
                          CartItem(
                            name: widget.product['name'],
                            basePrice: widget.product['price'],
                            price: _currentPrice,
                            image: widget.product['image'],
                            variant: variantName,
                            selectedStorage: selectedStorageName,
                            selectedColorName: "Warna $_selectedColor",
                            quantity: _quantity,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Berhasil masuk keranjang!"),
                            action: SnackBarAction(
                              label: "LIHAT",
                              onPressed: () => Navigator.pushNamed(context, '/cart'),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: orange,
                        side: const BorderSide(color: orange),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("+ Keranjang", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final selectedStorageName = storageOptions[_selectedStorage];
                        final variantName = "Warna $_selectedColor, $selectedStorageName";

                        Provider.of<CartProvider>(context, listen: false).addItem(
                          CartItem(
                            name: widget.product['name'],
                            basePrice: widget.product['price'],
                            price: _currentPrice,
                            image: widget.product['image'],
                            variant: variantName,
                            selectedStorage: selectedStorageName,
                            selectedColorName: "Warna $_selectedColor",
                            quantity: _quantity,
                          ),
                        );
                        
                        Navigator.pushNamed(context, '/cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Beli Langsung", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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