import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/auth/auth_services.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class Profil extends StatelessWidget {
  final authServices = AuthServices();
  Profil({super.key});
  final List<Map<String, dynamic>> pengguna = [
    {
      'nama': 'Sang Admin',
      'email': 'admin1@gmail.com',
      'jabatan': 'Admin',
      'nik': '12345',
      'noHP': '0812345',
      'jenisKelamin': 'Laki-Laki',
      'statusRegistrasi': 'Diterima',
    },
  ];

  logout(BuildContext context) async {
    await authServices.signOut();
    if (context.mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        // mengubah warna ikon back
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.green[100],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        pengguna[0]['nama'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(pengguna[0]['jabatan']),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Text(
                  'NIK:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(pengguna[0]['nik']),
                const SizedBox(height: 10),

                Text(
                  'Email:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(pengguna[0]['email']),
                const SizedBox(height: 10),

                Text(
                  'No HP:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(pengguna[0]['noHP']),
                const SizedBox(height: 10),

                Text(
                  'Jenis Kelamin:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(pengguna[0]['jenisKelamin']),
                const SizedBox(height: 10),

                Text(
                  'Status:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(pengguna[0]['statusRegistrasi']),

                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton.icon(
                      onPressed: () => logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
