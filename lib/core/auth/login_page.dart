import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/auth/auth_services.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authServices = AuthServices();

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _validateInputs() {
    bool isValid = true;
    final email = _emailController.text;
    final password = _passwordController.text;

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
    });
    return isValid;
  }

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!_validateInputs()) {
      return;
    }
    try {
      await authServices.signIn(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('Login gagal')),
            backgroundColor: Colors.red,
          ),
        );
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
                          key: const Key('input_email'),
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
                          key: const Key('input_password'),
                          controller: _passwordController,
                          cursorColor: AppColors.primary,
                          obscureText: true,
                          onChanged: (value) {
                            // Hapus error password & confirm saat mengetik
                            if (_passwordError != null) {
                              setState(() {
                                _passwordError = null;
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

                        // LOGIN BUTTON
                        SizedBox(
                          key: const Key('login_btn'),
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key('btn_login'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: login,
                            child: const Text('Login'),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SIGN UP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                'Daftar',
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
