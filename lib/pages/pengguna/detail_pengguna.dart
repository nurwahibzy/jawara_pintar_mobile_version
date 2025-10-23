import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/edit_pengguna.dart';

class DetailPengguna extends StatelessWidget {
  final Map<String, dynamic> pengguna;
  const DetailPengguna({super.key, required this.pengguna});

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
          title: Text('Detail Pengguna'),
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
                          pengguna['nama'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(pengguna['jabatan']),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  Text(
                    'NIK:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna['nik']),
                  const SizedBox(height: 10),

                  Text(
                    'Email:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna['email']),
                  const SizedBox(height: 10),

                  Text(
                    'No HP:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna['noHP']),
                  const SizedBox(height: 10),

                  Text(
                    'Jenis Kelamin:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna['jenisKelamin']),
                  const SizedBox(height: 10),

                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pengguna['statusRegistrasi']),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditPengguna(pengguna: pengguna),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Pengguna',
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
