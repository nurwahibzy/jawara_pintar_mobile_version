import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahPengeluaran extends StatefulWidget {
  final Map<String, dynamic>? dataEdit;

  const TambahPengeluaran({super.key, this.dataEdit});

  @override
  State<TambahPengeluaran> createState() => _TambahPengeluaranState();
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  String? kategori;
  DateTime? tanggalPengeluaran;
  File? buktiGambar;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.dataEdit != null) {
      final data = widget.dataEdit!;
      namaController.text = data['nama'] ?? '';
      nominalController.text = data['nominal'] ?? '';
      kategori = data['kategori'];
      if (data['tanggal'] != null) {
        try {
          tanggalPengeluaran = DateTime.parse(data['tanggal']);
          tanggalController.text =
              "${tanggalPengeluaran!.day}/${tanggalPengeluaran!.month}/${tanggalPengeluaran!.year}";
        } catch (_) {}
      }
      if (data['bukti'] != null && data['bukti'].toString().isNotEmpty) {
        buktiGambar = File(data['bukti']);
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        buktiGambar = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalPengeluaran ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        tanggalPengeluaran = picked;
        tanggalController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _resetForm() {
    setState(() {
      namaController.clear();
      nominalController.clear();
      tanggalController.clear();
      kategori = null;
      tanggalPengeluaran = null;
      buktiGambar = null;
    });
  }

  void _simpanData() {
    Navigator.pop(context, {
      'nama': namaController.text,
      'tanggal': tanggalPengeluaran?.toIso8601String(),
      'kategori': kategori,
      'nominal': nominalController.text,
      'bukti': buktiGambar?.path,
    });
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.dataEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Pengeluaran" : "Tambah Pengeluaran"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: namaController,
              cursorColor: Colors.green,
              decoration: _inputDecoration(
                "Nama Pengeluaran",
                "Masukkan nama pengeluaran",
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickTanggal,
              child: AbsorbPointer(
                child: TextField(
                  controller: tanggalController,
                  cursorColor: Colors.green,
                  decoration: _inputDecoration(
                    "Tanggal Pengeluaran",
                    "--/--/----",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: kategori,
              decoration: _inputDecoration("Kategori Pengeluaran", ""),
              items: [
                "Operasional",
                "Konsumsi",
                "Transportasi",
                "Lainnya",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => kategori = val),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nominalController,
              cursorColor: Colors.green,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Nominal", "Masukkan nominal"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Bukti Pengeluaran",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buktiGambar == null
                    ? const Center(
                        child: Text("Klik untuk unggah bukti (PNG/JPG)"),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(buktiGambar!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      isEdit ? "Perbarui" : "Simpan",
                      style: const TextStyle(color: Colors.white),
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
                      "Reset",
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