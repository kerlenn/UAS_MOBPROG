import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedBottomNavIndex = 3; // Profile tab aktif

  // Controllers untuk form Ubah Profil
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Controller untuk feedback
  final TextEditingController _feedbackController = TextEditingController();

  // Controllers untuk form Ubah Kata Sandi
  final TextEditingController _passwordLamaController = TextEditingController();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();

  // State untuk show/hide password
  bool _showPasswordLama = false;
  bool _showPasswordBaru = false;
  bool _showKonfirmasiPassword = false;

  @override
  void initState() {
    super.initState();
    // Load data user saat pertama kali masuk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      _namaController.text = user.username;
      _emailController.text = user.email;
      _nomorTeleponController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisKelaminController.dispose();
    _tanggalLahirController.dispose();
    _nomorTeleponController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  // ==================== LOGOUT FUNCTION ====================
  void _handleLogout() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final success = await authProvider.logout();
              
              if (!mounted) return;
              
              Navigator.pop(context); // Tutup dialog
              
              if (success) {
                // Redirect ke home setelah logout
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil logout'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
  // ==================== DIALOGS ====================

  void _showUbahKataSandiDialog() {
    // Reset controllers
    _passwordLamaController.clear();
    _passwordBaruController.clear();
    _konfirmasiPasswordController.clear();
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFB8724D), Color(0xFF6B3E2E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header dengan logo dan tombol back
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFFF6B35),
                                radius: 18,
                                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                              ),
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              height: 40,
                              errorBuilder: (c, e, s) => const Icon(Icons.store, color: Colors.white, size: 40),
                            ),
                            const SizedBox(width: 36),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Avatar dengan icon lock
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.lock, size: 50, color: Color(0xFFB8724D)),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.lock, color: Color(0xFFB8724D), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Ubah Kata Sandi',
                                style: TextStyle(
                                  color: Color(0xFFB8724D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Fields untuk Password
                        _buildPasswordField(
                          'Kata Sandi Lama',
                          _passwordLamaController,
                          _showPasswordLama,
                          () {
                            setStateDialog(() {
                              _showPasswordLama = !_showPasswordLama;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildPasswordField(
                          'Kata Sandi Baru',
                          _passwordBaruController,
                          _showPasswordBaru,
                          () {
                            setStateDialog(() {
                              _showPasswordBaru = !_showPasswordBaru;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildPasswordField(
                          'Konfirmasi Kata Sandi Baru',
                          _konfirmasiPasswordController,
                          _showKonfirmasiPassword,
                          () {
                            setStateDialog(() {
                              _showKonfirmasiPassword = !_showKonfirmasiPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // Validasi
                              if (_passwordLamaController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kata sandi lama harus diisi')),
                                );
                                return;
                              }
                              if (_passwordBaruController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kata sandi baru harus diisi')),
                                );
                                return;
                              }
                              if (_passwordBaruController.text != _konfirmasiPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')),
                                );
                                return;
                              }
                              if (_passwordBaruController.text.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kata sandi minimal 6 karakter')),
                                );
                                return;
                              }

                              // Logic simpan kata sandi baru (nanti connect ke API)
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Kata sandi berhasil diubah')),
                              );
                            },
                            child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUbahProfilDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB8724D), Color(0xFF6B3E2E)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header dengan logo dan tombol back
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFFFF6B35),
                            radius: 18,
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                          errorBuilder: (c, e, s) => const Icon(Icons.store, color: Colors.white, size: 40),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Avatar
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Color(0xFFB8724D)),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit, color: Color(0xFFB8724D), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Ubah Profil',
                            style: TextStyle(
                              color: Color(0xFFB8724D),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Fields
                    _buildProfileField('Nama', _namaController),
                    const SizedBox(height: 12),
                    _buildProfileField('Jenis Kelamin', _jenisKelaminController),
                    const SizedBox(height: 12),
                    _buildProfileField('Tanggal Lahir', _tanggalLahirController),
                    const SizedBox(height: 12),
                    _buildProfileField('Nomor Telepon', _nomorTeleponController),
                    const SizedBox(height: 12),
                    _buildProfileField('Email', _emailController),
                    const SizedBox(height: 24),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          // Logic simpan perubahan (nanti connect ke API)
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profil berhasil diperbarui')),
                          );
                        },
                        child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool showPassword, VoidCallback toggleShow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFDDCC),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: !showPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: toggleShow,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFDDCC),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);
    const darkBar = Color(0xFF262626);
    const brownGradientStart = Color(0xFFB8724D);
    const brownGradientEnd = Color(0xFF6B3E2E);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [brownGradientStart, brownGradientEnd],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Logo Header
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        errorBuilder: (c, e, s) => const Icon(Icons.store, color: Colors.white, size: 50),
                      ),
                      const SizedBox(height: 30),

                      // Avatar
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Color(0xFFB8724D)),
                      ),
                      const SizedBox(height: 16),

                      // Display User Info
                      if (user != null) ...[
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Color(0xFFFFDDCC),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            color: Color(0xFFFFDDCC),
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),

                      // Menu Buttons
                      _buildMenuButton(
                        icon: Icons.edit,
                        label: 'Ubah Profil',
                        onTap: _showUbahProfilDialog,
                      ),
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        icon: Icons.lock,
                        label: 'Ubah Kata Sandi',
                        onTap: _showUbahKataSandiDialog,
                      ),
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        icon: Icons.receipt_long,
                        label: 'Pesanan Saya',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur Pesanan Saya')),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        icon: Icons.shopping_cart,
                        label: 'Keranjang Saya',
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/cart');
                        },
                      ),
                      const SizedBox(height: 12),
                      // TOMBOL LOGOUT BARU
                      _buildMenuButton(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: _handleLogout,
                        isLogout: true,
                      ),
                      const SizedBox(height: 30),

                      // Feedback Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Berikan Feedback',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _feedbackController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText: 'Isi feedback Anda',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  if (_feedbackController.text.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Terima kasih atas feedback Anda!')),
                                    );
                                    _feedbackController.clear();
                                  }
                                },
                                child: const Text('Kirim', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                currentIndex: _selectedBottomNavIndex,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'Produk'),
                  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Keranjang'),
                  BottomNavigationBarItem(
                    icon: CircleAvatar(
                      radius: 14,
                      backgroundColor: orange,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    ),
                    label: 'Profile',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedBottomNavIndex = index;
                  });
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (index == 1) {
                    Navigator.pushReplacementNamed(context, '/products');
                  } else if (index == 2) {
                    Navigator.pushReplacementNamed(context, '/cart');
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isLogout ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isLogout ? Colors.white : const Color(0xFFB8724D), 
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isLogout ? Colors.white : const Color(0xFF3E2723),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}