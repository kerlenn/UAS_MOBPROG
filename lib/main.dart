import 'package:flutter/material.dart';
import 'screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS MobProg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      // Set HomeScreen sebagai halaman utama
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        // Tambahkan route lain di sini jika diperlukan
        // '/detail': (context) => DetailScreen(),
        // '/cart': (context) => CartScreen(),
        // '/profile': (context) => ProfileScreen(),
        // '/category': (context) => CategoryScreen(),
      },
      // Fallback jika route tidak ditemukan
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}