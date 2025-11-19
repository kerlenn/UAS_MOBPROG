import 'package:flutter/material.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  // Data Dummy (Pura-pura) sesuai desain
  List<Map<String, dynamic>> keranjangItems = [
    {
      "nama": "Apple Iphone 13",
      "varian": "128GB, Midnight",
      "harga": 8249000,
      "gambar": "assets/images/iphone.png", // Pastikan ada gambar ini atau ganti URL
      "jumlah": 1,
      "isChecked": false,
    },
    {
      "nama": "Samsung Galaxy S23",
      "varian": "256GB, Phantom Black",
      "harga": 12999000,
      "gambar": "assets/images/iphone.png",
      "jumlah": 1,
      "isChecked": false,
    },
  ];

  bool isSelectAll = false;

  // Fungsi menghitung total harga barang yang dicentang
  int get totalHarga {
    int total = 0;
    for (var item in keranjangItems) {
      if (item['isChecked'] == true) {
        total += (item['harga'] as int) * (item['jumlah'] as int);
      }
    }
    return total;
  }

  // Fungsi format rupiah sederhana
  String formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background agak abu sesuai desain
      appBar: AppBar(
        backgroundColor: Colors.black87, // Warna gelap sesuai desain header
        foregroundColor: Colors.white,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search Something Here...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text("Keranjang Saya")),
          )
        ],
      ),
      body: Column(
        children: [
          // DAFTAR BARANG (LIST)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: keranjangItems.length,
              itemBuilder: (context, index) {
                final item = keranjangItems[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Checkbox per item
                        Checkbox(
                          value: item['isChecked'],
                          activeColor: Colors.deepOrange,
                          onChanged: (value) {
                            setState(() {
                              item['isChecked'] = value;
                              // Update status Select All kalau manual klik satu2
                              isSelectAll = keranjangItems.every((element) => element['isChecked'] == true);
                            });
                          },
                        ),
                        // Gambar Produk
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            // Ganti Image.asset dengan Image.network jika pakai URL internet
                            // image: DecorationImage(image: AssetImage(item['gambar'])) 
                          ),
                          child: Icon(Icons.phone_iphone, color: Colors.grey), // Placeholder kalau gambar error
                        ),
                        SizedBox(width: 12),
                        // Detail Produk
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['nama'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                item['varian'],
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              SizedBox(height: 8),
                              Text(
                                formatRupiah(item['harga']),
                                style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // Counter Jumlah (- 1 +)
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() {
                                  keranjangItems.removeAt(index);
                                });
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (item['jumlah'] > 1) item['jumlah']--;
                                      });
                                    },
                                    child: Padding(padding: EdgeInsets.all(4), child: Icon(Icons.remove, size: 16)),
                                  ),
                                  Text("${item['jumlah']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        item['jumlah']++;
                                      });
                                    },
                                    child: Padding(padding: EdgeInsets.all(4), child: Icon(Icons.add, size: 16)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // BOTTOM BAR (CHECKOUT)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isSelectAll,
                          activeColor: Colors.deepOrange,
                          onChanged: (value) {
                            setState(() {
                              isSelectAll = value!;
                              for (var item in keranjangItems) {
                                item['isChecked'] = isSelectAll;
                              }
                            });
                          },
                        ),
                        Text("Semua"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total", style: TextStyle(color: Colors.grey)),
                        Text(
                          formatRupiah(totalHarga),
                          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      // LOGIKA CHECKOUT SEDERHANA
                      if (totalHarga > 0) {
                        setState(() {
                          // Hapus barang yang dicentang dari list
                          keranjangItems.removeWhere((item) => item['isChecked'] == true);
                          isSelectAll = false;
                        });
                        
                        // Tampilkan pesan sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Berhasil Checkout! Barang akan dikirim.")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Pilih minimal satu barang dulu!")),
                        );
                      }
                    },
                    child: Text("Checkout (${keranjangItems.where((e) => e['isChecked']).length})"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      
      // NAVBAR BAWAH (Dummy visual saja)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Posisi Keranjang
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Produk"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}