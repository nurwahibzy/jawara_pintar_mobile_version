import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_state.dart';

class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  DateTime? tanggalPengeluaran;
  String? kategori;
  File? buktiGambar;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Auto-format nominal
    nominalController.addListener(() {
      final text = nominalController.text.replaceAll('.', '');
      if (text.isEmpty) return;

      final formatted = formatNumber(text);

      if (nominalController.text != formatted) {
        final cursorPos = formatted.length;
        nominalController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
    });
  }

  String formatNumber(String s) {
    if (s.isEmpty) return '';
    s = s.replaceAll('.', '');

    final number = int.tryParse(s);
    if (number == null) return '';

    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number).replaceAll(',', '.');
  }

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalPengeluaran ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => tanggalPengeluaran = picked);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) setState(() => buktiGambar = File(pickedFile.path));
  }

  int _mapKategoriStringToId(String? kategori) {
    switch (kategori) {
      case "Dana Hibah/Donasi":
        return 1;
      case "Penjualan Sampah Daur Ulang":
        return 2;
      case "Operasional RT":
        return 3;
      case "Perbaikan Fasilitas":
        return 4;
      default:
        return 0;
    }
  }

  void _simpanData() {
    if (namaController.text.isEmpty ||
        nominalController.text.isEmpty ||
        kategori == null ||
        tanggalPengeluaran == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua field')));
      return;
    }

    final newPengeluaran = Pengeluaran(
      judul: namaController.text,
      kategoriTransaksiId: _mapKategoriStringToId(kategori),
      nominal: double.tryParse(nominalController.text.replaceAll('.', '')) ?? 0,
      tanggalTransaksi: tanggalPengeluaran!,
      buktiFoto: buktiGambar?.path,
      keterangan: keteranganController.text,
      createdBy: 1, // Sesuaikan dengan user login
      verifikatorId: null,
      tanggalVerifikasi: null,
      createdAt: DateTime.now(),
    );

    context.read<PengeluaranBloc>().add(CreatePengeluaranEvent(newPengeluaran));
  }

  void _resetForm() {
    setState(() {
      namaController.clear();
      nominalController.clear();
      keteranganController.clear();
      tanggalPengeluaran = null;
      kategori = null;
      buktiGambar = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
        centerTitle: true,
      ),
      body: BlocListener<PengeluaranBloc, PengeluaranState>(
        listener: (context, state) {
          if (state is PengeluaranActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context, true);
          } else if (state is PengeluaranError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Nama Pengeluaran
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Pengeluaran",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
              ),
              const SizedBox(height: 12),

              // Tanggal Pengeluaran
              GestureDetector(
                onTap: _pickTanggal,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: tanggalPengeluaran == null
                          ? "Tanggal Pengeluaran"
                          : "${tanggalPengeluaran!.day}/${tanggalPengeluaran!.month}/${tanggalPengeluaran!.year}",
                      border: _inputBorder(theme.dividerColor),
                      focusedBorder: _inputBorder(theme.colorScheme.primary),
                      filled: true,
                      fillColor: theme.cardColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Kategori
              DropdownButtonFormField<String>(
                value: kategori,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                items:
                    [
                          'Dana Hibah/Donasi',
                          'Penjualan Sampah Daur Ulang',
                          'Operasional RT',
                          'Perbaikan Fasilitas',
                          'Lainnya',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => kategori = val),
              ),
              const SizedBox(height: 12),

              // Nominal
              TextField(
                controller: nominalController,
                decoration: InputDecoration(
                  labelText: "Nominal",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Keterangan
              TextField(
                controller: keteranganController,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Bukti Gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                  ),
                  child: buktiGambar == null
                      ? const Center(child: Text("Klik untuk unggah bukti"))
                      : Image.file(buktiGambar!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan & Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpanData,
                      child: const Text("Simpan"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}