import 'package:flutter/material.dart';

class DetailPengguna extends StatelessWidget {
  final dynamic pengguna;

  const DetailPengguna({super.key, required this.pengguna});

  // Helper widget untuk membuat baris detail
  Widget _buildDetailRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna status
    final String statusAkun = pengguna['statusAkun'] as String;
    Color statusColor = statusAkun == 'Diterima' ? Colors.green : Colors.red;

    // Tentukan warna role
    final String role = pengguna['role'] as String;
    Color roleColor = role == 'Admin'
        ? Colors.blue
        : role == 'Ketua RT'
            ? Colors.deepPurple
            : role == 'Ketua RW'
                ? Colors.indigo
                : role == 'Sekretaris'
                    ? Colors.teal
                    : role == 'Bendahara'
                        ? Colors.purple
                        : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengguna',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Informasi Utama
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar dan Nama
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.green.withOpacity(0.2),
                              child: Text(
                                pengguna['nama']
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              pengguna['nama'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Role Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                role,
                                style: TextStyle(
                                  color: roleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 40),

                      // Informasi Detail
                      _buildDetailRow('NIK:', pengguna['nik'] ?? 'Tidak tersedia'),
                      _buildDetailRow('Email:', pengguna['email'] ?? '-'),
                      _buildDetailRow('Nomor HP:', pengguna['noTelepon'] ?? '-'),
                      _buildDetailRow('Jenis Kelamin:', pengguna['jenisKelamin'] ?? 'Tidak Tersedia'),
                      _buildDetailRow('Status Registrasi:', statusAkun,
                          valueColor: statusColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
