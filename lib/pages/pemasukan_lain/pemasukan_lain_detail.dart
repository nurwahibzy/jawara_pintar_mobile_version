import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_daftar.dart';

class DetailPemasukanLain extends StatelessWidget {
  final Pemasukan pemasukan;

  const DetailPemasukanLain({super.key, required this.pemasukan});

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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value, // Tampilkan '-' jika data kosong
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemasukan Lain'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Nama Pemasukan', pemasukan.nama),
                  _buildDetailRow('Kategori', pemasukan.jenisPemasukan),
                  _buildDetailRow(
                    'Tanggal Transaksi',
                    pemasukan.tanggal.toLocal().toString().split(' ')[0],
                  ),
                  _buildDetailRow(
                    'Jumlah',
                    'Rp ${pemasukan.nominal.toStringAsFixed(2)}',
                    valueColor: Colors.green.shade700,
                  ),
                  _buildDetailRow('Tanggal Terverifikasi', ''), // Data dummy
                  _buildDetailRow('Verifikator', 'Admin Jawara'), // Data dummy
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
