import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/pesan_warga/edit_pesan_warga.dart';

class DetailPesanWarga extends StatelessWidget {
  final Map<String, dynamic> pesan;
  const DetailPesanWarga({super.key, required this.pesan});

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
          title: Text('Detail Pesan'),
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
                    const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  Text(
                    'Judul:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['judul']),
                  const SizedBox(height: 10),

                  Text(
                    'Deskripsi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['deskripsi']),
                  const SizedBox(height: 10),

                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['status']),
                  const SizedBox(height: 10),

                  Text(
                    'Dibuat Oleh:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['pengirim']),
                  const SizedBox(height: 10),

                  Text(
                    'Tanggal Dibuat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['tglDibuat']),
                  const SizedBox(height: 10),

                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(pesan['status']),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPesanWarga(pesan: pesan),
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
                          'Edit Pesan',
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
