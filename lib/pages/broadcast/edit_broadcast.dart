import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/daftar_broadcast.dart';

class EditBroadcastPage extends StatefulWidget {
  final Broadcast broadcast;
  const EditBroadcastPage({super.key, required this.broadcast});

  @override
  State<EditBroadcastPage> createState() => _EditBroadcastPageState();
}

class _EditBroadcastPageState extends State<EditBroadcastPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pengirimController;
  late TextEditingController _judulController;
  late TextEditingController _isiPesanController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Isi data dari broadcast yang akan diedit
    _pengirimController =
        TextEditingController(text: widget.broadcast.pengirim);
    _judulController = TextEditingController(text: widget.broadcast.judul);
    _isiPesanController =
        TextEditingController(text: widget.broadcast.isiPesan);
    _selectedDate = widget.broadcast.tanggal;
  }

  @override
  void dispose() {
    _pengirimController.dispose();
    _judulController.dispose();
    _isiPesanController.dispose();
    super.dispose();
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _selectedDate!.toLocal().toString().split(' ')[0],
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Broadcast'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pengirim',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pengirimController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    fillColor: Color(0xFFF0F0F0),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Judul',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan judul broadcast',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Judul harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text('Tanggal',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDatePicker(),
                const SizedBox(height: 16),
                const Text('Isi Pesan',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _isiPesanController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan isi pesan broadcast...',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  maxLines: 6,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pesan harus diisi' : null,
                ),
                const SizedBox(height: 24),
                // Tombol
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Perubahan berhasil disimpan')));
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: const Text('Simpan Perubahan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}