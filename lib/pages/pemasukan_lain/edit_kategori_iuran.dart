import 'package:flutter/material.dart';

class EditKategoriIuran extends StatefulWidget {
  final Map<String, dynamic> dataEdit;

  const EditKategoriIuran({super.key, required this.dataEdit});

  @override
  State<EditKategoriIuran> createState() => _EditKategoriIuranState();
}

class _EditKategoriIuranState extends State<EditKategoriIuran> {
  late TextEditingController _namaController;
  late TextEditingController _jumlahController;
  String? _kategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dataEdit['nama']);
    _jumlahController = TextEditingController(text: widget.dataEdit['jumlah']);
    _kategori = widget.dataEdit['kategori'];
  }

  void _simpanData() {
    Navigator.pop(context, {
      'nama': _namaController.text,
      'jumlah': _jumlahController.text,
      'kategori': _kategori,
    });
  }

  void _resetForm() {
    setState(() {
      _namaController.text = widget.dataEdit['nama'];
      _jumlahController.text = widget.dataEdit['jumlah'];
      _kategori = widget.dataEdit['kategori'];
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
        title: const Text('Edit Kategori Iuran'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
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