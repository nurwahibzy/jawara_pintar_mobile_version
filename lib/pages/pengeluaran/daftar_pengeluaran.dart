import 'package:flutter/material.dart';

class DaftarPengeluaran extends StatefulWidget {
  const DaftarPengeluaran({super.key});

  @override
  State<DaftarPengeluaran> createState() => _DaftarPengeluaranState();
}

class _DaftarPengeluaranState extends State<DaftarPengeluaran> {
  List<Map<String, dynamic>> pengeluaranList = [
    {
      'nama': 'Beli Peralatan Kebersihan',
      'tanggal': '10/10/2025',
      'kategori': 'Kebersihan',
      'nominal': '150000',
      'tanggal_verifikasi': '12/10/2025 14:30',
      'verifikator': 'Admin Jawara',
    },
    {
      'nama': 'Bayar Tukang',
      'tanggal': '15/10/2025',
      'kategori': 'Perawatan',
      'nominal': '500000',
      'tanggal_verifikasi': '16/10/2025 10:15',
      'verifikator': 'Admin Jawara',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran', ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white), 
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: pengeluaranList.length,
        itemBuilder: (context, index) {
          final item = pengeluaranList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item['nama']),
              subtitle: Text(
                "Tanggal: ${item['tanggal']}\nKategori: ${item['kategori']}",
              ),
              trailing: Text(
                "Rp ${item['nominal']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPengeluaran(pengeluaran: item),
                  ),
                );

                if (result == 'hapus') {
                  setState(() {
                    pengeluaranList.removeAt(index);
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengeluaran'),
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_pengeluaran');
        },
      ),
    );
  }
}

class DetailPengeluaran extends StatelessWidget {
  final Map<String, dynamic> pengeluaran;

  const DetailPengeluaran({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengeluaran'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  pengeluaran['nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                _buildDetailItem('Tanggal', pengeluaran['tanggal']),
                _buildDetailItem('Kategori', pengeluaran['kategori']),
                _buildDetailItem('Nominal', pengeluaran['nominal']),
                _buildDetailItem('Tanggal Terverifikasi',pengeluaran['tanggal_verifikasi']),
                _buildDetailItem('Verifikator',pengeluaran['verifikator']),
                const SizedBox(height: 16),
                const Text(
                  'Bukti Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildImagePlaceholder(
                  child: Image.asset(
                    'images/background_login.jpg',
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_pengeluaran',
                          arguments: pengeluaran,
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hapus Pengeluaran'),
                            content: Text(
                              'Apakah yakin ingin hapus "${pengeluaran['nama'] ?? '-'}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context, 'hapus');
                                },
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : '-',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder({Widget? child}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child ?? const Icon(Icons.image, size: 60, color: Colors.grey),
    );
  }
}