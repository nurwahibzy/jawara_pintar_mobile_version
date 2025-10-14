import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah - Daftar'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Selamat Datang di Jawara!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pilih menu di bawah untuk melanjutkan.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          MenuCard(
            title: 'Daftar Rumah',
            icon: Icons.home,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu "Daftar Rumah" diklik')),
              );
            },
          ),
          MenuCard(
            title: 'Profil',
            icon: Icons.person,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu "Profil" diklik')),
              );
            },
          ),
          MenuCard(
            title: 'Keluar',
            icon: Icons.logout,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}
