import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart'; // <--- NEW IMPORT

// Screens
import 'screens/home/home.dart';
import 'screens/products/products_screen.dart';
import 'screens/keranjang_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/signUp/signup_screen.dart'; 

void main() {
  runApp(const MyAppRoot());
}

// Root Widget untuk MultiProvider
class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()), // <--- DAFTARKAN CART PROVIDER
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS MobProg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
              ),
            );
          }
          return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),

      routes: {
        '/home': (context) => const HomeScreen(),
        '/products': (context) => const ProductsScreen(),
        '/cart': (context) => const KeranjangScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
    );
  }
}