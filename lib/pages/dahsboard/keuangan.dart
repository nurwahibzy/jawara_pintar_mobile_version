import 'package:flutter/material.dart ';
import 'package:jawara_pintar_mobile_version/widgets/side_drawer.dart';

class Keuangan extends StatelessWidget {
  const Keuangan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keuangan')),
      drawer: SideDrawer(),
      body: const Center(child: Text('Halaman Keuangan')),
    );
  }
}