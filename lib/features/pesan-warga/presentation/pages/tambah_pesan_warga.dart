import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../domain/entities/pesan_warga.dart';
import '../bloc/pesan_warga_bloc.dart';

class TambahPesanWarga extends StatefulWidget {
  const TambahPesanWarga({super.key});

  @override
  State<TambahPesanWarga> createState() => _TambahPesanWargaState();
}

class _TambahPesanWargaState extends State<TambahPesanWarga> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Tambah Pesan Warga",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white), // warna icon back
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// JUDUL
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: "Judul",
                  filled: true,
                  fillColor: AppColors.secondBackground,
                  hintText: "Masukkan judul pesan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Judul tidak boleh kosong"
                    : null,
              ),
              const SizedBox(height: 16),

              /// DESKRIPSI
              TextFormField(
                controller: _deskripsiController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  filled: true,
                  fillColor: AppColors.secondBackground,
                  hintText: "Masukkan deskripsi pesan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Deskripsi tidak boleh kosong"
                    : null,
              ),
              const SizedBox(height: 32),

              /// TOMBOL SIMPAN / BATAL
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newAspirasi = Aspirasi(
                            id: 0,
                            wargaId: 1, // TODO: ganti dengan user login
                            judul: _judulController.text,
                            deskripsi: _deskripsiController.text,
                            status: StatusAspirasi.Pending,
                            tanggapanAdmin: null,
                            updatedBy: null,
                            createdAt: DateTime.now(),
                          );

                          context.read<AspirasiBloc>().add(
                            AddAspirasi(newAspirasi),
                          );

                          // Menampilkan snackbar notif berhasil
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pesan berhasil ditambahkan!"),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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