import 'package:flutter/material.dart';
import '../../domain/entities/mutasi_keluarga.dart';

class DetailMutasiKeluarga extends StatelessWidget {
  final MutasiKeluarga mutasi;

  const DetailMutasiKeluarga({super.key, required this.mutasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mutasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon Besar & Jenis Mutasi
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      _getIconByJenis(mutasi.jenisMutasi), 
                      size: 40, 
                      color: Colors.blue
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mutasi.jenisMutasi,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mutasi.tanggalMutasi.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            
            // BAGIAN 1: IDENTITAS
            const SizedBox(height: 8),
            const Text("Data Keluarga", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            // Tampilkan Nama (Bukan ID)
            _buildItem(
              icon: Icons.person,
              label: "Kepala Keluarga", 
              value: mutasi.namaKepalaKeluarga ?? "ID: ${mutasi.keluargaId}",
            ),
            
            const SizedBox(height: 16),
            const Divider(),

            // BAGIAN 2: PERPINDAHAN
            const SizedBox(height: 8),
            const Text("Informasi Perpindahan", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Tampilkan Alamat Asal (Bukan ID)
            _buildItem(
              icon: Icons.logout,
              label: "Rumah Asal", 
              value: mutasi.alamatAsal ?? "-", // Tampilkan strip jika null
            ),

            // Tampilkan Alamat Tujuan (Bukan ID)
            _buildItem(
              icon: Icons.login,
              label: "Rumah Tujuan", 
              value: mutasi.alamatTujuan ?? "-", // Tampilkan strip jika null
            ),

            const SizedBox(height: 16),
            const Divider(),

            // BAGIAN 3: KETERANGAN TAMBAHAN
            const SizedBox(height: 8),
            const Text("Lainnya", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            _buildItem(
              icon: Icons.note_alt_outlined,
              label: "Keterangan", 
              // Pastikan field 'keterangan' ada di entity. Jika tidak ada, hapus baris ini.
              // Jika null, tampilkan "-"
              value: (mutasi.keterangan != null && mutasi.keterangan!.isNotEmpty) 
                  ? mutasi.keterangan! 
                  : "-",
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk baris data
  Widget _buildItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk memilih icon berdasarkan jenis mutasi (Opsional)
  IconData _getIconByJenis(String jenis) {
    if (jenis.toLowerCase().contains("masuk")) return Icons.move_to_inbox;
    if (jenis.toLowerCase().contains("keluar")) return Icons.output_sharp;
    if (jenis.toLowerCase().contains("pindah")) return Icons.swap_horiz;
    return Icons.call_split;
  }
}