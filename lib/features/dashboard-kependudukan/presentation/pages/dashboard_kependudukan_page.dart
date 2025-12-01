import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_kependudukan.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';

import '../../../../core/injections/injection.dart';
import '../../domain/usecases/get_dashboard_kependudukan_usecase.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

/// Dashboard Kependudukan dengan Clean Architecture + Supabase
class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardKependudukanBloc(
        getDashboardKependudukanUseCase:
            sl.get<GetDashboardKependudukanUseCase>(),
      )..add(const LoadDashboardKependudukanEvent()),
      child: const _DashboardKependudukanPageContent(),
    );
  }
}

class _DashboardKependudukanPageContent extends StatelessWidget {
  const _DashboardKependudukanPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<DashboardKependudukanBloc, DashboardKependudukanState>(
        builder: (context, state) {
          if (state is DashboardKependudukanLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is DashboardKependudukanError) {
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
                      context.read<DashboardKependudukanBloc>().add(
                            const LoadDashboardKependudukanEvent(),
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
          } else if (state is DashboardKependudukanLoaded) {
            final dashboard = state.dashboard;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Text(
                    'Dashboard Kependudukan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu Kependudukan
                  const MenuKependudukan(),
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

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.home_outlined,
                          label: 'Total Keluarga',
                          value: dashboard.totalKeluarga.toString(),
                          color: const Color(0xFF6B5CE7), // Purple variant
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.people_outline,
                          label: 'Total Penduduk',
                          value: dashboard.totalPenduduk.toString(),
                          color: const Color(0xFF8E7AE7), // Purple variant
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Status Penduduk Chart
                  PieChartCard(
                    title: 'Status Penduduk',
                    icon: Icons.account_circle_outlined,
                    iconColor: const Color(0xFF6B5CE7),
                    data: dashboard.statusPenduduk.entries.map((entry) {
                      return ChartData(
                        label: entry.key,
                        value: entry.value.toDouble(),
                        color: entry.key == 'Aktif'
                            ? const Color(0xFF6B5CE7) // Purple
                            : const Color(0xFFB8AEE7), // Lighter purple
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Jenis Kelamin Chart
                  PieChartCard(
                    title: 'Jenis Kelamin',
                    icon: Icons.wc_outlined,
                    iconColor: const Color(0xFF7B68EE),
                    data: dashboard.jenisKelamin.entries.where((entry) {
                      // Filter only valid gender entries
                      return entry.key == 'L' || entry.key == 'P';
                    }).map((entry) {
                      return ChartData(
                        label: entry.key == 'L' ? 'Laki-laki' : 'Perempuan',
                        value: entry.value.toDouble(),
                        color: entry.key == 'L'
                            ? const Color(0xFF6B5CE7) // Purple for male
                            : const Color(0xFF9B8CE7), // Light purple for female
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Pekerjaan Penduduk Chart
                  if (dashboard.pekerjaanPenduduk.isNotEmpty)
                    PieChartCard(
                      title: 'Pekerjaan Penduduk',
                      icon: Icons.work_outline,
                      iconColor: const Color(0xFF5F8AE8),
                      data: dashboard.pekerjaanPenduduk.entries
                          .map((entry) {
                            final index = dashboard.pekerjaanPenduduk.keys
                                .toList()
                                .indexOf(entry.key);
                            return ChartData(
                              label: entry.key,
                              value: entry.value.toDouble(),
                              color: _getPekerjaanColor(index),
                            );
                          })
                          .toList(),
                    ),
                  const SizedBox(height: 20),

                  // Peran dalam Keluarga Chart
                  if (dashboard.peranDalamKeluarga.isNotEmpty)
                    PieChartCard(
                      title: 'Peran dalam Keluarga',
                      icon: Icons.family_restroom_outlined,
                      iconColor: const Color(0xFF6B5CE7),
                      data: dashboard.peranDalamKeluarga.entries
                          .map((entry) {
                            final index = dashboard.peranDalamKeluarga.keys
                                .toList()
                                .indexOf(entry.key);
                            return ChartData(
                              label: entry.key,
                              value: entry.value.toDouble(),
                              color: _getPeranColor(index),
                            );
                          })
                          .toList(),
                    ),
                  const SizedBox(height: 20),

                  // Agama Chart
                  if (dashboard.agama.isNotEmpty)
                    PieChartCard(
                      title: 'Agama',
                      icon: Icons.mosque_outlined,
                      iconColor: const Color(0xFF7B68EE),
                      data: dashboard.agama.entries.map((entry) {
                        final index =
                            dashboard.agama.keys.toList().indexOf(entry.key);
                        return ChartData(
                          label: entry.key,
                          value: entry.value.toDouble(),
                          color: _getAgamaColor(index),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),

                  // Pendidikan Chart
                  if (dashboard.pendidikan.isNotEmpty)
                    PieChartCard(
                      title: 'Pendidikan',
                      icon: Icons.school_outlined,
                      iconColor: const Color(0xFF5F8AE8),
                      data: dashboard.pendidikan.entries.map((entry) {
                        final index = dashboard.pendidikan.keys
                            .toList()
                            .indexOf(entry.key);
                        return ChartData(
                          label: entry.key,
                          value: entry.value.toDouble(),
                          color: _getPendidikanColor(index),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
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
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPekerjaanColor(int index) {
    // Purple tone variations only
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

  Color _getPeranColor(int index) {
    // Purple tone variations only
    final colors = [
      const Color(0xFF6B5CE7), // Base purple
      const Color(0xFF9B8CE7), // Lighter purple
      const Color(0xFF7B68EE), // Medium purple
      const Color(0xFFB8AEE7), // Light purple
      const Color(0xFF5B4DCE), // Dark purple
    ];
    return colors[index % colors.length];
  }

  Color _getAgamaColor(int index) {
    // Purple tone variations only
    final colors = [
      const Color(0xFF7B68EE), // Medium purple
      const Color(0xFF6B5CE7), // Base purple
      const Color(0xFF9B8CE7), // Lighter purple
      const Color(0xFF8E7AE7), // Medium light purple
      const Color(0xFFB8AEE7), // Light purple
      const Color(0xFF5B4DCE), // Dark purple
    ];
    return colors[index % colors.length];
  }

  Color _getPendidikanColor(int index) {
    // Purple tone variations only
    final colors = [
      const Color(0xFF8E7AE7), // Medium light purple
      const Color(0xFF6B5CE7), // Base purple
      const Color(0xFFB8AEE7), // Light purple
      const Color(0xFF7B68EE), // Medium purple
      const Color(0xFF9B8CE7), // Lighter purple
      const Color(0xFF5B4DCE), // Dark purple
    ];
    return colors[index % colors.length];
  }
}
