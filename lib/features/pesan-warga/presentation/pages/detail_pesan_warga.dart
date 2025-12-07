import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../domain/entities/pesan_warga.dart';
import '../bloc/pesan_warga_bloc.dart';
import 'edit_pesan_warga.dart';

class DetailPesanWarga extends StatefulWidget {
  final Aspirasi pesan;
  const DetailPesanWarga({super.key, required this.pesan});

  @override
  State<DetailPesanWarga> createState() => _DetailPesanWargaState();
}

class _DetailPesanWargaState extends State<DetailPesanWarga> {
  late Aspirasi pesan;

  @override
  void initState() {
    super.initState();
    pesan = widget.pesan;
    context.read<AspirasiBloc>().add(GetUserRoleEvent());
  }

  Color _getStatusColor(StatusAspirasi status) {
    switch (status) {
      case StatusAspirasi.Pending:
        return Colors.orange;
      case StatusAspirasi.Menunggu:
        return AppColors.primary;
      case StatusAspirasi.Diterima:
        return Colors.green;
      case StatusAspirasi.Ditolak:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(colorScheme: ColorScheme.light(primary: AppColors.primary)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Aspirasi'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        backgroundColor: AppColors.secondBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Judul
                  const Text(
                    'Judul:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan.judul),
                  const SizedBox(height: 10),

                  // Deskripsi
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan.deskripsi),
                  const SizedBox(height: 10),

                 // Status
                  const Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Align(
                    alignment:
                        Alignment.centerLeft, 
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(pesan.status),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        pesan.status.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dibuat oleh
                  const Text(
                    'Dibuat Oleh:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan.namaWarga ?? '-'),
                  const SizedBox(height: 10),

                  // Tanggal dibuat
                  const Text(
                    'Tanggal Dibuat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan.createdAt.toLocal().toString().split(' ')[0]),
                  const SizedBox(height: 20),

                  // Tanggapan Admin
                  const Text(
                    'Tanggapan Admin:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan.tanggapanAdmin ?? '-'),
                  const SizedBox(height: 20),

                  // Tombol edit
                BlocBuilder<AspirasiBloc, AspirasiState>(
                    builder: (context, state) {
                      final role = context
                          .read<AspirasiBloc>()
                          .currentRole; 

                      final bool canEdit =
                          role == "Admin" ||
                          (role == "Warga" &&
                              pesan.status == StatusAspirasi.Pending);

                      return Visibility(
                        visible: canEdit,
                        child: Center(
                          child: SizedBox(
                            width: 160,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<AspirasiBloc>(),
                                      child: EditPesanWarga(pesan: pesan),
                                    ),
                                  ),
                                );

                                if (result != null && result is Aspirasi) {
                                  setState(() => pesan = result);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}