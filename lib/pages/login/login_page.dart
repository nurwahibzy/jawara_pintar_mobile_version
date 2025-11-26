import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                          cursorColor: AppColors.primary,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan email disini',
                            prefixIcon: Icon(Icons.mail),
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
                          cursorColor: AppColors.primary,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan password disini',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/dashboard-keuangan', 
                              );
                            },
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