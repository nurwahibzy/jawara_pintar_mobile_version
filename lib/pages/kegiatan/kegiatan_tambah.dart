import 'package:flutter/material.dart';

class TambahKegiatan extends StatefulWidget {
  const TambahKegiatan({super.key});
  @override
  State<TambahKegiatan> createState() => _TambahKegiatanState();
}

class _TambahKegiatanState extends State<TambahKegiatan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _pjController = TextEditingController();
  final _deskripsiController = TextEditingController();
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
        title: const Text('Tambah Kegiatan', ),
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
                const Text('Tambah Kegiatan Baru',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('Nama Kegiatan',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text('Kategori Kegiatan',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('-- Pilih Kategori --'),
                  items: kategoriList.map((String kategori) {
                    return DropdownMenuItem<String>(
                        value: kategori, child: Text(kategori));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedKategori = newValue);
                  },
                  validator: (value) =>
                      value == null ? 'Harus dipilih' : null,
                ),
                const SizedBox(height: 16),
                const Text('Tanggal',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDatePicker(),
                const SizedBox(height: 16),
                const Text('Lokasi',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan lokasi kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text('Penanggung Jawab',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pjController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama penanggung jawab',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text('Deskripsi',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan deskripsi singkat kegiatan',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  maxLines: 4,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                const Text('Upload Dokumentasi',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Fitur upload akan segera tersedia')));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Column(children: [
                      Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Upload dokumentasi (.png/.jpg)',
                          style: TextStyle(color: Colors.grey)),
                    ]),
                  ),
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
                            // Logika simpan data baru
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Data berhasil disimpan')));
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
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _namaController.clear();
                          _lokasiController.clear();
                          _pjController.clear();
                          _deskripsiController.clear();
                          setState(() {
                            _selectedDate = null;
                            _selectedKategori = null;
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