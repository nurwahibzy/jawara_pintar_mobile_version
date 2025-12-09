import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/channel_transfer_model.dart';
import '../../domain/entities/channel_transfer_entities.dart';
import '../bloc/channel_transfer_bloc.dart';
import '../bloc/channel_transfer_event.dart';
import '../bloc/channel_transfer_state.dart';

class TambahTransferChannelPage extends StatefulWidget {
  const TambahTransferChannelPage({super.key});

  @override
  State<TambahTransferChannelPage> createState() =>
      _TambahTransferChannelPageState();
}

class _TambahTransferChannelPageState extends State<TambahTransferChannelPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorRekeningController = TextEditingController();
  final TextEditingController namaPemilikController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  ChannelType? tipe;
  File? qrFile;
  File? thumbnailFile;
  final ImagePicker _picker = ImagePicker();

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Future<void> _pickQr() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => qrFile = File(picked.path));
  }

  Future<void> _pickThumbnail() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => thumbnailFile = File(picked.path));
  }

Future<void> _simpan() async {
    if (namaController.text.trim().isEmpty) {
      return _showError("Nama channel tidak boleh kosong!");
    }

    if (tipe == null) {
      return _showError("Pilih tipe channel terlebih dahulu");
    }

    switch (tipe) {
      case ChannelType.Bank:
        if (nomorRekeningController.text.trim().isEmpty) {
          return _showError("Nomor rekening wajib untuk tipe BANK");
        }
        if (namaPemilikController.text.trim().isEmpty) {
          return _showError("Nama pemilik wajib untuk tipe BANK");
        }
        break;

      case ChannelType.QRIS:
        if (qrFile == null) {
          return _showError("QR wajib diupload untuk tipe QR");
        }
        break;

      case ChannelType.EWallet: 
       if (namaPemilikController.text.trim().isEmpty) {
          return _showError("Nama Pemilik wajib untuk tipe E-Wallet");
        }
        if (thumbnailFile == null) {
          return _showError("Thumbnail wajib untuk tipe E-Wallet");
        }
        break;

      default:
        break;
    }

    // Auth cek
    final userUid = Supabase.instance.client.auth.currentUser?.id;
    if (userUid == null) return _showError("User belum login");

    final response = await Supabase.instance.client
        .from('users')
        .select('id')
        .eq('auth_id', userUid)
        .maybeSingle();

    final userId = response?['id'] as int?;
    if (userId == null)
      return _showError("User tidak ditemukan di tabel users");

    final newChannel = TransferChannel(
      namaChannel: namaController.text.trim(),
      tipe: tipe!,
      nomorRekening: nomorRekeningController.text.trim().isEmpty
          ? null
          : nomorRekeningController.text.trim(),
      namaPemilik: namaPemilikController.text.trim().isEmpty
          ? null
          : namaPemilikController.text.trim(),
      qrUrl: null,
      thumbnailUrl: null,
      catatan: catatanController.text.trim().isEmpty
          ? null
          : catatanController.text.trim(),
      createdBy: userId,
      createdAt: DateTime.now(),
    );

    context.read<TransferChannelBloc>().add(
      CreateTransferChannelEvent(
        newChannel,
        qrFile: qrFile,
        thumbnailFile: thumbnailFile,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }


  void _resetForm() {
    setState(() {
      namaController.clear();
      nomorRekeningController.clear();
      namaPemilikController.clear();
      catatanController.clear();
      tipe = null;
      qrFile = null;
      thumbnailFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Tambah Channel Transfer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: BlocListener<TransferChannelBloc, TransferChannelState>(
        listener: (context, state) {
          if (state is TransferChannelActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context, true);
          } else if (state is TransferChannelError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Nama Channel
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Channel",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
              ),
              const SizedBox(height: 12),

              // Tipe Channel
              DropdownButtonFormField<ChannelType>(
                value: tipe,
                decoration: InputDecoration(
                  labelText: "Tipe Channel",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                items: ChannelType.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                    .toList(),
                onChanged: (val) => setState(() => tipe = val),
              ),
              const SizedBox(height: 12),

              // Nomor Rekening
              TextField(
                controller: nomorRekeningController,
                decoration: InputDecoration(
                  labelText: "Nomor Rekening",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Nama Pemilik
              TextField(
                controller: namaPemilikController,
                decoration: InputDecoration(
                  labelText: "Nama Pemilik",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
              ),
              const SizedBox(height: 12),

              // Catatan
              TextField(
                controller: catatanController,
                decoration: InputDecoration(
                  labelText: "Catatan",
                  border: _inputBorder(theme.dividerColor),
                  focusedBorder: _inputBorder(theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // QR Image
              GestureDetector(
                onTap: _pickQr,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                  ),
                  child: qrFile == null
                      ? const Center(child: Text("Klik untuk unggah QR"))
                      : Image.file(qrFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),

              // Thumbnail Image
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                  ),
                  child: thumbnailFile == null
                      ? const Center(child: Text("Klik untuk unggah Thumbnail"))
                      : Image.file(thumbnailFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan & Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Simpan",
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
      ),
    );
  }
}