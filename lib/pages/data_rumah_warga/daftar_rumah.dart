import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/detail_rumah.dart';

class DaftarRumah extends StatelessWidget {
  const DaftarRumah({super.key});

  // Data dummy sementara
  final List<Map<String, dynamic>> rumahList = const [
    {
      'no_rumah': 'A-01',
      'alamat': 'Jl. Kenanga No. 10',
      'status': 'Ditempati',
      'kepala_keluarga': 'Budi Santoso',
      'jumlah_anggota': 4,
      'penghuni': [
        'Budi Santoso',
        'Ani Santoso',
        'Rudi Santoso',
        'Rina Santoso',
      ],
    },
    {
      'no_rumah': 'A-02',
      'alamat': 'Jl. Melati No. 5',
      'status': 'Kosong',
      'kepala_keluarga': 'Siti Aminah',
      'jumlah_anggota': 3,
      'penghuni': ['Siti Aminah', 'Ahmad Amin', 'Lina Amin'],
    },
    {
      'no_rumah': 'A-03',
      'alamat': 'Jl. Anggrek No. 3',
      'status': 'Kosong',
      'kepala_keluarga': '-',
      'jumlah_anggota': 0,
      'penghuni': [],
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ditempati':
        return Colors.lightGreen.shade800;
      case 'Kosong':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
     return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 45, 92, 21),
          secondary: Color.fromARGB(255, 45, 92, 21),
          surface: Colors.white,
        ),
      ),
    child: Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Daftar Rumah Warga',
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
        padding: const EdgeInsets.all(12),
        itemCount: rumahList.length,
        itemBuilder: (context, index) {
          final rumah = rumahList[index];
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
                'No. Rumah: ${rumah['no_rumah']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alamat: ${rumah['alamat']}')
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(rumah['status']),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rumah['status'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailRumah(rumah: rumah)),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add_home, color: Colors.white),
        label: const Text('Tambah Rumah', style: TextStyle(color: Colors.white)), 
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_rumah');
        },
      ),
    )
     );
  }
}
