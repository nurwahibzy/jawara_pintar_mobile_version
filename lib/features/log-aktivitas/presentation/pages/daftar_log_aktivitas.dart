import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/injections/injection.dart';
// import '../../domain/entities/log_aktivitas.dart';
import '../bloc/log_aktivitas_bloc.dart';

class DaftarLogAktivitas extends StatefulWidget {
  const DaftarLogAktivitas({super.key});

  @override
  State<DaftarLogAktivitas> createState() => DaftarLogAktivitasState();
}

class DaftarLogAktivitasState extends State<DaftarLogAktivitas> {
  @override
  void initState() {
    super.initState();
    // Panggil event GetAll saat halaman dibuka untuk load data
    context.read<LogAktivitasBloc>().add(LogAktivitasEventGetAll());
  }

  IconData _getIconByJenis(String jenis) {
    if (jenis.toLowerCase().contains("insert")) return Icons.create;
    if (jenis.toLowerCase().contains("update")) return Icons.update;
    if (jenis.toLowerCase().contains("delete")) return Icons.delete;
    return Icons.select_all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Log Aktivitas'), elevation: 2),
      body: BlocBuilder<LogAktivitasBloc, LogAktivitasState>(
        builder: (context, state) {
          if (state is LogAktivitasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LogAktivitasError) {
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
                      context.read<LogAktivitasBloc>().add(
                        LogAktivitasEventGetAll(),
                      );
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (state is LogAktivitasLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Belum ada data log aktivitas"),
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
                final tanggalStr = item.changedAt.toLocal().toString().split(
                  ' ',
                )[0];

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
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // 1. Icon Avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              _getIconByJenis(item.action),
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 2. Konten Utama
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.role ?? 'User Tidak Dikenal'} melakukan ${item.action.toLowerCase()} data pada tabel ${item.tableName}' ,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
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
    );
  }
}
