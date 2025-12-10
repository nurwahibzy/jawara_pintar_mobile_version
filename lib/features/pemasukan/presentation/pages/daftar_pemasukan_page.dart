import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/pemasukan.dart';
import '../bloc/pemasukan_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'form_pemasukan_page.dart';
import 'detail_pemasukan_page.dart';

class DaftarPemasukanPage extends StatefulWidget {
  const DaftarPemasukanPage({super.key});

  @override
  State<DaftarPemasukanPage> createState() => _DaftarPemasukanPageState();
}

class _DaftarPemasukanPageState extends State<DaftarPemasukanPage> {
  bool _showFilter = false;
  String? _filterKategori;
  String? _filterKategoriTemp;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    context.read<PemasukanBloc>().add(const GetPemasukanListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Daftar Pemasukan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
                if (!_showFilter) {
                  _filterKategoriTemp = _filterKategori;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilter) _buildFilterSection(theme),
          Expanded(
            child: BlocConsumer<PemasukanBloc, PemasukanState>(
              listener: (context, state) {
                if (state is PemasukanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is PemasukanActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<PemasukanBloc>().add(
                    GetPemasukanListEvent(kategoriFilter: _filterKategori),
                  );
                }
              },
              builder: (context, state) {
                if (state is PemasukanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PemasukanListLoaded) {
                  final pemasukanList = state.pemasukanList;

                  if (pemasukanList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada data pemasukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<PemasukanBloc>().add(
                        GetPemasukanListEvent(kategoriFilter: _filterKategori),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pemasukanList.length,
                      itemBuilder: (context, index) {
                        final pemasukan = pemasukanList[index];
                        return _buildPemasukanCard(pemasukan, theme);
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Gagal memuat data'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => BlocProvider.value(
                value: BlocProvider.of<PemasukanBloc>(context),
                child: const FormPemasukanPage(),
              ),
            ),
          );
          if (mounted) {
            context.read<PemasukanBloc>().add(
              GetPemasukanListEvent(kategoriFilter: _filterKategori),
            );
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Kategori',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Semua'),
                selected: _filterKategoriTemp == null,
                onSelected: (selected) {
                  setState(() => _filterKategoriTemp = null);
                },
              ),
              ChoiceChip(
                label: const Text('Sumbangan Warga'),
                selected: _filterKategoriTemp == '1',
                onSelected: (selected) {
                  setState(() => _filterKategoriTemp = selected ? '1' : null);
                },
              ),
              ChoiceChip(
                label: const Text('Donasi'),
                selected: _filterKategoriTemp == '2',
                onSelected: (selected) {
                  setState(() => _filterKategoriTemp = selected ? '2' : null);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filterKategori = _filterKategoriTemp;
                      _showFilter = false;
                    });
                    context.read<PemasukanBloc>().add(
                      GetPemasukanListEvent(kategoriFilter: _filterKategori),
                    );
                  },
                  child: const Text('Terapkan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _filterKategori = null;
                      _filterKategoriTemp = null;
                      _showFilter = false;
                    });
                    context.read<PemasukanBloc>().add(
                      const GetPemasukanListEvent(),
                    );
                  },
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPemasukanCard(Pemasukan pemasukan, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => BlocProvider.value(
                value: BlocProvider.of<PemasukanBloc>(context),
                child: DetailPemasukanPage(pemasukanId: pemasukan.id),
              ),
            ),
          );
          if (mounted) {
            context.read<PemasukanBloc>().add(
              GetPemasukanListEvent(kategoriFilter: _filterKategori),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pemasukan.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pemasukan.namaKategori ?? '-',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    pemasukan.tanggalTransaksi,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pemasukan.keterangan,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatter.format(pemasukan.nominal),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
