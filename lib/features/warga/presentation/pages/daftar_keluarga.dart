import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/detail_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/form_keluarga_page.dart';

class DaftarKeluargaPage extends StatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  State<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends State<DaftarKeluargaPage> {
  // State UI
  bool _showFilter = true;
  final TextEditingController _searchController = TextEditingController();

  // Filter Variables
  String? _filterStatus;
  int? _filterRumahId;
  String? _filterRumahAlamat;

  // Temp variables for filter panel
  String? _filterStatusTemp;
  int? _filterRumahIdTemp;
  String? _filterRumahAlamatTemp;
  String? _filterSearchTemp;

  // Rumah dropdown data
  List<Map<String, dynamic>> _rumahList = [];
  bool _isLoadingRumah = false;

  // Full keluarga data
  List<Keluarga> _allKeluarga = [];

  @override
  void initState() {
    super.initState();
    context.read<WargaBloc>().add(LoadAllKeluargaWithRelations());
    _loadRumahData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load rumah data for dropdown
  Future<void> _loadRumahData() async {
    setState(() => _isLoadingRumah = true);
    try {
      final bloc = context.read<WargaBloc>();
      bloc.add(LoadRumahEvent());
    } catch (_) {
      setState(() => _isLoadingRumah = false);
    }
  }

  // Filter data locally
  List<Keluarga> _filterData(List<Keluarga> list) {
    return list.where((k) {
      // Filter by nama (search)
      if (_searchController.text.isNotEmpty) {
        final searchLower = _searchController.text.toLowerCase();
        final namaMatch = k.namaKeluarga.toLowerCase().contains(searchLower);
        final kkMatch = k.nomorKk.toLowerCase().contains(searchLower);
        if (!namaMatch && !kkMatch) return false;
      }

      // Filter by status
      if (_filterStatus != null && _filterStatus != '-- Pilih Status --') {
        if (k.statusHunian != _filterStatus) return false;
      }

      // Filter by rumah
      if (_filterRumahId != null) {
        if (k.rumahId != _filterRumahId) return false;
      }

      return true;
    }).toList();
  }

  // Reset all filters
  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _filterStatus = null;
      _filterRumahId = null;
      _filterRumahAlamat = null;
      _filterStatusTemp = null;
      _filterRumahIdTemp = null;
      _filterRumahAlamatTemp = null;
      _filterSearchTemp = null;
    });
  }

  // Apply filters
  void _applyFilter() {
    setState(() {
      _filterStatus = _filterStatusTemp;
      _filterRumahId = _filterRumahIdTemp;
      _filterRumahAlamat = _filterRumahAlamatTemp;
      if (_filterSearchTemp != null) {
        _searchController.text = _filterSearchTemp!;
      }
    });
  }

  // Helper warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'hidup':
        return Colors.green.shade700;
      case 'pindah internal':
        return Colors.orange.shade700;
      case 'keluar wilayah':
      case 'meninggal':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // Widget untuk menampilkan data row
  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan status badge
  Widget _buildStatusBadge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 0.5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Show rumah search dialog
  void _showRumahSearchDialog() {
    final TextEditingController searchRumahController = TextEditingController();
    List<Map<String, dynamic>> filteredRumah = List.from(_rumahList);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pilih Rumah'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchRumahController,
                      decoration: InputDecoration(
                        hintText: 'Cari alamat rumah...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: AppColors.secondBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value.isEmpty) {
                            filteredRumah = List.from(_rumahList);
                          } else {
                            filteredRumah = _rumahList
                                .where(
                                  (r) => (r['alamat'] as String)
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredRumah.isEmpty
                          ? const Center(child: Text('Tidak ada rumah'))
                          : ListView.separated(
                              itemCount: filteredRumah.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final rumah = filteredRumah[index];
                                return ListTile(
                                  title: Text(
                                    rumah['alamat'] ?? '-',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _filterRumahIdTemp = rumah['id'] as int;
                                      _filterRumahAlamatTemp =
                                          rumah['alamat'] as String;
                                    });
                                    Navigator.pop(dialogContext);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filterRumahIdTemp = null;
                      _filterRumahAlamatTemp = null;
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showFilter ? Icons.filter_alt_off : Icons.filter_alt),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<WargaBloc, WargaState>(
            listener: (context, state) {
              if (state is RumahListLoaded) {
                setState(() {
                  _rumahList = state.rumahList;
                  _isLoadingRumah = false;
                });
              } else if (state is RumahError) {
                setState(() => _isLoadingRumah = false);
              } else if (state is KeluargaListLoaded) {
                setState(() {
                  _allKeluarga = state.keluargaList;
                });
              }
            },
          ),
        ],
        child: Column(
          children: [
            // --- FILTER PANEL ---
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _showFilter
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Card(
                  color: AppColors.background,
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Filter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter Keluarga',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _showFilter = false),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Input Search Nama
                        const Text(
                          'Nama',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Cari nama...',
                              hintStyle: const TextStyle(fontSize: 13),
                              filled: true,
                              fillColor: AppColors.secondBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            onChanged: (v) => _filterSearchTemp = v,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dropdown Status
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 44,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.secondBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            initialValue: _filterStatusTemp ?? '-- Pilih Status --',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            items:
                                [
                                  '-- Pilih Status --',
                                  'Aktif',
                                  'Pindah Internal',
                                  'Keluar Wilayah',
                                ].map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (v) {
                              setState(() {
                                _filterStatusTemp = v == '-- Pilih Status --'
                                    ? null
                                    : v;
                              });
                            },
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dropdown Rumah (searchable)
                        const Text(
                          'Rumah',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: _isLoadingRumah
                              ? null
                              : _showRumahSearchDialog,
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.secondBackground,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _filterRumahAlamatTemp ??
                                        '-- Pilih Rumah --',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _filterRumahAlamatTemp != null
                                          ? Colors.black87
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                _isLoadingRumah
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tombol Reset & Terapkan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _resetFilter,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: _applyFilter,
                              child: const Text(
                                "Terapkan",
                                style: TextStyle(fontSize: 13),
                              ),
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

            // --- LIST AREA ---
            Expanded(
              child: BlocConsumer<WargaBloc, WargaState>(
                listener: (context, state) {
                  if (state is KeluargaError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is KeluargaListLoaded) {
                    setState(() {
                      _allKeluarga = state.keluargaList;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is KeluargaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = _filterData(_allKeluarga);

                  if (_allKeluarga.isEmpty) {
                    return const Center(child: Text('Belum ada data keluarga'));
                  }

                  if (list.isEmpty) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Card(
                        color: AppColors.background,
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header dengan nama dan menu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.namaKeluarga,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<WargaBloc>(
                                                  create: (_) =>
                                                      sl<WargaBloc>(),
                                                  child: DetailKeluargaPage(
                                                    keluarga: item,
                                                  ),
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'detail',
                                        child: Text('Detail'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Data Grid
                              _buildDataRow(
                                'Kepala Keluarga',
                                item.namaKepalaKeluarga,
                              ),
                              const SizedBox(height: 4),
                              _buildDataRow('Alamat Rumah', item.alamatRumah),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatusBadge(
                                      "Status Kepemilikan",
                                      item.statusKepemilikan,
                                      Colors.blue.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatusBadge(
                                      "Status Penduduk",
                                      item.statusPenduduk,
                                      _getStatusColor(item.statusPenduduk),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: ctx.read<WargaBloc>(),
                    child: const FormKeluargaPage(),
                  ),
                ),
              );
              if (result == true && mounted) {
                ctx.read<WargaBloc>().add(LoadAllKeluargaWithRelations());
              }
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
