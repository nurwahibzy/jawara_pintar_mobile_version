import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_kependudukan.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';

class Kependudukan extends StatelessWidget {
  const Kependudukan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
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
            // Chart Diagrams Section Header
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
                    value: '10',
                    subtitle: 'Jumlah Keluarga',
                    color: Colors.green.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Penduduk',
                    value: '15',
                    subtitle: 'Jumlah Penduduk',
                    color: Colors.green.shade600,
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
              data: [
                ChartData(
                  label: 'Aktif',
                  value: 13,
                  color: Colors.teal,
                ),
                ChartData(
                  label: 'Nonaktif',
                  value: 2,
                  color: Colors.deepOrange.shade800,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Jenis Kelamin Chart
            PieChartCard(
              title: 'Jenis Kelamin',
              icon: Icons.wc,
              backgroundColor: Colors.purple.shade50,
              data: [
                ChartData(
                  label: 'Laki-laki',
                  value: 8,
                  color: Colors.blue,
                ),
                ChartData(
                  label: 'Perempuan',
                  value: 7,
                  color: Colors.pink,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pekerjaan Penduduk Chart
            PieChartCard(
              title: 'Pekerjaan Penduduk',
              icon: Icons.work,
              backgroundColor: Colors.green.shade50,
              data: [
                ChartData(
                  label: 'PNS',
                  value: 3,
                  color: Colors.green,
                ),
                ChartData(
                  label: 'Swasta',
                  value: 5,
                  color: Colors.blue,
                ),
                ChartData(
                  label: 'Wiraswasta',
                  value: 4,
                  color: Colors.orange,
                ),
                ChartData(
                  label: 'Lainnya',
                  value: 3,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Peran dalam Keluarga Chart
            PieChartCard(
              title: 'Peran dalam Keluarga',
              icon: Icons.family_restroom,
              backgroundColor: Colors.blue.shade50,
              data: [
                ChartData(
                  label: 'Kepala Keluarga',
                  value: 4,
                  color: Colors.blue.shade700,
                ),
                ChartData(
                  label: 'Istri',
                  value: 4,
                  color: Colors.pink,
                ),
                ChartData(
                  label: 'Anak',
                  value: 5,
                  color: Colors.purple,
                ),
                ChartData(
                  label: 'Anggota Lain',
                  value: 2,
                  color: Colors.brown,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Agama Chart
            PieChartCard(
              title: 'Agama',
              icon: Icons.mosque,
              backgroundColor: Colors.orange.shade50,
              data: [
                ChartData(
                  label: 'Islam',
                  value: 10,
                  color: Colors.green,
                ),
                ChartData(
                  label: 'Kristen',
                  value: 2,
                  color: Colors.blue,
                ),
                ChartData(
                  label: 'Katolik',
                  value: 1,
                  color: Colors.orange,
                ),
                ChartData(
                  label: 'Hindu',
                  value: 1,
                  color: Colors.pink,
                ),
                ChartData(
                  label: 'Buddha',
                  value: 1,
                  color: Colors.deepOrange,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pendidikan Chart
            PieChartCard(
              title: 'Pendidikan',
              icon: Icons.school,
              backgroundColor: Colors.pink.shade50,
              data: [
                ChartData(
                  label: 'SD',
                  value: 2,
                  color: Colors.deepOrange,
                ),
                ChartData(
                  label: 'SMP',
                  value: 3,
                  color: Colors.orange,
                ),
                ChartData(
                  label: 'SMA',
                  value: 4,
                  color: Colors.green,
                ),
                ChartData(
                  label: 'D3',
                  value: 2,
                  color: Colors.blue,
                ),
                ChartData(
                  label: 'S1',
                  value: 3,
                  color: Colors.purple,
                ),
                ChartData(
                  label: 'S2',
                  value: 1,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ],
        ),
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
          // Icon
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
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
