import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';

class DetailKeluargaPage extends StatefulWidget {
  final Keluarga keluarga;

  const DetailKeluargaPage({super.key, required this.keluarga});

  @override
  State<DetailKeluargaPage> createState() => _DetailKeluargaPageState();
}

class _DetailKeluargaPageState extends State<DetailKeluargaPage> {
  late Keluarga _currentKeluarga;

  @override
  void initState() {
    super.initState();
    _currentKeluarga = widget.keluarga;
    // Refresh data to get latest
    context.read<WargaBloc>().add(GetDetailKeluarga(_currentKeluarga.id));
  }

  // Helper untuk format tanggal
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  // Helper warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'hidup':
        return Colors.green.shade700;
      case 'nonaktif':
      case 'pindah':
      case 'meninggal':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // Helper jenis kelamin
  String _getJenisKelaminFull(String jenisKelamin) {
    if (jenisKelamin.toLowerCase().startsWith('l')) {
      return 'Laki-laki';
    } else if (jenisKelamin.toLowerCase().startsWith('p')) {
      return 'Perempuan';
    }
    return '-';
  }

  // Widget untuk info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk status badge
  Widget _buildStatusBadge(String status, {double fontSize = 12}) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // Widget untuk section header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk card anggota keluarga
  Widget _buildAnggotaCard(AnggotaKeluarga anggota, int index) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar dengan nomor urut
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                anggota.nama.isNotEmpty ? anggota.nama[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info anggota
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan status hidup
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          anggota.nama,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildStatusBadge(anggota.statusHidup, fontSize: 10),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Detail info dalam row
                  Row(
                    children: [
                      // NIK
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NIK',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              anggota.nik,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Peran
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peran',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              anggota.statusKeluarga,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Jenis Kelamin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jenis Kelamin',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _getJenisKelaminFull(anggota.jenisKelamin),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tanggal Lahir
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Lahir',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatDate(anggota.tanggalLahir),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WargaBloc, WargaState>(
      listener: (context, state) {
        if (state is KeluargaDetailLoaded) {
          setState(() {
            _currentKeluarga = state.keluarga;
          });
        } else if (state is KeluargaError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Detail Keluarga',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Info Keluarga
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dengan status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Informasi Keluarga',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          _buildStatusBadge(_currentKeluarga.statusHunian),
                        ],
                      ),
                      const Divider(height: 24),

                      // Info rows
                      _buildInfoRow(
                        'Nama Keluarga',
                        _currentKeluarga.namaKeluarga,
                      ),
                      _buildInfoRow(
                        'Kepala Keluarga',
                        _currentKeluarga.kepalaKeluarga?.nama ?? '-',
                      ),
                      _buildInfoRow('Nomor KK', _currentKeluarga.nomorKk),
                      _buildInfoRow(
                        'Rumah Saat Ini',
                        _currentKeluarga.alamatRumah,
                      ),
                      _buildInfoRow(
                        'Status Kepemilikan',
                        _currentKeluarga.statusKepemilikan,
                      ),
                      _buildInfoRow(
                        'Tanggal Terdaftar',
                        _formatDate(_currentKeluarga.tanggalTerdaftar),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card Anggota Keluarga
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Anggota Keluarga (${_currentKeluarga.anggota.length})',
                        Icons.people,
                      ),
                      const SizedBox(height: 12),

                      if (_currentKeluarga.anggota.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Tidak ada anggota keluarga',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _currentKeluarga.anggota.length,
                          itemBuilder: (context, index) {
                            final anggota = _currentKeluarga.anggota[index];
                            return InkWell(
                              onTap: () {
                                // Optional: Navigate to detail warga
                                // Perlu fetch warga by id first
                              },
                              child: _buildAnggotaCard(anggota, index),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
