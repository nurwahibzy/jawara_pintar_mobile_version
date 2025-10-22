import 'package:flutter/material.dart';

class DetailKeluarga extends StatelessWidget {
  final Map<String, dynamic> keluarga;
  const DetailKeluarga({super.key, required this.keluarga});

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
          title: Text('Detail Keluarga'),
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
                  Text(
                    'Nama Keluarga:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(keluarga['namaKepalaKeluarga']),
                  const SizedBox(height: 10),

                  Text(
                    'Alamat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(keluarga['alamat']),
                  const SizedBox(height: 10),

                  Text(
                    'Status Kepemilikan:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(keluarga['statusKepemilikan']),
                  const SizedBox(height: 10),

                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(keluarga['status']),
                  const SizedBox(height: 20),

                  const Divider(thickness: 1),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
