import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<ChartData> data;
  final Color backgroundColor;
  final String Function(double)? valueFormatter;

  const PieChartCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    this.backgroundColor = Colors.white,
    this.valueFormatter,
  });

  @override
  State<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Calculate total
    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
          // Header with Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.data.isNotEmpty
                      ? widget.data[0].color.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.data.isNotEmpty
                      ? widget.data[0].color
                      : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
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
          
          // Pie Chart
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Chart
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: _buildPieChartSections(total),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Legend and Details
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total in center
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Jumlah',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.valueFormatter != null
                                  ? widget.valueFormatter!(total)
                                  : total.toInt().toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: widget.data.map((item) {
              final percentage = (item.value / total * 100).toStringAsFixed(0);
              final formattedValue = widget.valueFormatter != null
                  ? widget.valueFormatter!(item.value)
                  : item.value.toInt().toString();
              return _buildLegendItem(
                item.label,
                item.color,
                formattedValue,
                '$percentage%',
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(double total) {
    return List.generate(widget.data.length, (index) {
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 70.0 : 55.0;
      final fontSize = isTouched ? 13.0 : 14.0;
      final item = widget.data[index];
      final percentage = (item.value / total * 100).toStringAsFixed(0);

      final formattedValue = widget.valueFormatter != null
          ? widget.valueFormatter!(item.value)
          : item.value.toInt().toString();

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        title: isTouched 
            ? '${item.label}\n$formattedValue\n($percentage%)' 
            : '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
      );
    });
  }

  Widget _buildLegendItem(
      String label, Color color, String value, String percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$value ($percentage)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

// Data model for chart
class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
