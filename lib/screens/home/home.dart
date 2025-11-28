import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_carousel.dart';
import '../../providers/auth_provider.dart';
import '../product_detail/product_detail_screen.dart';

import '../products/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;

  final List<String> _carouselImages = [
    'assets/images/iphone_pro_1.jpg',
    'assets/images/iphone_pro_2.jpg',
    'assets/images/iphone_pro_3.jpg',
  ];

  final List<Map<String, String>> _brands = [
    {'name': 'Samsung', 'logo': 'assets/images/brands/samsung.png'},
    {'name': 'Apple', 'logo': 'assets/images/brands/apple.png'},
    {'name': 'Xiaomi', 'logo': 'assets/images/brands/xiaomi.png'},
    {'name': 'Google', 'logo': 'assets/images/brands/google.png'},
    {'name': 'Huawei', 'logo': 'assets/images/brands/huawei.png'},
  ];

  final List<Map<String, dynamic>> _homeProducts = [
    {
      'name': 'Apple iPhone 13',
      'price': 10299000,
      'image': 'assets/images/products/iphone_13.jpg',
      'brand': 'Apple',
      'description': 'iPhone 13 dengan chip A15 Bionic super cepat.',
    },
    {
      'name': 'Samsung Galaxy S20',
      'price': 1399000,
      'image': 'assets/images/products/samsung_s20.jpg',
      'brand': 'Samsung',
      'description': 'Galaxy S20, layar 120Hz yang memukau.',
    },
    {
      'name': 'Xiaomi Redmi Pad 2',
      'price': 1999000,
      'image': 'assets/images/products/redmi_note_13.jpg',
      'brand': 'Xiaomi',
      'description': 'Tablet hiburan terbaik di kelasnya.',
    },
  ];

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Widget Navigasi ke Detail
  void _navigateToDetail(Map<String, dynamic> productData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: productData),
      ),
    );
  }

  List<Widget> _buildCarouselItems() {
    return _carouselImages.map((imagePath) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) =>
                Container(color: Colors.grey, child: const Icon(Icons.error)),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);
    const darkBar = Color(0xFF262626);
    const lightGrey = Color(0xFFE3E3E3);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.phone_android, color: orange),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3EA),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // SEARCH BAR DISINI
                      child: TextField(
                        textInputAction: TextInputAction
                            .search, // Tombol enter jadi "Search"
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black87),
                          hintText: 'Cari Barang...',
                          hintStyle: TextStyle(color: orange, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 9),
                        ),
                        // LOGIKA PINDAH HALAMAN SAAT SEARCH DI SUBMIT
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            print("Searching for: $value"); // Debug log
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductsScreen(initialSearchQuery: value),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (authProvider.isLoggedIn) {
                        Navigator.pushNamed(context, '/profile');
                      } else {
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                    child: const CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_outline,
                        color: orange,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: orange,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Carousel
                    CustomCarousel(
                      items: _buildCarouselItems(),
                      height: 190,
                      autoPlay: true,
                      onPageChanged: (index) =>
                          setState(() => _currentCarouselIndex = index),
                    ),
                    const SizedBox(height: 10),
                    // Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentCarouselIndex == entry.key
                                ? orange
                                : Colors.grey[400],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // Banner Login
                    if (!authProvider.isLoggedIn)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: darkBar,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Masuk atau daftar untuk menikmati berbelanja dengan maksimal',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/login',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Masuk'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/register',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Daftar'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 22),

                    // Pilihan Brand
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pilihan Brand',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/products');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF545454),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Lihat Lain',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: _brands.map((brand) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              // LOGIKA KLIK BRAND
                              onTap: () {
                                print(
                                  "Brand Clicked: ${brand['name']}",
                                ); // Debug Log
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsScreen(
                                      initialBrand: brand['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFE0E0E0),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  brand['logo']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) =>
                                      Center(child: Text(brand['name']![0])),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // List Produk Home
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Pilihan terbaik minggu ini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: _homeProducts.length,
                        itemBuilder: (context, index) {
                          final product = _homeProducts[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetail(product),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 249, 245, 245),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      color: const Color.fromARGB(
                                        255,
                                        243,
                                        243,
                                        243,
                                      ),
                                      child: Image.asset(
                                        product['image']!,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.phone_android,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              25,
                                              1,
                                              1,
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        if (product['discountPrice']!
                                            .isNotEmpty)
                                          Text(
                                            product['price']!,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color.fromARGB(
                                                255,
                                                33,
                                                2,
                                                2,
                                              ),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        Text(
                                          product['discountPrice']!.isNotEmpty
                                              ? product['discountPrice']!
                                              : product['price']!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 8, 0, 0),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: orange,
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () =>
                                                _navigateToDetail(product),
                                            child: const Text(
                                              'Beli',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: darkBar,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: orange,
            unselectedItemColor: Colors.white,
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded),
                label: 'Produk',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Keranjang',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              if (index == 1) Navigator.pushNamed(context, '/products');
              if (index == 2) Navigator.pushNamed(context, '/cart');
              if (index == 3) {
                if (authProvider.isLoggedIn) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
