import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/daftar_broadcast.dart';

class DetailBroadcastPage extends StatelessWidget {
  final Broadcast broadcast;

  const DetailBroadcastPage({super.key, required this.broadcast});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Broadcast'),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Judul', broadcast.judul),
                  _buildDetailRow('Pengirim', broadcast.pengirim),
                  _buildDetailRow('Tanggal',
                      broadcast.tanggal.toLocal().toString().split(' ')[0]),
                  const Divider(height: 24),
                  // Isi pesan dibuat lebih menonjol
                  const Text('Isi Pesan',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    broadcast.isiPesan,
                    style: const TextStyle(fontSize: 16, height: 1.5),
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