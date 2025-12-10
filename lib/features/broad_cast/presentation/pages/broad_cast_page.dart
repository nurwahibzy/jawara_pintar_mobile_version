import 'package:flutter/material.dart';

import '../../domain/entities/broadcast.dart';

class BroadCastPage extends StatefulWidget {
  final BroadCastPage addBroadcast;

  const BroadCastPage({super.key, required this.addBroadcast});

  @override
  State<BroadCastPage> createState() => _BroadCastPageState();
}

class _BroadCastPageState extends State<BroadCastPage> {
  final _gambarController = TextEditingController();
  final _dokumenController = TextEditingController();

  void _submit() async {
    final newBroadcast = (
      lampiranGambar: _gambarController.text.isEmpty ? null : _gambarController.text,
      lampiranDokumen: _dokumenController.text.isEmpty ? null : _dokumenController.text,
      createdBy: 1,
    );

    await widget.addBroadcast;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Broadcast berhasil ditambahkan!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Broadcast')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _gambarController,
              decoration: const InputDecoration(labelText: 'Lampiran Gambar'),
            ),
            TextField(
              controller: _dokumenController,
              decoration: const InputDecoration(labelText: 'Lampiran Dokumen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

// class BroadCastPage extends StatelessWidget {
//   const BroadCastPage({super.key});

//   static const String routeName = '/broad_cast';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('BroadCast')),
//       body: const Center(child: Text('BroadCast Page')),
//     );
//   }
// }
