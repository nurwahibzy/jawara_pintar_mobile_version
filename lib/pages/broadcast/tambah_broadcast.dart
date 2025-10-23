import 'package:flutter/material.dart';

class TambahBroadcastPage extends StatefulWidget {
  const TambahBroadcastPage({super.key});
  @override
  State<TambahBroadcastPage> createState() => _TambahBroadcastPageState();
}

class _TambahBroadcastPageState extends State<TambahBroadcastPage> {
  final _formKey = GlobalKey<FormState>();
  final _pengirimController = TextEditingController();
  final _judulController = TextEditingController();
  final _isiPesanController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _pengirimController.text = 'Admin Jawara';
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
          _selectedDate == null
              ? 'Pilih tanggal'
              : _selectedDate!.toLocal().toString().split(' ')[0],
          style: TextStyle(
            color: _selectedDate == null ? Colors.grey[700] : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Broadcast'),
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
                const Text('Buat Broadcast Baru',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('Pengirim',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pengirimController,
                  readOnly: true, // Pengirim tidak bisa diubah
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
                _buildDatePicker(), // Date picker
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
                          if (_formKey.currentState!.validate() &&
                              _selectedDate != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Broadcast berhasil dikirim')));
                            Navigator.pop(context);
                          } else if (_selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Tanggal harus dipilih')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: const Text('Kirim'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _judulController.clear();
                          _isiPesanController.clear();
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: const Text('Reset'),
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