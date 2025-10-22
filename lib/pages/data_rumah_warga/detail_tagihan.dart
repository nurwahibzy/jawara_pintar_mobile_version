import 'package:flutter/material.dart';

class DetailTagihan extends StatelessWidget {
  final Map<String, dynamic> tagihan;
  const DetailTagihan({super.key, required this.tagihan});

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
          title: Text('Detail Tagihan'),
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
                    'Kode Iuran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['kodeIuran']),
                  const SizedBox(height: 10),

                  Text(
                    'Nama Iuran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['namaIuran']),
                  const SizedBox(height: 10),

                  Text(
                    'Kategori:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['kategori']),
                  const SizedBox(height: 10),

                  Text(
                    'Periode:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['periode']),
                  const SizedBox(height: 10),
                  Text(
                    'Nominal:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['nominal'].toString()),
                  const SizedBox(height: 10),
                  Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['status']),
                  const SizedBox(height: 10),
                  Text(
                    'Nama Kepala Keluarga:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['namaKepalaKeluarga']),
                  const SizedBox(height: 10),
                  Text(
                    'Alamat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(tagihan['alamat']),
                  const SizedBox(height: 10),
                  Text(
                    'Metode Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Belum Tersedia'),
                  const SizedBox(height: 10),
                  Text(
                    'Bukti:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('-'),
                  const SizedBox(height: 10),
                  Text(
                    'Alasan Penolakan:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                          foregroundColor: Colors.white, // Text/icon color
                          padding: EdgeInsets.all(20), // Internal padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text('Setujui'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                          foregroundColor: Colors.white, // Text/icon color
                          padding: EdgeInsets.all(20), // Internal padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text('Tolak'),
                      ),
                    ],
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
