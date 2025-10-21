import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';

class Kependudukan extends StatelessWidget {
  const Kependudukan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kependudukan')),
      body: const Center(child: Text('Halaman Kependudukan')),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}

