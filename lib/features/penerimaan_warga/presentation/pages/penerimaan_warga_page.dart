import 'package:flutter/material.dart';

class PenerimaanWargaPage extends StatelessWidget {
  const PenerimaanWargaPage({super.key});

  static const String routeName = '/penerimaan_warga';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PenerimaanWarga')),
      body: const Center(child: Text('PenerimaanWarga Page')),
    );
  }
}
