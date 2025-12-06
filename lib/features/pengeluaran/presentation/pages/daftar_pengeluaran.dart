import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../features/pengeluaran/domain/entities/kategori_transaksi.dart';
import '../../../../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import '../../../../../features/pengeluaran/presentation/bloc/pengeluaran_state.dart';
import '../../../../core/theme/app_colors.dart';
import 'detail_pengeluaran.dart';
import 'edit_pengeluaran.dart';

class DaftarPengeluaran extends StatefulWidget {
  const DaftarPengeluaran({super.key});

  @override
  State<DaftarPengeluaran> createState() => _DaftarPengeluaranState();
}

class _DaftarPengeluaranState extends State<DaftarPengeluaran> {
  bool _showFilter = false;
  final TextEditingController _searchController = TextEditingController();
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String? _filterKategori;
  String? _filterKategoriTemp;
  String? _filterSearchTemp;
  DateTime? _filterDari;
  DateTime? _filterSampai;
  DateTime? _filterDariTemp;
  DateTime? _filterSampaiTemp;

  List<Pengeluaran> _allItems = [];
  List<KategoriEntity> _allKategori = [];

  @override
  void initState() {
    super.initState();
    context.read<PengeluaranBloc>().add(LoadPengeluaran());
    context.read<PengeluaranBloc>().add(LoadKategoriPengeluaran());
  }

  List<Pengeluaran> get filteredPengeluaran {
    return _allItems.where((item) {
      final searchMatch = item.judul.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );

      final kategoriMatch =
          _filterKategori == null || _filterKategori == '-- Pilih Kategori --'
          ? true
          : _allKategori
                    .firstWhere(
                      (k) => k.id == item.kategoriTransaksiId,
                      orElse: () => KategoriEntity(
                        id: 0,
                        nama_kategori: 'Lainnya',
                        jenis: 'Lainnya',
                      ),
                    )
                    .nama_kategori ==
                _filterKategori;

      final dariMatch = _filterDari == null
          ? true
          : item.tanggalTransaksi.isAfter(
              _filterDari!.subtract(const Duration(days: 1)),
            );
      final sampaiMatch = _filterSampai == null
          ? true
          : item.tanggalTransaksi.isBefore(
              _filterSampai!.add(const Duration(days: 1)),
            );

      return searchMatch && kategoriMatch && dariMatch && sampaiMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, 
        title: const Text(
          'Daftar Pengeluaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), 

        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_alt_off : Icons.filter_alt,
              color: Colors.white, 
            ),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTER PANEL
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showFilter
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() => _showFilter = false);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// SEARCH INPUT
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.secondBackground,
                        ),
                        onChanged: (v) => _filterSearchTemp = v,
                      ),
                      const SizedBox(height: 16),

                      /// DROPDOWN KATEGORI
                      BlocBuilder<PengeluaranBloc, PengeluaranState>(
                        builder: (context, state) {
                          final kategoriOptions = [
                            '-- Pilih Kategori --',
                            ..._allKategori
                                .map((k) => k.nama_kategori ?? 'Lainnya')
                                .toList(),
                          ];

                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.secondBackground,
                            ),
                            value: _filterKategori ?? '-- Pilih Kategori --',
                            items: kategoriOptions.map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => _filterKategoriTemp = v),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      /// TANGGAL RANGE
                     Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null)
                                  setState(() => _filterDariTemp = picked);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _filterDariTemp == null
                                      ? "Dari Tanggal"
                                      : DateFormat(
                                          "dd/MM/yyyy",
                                        ).format(_filterDariTemp!),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null)
                                  setState(() => _filterSampaiTemp = picked);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _filterSampaiTemp == null
                                      ? "Sampai Tanggal"
                                      : DateFormat(
                                          "dd/MM/yyyy",
                                        ).format(_filterSampaiTemp!),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
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
                                _filterKategori = '-- Pilih Kategori --';
                                _filterDari = null;
                                _filterSampai = null;
                                _filterSearchTemp = null;
                                _filterKategoriTemp = null;
                                _filterDariTemp = null;
                                _filterSampaiTemp = null;
                              });
                            },
                            child: const Text("Reset Filter"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filterKategori = _filterKategoriTemp;
                                _searchController.text =
                                    _filterSearchTemp ?? "";
                                _filterDari = _filterDariTemp;
                                _filterSampai = _filterSampaiTemp;
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
          // LIST AREA
          Expanded(
            child: BlocConsumer<PengeluaranBloc, PengeluaranState>(
              listener: (context, state) {
                if (state is PengeluaranError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is PengeluaranActionSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  context.read<PengeluaranBloc>().add(const LoadPengeluaran());
                } else if (state is PengeluaranLoaded) {
                  _allItems = state.items;
                  setState(() {});
                } else if (state is KategoriPengeluaranLoaded) {
                  _allKategori = state.kategori;
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is PengeluaranLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PengeluaranEmpty) {
                  return const Center(child: Text('Belum ada pengeluaran'));
                } else if (state is PengeluaranLoaded ||
                    state is PengeluaranActionSuccess) {
                  final list = filteredPengeluaran;

                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada data pengeluaran yang cocok',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final kategoriNama =
                          _allKategori
                              .firstWhere(
                                (k) => k.id == item.kategoriTransaksiId,
                                orElse: () => KategoriEntity(
                                  id: 0,
                                  nama_kategori: 'Lainnya',
                                  jenis: 'Lainnya',
                                ),
                              )
                              .nama_kategori ??
                          'Lainnya';
                      return Card(
                        child: ListTile(
                          title: Text(item.judul),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.tanggalTransaksi.day}/${item.tanggalTransaksi.month}/${item.tanggalTransaksi.year}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.category, size: 16),
                                  const SizedBox(width: 4),
                                  Text(kategoriNama),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatter.format(item.nominal),
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                             if (value == 'detail') {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPengeluaran(
                                      pengeluaran: item,
                                      kategoriList: _allKategori, 
                                    ),
                                  ),
                                );
                              } else if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<PengeluaranBloc>(),
                                      child: EditPengeluaranPage(
                                        pengeluaran: item,
                                        kategoriList:
                                            _allKategori, 
                                      ),
                                    ),
                                  ),
                                );
                              } else if (value == 'hapus') {
                                context.read<PengeluaranBloc>().add(
                                  DeletePengeluaranEvent(item.id!),
                                );
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'detail',
                                child: Text("Detail"),
                              ),
                              PopupMenuItem(value: 'edit', child: Text("Edit")),
                              PopupMenuItem(
                                value: 'hapus',
                                child: Text("Hapus"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              '/tambah-pengeluaran',
            );
            if (result == true) {
              context.read<PengeluaranBloc>().add(const LoadPengeluaran());
            }
          },
        ),
      ),
    );
  }
}