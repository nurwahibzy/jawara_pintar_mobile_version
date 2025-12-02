import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/tambah_warga.dart';

class DetailWargaPage extends StatefulWidget {
  final Warga warga;

  const DetailWargaPage({super.key, required this.warga});

  @override
  State<DetailWargaPage> createState() => _DetailWargaPageState();
}

class _DetailWargaPageState extends State<DetailWargaPage> {
  late Warga _currentWarga;

  @override
  void initState() {
    super.initState();
    _currentWarga = widget.warga;
  }

  // Helper untuk format tanggal
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  // Helper untuk jenis kelamin
  String _getJenisKelaminFull(String jenisKelamin) {
    if (jenisKelamin.toLowerCase().startsWith('l')) {
      return 'Laki-laki';
    } else if (jenisKelamin.toLowerCase().startsWith('p')) {
      return 'Perempuan';
    }
    return '-';
  }

  // Helper warna status hidup
  Color _getStatusHidupColor(String status) {
    switch (status.toLowerCase()) {
      case 'hidup':
        return Colors.green.shade700;
      case 'meninggal':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // Helper warna status penduduk
  Color _getStatusPendudukColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'aktif':
        return Colors.blue.shade700;
      case 'nonaktif':
      case 'pindah':
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade700;
    }
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

  // Widget untuk detail row
  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 120,
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
  Widget _buildStatusBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WargaBloc, WargaState>(
      listener: (context, state) {
        if (state is WargaDetailLoaded) {
          setState(() {
            _currentWarga = state.warga;
          });
        } else if (state is WargaActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          // Refresh data setelah update
          context.read<WargaBloc>().add(GetDetailWarga(_currentWarga.idWarga));
        } else if (state is WargaError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Detail Warga',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<WargaBloc>(
                      create: (_) => sl<WargaBloc>(),
                      child: WargaFormPage(
                        warga: _currentWarga,
                        keluargaId: _currentWarga.keluargaId,
                      ),
                    ),
                  ),
                );
                if (result == true) {
                  // Refresh data jika ada perubahan
                  if (mounted) {
                    context.read<WargaBloc>().add(
                      GetDetailWarga(_currentWarga.idWarga),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card dengan Avatar dan Nama
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          _currentWarga.nama.isNotEmpty
                              ? _currentWarga.nama[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama
                      Text(
                        _currentWarga.nama,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      // NIK
                      Text(
                        'NIK: ${_currentWarga.nik}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),

                      // Status Badges
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildStatusBadge(
                            'Status Hidup',
                            _currentWarga.statusHidup,
                            _getStatusHidupColor(_currentWarga.statusHidup),
                          ),
                          _buildStatusBadge(
                            'Domisili',
                            _currentWarga.statusPenduduk ?? 'Aktif',
                            _getStatusPendudukColor(
                              _currentWarga.statusPenduduk,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Data Pribadi Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Data Pribadi', Icons.person),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Tempat Lahir',
                      _currentWarga.tempatLahir ?? '-',
                      icon: Icons.location_city,
                    ),
                    _buildDetailRow(
                      'Tanggal Lahir',
                      _formatDate(_currentWarga.tanggalLahir),
                      icon: Icons.cake,
                    ),
                    _buildDetailRow(
                      'Jenis Kelamin',
                      _getJenisKelaminFull(_currentWarga.jenisKelamin),
                      icon: Icons.wc,
                    ),
                    _buildDetailRow(
                      'Agama',
                      _currentWarga.agama ?? '-',
                      icon: Icons.church,
                    ),
                    _buildDetailRow(
                      'Golongan Darah',
                      _currentWarga.golonganDarah ?? '-',
                      icon: Icons.bloodtype,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Data Keluarga Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Data Keluarga', Icons.family_restroom),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'ID Keluarga',
                      _currentWarga.keluargaId.toString(),
                      icon: Icons.numbers,
                    ),
                    _buildDetailRow(
                      'Status Keluarga',
                      _currentWarga.statusKeluarga,
                      icon: Icons.group,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Data Kontak & Pendidikan Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Kontak & Pekerjaan', Icons.work),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'No. Telepon',
                      _currentWarga.nomorTelepon,
                      icon: Icons.phone,
                    ),
                    _buildDetailRow(
                      'Pendidikan',
                      _currentWarga.pendidikanTerakhir ?? '-',
                      icon: Icons.school,
                    ),
                    _buildDetailRow(
                      'Pekerjaan',
                      _currentWarga.pekerjaan ?? '-',
                      icon: Icons.business_center,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Data Sistem Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Informasi Sistem', Icons.info),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'ID Warga',
                      _currentWarga.idWarga.toString(),
                      icon: Icons.tag,
                    ),
                    _buildDetailRow(
                      'Dibuat',
                      _formatDate(_currentWarga.createdAt),
                      icon: Icons.calendar_today,
                    ),
                    _buildDetailRow(
                      'Diperbarui',
                      _formatDate(_currentWarga.updatedAt),
                      icon: Icons.update,
                    ),
                    const SizedBox(height: 12),
                  ],
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
