import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // tanpa bayangan
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // judul aplikasi di kiri
            const Text(
              'Jawara Pintar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol Pesan
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.green),
                  tooltip: 'Pesan',
                  onPressed: () {
                    Navigator.pushNamed(context, '/pesan_warga');
                  },
                ),
        
                // Tombol Profil
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.green),
                  tooltip: 'Profil',
                  onPressed: () {
                    Navigator.pushNamed(context, '/profil');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.shade300,
          height: 1.0,
        ),
      ),
    );
  }

  // Tentukan tinggi app bar (wajib untuk PreferredSizeWidget)
  @override
  Size get preferredSize => const Size.fromHeight(60);
}
