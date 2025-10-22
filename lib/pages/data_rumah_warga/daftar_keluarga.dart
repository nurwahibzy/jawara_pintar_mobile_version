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
        'status': 'Aktif',
      },
      {
        'namaKepalaKeluarga': 'Siti Aminah',
        'alamat': 'Jl. Sudirman No. 5',
        'statusKepemilikan': 'Penyewa',
        'status': 'Nonaktif',
      },
      {
        'namaKepalaKeluarga': 'Andi Wijaya',
        'alamat': 'Jl. Thamrin No. 20',
        'statusKepemilikan': 'Pemilik',
        'status': 'Aktif',
      },
    ];

    Color _getStatusColor(String status) {
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

// class KeluargaCard extends StatelessWidget {
//   final int nomor;
//   final String namaKepalaKeluarga;
//   final String alamat;
//   final String statusKepemilikan;
//   final String status;

//   const KeluargaCard({
//     super.key,
//     required this.nomor,
//     required this.namaKepalaKeluarga,
//     required this.alamat,
//     required this.statusKepemilikan,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Navigator.pushNamed(
//         context,
//         '/detail-keluarga',
//         arguments: {
//           'nomor': nomor,
//           'nama': namaKepalaKeluarga,
//           'alamat': alamat,
//           'statusKepemilikan': statusKepemilikan,
//           'status': status,
//         },
//       ),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Nomor urut
//               CircleAvatar(
//                 backgroundColor: Colors.green.withAlpha(1),
//                 child: Text(
//                   nomor.toString(),
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Detail keluarga
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Keluarga: $namaKepalaKeluarga',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     const SizedBox(height: 6),
//                     Text('Status: $statusKepemilikan - $status'),
//                     const SizedBox(height: 6),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
