
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        // Navigasi ke halaman sesuai item yang ditekan
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/keuangan');
            break;
          case 1:
            Navigator.pushNamed(context, '/kegiatan');
            break;
          case 2:
            Navigator.pushNamed(context, '/kependudukan');
            break;
          // case 3:
          //   Navigator.pushNamed(context, '/');
          //   break;
          // case 4:
          //   Navigator.pushNamed(context, '/');
          //   break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Keuangan'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kependudukan'),
        // BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
