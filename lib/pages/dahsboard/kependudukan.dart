import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/side_drawer.dart';

class Kependudukan extends StatelessWidget {
  const Kependudukan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kependudukan')),
      drawer: SideDrawer(),
      body: const Center(child: Text('Halaman Kependudukan')),
    );
  }
}

