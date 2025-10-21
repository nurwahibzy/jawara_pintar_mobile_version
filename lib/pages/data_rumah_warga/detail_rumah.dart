import 'package:flutter/material.dart';

class DetailRumah extends StatelessWidget {
  final Map<String, dynamic> rumah;
  const DetailRumah({super.key, required this.rumah});

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
      appBar: AppBar(
        title: Text('Detail Rumah ${rumah['no_rumah']}'),
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
                  'Alamat:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(rumah['alamat']),
                const SizedBox(height: 10),

                Text(
                  'Status Rumah:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(rumah['status']),
                const SizedBox(height: 10),

                Text(
                  'Kepala Keluarga:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(rumah['kepala_keluarga']),
                const SizedBox(height: 10),

                Text(
                  'Jumlah Anggota:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('${rumah['jumlah_anggota']} orang'),
                const SizedBox(height: 20),

                const Divider(thickness: 1),
                const SizedBox(height: 10),

                Text(
                  'Daftar Penghuni:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                rumah['penghuni'].isEmpty
                    ? const Text('Belum ada penghuni.')
                    : Column(
                        children: List.generate(
                          rumah['penghuni'].length,
                          (index) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(rumah['penghuni'][index]),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }
}
