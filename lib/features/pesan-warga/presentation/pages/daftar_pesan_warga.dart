import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../domain/entities/pesan_warga.dart';
import '../../presentation/bloc/pesan_warga_bloc.dart';
import 'detail_pesan_warga.dart';
import 'tambah_pesan_warga.dart';

class DaftarPesanWarga extends StatefulWidget {
  const DaftarPesanWarga({super.key});

  @override
  State<DaftarPesanWarga> createState() => _DaftarPesanWargaState();
}

class _DaftarPesanWargaState extends State<DaftarPesanWarga> {
  bool _showFilter = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dariController = TextEditingController();
  final TextEditingController _sampaiController = TextEditingController();

  StatusAspirasi? appliedStatus;
  DateTime? appliedStartDate;
  DateTime? appliedEndDate;

  StatusAspirasi? tempStatus;
  DateTime? tempStart;
  DateTime? tempEnd;

  final dateFormat = DateFormat('dd/MM/yyyy');

  Color _getStatusColor(StatusAspirasi status) {
    switch (status) {
      case StatusAspirasi.Pending:
        return Colors.orange;
      case StatusAspirasi.Menunggu:
        return AppColors.primary;
      case StatusAspirasi.Diterima:
        return Colors.green;
      case StatusAspirasi.Ditolak:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Aspirasi> _applyFilter(List<Aspirasi> list) {
    return list.where((item) {
      final searchMatch = item.judul.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final statusMatch = appliedStatus == null || item.status == appliedStatus;
      final date = item.createdAt;
      final dateMatch = (appliedStartDate == null && appliedEndDate == null)
          ? true
          : (appliedStartDate != null &&
                    date.isAfter(
                      appliedStartDate!.subtract(const Duration(days: 1)),
                    )) &&
                (appliedEndDate != null &&
                    date.isBefore(
                      appliedEndDate!.add(const Duration(days: 1)),
                    ));
      return searchMatch && statusMatch && dateMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dariController.dispose();
    _sampaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aspirasi Warga',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_alt_off : Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showFilter = !_showFilter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context
                    .read<AspirasiBloc>(), 
                child: const TambahPesanWarga(), //TODO: disable buat admin ( fitur punya warga)
              ),
            ),
          );
        },
      ),
      body: Column(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showFilter
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Filter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _showFilter = false),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Cari berdasarkan judul...",
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<StatusAspirasi>(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                        value: tempStatus ?? appliedStatus,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Semua"),
                          ),
                          ...StatusAspirasi.values.map(
                            (s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)),
                          ),
                        ],
                        onChanged: (v) => setState(() => tempStatus = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _dariController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Dari Tanggal",
                                filled: true,
                                fillColor: AppColors.secondBackground,
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: tempStart ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    tempStart = picked;
                                    _dariController.text = dateFormat.format(
                                      picked,
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _sampaiController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Sampai Tanggal",
                                filled: true,
                                fillColor: AppColors.secondBackground,
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: tempEnd ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    tempEnd = picked;
                                    _sampaiController.text = dateFormat.format(
                                      picked,
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _dariController.clear();
                                _sampaiController.clear();
                                appliedStatus = null;
                                appliedStartDate = null;
                                appliedEndDate = null;
                                tempStatus = null;
                                tempStart = null;
                                tempEnd = null;
                              });
                            },
                            child: const Text("Reset Filter"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                appliedStatus = tempStatus;
                                appliedStartDate = tempStart;
                                appliedEndDate = tempEnd;
                              });
                            },
                            child: const Text("Terapkan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<AspirasiBloc, AspirasiState>(
              builder: (context, state) {
                if (state is AspirasiLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AspirasiLoaded) {
                  final filteredList = _applyFilter(state.aspirasiList);
                  if (filteredList.isEmpty) {
                    return const Center(child: Text("Belum ada aspirasi"));
                  }
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final data = filteredList[index];
                      final status = data.status ?? StatusAspirasi.Pending;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(data.judul),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pengirim: ${data.namaWarga ?? '-'}"), 
                              Text(
                                "Tanggal: ${data.createdAt.toString().split(' ')[0]}",
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status.name.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) async {
                                  if (value == 'detail') {
                                   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<AspirasiBloc>(),
                                          child: DetailPesanWarga(pesan: data),
                                        ),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Hapus Aspirasi"),
                                        content: const Text(
                                          "Apakah Anda yakin ingin menghapus aspirasi ini?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Hapus"),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      context.read<AspirasiBloc>().add(
                                        DeleteAspirasi(data.id!),
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Aspirasi berhasil dihapus!",
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'detail',
                                    child: Text("Detail"),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text("Hapus"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AspirasiOperationFailure) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}