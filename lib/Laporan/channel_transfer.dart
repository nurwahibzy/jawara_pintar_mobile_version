import 'package:flutter/material.dart';

/// Model data ChannelTransfer
class ChannelTransfer {
  final String namaChannel;
  final double nominal;
  final String tanggal;

  ChannelTransfer({
    required this.namaChannel,
    required this.nominal,
    required this.tanggal,
  });
}

/// Halaman Tambah Channel Transfer
class AddChannelTransferPage extends StatefulWidget {
  const AddChannelTransferPage({super.key});

  @override
  State<AddChannelTransferPage> createState() => _AddChannelTransferPageState();
}

class _AddChannelTransferPageState extends State<AddChannelTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nominalController = TextEditingController();

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      final newTransfer = ChannelTransfer(
        namaChannel: _namaController.text,
        nominal: double.parse(_nominalController.text),
        tanggal: DateTime.now().toString().substring(0, 10),
      );

      Navigator.pop(context, newTransfer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Channel Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Channel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama Channel wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal Transfer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nominal wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _simpanData,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
