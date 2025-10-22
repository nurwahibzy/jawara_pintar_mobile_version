import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_daftar.dart';

class EditKegiatan extends StatefulWidget {
  final ModelKegiatan kegiatan; // Menerima data kegiatan yang akan diedit

  const EditKegiatan({super.key, required this.kegiatan});

  @override
  State<EditKegiatan> createState() => _EditKegiatanState();
}

class _EditKegiatanState extends State<EditKegiatan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _lokasiController;
  late TextEditingController _pjController;
  late TextEditingController _deskripsiController;
  DateTime? _selectedDate;
  String? _selectedKategori;

  final List<String> kategoriList = [
    'Komunitas & Sosial',
    'Olahraga',
    'Keagamaan',
    'Acara Khusus',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kegiatan.namaKegiatan);
    _lokasiController = TextEditingController(text: widget.kegiatan.lokasi);
    _pjController = TextEditingController(
      text: widget.kegiatan.penanggungJawab,
    );
    _deskripsiController = TextEditingController(
      text: widget.kegiatan.deskripsi,
    );
    _selectedDate = widget.kegiatan.tanggal;
    _selectedKategori = widget.kegiatan.kategori;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _pjController.dispose();
    _deskripsiController.dispose();
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
          _selectedDate!.toLocal().toString().split(
            ' ',
          )[0], // Tidak mungkin null
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kegiatan'),
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
                const Text(
                  'Nama Kegiatan',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController, // Sudah terisi
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kategori Kegiatan',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedKategori, // Sudah terisi
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  hint: const Text('-- Pilih Kategori --'),
                  items: kategoriList.map((String kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedKategori = newValue);
                  },
                  validator: (value) => value == null ? 'Harus dipilih' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tanggal',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildDatePicker(), // Sudah terisi
                const SizedBox(height: 16),
                const Text(
                  'Lokasi',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lokasiController, // Sudah terisi
                  decoration: const InputDecoration(
                    hintText: 'Masukkan lokasi kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Penanggung Jawab',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pjController, // Sudah terisi
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama penanggung jawab',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deskripsiController, // Sudah terisi
                  decoration: const InputDecoration(
                    hintText: 'Masukkan deskripsi singkat kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload Dokumentasi',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur upload akan segera tersedia'),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Upload dokumentasi (.png/.jpg)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Perubahan berhasil disimpan'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        // Teks tombol diubah
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
