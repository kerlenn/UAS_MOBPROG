import 'package:flutter/material.dart';

class DetailProdukScreen extends StatefulWidget {
  const DetailProdukScreen({super.key});

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  String selectedColor = "Orange";
  String selectedCapacity = "256 GB";
  int jumlahBeli = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Container(
           height: 40,
           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
           child: TextField(decoration: InputDecoration(hintText: "Search...", prefixIcon: Icon(Icons.search), border: InputBorder.none)),
        ),
        actions: [Icon(Icons.shopping_cart), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL PRODUK
              Text("Apple Iphone 17 Pro Max", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("SKU: 02193293201", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("Bebas Ongkir  |  Stok Tersedia", style: TextStyle(color: Colors.green, fontSize: 12)),
              
              SizedBox(height: 16),
              // GAMBAR PRODUK (Placeholder kotak abu)
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Padding(
                padding: EdgeInsets.all(20), // Biar ada jarak dikit
                child: Image.asset("assets/images/iphone.png", fit: BoxFit.contain),
                ),
              ),
              
              // THUMBNAIL GAMBAR KECIL
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.deepOrange)),
                )),
              ),

              SizedBox(height: 16),
              // HARGA
              Text("Rp25.749.000", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              
              SizedBox(height: 16),
              // PILIHAN WARNA
              Text("Warna - $selectedColor", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildColorDot(Colors.orange, "Orange"),
                  _buildColorDot(Colors.blue, "Blue"),
                  _buildColorDot(Colors.grey, "Silver"),
                ],
              ),

              SizedBox(height: 16),
              // KAPASITAS MEMORI
              Text("Kapasitas", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ["128 GB", "256 GB", "512 GB", "1 TB"].map((cap) {
                  return ChoiceChip(
                    label: Text(cap),
                    selected: selectedCapacity == cap,
                    selectedColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: selectedCapacity == cap ? Colors.black : Colors.grey)
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCapacity = cap;
                      });
                    },
                  );
                }).toList(),
              ),
              
              SizedBox(height: 20),
              // DESKRIPSI
              Text("Detail Produk", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "iPhone 17 Pro Max. iPhone paling andal yang pernah ada. Layar 6,9 inci yang cemerlang, desain unibody aluminium, chip A19 Pro.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 80), // Space agar tidak tertutup tombol bawah
            ],
          ),
        ),
      ),
      
      // TOMBOL BELI DI BAWAH
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)]),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: (){},
                style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.deepOrange), padding: EdgeInsets.symmetric(vertical: 12)),
                child: Text("+ Keranjang", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: EdgeInsets.symmetric(vertical: 12)),
                child: Text("Beli Langsung", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, String name) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = name),
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selectedColor == name ? Colors.black : Colors.transparent, width: 1)
        ),
        child: CircleAvatar(backgroundColor: color, radius: 15),
      ),
    );
  }
}