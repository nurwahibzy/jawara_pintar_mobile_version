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
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8E6CEF).withOpacity(0.15),
                      const Color(0xFF8E6CEF).withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8E6CEF).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF8E6CEF),
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
          
          // Pie Chart - Centered
          Center(
            child: SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
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
                      centerSpaceRadius: 70,
                      sections: _buildPieChartSections(total),
                    ),
                  ),
                  // Total in center
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8E6CEF).withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            widget.valueFormatter != null
                                ? widget.valueFormatter!(total)
                                : total.toInt().toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
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
      final radius = isTouched ? 42.0 : 35.0;
      final item = widget.data[index];
      final percentage = (item.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        title: isTouched ? '$percentage%' : '',
        radius: radius,
        borderSide: BorderSide(
          color: Colors.white,
          width: 3,
        ),
        titleStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegendItem(
      String label, Color color, String value, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
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
