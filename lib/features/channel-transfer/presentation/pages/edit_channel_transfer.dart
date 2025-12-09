import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/channel_transfer_model.dart';
import '../../domain/entities/channel_transfer_entities.dart';
import '../bloc/channel_transfer_bloc.dart';
import '../bloc/channel_transfer_event.dart';
import '../bloc/channel_transfer_state.dart';

class EditTransferChannelPage extends StatefulWidget {
  final TransferChannel channel;

  const EditTransferChannelPage({super.key, required this.channel});

  @override
  State<EditTransferChannelPage> createState() =>
      _EditTransferChannelPageState();
}

class _EditTransferChannelPageState extends State<EditTransferChannelPage> {
  late TextEditingController namaController;
  late TextEditingController nomorRekeningController;
  late TextEditingController namaPemilikController;
  late TextEditingController catatanController;

  ChannelType? tipe;
  File? qrFile;
  File? thumbnailFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = widget.channel;

    namaController = TextEditingController(text: data.namaChannel);
    nomorRekeningController = TextEditingController(
      text: data.nomorRekening ?? '',
    );
    namaPemilikController = TextEditingController(text: data.namaPemilik ?? '');
    catatanController = TextEditingController(text: data.catatan ?? '');
    tipe = data.tipe;

    if (data.qrUrl != null &&
        data.qrUrl!.isNotEmpty &&
        !data.qrUrl!.startsWith("http")) {
      qrFile = File(data.qrUrl!);
    }
    if (data.thumbnailUrl != null &&
        data.thumbnailUrl!.isNotEmpty &&
        !data.thumbnailUrl!.startsWith("http")) {
      thumbnailFile = File(data.thumbnailUrl!);
    }
  }

  void _resetForm() {
    setState(() {
      namaController.text = widget.channel.namaChannel;
      nomorRekeningController.text = widget.channel.nomorRekening ?? '';
      namaPemilikController.text = widget.channel.namaPemilik ?? '';
      catatanController.text = widget.channel.catatan ?? '';
      tipe = widget.channel.tipe;
      qrFile =
          (widget.channel.qrUrl != null &&
              !widget.channel.qrUrl!.startsWith("http"))
          ? File(widget.channel.qrUrl!)
          : null;
      thumbnailFile =
          (widget.channel.thumbnailUrl != null &&
              !widget.channel.thumbnailUrl!.startsWith("http"))
          ? File(widget.channel.thumbnailUrl!)
          : null;
    });
  }

  Future<void> _pickQr() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => qrFile = File(picked.path));
  }

  Future<void> _pickThumbnail() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => thumbnailFile = File(picked.path));
  }

  void _simpanData() {
    if (namaController.text.trim().isEmpty) {
      return _showError("Nama channel tidak boleh kosong!");
    }

    if (tipe == null) {
      return _showError("Pilih tipe channel terlebih dahulu");
    }

    switch (tipe!) {
      case ChannelType.QRIS:
        if (qrFile == null &&
            (widget.channel.qrUrl == null || widget.channel.qrUrl!.isEmpty)) {
          return _showError("QR wajib diupload untuk tipe QRIS");
        }
        break;

      case ChannelType.EWallet:
      if (namaPemilikController.text.trim().isEmpty) {
        return _showError("Nama Pemilik wajib untuk tipe E-Wallet");
      }
      if (thumbnailFile == null && (widget.channel.thumbnailUrl == null || widget.channel.thumbnailUrl!.isEmpty)) {
        return _showError("Thumbnail wajib untuk tipe E-Wallet");
      }
      break;

    case ChannelType.Bank:
      if (nomorRekeningController.text.trim().isEmpty) {
        return _showError("Nomor rekening wajib untuk tipe BANK");
      }
      if (namaPemilikController.text.trim().isEmpty) {
        return _showError("Nama pemilik wajib untuk tipe BANK");
      }
      break;
    }

    final updatedChannel = TransferChannel(
      id: widget.channel.id,
      namaChannel: namaController.text.trim(),
      tipe: tipe!,
      nomorRekening: nomorRekeningController.text.trim().isEmpty
          ? null
          : nomorRekeningController.text.trim(),
      namaPemilik: namaPemilikController.text.trim().isEmpty
          ? null
          : namaPemilikController.text.trim(),
      qrUrl: qrFile != null ? null : widget.channel.qrUrl,
      thumbnailUrl: thumbnailFile != null ? null : widget.channel.thumbnailUrl,
      catatan: catatanController.text.trim().isEmpty
          ? null
          : catatanController.text.trim(),
      createdBy: widget.channel.createdBy,
      createdAt: widget.channel.createdAt,
    );

     context.read<TransferChannelBloc>().add(
      UpdateTransferChannelEvent(
        channel: updatedChannel,
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

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Edit Channel Transfer",
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

              // Tipe
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
                  child: qrFile != null
                      ? Image.file(qrFile!, fit: BoxFit.cover)
                      : (widget.channel.qrUrl != null
                            ? Image.network(
                                widget.channel.qrUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text("Klik untuk unggah QR"),
                              )),
                ),
              ),
              const SizedBox(height: 12),

              // Thumbnail
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.cardColor,
                  ),
                  child: thumbnailFile != null
                      ? Image.file(thumbnailFile!, fit: BoxFit.cover)
                      : (widget.channel.thumbnailUrl != null
                            ? Image.network(
                                widget.channel.thumbnailUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text("Klik untuk unggah Thumbnail"),
                              )),
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
                        backgroundColor: AppColors.primary,
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
      ),
    );
  }
}