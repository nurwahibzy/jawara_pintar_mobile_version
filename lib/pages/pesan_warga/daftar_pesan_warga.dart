import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pesan_warga/detail_pesan_warga.dart';

class DaftarPesanWarga extends StatelessWidget {
  const DaftarPesanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pengguna = [
      {
        'judul': 'Bongkar rumah pak RT',
        'pengirim': 'Kang Atmin',
        'deskripsi': 'pak rt mau renovasi',
        'tglDibuat': '21 Mei 2022',
        'status': 'Dipending',
      },
      {
        'judul': 'Bersih Desa',
        'pengirim': 'Pak Joko',
        'deskripsi': 'gotong royong',
        'tglDibuat': '2 April 2022',
        'status': 'Diterima',
      },
    ];

    Color _getStatusColor(String statusRegistrasi) {
      switch (statusRegistrasi) {
        case 'Diterima':
          return Colors.lightGreen.shade800;
        case 'Dipending':
          return Colors.orange;
        case 'Ditolak':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aspirasi Warga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: pengguna.length,
        itemBuilder: (context, index) {
          final data = pengguna[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: Text(
                'Judul : ${data['judul']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pengirim: ${data['pengirim']}'),
                  Text(data['tglDibuat']),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(data['status']),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data['status'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPesanWarga(pesan: data),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
