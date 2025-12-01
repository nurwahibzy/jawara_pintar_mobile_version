import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_kegiatan.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';
import 'package:jawara_pintar_mobile_version/widgets/bar_chart_card.dart';

import '../../../../core/injections/injection.dart';
import '../../domain/usecases/get_dashboard_kegiatan_usecase.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

/// Dashboard Kegiatan dengan Clean Architecture + Supabase
class DashboardKegiatanPage extends StatelessWidget {
  const DashboardKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardKegiatanBloc(
        getDashboardKegiatanUseCase: sl.get<GetDashboardKegiatanUseCase>(),
      )..add(const LoadDashboardKegiatanEvent()),
      child: const _DashboardKegiatanPageContent(),
    );
  }
}

class _DashboardKegiatanPageContent extends StatelessWidget {
  const _DashboardKegiatanPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<DashboardKegiatanBloc, DashboardKegiatanState>(
        builder: (context, state) {
          if (state is DashboardKegiatanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardKegiatanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardKegiatanBloc>().add(
                            const LoadDashboardKegiatanEvent(),
                          );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is DashboardKegiatanLoaded) {
            final dashboard = state.dashboard;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Dashboard Kegiatan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola data kegiatan warga',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Menu Kegiatan
                  const MenuKegiatan(),
                  const SizedBox(height: 24),

                  Text(
                    'Statistik Kegiatan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total Kegiatan Card
                  _buildStatCard(
                    icon: Icons.event,
                    label: 'Total Kegiatan',
                    value: dashboard.totalKegiatan.toString(),
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),

                  // Pie Chart - Kegiatan per Kategori
                  PieChartCard(
                    title: 'Kegiatan per Kategori',
                    icon: Icons.pie_chart,
                    backgroundColor: Colors.blue.shade50,
                    data: dashboard.kegiatanPerKategori.entries.map((entry) {
                      final index = dashboard.kegiatanPerKategori.keys.toList().indexOf(entry.key);
                      return ChartData(
                        label: entry.key,
                        value: entry.value.toDouble(),
                        color: _getKategoriColor(index),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Kegiatan berdasarkan Waktu
                  _buildKegiatanBerdasarkanWaktuCard(dashboard.kegiatanBerdasarkanWaktu),
                  const SizedBox(height: 24),

                  // Penanggung Jawab Terbanyak
                  _buildPenanggungJawabTerbanyakCard(dashboard.penanggungJawabTerbanyak),
                  const SizedBox(height: 24),

                  // Bar Chart - Kegiatan per Bulan
                  BarChartCard(
                    title: 'Kegiatan per Bulan (Tahun ${DateTime.now().year})',
                    icon: Icons.bar_chart,
                    barColor: Colors.teal.shade600,
                    backgroundColor: Colors.teal.shade50,
                    data: dashboard.kegiatanPerBulan.map((e) => e.toDouble()).toList(),
                    labels: const [
                      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
                    ],
                    useCurrencyFormat: false,
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildKegiatanBerdasarkanWaktuCard(Map<String, int> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.access_time, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Kegiatan berdasarkan Waktu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getWaktuColor(entry.key),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.key,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getWaktuColor(entry.key),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPenanggungJawabTerbanyakCard(List<dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.purple, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Penanggung Jawab Terbanyak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...data.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.purple.shade700,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.nama,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.jumlah.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getKategoriColor(int index) {
    final colors = [
      Colors.blue,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.red,
      Colors.blueGrey,
    ];
    return colors[index % colors.length];
  }

  Color _getWaktuColor(String status) {
    switch (status) {
      case 'Sudah Lewat':
        return Colors.grey.shade600;
      case 'Hari Ini':
        return Colors.orange;
      case 'Akan Datang':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
