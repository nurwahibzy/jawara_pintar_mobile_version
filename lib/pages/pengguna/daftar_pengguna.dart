import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/detail_pengguna.dart';

class DaftarPengguna extends StatelessWidget {
  const DaftarPengguna({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pengguna = [
      {
        'nama': 'Kang Atmin',
        'email': 'admin1@gmail.com',
        'jabatan': 'admin',
        'nik': '12345',
        'noHP': '0812345',
        'jenisKelamin': 'Laki-Laki',
        'statusRegistrasi': 'Diterima',
      },
      {
        'nama': 'Pak RT',
        'email': 'rt@gmail.com',
        'jabatan': 'Admin',
        'nik': '12345',
        'noHP': '0812345',
        'jenisKelamin': 'Laki-Laki',
        'statusRegistrasi': 'Ditolak',
      },
    ];

    Color _getStatusColor(String statusRegistrasi) {
      switch (statusRegistrasi) {
        case 'Diterima':
          return Colors.lightGreen.shade800;
        case 'Ditolak':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pengguna',
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
                'Nama : ${data['nama']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Email: ${data['email']}')],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(data['statusRegistrasi']),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data['statusRegistrasi'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPengguna(pengguna: data),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text(
            'Tambah Pengguna',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/tambah_pengguna');
          },
        ),
    );
  }
}
