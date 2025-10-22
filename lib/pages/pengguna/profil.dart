import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  Profil({super.key});
  final List<Map<String, dynamic>> pengguna = [
    {
      'nama': 'Kang Atmin',
      'email': 'admin1@gmail.com',
      'jabatan': 'Admin',
      'nik': '12345',
      'noHP': '0812345',
      'jenisKelamin': 'Laki-Laki',
      'statusRegistrasi': 'Diterima',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 45, 92, 21),
          secondary: Color.fromARGB(255, 45, 92, 21),
          surface: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.green[100],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          pengguna[0]['nama'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(pengguna[0]['jabatan']),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  Text(
                    'NIK:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna[0]['nik']),
                  const SizedBox(height: 10),

                  Text(
                    'Email:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna[0]['email']),
                  const SizedBox(height: 10),

                  Text(
                    'No HP:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna[0]['noHP']),
                  const SizedBox(height: 10),

                  Text(
                    'Jenis Kelamin:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna[0]['jenisKelamin']),
                  const SizedBox(height: 10),

                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna[0]['statusRegistrasi']),

                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 100,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
