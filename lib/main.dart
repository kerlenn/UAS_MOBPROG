import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home/home.dart';
import 'screens/products/products_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/signUp/signup_screen.dart';
import 'screens/keranjang_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'UAS MobProg',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        ),

        // Halaman awal
        initialRoute: '/',

        // Daftar route
        routes: {
          '/': (context) => const HomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/products': (context) => const ProductsScreen(),
          '/cart': (context) => const KeranjangScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/brands': (context) => const BrandsScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const SignupScreen(),
        },

        // Fallback kalau nama route salah
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        },
      ),
    );
  }
}


class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Brand')),
      body: const Center(child: Text('Halaman Daftar Brand')),
    );
  }
}