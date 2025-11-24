import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_state.dart';
import 'package:intl/intl.dart';


class EditPengeluaranPage extends StatefulWidget {
  final Pengeluaran pengeluaran;
  

  const EditPengeluaranPage({super.key, required this.pengeluaran,
  });
  

  @override
  State<EditPengeluaranPage> createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  late TextEditingController namaController;
  late TextEditingController nominalController;
  late TextEditingController keteranganController;
  String? kategori;
  DateTime? tanggalPengeluaran;
  File? buktiGambar;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController tanggalController;

  @override
  void initState() {
    super.initState();
    final data = widget.pengeluaran;
    namaController = TextEditingController(text: data.judul);
    keteranganController = TextEditingController(text: data.keterangan);
    nominalController = TextEditingController(
      text: formatNumber(data.nominal.toInt().toString()),
    );

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

    kategori = _mapKategoriIdToString(data.kategoriTransaksiId);
    tanggalController = TextEditingController(
      text:
          "${data.tanggalTransaksi.day}/${data.tanggalTransaksi.month}/${data.tanggalTransaksi.year}",
    );
    tanggalPengeluaran = data.tanggalTransaksi;

    if (data.buktiFoto != null && data.buktiFoto!.isNotEmpty) {
      buktiGambar = File(data.buktiFoto!);
    }
  }

  void _resetForm() {
    setState(() {
      namaController.clear();
      nominalController.clear();
      keteranganController.clear();
      kategori = null;
      tanggalPengeluaran = null;
      buktiGambar = null;
    });
  }


  String _mapKategoriIdToString(int id) {
    switch (id) {
      case 1:
        return "Dana Hibah/Donasi";
      case 2:
        return "Penjualan Sampah Daur Ulang";
      case 3:
        return "Operasional RT";
      case 4:
        return "Perbaikan Fasilitas";
      default:
        return "Lainnya";
    }
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
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tanggalPengeluaran = picked;
        tanggalController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
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

    final updatedPengeluaran = Pengeluaran(
      id: widget.pengeluaran.id,
      judul: namaController.text,
      kategoriTransaksiId: _mapKategoriStringToId(kategori),
      nominal: double.tryParse(nominalController.text.replaceAll('.', '')) ?? 0,
      tanggalTransaksi: tanggalPengeluaran!,
      buktiFoto: buktiGambar?.path,
      keterangan: keteranganController.text,
      createdBy: widget.pengeluaran.createdBy,
      verifikatorId: widget.pengeluaran.verifikatorId,
      tanggalVerifikasi: widget.pengeluaran.tanggalVerifikasi,
      createdAt: widget.pengeluaran.createdAt,
    );

    context.read<PengeluaranBloc>().add(
      UpdatePengeluaranEvent(updatedPengeluaran),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  String formatNumber(String s) {
    if (s.isEmpty) return '';
    s = s.replaceAll('.', ''); 

    final number = int.tryParse(s);
    if (number == null) return '';

    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number).replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pengeluaran"), centerTitle: true),
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
              TextField(
                controller: namaController,
                cursorColor: theme.colorScheme.primary,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: "Nama Pengeluaran",
                  hintText: "Masukkan nama pengeluaran",
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickTanggal,
                child: AbsorbPointer(
                  child: TextField(
                    controller: tanggalController,
                    cursorColor: theme.colorScheme.primary,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: "Tanggal Pengeluaran",
                      enabledBorder: _inputBorder(theme.dividerColor),
                      focusedBorder: _inputBorder(theme.colorScheme.primary),
                      filled: true,
                      fillColor:
                          theme.inputDecorationTheme.fillColor ??
                          theme.cardColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: kategori,
                decoration: InputDecoration(
                  labelText: "Kategori Pengeluaran",
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                ),
                items: [
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
              TextField(
                controller: nominalController,
                cursorColor: theme.colorScheme.primary,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: "Nominal",
                  hintText: "Masukkan nominal",
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keteranganController,
                cursorColor: theme.colorScheme.primary,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  hintText: "Masukkan keterangan pengeluaran",
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Text(
                "Bukti Pengeluaran",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                  ),
                  child: buktiGambar == null
                      ? Center(
                          child: Text(
                            "Klik untuk unggah bukti (PNG/JPG)",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
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
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Perbarui",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Reset",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
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