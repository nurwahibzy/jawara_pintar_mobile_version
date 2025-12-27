import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

import '../../../../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../../../../features/pengeluaran/domain/entities/kategori_transaksi.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_state.dart';

class EditPengeluaranPage extends StatefulWidget {
  final Pengeluaran pengeluaran;
  final List<KategoriEntity> kategoriList;

  const EditPengeluaranPage({
    super.key,
    required this.pengeluaran,
    required this.kategoriList,
  });

  @override
  State<EditPengeluaranPage> createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  late TextEditingController namaController;
  late TextEditingController nominalController;
  late TextEditingController keteranganController;
  late TextEditingController tanggalController;

  String? kategori;
  DateTime? tanggalPengeluaran;
  File? buktiGambar;
  final ImagePicker _picker = ImagePicker();

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

    kategori = widget.kategoriList
        .firstWhere(
          (k) => k.id == data.kategoriTransaksiId,
          orElse: () =>
              KategoriEntity(id: 0, nama_kategori: 'Lainnya', jenis: 'Lainnya'),
        )
        .nama_kategori;

    tanggalPengeluaran = data.tanggalTransaksi;
    tanggalController = TextEditingController(
      text:
          "${data.tanggalTransaksi.day}/${data.tanggalTransaksi.month}/${data.tanggalTransaksi.year}",
    );

    if (data.buktiFoto != null && data.buktiFoto!.isNotEmpty && !data.buktiFoto!.startsWith("http")) {buktiGambar = File(data.buktiFoto!);
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
      tanggalController.clear();
    });
  }

  int _mapKategoriStringToId(String? kategori) {
    final found = widget.kategoriList.firstWhere(
      (k) => k.nama_kategori == kategori,
      orElse: () =>
          KategoriEntity(id: 0, nama_kategori: 'Lainnya', jenis: 'Lainnya'),
    );
    return found.id;
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
      buktiFoto: widget.pengeluaran.buktiFoto, 
      keterangan: keteranganController.text,
      createdBy: widget.pengeluaran.createdBy,
      createdAt: widget.pengeluaran.createdAt,
    );

    context.read<PengeluaranBloc>().add(
      UpdatePengeluaranEvent(
        pengeluaran: updatedPengeluaran,
        buktiFile: buktiGambar, 
        oldBuktiUrl: widget.pengeluaran.buktiFoto, 
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );

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
    appBar: AppBar(
        backgroundColor: AppColors.primary, 
        centerTitle: true,
        title: const Text(
          "Edit Pengeluaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
              TextField(
                key: const Key('input_nama_pengeluaran'),
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
                key: const Key('input_tanggal_pengeluaran'),
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
                key: const Key('dropdown_kategori'),
                initialValue: kategori,
                decoration: InputDecoration(
                  labelText: "Kategori Pengeluaran",
                  enabledBorder: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                ),
                items: widget.kategoriList
                    .map(
                      (k) => DropdownMenuItem(
                        value: k.nama_kategori,
                        child: Text(k.nama_kategori ?? 'Lainnya'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => kategori = val),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('input_nominal'),
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
                key: const Key('input_keterangan'),
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
             key: const Key('input_bukti_gambar'),
  onTap: _pickImage,
  child: Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.dividerColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: buktiGambar != null
          ? Image.file(
              buktiGambar!,
              fit: BoxFit.contain,
            )
          : (widget.pengeluaran.buktiFoto != null &&
                  widget.pengeluaran.buktiFoto!.isNotEmpty)
              ? Image.network(
                  widget.pengeluaran.buktiFoto!,
                  fit: BoxFit.contain,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: theme.hintColor, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        "Klik untuk unggah bukti (PNG/JPG)",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    ),
  ),
),
              const SizedBox(height: 24),
              // Bagian tombol Simpan & Reset di build()
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('btn_update_form'),
                      onPressed: _simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, 
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Perbarui",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white, 
                        ),
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
                      child: Text(
                        "Reset",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white, 
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