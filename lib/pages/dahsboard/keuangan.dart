import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_keuangan.dart';
import 'package:jawara_pintar_mobile_version/widgets/bar_chart_card.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';

class Keuangan extends StatefulWidget {
  const Keuangan({super.key});

  @override
  State<Keuangan> createState() => _KeuanganState();
}

class _KeuanganState extends State<Keuangan> {
  String selectedYear = '2025';
  int touchedIndexIncome = -1;
  int touchedIndexExpense = -1;

  // Sample data - dalam implementasi nyata, data ini akan diambil dari database
  final List<String> years = ['2022', '2023', '2024', '2025'];

  // Data untuk pemasukan bulanan RT/Warga 
  final Map<String, List<double>> monthlyIncome = {
    '2025': [
      8500000,  
      8200000,  
      8800000,  
      9100000,  
      8600000,  
      9500000,  
      8900000,  
      8400000,  
      9200000,  
      8700000,  
      9000000,  
      10500000, 
    ],
  };

  // Data untuk pengeluaran bulanan RT/Warga 
  final Map<String, List<double>> monthlyExpense = {
    '2025': [
      5500000,  
      5200000,  
      5800000,  
      6200000,  
      5900000,  
      7500000,  
      5600000,  
      5400000,  
      6800000,  
      5700000,  
      6100000,  
      8000000,  
    ],
  };

  // Data kategori pemasukan RT/Warga
  final Map<String, Map<String, double>> incomeCategories = {
    '2025': {
      'Iuran Bulanan': 48330000,    
      'Iuran Keamanan': 23628000,   
      'Iuran Kebersihan': 19332000, 
      'Donasi': 8592000,            
      'Lain-lain': 7518000,         
    },
  };

  // Data kategori pengeluaran RT/Warga 
  final Map<String, Map<String, double>> expenseCategories = {
    '2025': {
      'Keamanan': 21402000,            
      'Kebersihan': 19188000,          
      'Perawatan Fasilitas': 13284000, 
      'Listrik & Air': 8856000,        
      'Acara RT': 6642000,             
      'Administrasi': 4428000,         
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentYearIncome = monthlyIncome[selectedYear] ?? [];
    final currentYearExpense = monthlyExpense[selectedYear] ?? [];
    final currentIncomeCategories = incomeCategories[selectedYear] ?? {};
    final currentExpenseCategories = expenseCategories[selectedYear] ?? {};

    double totalIncome = currentYearIncome.fold(
      0,
      (sum, amount) => sum + amount,
    );
    double totalExpense = currentYearExpense.fold(
      0,
      (sum, amount) => sum + amount,
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
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
                    value: selectedYear,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    items: years.map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedYear = newValue;
                        });
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
                    value: _formatCurrency(totalIncome),
                    subtitle: 'Pemasukan',
                    color: Colors.green.shade400,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Pengeluaran',
                    value: _formatCurrency(totalExpense),
                    subtitle: 'Pengeluaran',
                    color: Colors.red.shade400,
                    icon: Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bar Chart - Pemasukan per Bulan
            BarChartCard(
              title: 'Pemasukan per Bulan',
              icon: Icons.trending_up,
              barColor: Colors.green.shade600,
              backgroundColor: const Color(0xFFE8F5E9),
              data: currentYearIncome,
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
              data: currentYearExpense,
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
              data: currentIncomeCategories.entries.map((entry) {
                final index =
                    currentIncomeCategories.keys.toList().indexOf(entry.key);
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
              data: currentExpenseCategories.entries.map((entry) {
                final index =
                    currentExpenseCategories.keys.toList().indexOf(entry.key);
                return ChartData(
                  label: entry.key,
                  value: entry.value,
                  color: _getExpenseColor(index),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {},
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

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return 'Rp${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return 'Rp${amount.toStringAsFixed(0)}';
    }
  }
}
