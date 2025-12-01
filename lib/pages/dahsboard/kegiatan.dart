import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/widgets/bottom_navigation_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/custom_app_bar.dart';
import 'package:jawara_pintar_mobile_version/widgets/menu_kegiatan.dart';
import 'package:jawara_pintar_mobile_version/widgets/pie_chart_card.dart';
import 'package:jawara_pintar_mobile_version/widgets/bar_chart_card.dart';

class Kegiatan extends StatelessWidget {
  const Kegiatan({super.key});

  // Data kegiatan per kategori
  List<ChartData> get kegiatanPerKategori => [
    ChartData(label: 'Komunitas & Sosial', value: 8, color: Colors.blue),
    ChartData(label: 'Kebersihan & Keamanan', value: 6, color: Colors.greenAccent),
    ChartData(label: 'Keagamaan', value: 4, color: Colors.purpleAccent),
    ChartData(label: 'Pendidikan', value: 3, color: Colors.orangeAccent),
    ChartData(label: 'Kesehatan & Olahraga', value: 2, color: Colors.red),
    ChartData(label: 'Lainnya', value: 2, color: Colors.blueGrey),
  ];

  // Data kegiatan berdasarkan waktu
  List<ChartData> get kegiatanBerdasarkanWaktu => [
    ChartData(label: 'Sudah Lewat', value: 10, color: Colors.grey.shade600),
    ChartData(label: 'Hari Ini', value: 2, color: Colors.orange),
    ChartData(label: 'Akan Datang', value: 13, color: Colors.blue),
  ];

  // Data penanggung jawab terbanyak
  List<Map<String, dynamic>> get penanggungJawabTerbanyak => [
    {'nama': 'Pak Budi', 'jumlah': 5},
    {'nama': 'Bu Siti', 'jumlah': 4},
    {'nama': 'Pak Ahmad', 'jumlah': 3},
    {'nama': 'Bu Rani', 'jumlah': 3},
    {'nama': 'Pak Joko', 'jumlah': 2},
  ];

  // Data kegiatan per bulan (tahun 2025) - data bulat (integer)
  List<double> get kegiatanPerBulan => [
    2,  // Jan
    3,  // Feb
    2,  // Mar
    3,  // Apr
    2,  // Mei
    4,  // Jun
    2,  // Jul
    3,  // Agu - 17 Agustus
    2,  // Sep
    1,  // Okt
    0,  // Nov - belum terjadi
    0,  // Des - belum terjadi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dashboard Kegiatan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola data kegiatan warga',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Menu Kegiatan
            const MenuKegiatan(),
            Text(
              'Statistik Kegiatan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),            
            const SizedBox(height: 4),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.event,
                    label: 'Total Kegiatan',
                    value: '25',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pie Chart - Kegiatan per Kategori
            PieChartCard(
              title: 'Kegiatan per Kategori',
              icon: Icons.pie_chart,
              backgroundColor: Colors.blue.shade50,
              data: kegiatanPerKategori,
            ),
            const SizedBox(height: 24),

            // Card - Kegiatan berdasarkan Waktu
            _buildKegiatanBerdasarkanWaktuCard(),
            const SizedBox(height: 24),

            // Card - Penanggung Jawab Terbanyak
            _buildPenanggungJawabTerbanyakCard(),
            const SizedBox(height: 24),

            // Bar Chart - Kegiatan per Bulan
            BarChartCard(
              title: 'Kegiatan per Bulan (Tahun 2025)',
              icon: Icons.bar_chart,
              barColor: Colors.teal.shade600,
              backgroundColor: Colors.teal.shade50,
              data: kegiatanPerBulan,
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
              useCurrencyFormat: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKegiatanBerdasarkanWaktuCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Kegiatan berdasarkan Waktu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // List items
          ...kegiatanBerdasarkanWaktu.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPenanggungJawabTerbanyakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Penanggung Jawab Terbanyak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // List items
          ...penanggungJawabTerbanyak.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.purple.shade700,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['nama'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['jumlah'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
