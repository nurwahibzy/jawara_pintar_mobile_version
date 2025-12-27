import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/auth/auth_services.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Judul aplikasi dengan icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.book_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jawara Pintar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Sistem Informasi RT/RW',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Action buttons
              Row(
                children: [
                  // Tombol Pesan
                  const SizedBox(width: 8),
                  // Tombol Logout
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                       key: const Key('btn_profile'),
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TAMPILKAN DIALOG KONFIRMASI
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              // title: const Text("Konfirmasi Logout"),s
                              content: const Text(
                                "Apakah Anda yakin ingin keluar dari aplikasi?",
                                style: TextStyle(fontSize: 18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              actions: [
                                // Tombol Batal
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                // Tombol Ya/Keluar
                                TextButton(
                                  key: const Key('btn_logout'),
                                  onPressed: () async {
                                    Navigator.of(context).pop(); // Tutup dialog

                                    try {
                                      // LAKUKAN AKSI LOGOUT
                                      final authServices = AuthServices();
                                      await authServices.signOut();

                                      // Navigate ke root dan clear semua route
                                      if (context.mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          '/',
                                          (route) => false,
                                        );
                                      }
                                    } catch (e) {
                                      // Handle error jika ada
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Logout gagal: $e'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Ya, Keluar",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tentukan tinggi app bar (wajib untuk PreferredSizeWidget)
  @override
  Size get preferredSize => const Size.fromHeight(70);
}
