import 'package:flutter/material.dart';

class TambahBroadCastPage extends StatelessWidget {
  const TambahBroadCastPage({super.key});

  void _showTambahBroadcast(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Broadcast'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Isi Broadcast',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // simpan data broadcast
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Broadcast')),
      body: const Center(
        child: Text('Form Tambah Broadcast'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTambahBroadcast(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
