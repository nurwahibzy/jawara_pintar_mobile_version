import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/auth/auth_services.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authServices = AuthServices();

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationPasswordController = TextEditingController();

  // ERROR STATE VARIABLES (Untuk menyimpan pesan error)
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // FUNGSI VALIDASI
  bool _validateInputs() {
    bool isValid = true;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmationPasswordController.text;

    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email tidak boleh kosong';
        isValid = false;
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = 'Format email tidak valid';
        isValid = false;
      } else {
        _emailError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Password tidak boleh kosong';
        isValid = false;
      } else if (password.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
        isValid = false;
      } else {
        _passwordError = null;
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
        isValid = false;
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Password tidak cocok';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }
    });

    return isValid;
  }

  void signUp() async {
    // Jalankan validasi lokal dulu sebelum kirim ke server
    if (!_validateInputs()) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authServices.signUp(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Registrasi berhasil, silakan login')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // Cek error spesifik dari backend Supabase
        String errorMessage = e.toString();

        setState(() {
          if (errorMessage.contains("already registered")) {
            _emailError = "Email sudah terdaftar";
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: Text('Registrasi gagal: $errorMessage')),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/background_login.jpg', fit: BoxFit.cover),

          // Overlay gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(140, 29, 24, 42),
                  Color.fromARGB(200, 52, 47, 63),
                ],
              ),
            ),

            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.secondBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.book,
                                size: 35,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Jawara Pintar',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Solusi digital untuk manajemen keuangan dan kegiatan warga',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        const SizedBox(height: 20),

                        // EMAIL LABEL
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // EMAIL FIELD
                        TextField(
                          controller: _emailController,
                          cursorColor: AppColors.primary,
                          // Hapus error saat user mengetik
                          onChanged: (value) {
                            if (_emailError != null) {
                              setState(() => _emailError = null);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukkan email',
                            prefixIcon: const Icon(Icons.mail),
                            // Tampilkan Error Disini
                            errorText: _emailError,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // PASSWORD LABEL
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),

                        // PASSWORD FIELD
                        TextField(
                          controller: _passwordController,
                          cursorColor: AppColors.primary,
                          obscureText: true,
                          onChanged: (value) {
                            // Hapus error password & confirm saat mengetik
                            if (_passwordError != null ||
                                _confirmPasswordError != null) {
                              setState(() {
                                _passwordError = null;
                                _confirmPasswordError = null;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukkan password',
                            prefixIcon: const Icon(Icons.lock),
                            // Tampilkan Error Disini
                            errorText: _passwordError,
                          ),
                        ),

                        const SizedBox(height: 30),
                        // PASSWORD LABEL
                        Text(
                          'Konfimasi Password',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),

                        // PASSWORD confirmation FIELD
                        TextField(
                          controller: _confirmationPasswordController,
                          cursorColor: AppColors.primary,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Masukkan konfirmasi password',
                            prefixIcon: Icon(Icons.lock),
                            // Tampilkan Error Disini
                            errorText: _confirmPasswordError,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Signup BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: signUp,
                            child: const Text('Sign Up'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, '/login');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
