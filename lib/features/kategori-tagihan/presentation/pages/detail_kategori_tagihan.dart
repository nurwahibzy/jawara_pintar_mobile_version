import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_event.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_state.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/pages/edit_kategori_tagihan.dart';

class DetailKategoriTagihanPage extends StatelessWidget {
  final int masterIuranId;

  const DetailKategoriTagihanPage({super.key, required this.masterIuranId});

  // Helper warna status
  Color _getStatusColor(bool isActive) {
    return isActive ? Colors.green.shade700 : Colors.red.shade700;
  }

  // Helper text status untuk display
  String _getStatusDisplay(bool isActive) {
    return isActive ? 'Aktif' : 'Tidak Aktif';
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Kategori Tagihan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<MasterIuranBloc, MasterIuranState>(
        listener: (context, state) {
          if (state is MasterIuranActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is MasterIuranError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<MasterIuranBloc, MasterIuranState>(
          builder: (context, state) {
            if (state is MasterIuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MasterIuranDetailLoaded) {
              final masterIuran = state.masterIuran;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detail Master Iuran Card
                    Card(
                      color: AppColors.background,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Informasi Kategori Tagihan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),

                            // Nama Iuran
                            _buildDetailRow(
                              'Nama Iuran',
                              masterIuran.namaIuran,
                            ),
                            const SizedBox(height: 12),

                            // Kategori Iuran
                            _buildDetailRow(
                              'Kategori',
                              masterIuran.kategoriIuran?.namaKategori ??
                                  'Tidak ada kategori',
                            ),
                            const SizedBox(height: 12),

                            // Nominal Standar
                            _buildDetailRow(
                              'Nominal Standar',
                              masterIuran.formattedNominal,
                            ),
                            const SizedBox(height: 12),

                            // Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      masterIuran.isActive,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _getStatusColor(
                                        masterIuran.isActive,
                                      ),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusDisplay(masterIuran.isActive),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(
                                        masterIuran.isActive,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),

                            // Tanggal Dibuat
                            if (masterIuran.createdAt != null)
                              _buildDetailRow(
                                'Dibuat Pada',
                                DateFormat(
                                  'dd MMMM yyyy, HH:mm',
                                  'id_ID',
                                ).format(masterIuran.createdAt!),
                              ),
                            if (masterIuran.createdAt != null)
                              const SizedBox(height: 12),

                            // Tanggal Update
                            if (masterIuran.updatedAt != null)
                              _buildDetailRow(
                                'Terakhir Diubah',
                                DateFormat(
                                  'dd MMMM yyyy, HH:mm',
                                  'id_ID',
                                ).format(masterIuran.updatedAt!),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => sl<MasterIuranBloc>(),
                                child: EditKategoriTagihanPage(
                                  masterIuran: masterIuran,
                                ),
                              ),
                            ),
                          );
                          if (result == true && context.mounted) {
                            context.read<MasterIuranBloc>().add(
                              LoadMasterIuranById(masterIuranId),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MasterIuranError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
