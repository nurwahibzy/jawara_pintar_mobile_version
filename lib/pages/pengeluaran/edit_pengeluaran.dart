import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPengeluaranPage extends StatefulWidget {
  final Map<String, dynamic> pengeluaran;
  const EditPengeluaranPage({super.key, required this.pengeluaran});

  @override
  State<EditPengeluaranPage> createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  String? kategori;
  DateTime? tanggalPengeluaran;
  File? buktiGambar;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = widget.pengeluaran;
    namaController.text = data['nama'] ?? '';
    nominalController.text = data['nominal'] ?? '';
    kategori = data['kategori'];
    if (data['tanggal'] != null) {
      try {
        tanggalPengeluaran = DateTime.parse(data['tanggal']);
      } catch (_) {}
    }
    if (data['bukti'] != null && data['bukti'].toString().isNotEmpty) {
      buktiGambar = File(data['bukti']);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) setState(() => buktiGambar = File(pickedFile.path));
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
              primary: Colors.green, // header & tombol OK/Cancel
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
    if (picked != null) setState(() => tanggalPengeluaran = picked);
  }

  void _resetForm() {
    setState(() {
      namaController.clear();
      nominalController.clear();
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

  // Fungsi untuk membuat border kotak hijau saat fokus
  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pengeluaran"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Nama Pengeluaran
            TextField(
              controller: namaController,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                labelText: "Nama Pengeluaran",
                hintText: "Masukkan nama pengeluaran",
                enabledBorder: _inputBorder(Colors.grey),
                focusedBorder: _inputBorder(Colors.green),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Tanggal Pengeluaran
            GestureDetector(
              onTap: _pickTanggal,
              child: AbsorbPointer(
                child: TextField(
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    labelText: "Tanggal Pengeluaran",
                    hintText: tanggalPengeluaran == null
                        ? "dd/mm/yyyy"
                        : "${tanggalPengeluaran!.day}/${tanggalPengeluaran!.month}/${tanggalPengeluaran!.year}",
                    enabledBorder: _inputBorder(Colors.grey),
                    focusedBorder: _inputBorder(Colors.green),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Kategori
            DropdownButtonFormField<String>(
              value: kategori,
              decoration: InputDecoration(
                labelText: "Kategori Pengeluaran",
                enabledBorder: _inputBorder(Colors.grey),
                focusedBorder: _inputBorder(Colors.green),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                "Operasional",
                "Konsumsi",
                "Transportasi",
                "Lainnya",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => kategori = val),
            ),
            const SizedBox(height: 12),

            // Nominal
            TextField(
              controller: nominalController,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                labelText: "Nominal",
                hintText: "Masukkan nominal",
                enabledBorder: _inputBorder(Colors.grey),
                focusedBorder: _inputBorder(Colors.green),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Bukti Pengeluaran
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

            // Tombol Simpan & Reset
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
                      "Perbarui",
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