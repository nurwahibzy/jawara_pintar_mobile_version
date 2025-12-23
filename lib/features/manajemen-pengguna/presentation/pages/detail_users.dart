import 'package:flutter/material.dart';
import '../../domain/entities/users.dart';
import '../../../../core/theme/app_colors.dart';

class DetailUsers extends StatelessWidget {
  final Users user;

  const DetailUsers({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Mengambil inisial nama untuk avatar
    // final String inisial = user.nama.isNotEmpty
    //     ? user.nama[0].toUpperCase()
    //     : '?';

    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Background sedikit abu agar Card pop-up
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BAGIAN HEADER (Avatar & Nama)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.nama ?? 'kosong',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // BAGIAN CARD DETAIL
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Akun",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 30),

                      // Status dengan Badge Warna
                      _buildStatusBadge(user.status),
                      const SizedBox(height: 20),

                      // Detail Item
                      _buildDetailRow(Icons.badge, 'Role', user.role),
                      _buildDetailRow(
                        Icons.calendar_today,
                        'Terdaftar Sejak',
                        _formatTanggal(user.createdAt),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget khusus untuk menampilkan Status
  Widget _buildStatusBadge(String status) {
    final bool isActive = status.toLowerCase() == 'approved';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Status Akun",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: isActive ? Colors.green[800] : Colors.red[800],
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: isActive ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget baris detail dengan Ikon
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Format Tanggal
  String _formatTanggal(DateTime date) {
    // Menggunakan list nama bulan manual agar tidak perlu package intl jika belum ada
    const List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }
}
