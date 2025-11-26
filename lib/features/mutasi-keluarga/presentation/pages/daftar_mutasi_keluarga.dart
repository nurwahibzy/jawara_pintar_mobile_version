import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/mutasi_keluarga.dart';
import '../../injection.dart';
import '../bloc/mutasi_keluarga_bloc.dart';
import 'detail_mutasi_keluarga.dart';
import 'tambah_mutasi_keluarga.dart';

class DaftarMutasiKeluarga extends StatefulWidget {
  const DaftarMutasiKeluarga({super.key});

  @override
  State<DaftarMutasiKeluarga> createState() => DaftarMutasiKeluargaState();
}

class DaftarMutasiKeluargaState extends State<DaftarMutasiKeluarga> {
  @override
  void initState() {
    super.initState();
    // Panggil event GetAll saat halaman dibuka untuk load data
    context.read<MutasiKeluargaBloc>().add(MutasiKeluargaEventGetAll());
  }

  void _navigasiKeDetail(MutasiKeluarga data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailMutasiKeluarga(mutasi: data),
      ),
    );
  }

  // Navigasi ke Form Tambah dengan Bloc Baru
  void _navigasiKeTambah() async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => myInjection<MutasiKeluargaBloc>(),
          child: const TambahMutasiKeluarga(),
        ),
      ),
    );

    // Refresh list jika berhasil tambah data
    if (result == true && mounted) {
      context.read<MutasiKeluargaBloc>().add(MutasiKeluargaEventGetAll());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mutasi Keluarga'), elevation: 2),
      body: BlocBuilder<MutasiKeluargaBloc, MutasiKeluargaState>(
        builder: (context, state) {
          if (state is MutasiKeluargaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MutasiKeluargaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MutasiKeluargaBloc>().add(
                        MutasiKeluargaEventGetAll(),
                      );
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (state is MutasiKeluargaLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Belum ada data mutasi"),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];

                // Format Tanggal Sederhana (YYYY-MM-DD)
                final tanggalStr = item.tanggalMutasi
                    .toLocal()
                    .toString()
                    .split(' ')[0];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _navigasiKeDetail(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // 1. Icon Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.family_restroom,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 2. Konten Utama
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NAMA KEPALA KELUARGA
                                Text(
                                  // Gunakan field namaKepalaKeluarga dari Entity
                                  item.namaKepalaKeluarga ??
                                      "Keluarga #${item.keluargaId}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                const SizedBox(height: 6),

                                // ALUR PERPINDAHAN (ASAL -> TUJUAN)
                                Row(
                                  children: [
                                    Icon(
                                      _getIconByJenis(item.jenisMutasi),
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.jenisMutasi,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 3. Tanggal (Trailing)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tanggalStr,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigasiKeTambah,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconByJenis(String jenis) {
    if (jenis.toLowerCase().contains("masuk")) return Icons.move_to_inbox;
    if (jenis.toLowerCase().contains("keluar")) return Icons.output_sharp;
    if (jenis.toLowerCase().contains("pindah")) return Icons.swap_horiz;
    return Icons.call_split;
  }
}
