import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_keuangan.dart';
import 'package:jawara_pintar_mobile_version/widgets/bar_chart_card.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';

import '../../../../core/injections/injection.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_available_years_usecase.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

/// Dashboard Keuangan dengan Clean Architecture + Supabase
/// Menggantikan hardcoded keuangan.dart
class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        getDashboardSummaryUseCase: sl.get<GetDashboardSummaryUseCase>(),
        getAvailableYearsUseCase: sl.get<GetAvailableYearsUseCase>(),
      )..add(LoadDashboardSummaryEvent(DateTime.now().year.toString())),
      child: const _DashboardKeuanganPageContent(),
    );
  }
}

class _DashboardKeuanganPageContent extends StatelessWidget {
  const _DashboardKeuanganPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DashboardError) {
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
                      context.read<DashboardBloc>().add(
                            LoadDashboardSummaryEvent(
                              DateTime.now().year.toString(),
                            ),
                          );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DashboardLoaded) {
            final summary = state.summary;
            final availableYears = state.availableYears;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Keuangan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kelola pemasukan dan pengeluaran',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      // Year Selector
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: summary.year,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down, size: 20),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          items: availableYears.map((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null && newValue != summary.year) {
                              context.read<DashboardBloc>().add(
                                    ChangeYearEvent(newValue),
                                  );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Menu Keuangan
                  const MenuKeuangan(),
                  const SizedBox(height: 24),

                  Text(
                    'Ringkasan Keuangan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Pemasukan',
                          value: summary.getFormattedTotalPemasukan(),
                          subtitle: 'Pemasukan',
                          color: Colors.green.shade400,
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Pengeluaran',
                          value: summary.getFormattedTotalPengeluaran(),
                          subtitle: 'Pengeluaran',
                          color: Colors.red.shade400,
                          icon: Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Saldo Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              summary.getFormattedSaldo(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bar Chart - Pemasukan per Bulan
                  BarChartCard(
                    title: 'Pemasukan per Bulan',
                    icon: Icons.trending_up,
                    barColor: Colors.green.shade600,
                    backgroundColor: const Color(0xFFE8F5E9),
                    data: summary.monthlyPemasukan,
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
                  ),
                  const SizedBox(height: 24),

                  // Bar Chart - Pengeluaran per Bulan
                  BarChartCard(
                    title: 'Pengeluaran per Bulan',
                    icon: Icons.trending_down,
                    barColor: Colors.red.shade600,
                    backgroundColor: const Color(0xFFFFEBEE),
                    data: summary.monthlyPengeluaran,
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
                  ),
                  const SizedBox(height: 24),

                  // Pie Chart - Pemasukan per Kategori
                  PieChartCard(
                    title: 'Pemasukan per Kategori',
                    icon: Icons.account_balance_wallet,
                    backgroundColor: const Color(0xFFE8F5E9),
                    valueFormatter: _formatCurrency,
                    data: summary.kategoriPemasukan.entries.map((entry) {
                      final index =
                          summary.kategoriPemasukan.keys.toList().indexOf(entry.key);
                      return ChartData(
                        label: entry.key,
                        value: entry.value,
                        color: _getIncomeColor(index),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Pie Chart - Pengeluaran per Kategori
                  PieChartCard(
                    title: 'Pengeluaran per Kategori',
                    icon: Icons.shopping_cart,
                    backgroundColor: const Color(0xFFFFEBEE),
                    valueFormatter: _formatCurrency,
                    data: summary.kategoriPengeluaran.entries.map((entry) {
                      final index =
                          summary.kategoriPengeluaran.keys.toList().indexOf(entry.key);
                      return ChartData(
                        label: entry.key,
                        value: entry.value,
                        color: _getExpenseColor(index),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
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
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 12),
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Value
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIncomeColor(int index) {
    final colors = [
      Colors.green.shade400,
      Colors.green.shade600,
      Colors.green.shade800,
      Colors.teal.shade400,
      Colors.teal.shade600,
    ];
    return colors[index % colors.length];
  }

  Color _getExpenseColor(int index) {
    final colors = [
      Colors.red.shade400,
      Colors.red.shade600,
      Colors.red.shade800,
      Colors.orange.shade400,
      Colors.orange.shade600,
      Colors.orange.shade800,
    ];
    return colors[index % colors.length];
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return 'Rp${(amount / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)} Juta';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)} Ribu';
    } else {
      return 'Rp${amount.toStringAsFixed(0)}';
    }
  }
}
