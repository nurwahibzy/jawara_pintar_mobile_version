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
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

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
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is DashboardKegiatanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardKegiatanBloc>().add(
                        const LoadDashboardKegiatanEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DashboardKegiatanLoaded) {
            final dashboard = state.dashboard;

            return SingleChildScrollView(
              key: const Key('list_kegiatan'),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Dashboard Kegiatan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu Kegiatan
                  const MenuKegiatan(),
                  const SizedBox(height: 24),

                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Total Kegiatan Card
                  _buildStatCard(
                    icon: Icons.event_available,
                    label: 'Total Kegiatan',
                    value: dashboard.totalKegiatan.toString(),
                    color: const Color(0xFF6B5CE7), // Purple variant
                  ),
                  const SizedBox(height: 20),

                  // Pie Chart - Kegiatan per Kategori
                  PieChartCard(
                    title: 'Kategori Kegiatan',
                    icon: Icons.category_outlined,
                    iconColor: const Color(0xFF6B5CE7), // Purple variant
                    data: dashboard.kegiatanPerKategori.entries.map((entry) {
                      final index = dashboard.kegiatanPerKategori.keys
                          .toList()
                          .indexOf(entry.key);
                      return ChartData(
                        label: entry.key,
                        value: entry.value.toDouble(),
                        color: _getKategoriColor(index),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Kegiatan berdasarkan Waktu
                  _buildKegiatanBerdasarkanWaktuCard(
                    dashboard.kegiatanBerdasarkanWaktu,
                  ),
                  const SizedBox(height: 20),

                  // Penanggung Jawab Terbanyak
                  _buildPenanggungJawabTerbanyakCard(
                    dashboard.penanggungJawabTerbanyak,
                  ),
                  const SizedBox(height: 20),

                  // Bar Chart - Kegiatan per Bulan
                  BarChartCard(
                    title: 'Kegiatan Bulanan',
                    icon: Icons.bar_chart,
                    barColor: const Color(0xFF6B5CE7), // Purple variant
                    data: dashboard.kegiatanPerBulan
                        .map((e) => e.toDouble())
                        .toList(),
                    labels: const [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'Mei',
                      'Jun',
                      'Jul',
                      'Agu',
                      'Sep',
                      'Okt',
                      'Nov',
                      'Des',
                    ],
                    useCurrencyFormat: false,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKegiatanBerdasarkanWaktuCard(Map<String, int> data) {
    final firstColor = data.isNotEmpty
        ? _getWaktuColor(data.keys.first)
        : Colors.grey;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: firstColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.schedule_outlined,
                  color: firstColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Status Waktu',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...data.entries.map((entry) {
            final color = _getWaktuColor(entry.key);
            final IconData icon = entry.key == 'Sudah Lewat'
                ? Icons.check_circle_outline
                : entry.key == 'Hari Ini'
                ? Icons.today_outlined
                : Icons.event_outlined;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.15), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.value} kegiatan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPenanggungJawabTerbanyakCard(List<dynamic> data) {
    const cardColor = Color(0xFF6B5CE7); // Purple variant matching theme
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: cardColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Penanggung Jawab',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: cardColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: cardColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.nama,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.jumlah} kegiatan',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cardColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getKategoriColor(int index) {
    // Purple theme variations
    final colors = [
      const Color(0xFF6B5CE7), // Base purple
      const Color(0xFF8E7AE7), // Medium light purple
      const Color(0xFF7B68EE), // Medium purple
      const Color(0xFFB8AEE7), // Light purple
      const Color(0xFF9B8CE7), // Lighter purple
      const Color(0xFF5B4DCE), // Dark purple
    ];
    return colors[index % colors.length];
  }

  Color _getWaktuColor(String status) {
    switch (status) {
      case 'Sudah Lewat':
        return const Color(0xFF6B5CE7); 
      case 'Hari Ini':
        return const Color.fromARGB(255, 81, 65, 207); 
      case 'Akan Datang':
        return const Color(0xFFB8AEE7);
      default:
        return Colors.grey;
    }
  }
}
