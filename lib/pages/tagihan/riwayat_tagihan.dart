import 'package:flutter/material.dart';

class RiwayatTagihan extends StatelessWidget {
  final dynamic tagihan;

  const RiwayatTagihan({super.key, required this.tagihan});

  @override
  Widget build(BuildContext context) {
    // Data riwayat pembayaran dummy
    final List<Map<String, dynamic>> riwayatPembayaran = [
      {
        'tanggal': DateTime(2025, 10, 15),
        'nominal': 50000.00,
        'metodePembayaran': 'Transfer Bank',
        'status': 'Terverifikasi',
        'keterangan': 'Pembayaran sebagian',
      },
      {
        'tanggal': DateTime(2025, 9, 10),
        'nominal': 150000.00,
        'metodePembayaran': 'Tunai',
        'status': 'Terverifikasi',
        'keterangan': 'Pembayaran lunas periode September',
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: riwayatPembayaran.length,
        itemBuilder: (context, index) {
          final riwayat = riwayatPembayaran[index];
          final tanggal = riwayat['tanggal'] as DateTime;
          final formattedTanggal =
              '${tanggal.day} ${_getMonthName(tanggal.month)} ${tanggal.year}';
          final formattedNominal =
              'Rp ${(riwayat['nominal'] as double).toStringAsFixed(0).replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]}.',
                  )}';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedTanggal,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          riwayat['status'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        riwayat['metodePembayaran'],
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.description, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          riwayat['keterangan'],
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedNominal,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
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
      'Desember'
    ];
    return months[month - 1];
  }
}
