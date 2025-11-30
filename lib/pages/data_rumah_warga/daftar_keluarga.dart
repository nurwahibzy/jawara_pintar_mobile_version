import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/detail_keluarga.dart';

class DaftarKeluarga extends StatelessWidget {
  const DaftarKeluarga({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> keluarga = [
      {
        'namaKepalaKeluarga': 'Budi Santoso',
        'alamat': 'Jl. Merdeka No. 10',
        'statusKepemilikan': 'Pemilik',
        'nik': '1234567890',
        'peran': 'Kepala Keluarga',
        'jenisKelamin': 'Laki-Laki',
        'tanggalLahir': '12 Desember 1945',
        'status': 'Aktif',
      },
      {
        'namaKepalaKeluarga': 'Siti Aminah',
        'alamat': 'Jl. Sudirman No. 5',
        'statusKepemilikan': 'Penyewa',
        'nik': '1234567890',
        'peran': 'Ibu Rumah Tangga',
        'jenisKelamin': 'Perempuan',
        'tanggalLahir': '1 Mei 1927',
        'status': 'Nonaktif',
      },
      {
        'namaKepalaKeluarga': 'Andi Wijaya',
        'alamat': 'Jl. Thamrin No. 20',
        'statusKepemilikan': 'Pemilik',
        'nik': '1234567890',
        'peran': 'Kepala Keluarga',
        'jenisKelamin': 'Laki-Laki',
        'tanggalLahir': '2 Januari 1927',
        'status': 'Aktif',
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Aktif':
          return Colors.lightGreen.shade800;
        case 'Nonaktif':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.pushNamedAndRemoveUntil(context, '/kependudukan', (route) => false);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: keluarga.length,
        itemBuilder: (context, index) {
          final data = keluarga[index];
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
                'Nama keluarga: ${data['namaKepalaKeluarga']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Alamat: ${data['alamat']}')],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(data['status']),
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
                  MaterialPageRoute(builder: (_) => DetailKeluarga(keluarga: data)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
