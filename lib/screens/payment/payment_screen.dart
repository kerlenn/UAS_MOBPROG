import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Copy Paste

class PaymentScreen extends StatefulWidget {
  final int totalPrice;
  final String selectedBank;

  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.selectedBank,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Warna tema
  final Color orange = const Color(0xFFFF6B35);
  final Color darkBar = const Color(0xFF262626);

  // Data Dummy Virtual Account
  late String _virtualAccountNumber;
  late DateTime _deadlineTime;

  @override
  void initState() {
    super.initState();
    // Generate nomor VA dummy (Kode Bank + Random Number)
    String bankCode = "8800"; // Default
    if (widget.selectedBank == 'BCA') bankCode = "80777";
    if (widget.selectedBank == 'Mandiri') bankCode = "88321";
    if (widget.selectedBank == 'BNI') bankCode = "8241";
    if (widget.selectedBank == 'SeaBank') bankCode = "7829";
    
    // Nomor HP pura-pura + random
    _virtualAccountNumber = "$bankCode${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    // Set batas waktu 24 jam dari sekarang
    _deadlineTime = DateTime.now().add(const Duration(hours: 24));
  }

  String formatCurrency(int amount) {
    final str = amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $str';
  }

  // Helper format tanggal sederhana tanpa library intl
  String getDeadlineString() {
    final List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return "${_deadlineTime.day} ${months[_deadlineTime.month - 1]} ${_deadlineTime.year}, ${_deadlineTime.hour.toString().padLeft(2, '0')}:${_deadlineTime.minute.toString().padLeft(2, '0')} WIB";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Tombol back pergi ke Halaman Produk (menghapus history checkout)
            Navigator.pushNamedAndRemoveUntil(context, '/products', (route) => false);
          },
        ),
        title: const Text(
          "Info Pembayaran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= 1. TOTAL PEMBAYARAN =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Pembayaran", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(
                    formatCurrency(widget.totalPrice),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= 2. INFO DEADLINE =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EA), // Orange muda
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text("Bayar sebelum:", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(
                    getDeadlineString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= 3. INFO VA & BANK =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Bank
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon Bank Placeholder
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            widget.selectedBank,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("Bank (Dicek Otomatis)", style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // Nomor VA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nomor Virtual Account:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nomor Besar
                            Text(
                              _virtualAccountNumber,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: orange,
                                letterSpacing: 1.2,
                              ),
                            ),
                            // Tombol Salin
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: _virtualAccountNumber));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Nomor VA berhasil disalin!"),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: Text(
                                "SALIN",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Dicek dalam 10 menit setelah pembayaran berhasil",
                          style: TextStyle(fontSize: 11, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text("Ikuti langkah berikut:", style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            
            const SizedBox(height: 8),

            // ================= 4. INSTRUKSI ATM (Accordion) =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text("Petunjuk Transfer ATM", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionStep(1, "Masukkan kartu ATM dan PIN Anda."),
                          _buildInstructionStep(2, "Pilih menu Transaksi Lain > Pembayaran > Lainnya > BRIVA (sesuai bank)."),
                          _buildInstructionStep(3, "Masukkan Nomor Virtual Account: $_virtualAccountNumber."),
                          _buildInstructionStep(4, "Di halaman konfirmasi, pastikan detail pembayaran sudah sesuai seperti Nomor VA, Nama, dan Jumlah Bayar."),
                          _buildInstructionStep(5, "Ikuti instruksi selanjutnya untuk menyelesaikan transaksi."),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2), // Jarak tipis antar accordion
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: const ExpansionTile(
                  title: Text("Petunjuk Transfer M-Banking", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Instruksi M-Banking akan muncul di sini..."),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100), // Space bawah
          ],
        ),
      ),

      // ================= 5. TOMBOL OK (FIXED BOTTOM) =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Klik Ok! -> Kembali ke Halaman Home
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Border kotak sedikit rounded seperti di gambar referensi
                elevation: 0,
              ),
              child: const Text("Ok!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20, height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Text("$number", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
          ),
        ],
      ),
    );
  }
}