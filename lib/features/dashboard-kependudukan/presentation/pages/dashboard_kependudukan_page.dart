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
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardKependudukanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.red.shade400),
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
                      context.read<DashboardKependudukanBloc>().add(
                            const LoadDashboardKependudukanEvent(),
                          );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is DashboardKependudukanLoaded) {
            final dashboard = state.dashboard;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Text(
                    'Dashboard Kependudukan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola data penduduk dan keluarga',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Menu Kependudukan
                  const MenuKependudukan(),

                  // Statistics Cards
                  Text(
                    'Statistik Penduduk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Keluarga',
                          value: dashboard.totalKeluarga.toString(),
                          subtitle: 'Jumlah Keluarga',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Penduduk',
                          value: dashboard.totalPenduduk.toString(),
                          subtitle: 'Jumlah Penduduk',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Status Penduduk Chart
                  PieChartCard(
                    title: 'Status Penduduk',
                    icon: Icons.account_circle,
                    backgroundColor: Colors.amber.shade50,
                    data: dashboard.statusPenduduk.entries.map((entry) {
                      return ChartData(
                        label: entry.key,
                        value: entry.value.toDouble(),
                        color: entry.key == 'Aktif'
                            ? Colors.teal
                            : Colors.deepOrange.shade800,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Jenis Kelamin Chart
                  PieChartCard(
                    title: 'Jenis Kelamin',
                    icon: Icons.wc,
                    backgroundColor: Colors.purple.shade50,
                    data: dashboard.jenisKelamin.entries.map((entry) {
                      return ChartData(
                        label: entry.key,
                        value: entry.value.toDouble(),
                        color: entry.key == 'L'
                            ? Colors.blue
                            : Colors.pink,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Pekerjaan Penduduk Chart
                  if (dashboard.pekerjaanPenduduk.isNotEmpty)
                    PieChartCard(
                      title: 'Pekerjaan Penduduk',
                      icon: Icons.work,
                      backgroundColor: Colors.green.shade50,
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
                  const SizedBox(height: 16),

                  // Peran dalam Keluarga Chart
                  if (dashboard.peranDalamKeluarga.isNotEmpty)
                    PieChartCard(
                      title: 'Peran dalam Keluarga',
                      icon: Icons.family_restroom,
                      backgroundColor: Colors.blue.shade50,
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
                  const SizedBox(height: 16),

                  // Agama Chart
                  if (dashboard.agama.isNotEmpty)
                    PieChartCard(
                      title: 'Agama',
                      icon: Icons.mosque,
                      backgroundColor: Colors.orange.shade50,
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
                  const SizedBox(height: 16),

                  // Pendidikan Chart
                  if (dashboard.pendidikan.isNotEmpty)
                    PieChartCard(
                      title: 'Pendidikan',
                      icon: Icons.school,
                      backgroundColor: Colors.pink.shade50,
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
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              title.contains('Keluarga') ? Icons.home : Icons.people,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPekerjaanColor(int index) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.grey,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Color _getPeranColor(int index) {
    final colors = [
      Colors.blue.shade700,
      Colors.pink,
      Colors.purple,
      Colors.brown,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  Color _getAgamaColor(int index) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.pink,
      Colors.deepOrange,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Color _getPendidikanColor(int index) {
    final colors = [
      Colors.deepOrange,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
