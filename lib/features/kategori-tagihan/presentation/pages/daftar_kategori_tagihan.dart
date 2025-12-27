import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injections/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/master_iuran.dart';
import '../bloc/master_iuran_bloc.dart';
import '../bloc/master_iuran_event.dart';
import '../bloc/master_iuran_state.dart';
import 'tambah_kategori_tagihan.dart';
import 'edit_kategori_tagihan.dart';
import 'detail_kategori_tagihan.dart';

class DaftarKategoriTagihanPage extends StatelessWidget {
  const DaftarKategoriTagihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MasterIuranBloc>()..add(const LoadMasterIuranList()),
      child: const _DaftarKategoriTagihanContent(),
    );
  }
}

class _DaftarKategoriTagihanContent extends StatefulWidget {
  const _DaftarKategoriTagihanContent();

  @override
  State<_DaftarKategoriTagihanContent> createState() =>
      _DaftarKategoriTagihanContentState();
}

class _DaftarKategoriTagihanContentState
    extends State<_DaftarKategoriTagihanContent> {
  bool _showFilter = true;
  final TextEditingController _searchController = TextEditingController();
  String? _filterKategori;
  String? _filterKategoriTemp;
  List<MasterIuran> _filteredList = [];

  @override
  void initState() {
    super.initState();
    // Event sudah dipanggil di BlocProvider
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter(List<MasterIuran> allData) {
    setState(() {
      _filterKategori = _filterKategoriTemp;
      _filteredList = allData.where((item) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchSearch =
            searchQuery.isEmpty ||
            item.namaIuran.toLowerCase().contains(searchQuery);
        final matchKategori =
            _filterKategori == null ||
            _filterKategori == '-- Pilih Kategori --' ||
            item.kategoriIuran?.namaKategori == _filterKategori;
        return matchSearch && matchKategori;
      }).toList();
    });
  }

  void _resetFilter(List<MasterIuran> allData) {
    setState(() {
      _searchController.clear();
      _filterKategori = null;
      _filterKategoriTemp = null;
      _filteredList = allData;
    });
  }

  Color _getStatusColor(bool isActive) {
    return isActive ? Colors.green.shade700 : Colors.red.shade700;
  }

  String _getStatusDisplay(bool isActive) {
    return isActive ? 'Aktif' : 'Tidak Aktif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Daftar Kategori Tagihan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilter ? Icons.filter_list_off : Icons.filter_list),
            tooltip: _showFilter ? 'Sembunyikan Filter' : 'Tampilkan Filter',
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl<MasterIuranBloc>(),
                child: const TambahKategoriTagihanPage(),
              ),
            ),
          );
          if (result == true && mounted) {
            context.read<MasterIuranBloc>().add(const RefreshMasterIuranList());
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<MasterIuranBloc, MasterIuranState>(
        listener: (context, state) {
          if (state is MasterIuranActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MasterIuranBloc>().add(const LoadMasterIuranList());
          } else if (state is MasterIuranError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MasterIuranLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MasterIuranError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MasterIuranBloc>().add(
                        const LoadMasterIuranList(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is MasterIuranEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data iuran',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          } else if (state is MasterIuranLoaded) {
            final allData = state.masterIuranList;
            if (_filteredList.isEmpty && _searchController.text.isEmpty) {
              _filteredList = allData;
            }

            // Get unique categories
            final categories = allData
                .map((e) => e.kategoriIuran?.namaKategori ?? '-')
                .toSet()
                .toList();

            return Column(
              children: [
                // Filter Panel
                if (_showFilter)
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Filter Data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Cari Nama Iuran',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _filterKategoriTemp,
                          decoration: InputDecoration(
                            labelText: 'Kategori',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: '-- Pilih Kategori --',
                              child: Text('-- Pilih Kategori --'),
                            ),
                            ...categories.map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _filterKategoriTemp = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _applyFilter(allData),
                                icon: const Icon(Icons.check, size: 18),
                                label: const Text('Terapkan'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _resetFilter(allData),
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Reset'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Data Table
                Expanded(
                  child: _filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada data yang sesuai',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          key: const Key('list_kategori_tagihan'),
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final masterIuran = _filteredList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) =>
                                            sl<MasterIuranBloc>()..add(
                                              LoadMasterIuranById(
                                                masterIuran.id,
                                              ),
                                            ),
                                        child: DetailKategoriTagihanPage(
                                          masterIuranId: masterIuran.id,
                                        ),
                                      ),
                                    ),
                                  );
                                  if (result == true && mounted) {
                                    context.read<MasterIuranBloc>().add(
                                      const RefreshMasterIuranList(),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      // Number Badge
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              masterIuran.namaIuran,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              masterIuran.jenisKategori,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              masterIuran.formattedNominal,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Status & Actions
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                masterIuran.isActive,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: _getStatusColor(
                                                  masterIuran.isActive,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Text(
                                              _getStatusDisplay(
                                                masterIuran.isActive,
                                              ),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: _getStatusColor(
                                                  masterIuran.isActive,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                        create: (context) =>
                                                            sl<
                                                              MasterIuranBloc
                                                            >(),
                                                        child:
                                                            EditKategoriTagihanPage(
                                                              masterIuran:
                                                                  masterIuran,
                                                            ),
                                                      ),
                                                ),
                                              );
                                              if (result == true && mounted) {
                                                context.read<MasterIuranBloc>().add(
                                                  const RefreshMasterIuranList(),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
