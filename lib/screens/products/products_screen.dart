import 'package:flutter/material.dart';
import '../product_detail/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialBrand;
  final String? initialSearchQuery; // Parameter untuk menerima teks pencarian

  const ProductsScreen({
    super.key,
    this.initialBrand,
    this.initialSearchQuery,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Controller untuk Search Bar
  late TextEditingController _searchController;

  // ignore: unused_field
  final int _selectedBottomNavIndex = 1;

  // ==================== STATE FILTER ====================
  String _selectedSortOption = 'Sesuai Nama';
  final List<String> _availableBrands = [
    'Samsung',
    'Apple',
    'Xiaomi',
    'Google',
    'Huawei'
  ];
  List<String> _selectedBrands = [];
  RangeValues _selectedPriceRange = const RangeValues(0, 30000000);
  bool _isPriceFilterActive = false;

  @override
  void initState() {
    super.initState();
    
    // 1. Inisialisasi Search Controller dengan teks dari Home (jika ada)
    _searchController = TextEditingController(text: widget.initialSearchQuery ?? '');

    // 2. Inisialisasi Brand Filter dengan brand dari Home (jika ada)
    if (widget.initialBrand != null) {
      _selectedBrands.add(widget.initialBrand!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Data Dummy Produk
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Apple iPhone 17 Pro Max',
      'price': 25749000,
      'discountPrice': '',
      'image': 'assets/images/products/iphone_17_pro_max.jpg',
      'brand': 'Apple',
      'colors': [const Color(0xFFE36B37), const Color(0xFF1C2739), const Color(0xFFE3E3E1)],
      'storage': ['256 GB', '512 GB', '1 TB', '2 TB'],
      'description': 'iPhone 17 Pro Max. iPhone paling andal yang pernah ada.',
    },
    {
      'name': 'Apple iPhone 15',
      'price': 16499000,
      'discountPrice': '',
      'image': 'assets/images/products/iphone_15.jpg',
      'brand': 'Apple',
      'colors': [const Color(0xFF363738), const Color(0xFFDBE4EA), const Color(0xFFFCE3E5)],
      'storage': ['128 GB', '256 GB', '512 GB'],
      'description': 'iPhone 15 menghadirkan Dynamic Island.',
    },
    {
      'name': 'Apple iPhone 13',
      'price': 10999000,
      'discountPrice': 'Rp 8.249.000',
      'image': 'assets/images/products/iphone_13.jpg',
      'brand': 'Apple',
      'colors': [const Color(0xFF1F2020), const Color(0xFFF9F6EF)],
      'storage': ['128 GB', '256 GB'],
      'description': 'Sistem kamera ganda paling canggih.',
    },
    {
      'name': 'Xiaomi Redmi Note 13',
      'price': 2799000,
      'discountPrice': '',
      'image': 'assets/images/products/redmi_note_13.jpg',
      'brand': 'Xiaomi',
      'colors': [const Color(0xFFE6C8B6), const Color(0xFFC0DCE9)],
      'storage': ['128 GB', '256 GB'],
      'description': 'Redmi Note 13 hadir dengan layar AMOLED 120Hz.',
    },
    {
      'name': 'Samsung Galaxy S25',
      'price': 14999000,
      'discountPrice': '',
      'image': 'assets/images/products/samsung_s25.jpg',
      'brand': 'Samsung',
      'colors': [const Color(0xFF1F2A44), const Color(0xFFDAE5EB)],
      'storage': ['256 GB', '512 GB'],
      'description': 'Galaxy S25 dengan layar Dynamic AMOLED 2X.',
    },
    {
      'name': 'Google Pixel 9 Pro',
      'price': 25790000,
      'discountPrice': '',
      'image': 'assets/images/products/pixel_9.jpg',
      'brand': 'Google',
      'colors': [const Color(0xFFF5F5F5), const Color(0xFF3C4043)],
      'storage': ['128 GB', '256 GB', '512 GB'],
      'description': 'Pixel 9 Pro dengan kamera canggih.',
    },
    {
      'name': 'Huawei Pura 80',
      'price': 10999000,
      'discountPrice': '',
      'image': 'assets/images/products/huawei_pura.jpg',
      'brand': 'Huawei',
      'colors': [const Color(0xFF000000), const Color(0xFF6B4E3D)],
      'storage': ['256 GB', '512 GB'],
      'description': 'Huawei Pura 80 dengan layar OLED 90Hz.',
    },
  ];

  String formatCurrency(int amount) {
    final str = amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $str';
  }

  // ==================== LOGIC FILTERING (UPDATED) ====================
  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> results = List.from(_allProducts);

    // 1. Filter Search Text
    // Kita ambil text dari _searchController sekarang
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      results = results.where((prod) => 
        prod['name'].toString().toLowerCase().contains(query)
      ).toList();
    }

    // 2. Filter Brand
    if (_selectedBrands.isNotEmpty) {
      results = results.where((prod) => _selectedBrands.contains(prod['brand'])).toList();
    }

    // 3. Filter Harga
    if (_isPriceFilterActive) {
      results = results.where((prod) {
        int price = prod['price'];
        return price >= _selectedPriceRange.start &&
            price <= _selectedPriceRange.end;
      }).toList();
    }

    // 4. Sorting
    if (_selectedSortOption == 'Sesuai Nama') {
      results.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_selectedSortOption == 'Harga Tertinggi') {
      results.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (_selectedSortOption == 'Harga Terendah') {
      results.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_selectedSortOption == 'Terbaru') {
      results.sort((a, b) => b['name'].compareTo(a['name']));
    }

    return results;
  }

  // ==================== DIALOGS ====================
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader('Urutkan'),
                const SizedBox(height: 10),
                _buildRadioItem('Sesuai Nama', _selectedSortOption, (val) {
                  setState(() => _selectedSortOption = val);
                  Navigator.pop(context);
                }),
                _buildRadioItem('Terbaru', _selectedSortOption, (val) {
                  setState(() => _selectedSortOption = val);
                  Navigator.pop(context);
                }),
                _buildRadioItem('Harga Tertinggi', _selectedSortOption, (val) {
                  setState(() => _selectedSortOption = val);
                  Navigator.pop(context);
                }),
                _buildRadioItem('Harga Terendah', _selectedSortOption, (val) {
                  setState(() => _selectedSortOption = val);
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBrandDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelected = List.from(_selectedBrands);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDialogHeader('Pilih Brand'),
                    const SizedBox(height: 16),
                    ..._availableBrands.map((brand) {
                      return CheckboxListTile(
                        title: Text(brand),
                        value: tempSelected.contains(brand),
                        activeColor: const Color(0xFFFF6B35),
                        onChanged: (bool? value) {
                          setStateDialog(() {
                            if (value == true) {
                              tempSelected.add(brand);
                            } else {
                              tempSelected.remove(brand);
                            }
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          setState(() => _selectedBrands = tempSelected);
                          Navigator.pop(context);
                        },
                        child: const Text('Terapkan Filter'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPriceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        RangeValues tempRange = _selectedPriceRange;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogHeader('Rentang Harga'),
                    const SizedBox(height: 20),
                    Text(
                      '${formatCurrency(tempRange.start.round())} - ${formatCurrency(tempRange.end.round())}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    RangeSlider(
                      values: tempRange,
                      min: 0,
                      max: 30000000,
                      divisions: 30,
                      activeColor: const Color(0xFFFF6B35),
                      inactiveColor: Colors.grey.shade300,
                      labels: RangeLabels(
                        formatCurrency(tempRange.start.round()),
                        formatCurrency(tempRange.end.round()),
                      ),
                      onChanged: (RangeValues values) {
                        setStateDialog(() {
                          tempRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isPriceFilterActive = false;
                                _selectedPriceRange =
                                    const RangeValues(0, 30000000);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Reset',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35)),
                            onPressed: () {
                              setState(() {
                                _selectedPriceRange = tempRange;
                                _isPriceFilterActive = true;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Simpan',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRadioItem(
      String label, String groupValue, Function(String) onChanged) {
    return InkWell(
      onTap: () => onChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            if (label == groupValue)
              const Icon(Icons.check, color: Color(0xFFFF6B35), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      {required String label,
      required bool isActive,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF6B35) : const Color(0xFFFFF0EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isActive ? const Color(0xFFFF6B35) : Colors.black12,
              width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.keyboard_arrow_down,
                size: 18,
                color: isActive ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(2, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Hero(
                    tag: product['name'],
                    child: Image.asset(product['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                            Icons.broken_image,
                            color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(formatCurrency(product['price']),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 10),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          padding: const EdgeInsets.symmetric(vertical: 8)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: const Text('Lihat Detail',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);
    const darkBar = Color(0xFF262626);
    const lightGrey = Color(0xFFE3E3E3);
    bool isSortActive = _selectedSortOption != 'Sesuai Nama';
    bool isBrandActive = _selectedBrands.isNotEmpty;
    bool isPriceActive = _isPriceFilterActive;

    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: darkBar,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: orange,
                      radius: 18,
                      child: Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // SEARCH BAR YANG BISA DIKETIK
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController, // <-- CONTROLLER DISINI
                        onChanged: (val) {
                           setState(() {}); // Trigger rebuild untuk filter real-time
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Colors.black87, size: 20),
                          hintText: 'Cari Produk...',
                          hintStyle: TextStyle(color: orange, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                          // Tombol hapus text (X)
                          suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: const Icon(Icons.shopping_cart,
                        color: orange, size: 24),
                  ),
                ],
              ),
            ),

            // CONTENT (HASIL SEARCH / PRODUK)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jika sedang mencari, sembunyikan banner & filter brand biar fokus
                    if (_searchController.text.isEmpty) ...[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: Colors.black,
                            child: Image.asset(
                                'assets/images/iphone_pro_3.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Center(
                                    child:
                                        Icon(Icons.image, color: Colors.grey))),
                          ),
                        ),
                        const SizedBox(height: 10),
                    ],

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                          _searchController.text.isNotEmpty
                            ? 'Hasil Pencarian: "${_searchController.text}"'
                            : 'Semua Produk Smartphone',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ),
                    
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildFilterChip(
                              label: 'Urutkan',
                              isActive: isSortActive,
                              onTap: _showSortDialog),
                          _buildFilterChip(
                              label: 'Harga',
                              isActive: isPriceActive,
                              onTap: _showPriceDialog),
                          _buildFilterChip(
                              label: 'Brand',
                              isActive: isBrandActive,
                              onTap: _showBrandDialog),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // GRID HASIL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _filteredProducts.isEmpty
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text("Produk tidak ditemukan", style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ))
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                return _buildProductCard(
                                    _filteredProducts[index]);
                              },
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkBar,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: orange,
            unselectedItemColor: Colors.white,
            currentIndex: _selectedBottomNavIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 14,
                  backgroundColor: orange,
                  child: Icon(Icons.people_alt_rounded,
                      size: 18, color: Colors.white),
                ),
                label: 'Produk',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Keranjang'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            onTap: (index) {
              if (index == 0) Navigator.pushReplacementNamed(context, '/home');
              if (index == 2) Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      ),
    );
  }
}