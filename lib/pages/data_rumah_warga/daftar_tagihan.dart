import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/detail_tagihan.dart';

class DaftarTagihanRumah extends StatelessWidget {
  const DaftarTagihanRumah({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tagihan = [
      {
        'namaKepalaKeluarga': 'Budi Santoso',
        'alamat': 'Jl. Merdeka No. 10',
        'namaIuran': 'Bersih Desa',
        'statusKeluarga': 'Aktif',
        'kodeIuran': 'abc123',
        'nominal': 10000,
        'kategori': 'Iuran khusus',
        'periode': '1 Oktober 2025',
        'status': 'Belum Dibayar',
      },
      {
        'namaKepalaKeluarga': 'Siti Aminah',
        'alamat': 'Jl. Sudirman No. 5',
        'namaIuran': 'Bersih Desa',
        'statusKeluarga': 'Nonaktif',
        'kodeIuran': 'abc123',
        'nominal': 10000,
        'kategori': 'Iuran khusus',
        'periode': '1 Oktober 2025',
        'status': 'Dibayar',
      },
      {
        'namaKepalaKeluarga': 'Andi Wijaya',
        'alamat': 'Jl. Thamrin No. 10',
        'namaIuran': 'Bersih Desa',
        'statusKeluarga': 'Aktif',
        'kodeIuran': 'abc123',
        'nominal': 10000,
        'kategori': 'Iuran khusus',
        'periode': '1 Oktober 2025',
        'status': 'Ditolak',
      },
    ];

    Color _getStatusColor(String status) {
      switch (status) {
        case 'Dibayar':
          return Colors.lightGreen.shade800;
        case 'Belum Dibayar':
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
          'Daftar Tagihan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/keuangan',
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ListView.builder(
          itemCount: tagihan.length,
          itemBuilder: (context, index) {
            final data = tagihan[index];
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
                  'Nama Keluarga: ${data['namaKepalaKeluarga']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Iuran: ${data['namaIuran']}'),
                  Text('Nominal: Rp. ${data['nominal']}'),
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
                      builder: (_) => DetailTagihan(tagihan: data),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
