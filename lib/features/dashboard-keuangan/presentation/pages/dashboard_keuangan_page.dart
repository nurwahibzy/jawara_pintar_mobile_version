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
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';


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
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is DashboardError) {
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
                      context.read<DashboardBloc>().add(
                            LoadDashboardSummaryEvent(
                              DateTime.now().year.toString(),
                            ),
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
          } else if (state is DashboardLoaded) {
            final summary = state.summary;
            final availableYears = state.availableYears;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section with Year Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard Keuangan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      // Year Selector
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: summary.year,
                          underline: const SizedBox(),
                          icon: Icon(Icons.calendar_today, 
                            size: 16, 
                            color: AppColors.primary,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
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
                  const SizedBox(height: 20),

                  // Menu Keuangan
                  const MenuKeuangan(),
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

                  // Saldo Card - Prominent Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          summary.getFormattedSaldo(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Cards - Modern Minimal Design
                  Row(
                    children: [
                      Expanded(
                        child: _buildMinimalStatCard(
                          value: summary.getFormattedTotalPemasukan(),
                          label: 'Pemasukan',
                          color: const Color(0xFF5B8DEE), // Blue-purple
                          icon: Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMinimalStatCard(
                          value: summary.getFormattedTotalPengeluaran(),
                          label: 'Pengeluaran',
                          color: const Color(0xFFE85D9A), // Pink-purple
                          icon: Icons.arrow_downward,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Charts Section
                  BarChartCard(
                    title: 'Pemasukan Bulanan',
                    icon: Icons.trending_up,
                    barColor: const Color(0xFF5B8DEE), // Blue-purple untuk pemasukan
                    data: summary.monthlyPemasukan,
                    labels: const [
                      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
                    ],
                  ),
                  const SizedBox(height: 20),

                  BarChartCard(
                    title: 'Pengeluaran Bulanan',
                    icon: Icons.trending_down,
                    barColor: const Color(0xFFE85D9A), // Pink-purple untuk pengeluaran
                    data: summary.monthlyPengeluaran,
                    labels: const [
                      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
                    ],
                  ),
                  const SizedBox(height: 20),

                  PieChartCard(
                    title: 'Kategori Pemasukan',
                    icon: Icons.pie_chart_outline,
                    iconColor: const Color(0xFF5B8DEE), // Blue-purple untuk pemasukan
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
                  const SizedBox(height: 20),

                  PieChartCard(
                    title: 'Kategori Pengeluaran',
                    icon: Icons.pie_chart_outline,
                    iconColor: const Color(0xFFE85D9A), // Pink-purple untuk pengeluaran
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
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildMinimalStatCard({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
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
          color: color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIncomeColor(int index) {
    // Blue-purple gradient untuk pemasukan (senada dengan theme)
    final colors = [
      const Color(0xFF5B8DEE), // Blue-purple terang
      const Color(0xFF4A7FDB), // Blue-purple medium
      const Color(0xFF6B9EF5), // Light blue-purple
      const Color(0xFF3D6FC7), // Deep blue-purple
      const Color(0xFF7BAEF8), // Sky blue-purple
      const Color(0xFF4E82D9), // Medium blue-purple
    ];
    return colors[index % colors.length];
  }

  Color _getExpenseColor(int index) {
    // Pink-purple gradient untuk pengeluaran (senada dengan theme)
    final colors = [
      const Color(0xFFE85D9A), // Pink-purple medium
      const Color(0xFFD94B87), // Pink-purple deep
      const Color(0xFFF06FA8), // Light pink-purple
      const Color(0xFFDB4A86), // Deep pink-purple
      const Color(0xFFEE79A7), // Soft pink-purple
      const Color(0xFFE156A0), // Vibrant pink-purple
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
