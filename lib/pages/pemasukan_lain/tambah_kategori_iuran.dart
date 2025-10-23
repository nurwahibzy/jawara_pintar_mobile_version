import 'package:flutter/material.dart';

class TambahKategoriIuran extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSubmit;

  const TambahKategoriIuran({super.key, this.onSubmit});

  @override
  State<TambahKategoriIuran> createState() => _TambahKategoriIuranState();
}

class _TambahKategoriIuranState extends State<TambahKategoriIuran> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String? _kategori;

  void _simpanData() {
    if (_namaController.text.isEmpty ||
        _jumlahController.text.isEmpty ||
        _kategori == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua field!')));
      return;
    }

    if (widget.onSubmit != null) {
      widget.onSubmit!({
        'nama': _namaController.text,
        'jumlah': _jumlahController.text,
        'kategori': _kategori,
      });
    }

    Navigator.pop(context);
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _jumlahController.clear();
      _kategori = null;
    });
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _kategori,
          hint: const Text('-- Pilih Kategori --'),
          isExpanded: true,
          iconEnabledColor: Colors.green,
          items: [
            'Bulanan',
            'Tahunan',
            'Lainnya',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => _kategori = val),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Iuran Baru'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Masukkan data iuran baru dengan lengkap.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Nama Iuran',
              hint: 'Masukkan nama iuran',
              controller: _namaController,
            ),
            _buildTextField(
              label: 'Jumlah',
              hint: 'Masukkan jumlah',
              controller: _jumlahController,
              keyboardType: TextInputType.number,
            ),
            _buildDropdownField(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}