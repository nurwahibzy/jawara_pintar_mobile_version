import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_daftar.dart';

class DetailKegiatan extends StatelessWidget {
  final ModelKegiatan kegiatan;

  const DetailKegiatan({super.key, required this.kegiatan});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kegiatan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
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
                  _buildDetailRow('Nama Kegiatan', kegiatan.namaKegiatan),
                  _buildDetailRow('Kategori', kegiatan.kategori),
                  _buildDetailRow(
                    'Tanggal',
                    kegiatan.tanggal.toLocal().toString().split(' ')[0],
                  ),
                  _buildDetailRow('Lokasi', kegiatan.lokasi),
                  _buildDetailRow('Penanggung Jawab', kegiatan.penanggungJawab),
                  _buildDetailRow('Deskripsi', kegiatan.deskripsi),
                  _buildDetailRow(
                    'Dokumentasi',
                    kegiatan.dokumentasiPath ?? 'Belum ada',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
