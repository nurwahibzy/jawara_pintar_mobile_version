import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<double> data;
  final Color barColor;
  final Color backgroundColor;
  final List<String> labels;
  final String Function(double)? valueFormatter;
  final bool useCurrencyFormat;

  const BarChartCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    required this.barColor,
    this.backgroundColor = Colors.white,
    required this.labels,
    this.valueFormatter,
    this.useCurrencyFormat = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: barColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bar Chart
          SizedBox(
            height: 250,
            child: data.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : BarChart(
                    BarChartData(
                      maxY: maxValue * 1.2,
                      minY: 0,
                      groupsSpace: 16,
                      barGroups: data.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              gradient: LinearGradient(
                                colors: [
                                  barColor,
                                  barColor.withOpacity(0.7),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: 18,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: maxValue * 1.2,
                                color: barColor.withOpacity(0.05),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: (maxValue * 1.2) / 4,
                            getTitlesWidget: (value, meta) {
                              String formattedValue;
                              if (valueFormatter != null) {
                                formattedValue = valueFormatter!(value);
                              } else if (useCurrencyFormat) {
                                formattedValue = _formatCurrency(value);
                              } else {
                                formattedValue = value.toInt().toString();
                              }
                              return SizedBox(
                                width: 50,
                                child: Text(
                                  formattedValue,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[value.toInt()],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
                        horizontalInterval: (maxValue * 1.2) / 4,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.grey[800]!,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String formattedValue;
                            if (valueFormatter != null) {
                              formattedValue = valueFormatter!(rod.toY);
                            } else if (useCurrencyFormat) {
                              formattedValue = _formatCurrencyFull(rod.toY);
                            } else {
                              formattedValue = rod.toY.toInt().toString();
                            }
                            return BarTooltipItem(
                              '${labels[group.x.toInt()]}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: formattedValue,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          // Summary Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: barColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: barColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  'Total',
                  _formatValue(data.fold(0.0, (sum, value) => sum + value)),
                  barColor,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                _buildInfoItem(
                  'Rata-rata',
                  _formatValue(
                    data.isNotEmpty
                        ? data.reduce((a, b) => a + b) / data.length
                        : 0,
                  ),
                  barColor,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                _buildInfoItem(
                  'Tertinggi',
                  _formatValue(maxValue.toDouble()),
                  barColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatValue(double value) {
    if (valueFormatter != null) {
      return valueFormatter!(value);
    } else if (useCurrencyFormat) {
      return _formatCurrencyFull(value);
    } else {
      return value.toInt().toString();
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}Jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  String _formatCurrencyFull(double value) {
    if (value >= 1000000) {
      return 'Rp${(value / 1000000).toStringAsFixed(1)} Juta';
    } else if (value >= 1000) {
      return 'Rp${(value / 1000).toStringAsFixed(0)} Ribu';
    } else {
      return 'Rp${value.toStringAsFixed(0)}';
    }
  }
}
