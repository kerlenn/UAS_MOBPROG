import 'package:flutter/material.dart';
import '../../widgets/custom_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;
  int _selectedBottomNavIndex = 0;

  final List<String> _carouselImages = [
    'assets/images/iphone_pro_1.jpg',
    'assets/images/iphone_pro_2.jpg',
    'assets/images/iphone_pro_3.jpg',
  ];

  final List<Map<String, String>> _brands = [
    {
      'name': 'Samsung',
      'logo': 'assets/images/brands/samsung.png',
    },
    {
      'name': 'Apple',
      'logo': 'assets/images/brands/apple.png',
    },
    {
      'name': 'Xiaomi',
      'logo': 'assets/images/brands/xiaomi.png',
    },
    {
      'name': 'Google',
      'logo': 'assets/images/brands/google.png',
    },
    {
      'name': 'Huawei',
      'logo': 'assets/images/brands/huawei.png',
    },
  ];

  final List<Map<String, String>> _products = [
    {
      'name': 'iPhone 13',
      'price': 'Rp 10.299.000',
      'discountPrice': 'Rp 8.249.000',
      'image': 'assets/images/products/iphone_13.jpg',
    },
    {
      'name': 'Apple iPhone 15',
      'price': 'Rp 10.299.000',
      'discountPrice': 'Rp 8.249.000',
      'image': 'assets/images/products/iphone_15.jpg',
    },
    {
      'name': 'Samsung Galaxy S20',
      'price': 'Rp 1.399.000',
      'discountPrice': '',
      'image': 'assets/images/products/samsung_s20.jpg',
    },
    {
      'name': 'Xiaomi Redmi Note 13',
      'price': 'Rp 1.999.000',
      'discountPrice': '',
      'image': 'assets/images/products/redmi_note_13.jpg',
    },
  ];

  List<Widget> _buildCarouselItems() {
    return _carouselImages.map((imagePath) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text(
                        'Gambar tidak ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
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

    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // ==================== HEADER ====================
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
                  // Logo kotak (tanpa background putih, nempel di bar hitam)
                  Image.asset(
                    'assets/images/logo.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.phone_android,
                        color: orange,
                        size: 28,
                      );
                    },
                  ),
                  const SizedBox(width: 10),

                  // SEARCH BAR
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3EA),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const TextField(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black87,
                            size: 22,
                          ),
                          hintText: 'Search Something Here...',
                          hintStyle: TextStyle(
                            color: orange,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // PROFILE ICON
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: orange, width: 2),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: orange,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // CART ICON
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: orange,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            // ==================== CONTENT ====================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // CAROUSEL
                    CustomCarousel(
                      items: _buildCarouselItems(),
                      height: 190,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // CAROUSEL INDICATOR
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

                    // CARD MASUK / DAFTAR
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
                              'Masuk atau daftar untuk menikmati',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'berbelanja dengan maksimal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // PILIHAN BRAND + TOMBOL LIHAT LAIN
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
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/brands');
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // BRAND ICONS (CIRCLE + BORDER)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _brands.map((brand) {
                          return GestureDetector(
                            onTap: () {
                              // nanti bisa diarahkan ke halaman brand tertentu
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${brand['name']} diklik'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: darkBar,
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
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    brand['logo']!,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          brand['name']![0],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: orange,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // TITLE PRODUK TERBAIK
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Pilihan terbaik minggu ini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // GRID PRODUK – CARD HITAM + BORDER PUTIH
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return GestureDetector(
                            onTap: () {
                              // bisa diarahkan ke detail produk nanti
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product['name']} diklik'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: darkBar,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: darkBar,
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
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(18),
                                    ),
                                    child: Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Image.asset(
                                        product['image']!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error,
                                            stackTrace) {
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

                                  // INFO PRODUK
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
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        if (product['discountPrice']!
                                            .isNotEmpty)
                                          Text(
                                            product['price']!,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[400],
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
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Beli ${product['name']} sekarang',
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  backgroundColor: darkBar,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: orange,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              'Beli Sekarang',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
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

      // ==================== BOTTOM NAV ====================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkBar,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: orange,
            unselectedItemColor: Colors.white,
            currentIndex: _selectedBottomNavIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            onTap: (index) {
              setState(() {
                _selectedBottomNavIndex = index;
              });

              switch (index) {
                case 0: // Home
                  Navigator.pushReplacementNamed(context, '/');
                  break;
                case 1: // Produk
                  Navigator.pushNamed(context, '/products');
                  break;
                case 2: // Keranjang
                  Navigator.pushNamed(context, '/cart');
                  break;
                case 3: // Profile
                  Navigator.pushNamed(context, '/profile');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 14,
                  backgroundColor: orange,
                  child: Icon(
                    Icons.home,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                label: 'Home',
              ),
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
          ),
        ),
      ),
    );
  }
}
