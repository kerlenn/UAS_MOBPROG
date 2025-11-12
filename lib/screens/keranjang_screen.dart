import 'package:flutter/material.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  @override
  Widget build(BuildContext context) {
    // 'Scaffold' adalah kerangka dasar untuk sebuah halaman
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Saya'),
      ),
      body: Center(
        child: Text('Ini Halaman Keranjang'),
      ),
    );
  }
}