import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/side_drawer.dart';
import 'package:fl_chart/fl_chart.dart';

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
  
  // Data untuk pemasukan bulanan
  final Map<String, List<double>> monthlyIncome = {
    '2025': [5000000, 6000000, 5500000, 7000000, 6500000, 8000000, 
             7500000, 8500000, 9000000, 8000000, 7000000, 9500000],
  };
  
  // Data untuk pengeluaran bulanan
  final Map<String, List<double>> monthlyExpense = {
    '2025': [3000000, 3500000, 4000000, 4500000, 4200000, 5000000,
             4800000, 5200000, 5500000, 5100000, 4900000, 6000000],
  };
  
  // Data kategori pemasukan
  final Map<String, Map<String, double>> incomeCategories = {
    '2025': {
      'Pendapatan Lainnya': 5000000,
    },
  };
  
  // Data kategori pengeluaran
  final Map<String, Map<String, double>> expenseCategories = {
    '2025': {
      'Makanan': 20000000,
      'Transportasi': 8000000,
      'Kesehatan': 5000000,
      'Pendidikan': 12000000,
      'Hiburan': 7000000,
      'Pemeliharaan Fasilitas': 8000000,
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentYearIncome = monthlyIncome[selectedYear] ?? [];
    final currentYearExpense = monthlyExpense[selectedYear] ?? [];
    final currentIncomeCategories = incomeCategories[selectedYear] ?? {};
    final currentExpenseCategories = expenseCategories[selectedYear] ?? {};
    
    double totalIncome = currentYearIncome.fold(0, (sum, amount) => sum + amount);
    double totalExpense = currentYearExpense.fold(0, (sum, amount) => sum + amount);
    int totalTransactions = 156; // Sample data
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keuangan'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedYear,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
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
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section 1: Summary Cards - Keep as row for better overview
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Pemasukan',
                    _formatCurrency(totalIncome),
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Pengeluaran',
                    _formatCurrency(totalExpense),
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Jumlah Transaksi',
                    totalTransactions.toString(),
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Section 2: Pemasukan per Bulan - Full width
            _buildMonthlyIncomeChart(currentYearIncome),
            const SizedBox(height: 24),
            
            // Section 3: Pengeluaran per Bulan - Full width
            _buildMonthlyExpenseChart(currentYearExpense),
            const SizedBox(height: 24),
            
            // Section 4: Pemasukan per Kategori - Full width
            _buildIncomeCategoryChart(currentIncomeCategories),
            const SizedBox(height: 24),
            
            // Section 5: Pengeluaran per Kategori - Full width
            _buildExpenseCategoryChart(currentExpenseCategories),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyIncomeChart(List<double> data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pemasukan per Bulan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: data.isEmpty
                  ? const Center(child: Text('No data available'))
                  : BarChart(
                      BarChartData(
                        maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
                        groupsSpace: 16,
                        barGroups: data.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Colors.green,
                                width: 16,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    _formatCurrencyShort(value),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                                               'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                                if (value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: data.reduce((a, b) => a > b ? a : b) / 5,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyExpenseChart(List<double> data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengeluaran per Bulan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: data.isEmpty
                  ? const Center(child: Text('No data available'))
                  : BarChart(
                      BarChartData(
                        maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
                        groupsSpace: 16,
                        barGroups: data.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Colors.red,
                                width: 16,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    _formatCurrencyShort(value),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                                               'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                                if (value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: data.reduce((a, b) => a > b ? a : b) / 5,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCategoryChart(Map<String, double> categories) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pemasukan per Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 160,
                    child: categories.isEmpty
                        ? const Center(child: Text('No data available'))
                        : PieChart(
                            PieChartData(
                              sections: _buildIncomePieChartSections(categories, _getIncomeColors()),
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndexIncome = -1;
                                      return;
                                    }
                                    touchedIndexIncome = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: _getPieChartConfig(categories.length)['sectionsSpace']!,
                              centerSpaceRadius: _getPieChartConfig(categories.length)['centerSpaceRadius']!,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Legend
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildLegendItems(categories, _getIncomeColors()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCategoryChart(Map<String, double> categories) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengeluaran per Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 160,
                    child: categories.isEmpty
                        ? const Center(child: Text('No data available'))
                        : PieChart(
                            PieChartData(
                              sections: _buildExpensePieChartSections(categories, _getExpenseColors()),
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndexExpense = -1;
                                      return;
                                    }
                                    touchedIndexExpense = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: _getPieChartConfig(categories.length)['sectionsSpace']!,
                              centerSpaceRadius: _getPieChartConfig(categories.length)['centerSpaceRadius']!,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Legend
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildLegendItems(categories, _getExpenseColors()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk mendapatkan radius yang konsisten
  Map<String, double> _getPieChartRadius(int categoryCount) {
    // Radius tetap sama untuk semua kondisi
    return {'base': 65.0, 'touched': 75.0};
  }

  // Helper method untuk mendapatkan konfigurasi yang konsisten
  Map<String, double> _getPieChartConfig(int categoryCount) {
    return {
      'centerSpaceRadius': 25.0, // Konsisten untuk semua kondisi
      'sectionsSpace': categoryCount == 1 ? 0.0 : 1.0, // Tetap 0 untuk single data
    };
  }

  List<PieChartSectionData> _buildIncomePieChartSections(Map<String, double> categories, List<Color> colors) {
    double total = categories.values.fold(0, (sum, value) => sum + value);
    List<String> keys = categories.keys.toList();
    
    // Gunakan radius yang konsisten
    final radiusConfig = _getPieChartRadius(keys.length);
    final baseRadius = radiusConfig['base']!;
    final touchedRadius = radiusConfig['touched']!;
    
    return keys.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final value = categories[category]!;
      final percentage = (value / total * 100);
      final isTouched = index == touchedIndexIncome;
      final radius = isTouched ? touchedRadius : baseRadius;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: value,
        title: isTouched 
            ? '$category\n${percentage.toStringAsFixed(1)}%\n${_formatCurrency(value)}' 
            : '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 9 : 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> _buildExpensePieChartSections(Map<String, double> categories, List<Color> colors) {
    double total = categories.values.fold(0, (sum, value) => sum + value);
    List<String> keys = categories.keys.toList();
    
    // Gunakan radius yang konsisten
    final radiusConfig = _getPieChartRadius(keys.length);
    final baseRadius = radiusConfig['base']!;
    final touchedRadius = radiusConfig['touched']!;
    
    return keys.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final value = categories[category]!;
      final percentage = (value / total * 100);
      final isTouched = index == touchedIndexExpense;
      final radius = isTouched ? touchedRadius : baseRadius;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: value,
        title: isTouched 
            ? '$category\n${percentage.toStringAsFixed(1)}%\n${_formatCurrency(value)}' 
            : '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 9 : 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegendItems(Map<String, double> categories, List<Color> colors) {
    List<String> keys = categories.keys.toList();
    double total = categories.values.fold(0, (sum, value) => sum + value);
    
    return keys.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final value = categories[category]!;
      final percentage = (value / total * 100);
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}% - ${_formatCurrency(value)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Color> _getIncomeColors() {
    return [
      Colors.green.shade400,
      Colors.green.shade600,
      Colors.green.shade800,
      Colors.teal.shade400,
      Colors.teal.shade600,
    ];
  }

  List<Color> _getExpenseColors() {
    return [
      Colors.red.shade400,
      Colors.red.shade600,
      Colors.red.shade800,
      Colors.orange.shade400,
      Colors.orange.shade600,
      Colors.orange.shade800,
    ];
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

  String _formatCurrencyShort(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}Jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}