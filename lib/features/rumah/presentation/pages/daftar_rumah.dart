import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/usecases/filter_rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/bloc/rumah_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/pages/tambah_rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/pages/edit_rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/pages/detail_rumah.dart';

class DaftarRumahPage extends StatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  State<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends State<DaftarRumahPage> {
  // State UI
  bool _showFilter = true;
  final TextEditingController _searchController = TextEditingController();

  // Filter Variables
  String? _filterStatus;

  // Temp variables for filter panel
  String? _filterStatusTemp;
  String? _filterSearchTemp;

  // Current applied filters
  FilterRumahParams? _currentFilter;

  @override
  void initState() {
    super.initState();
    context.read<RumahBloc>().add(LoadAllRumah());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to apply filters
  void _applyFilter() {
    setState(() {
      _filterStatus = _filterStatusTemp;
      if (_filterSearchTemp != null) {
        _searchController.text = _filterSearchTemp!;
      }
    });

    final params = FilterRumahParams(
      alamat: _searchController.text.isEmpty ? null : _searchController.text,
      status: _filterStatus == null || _filterStatus == '-- Pilih Status --'
          ? null
          : _filterStatus,
    );

    if (params.alamat != null || params.status != null) {
      context.read<RumahBloc>().add(FilterRumahEvent(params));
      _currentFilter = params;
    } else {
      context.read<RumahBloc>().add(LoadAllRumah());
      _currentFilter = null;
    }
  }

  // Method to reset all filters
  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _filterStatus = null;
      _filterStatusTemp = null;
      _filterSearchTemp = null;
      _currentFilter = null;
    });
    context.read<RumahBloc>().add(LoadAllRumah());
  }

  // Helper warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'kosong':
        return Colors.green.shade700;
      case 'dihuni':
        return Colors.blue.shade700;
      case 'disewakan':
        return Colors.orange.shade700;
      default:
        return Colors.grey;
    }
  }

  // Helper text status untuk display
  String _getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'kosong':
        return 'Tersedia';
      case 'dihuni':
        return 'Ditempati';
      case 'disewakan':
        return 'Disewakan';
      default:
        return status;
    }
  }

  // Widget untuk menampilkan status badge (card style)
  Widget _buildStatusBadgeCard(String label, String value, Color color) {
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

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, Rumah rumah) {
    if (!rumah.canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rumah hanya bisa dihapus jika statusnya Kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus rumah "${rumah.alamat}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RumahBloc>().add(DeleteRumahEvent(rumah.id));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Rumah',
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
      body: Column(
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
                            'Filter Rumah',
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

                      // Input Search Alamat
                      const Text(
                        'Alamat',
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
                            hintText: 'Cari alamat...',
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
                              borderSide: BorderSide(color: AppColors.primary),
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
                              borderSide: BorderSide(color: AppColors.primary),
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
                                'Kosong',
                                'Dihuni',
                                'Disewakan',
                              ].map((e) {
                                String displayText = e;
                                if (e == 'Kosong') displayText = 'Tersedia';
                                if (e == 'Dihuni') displayText = 'Ditempati';
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    displayText,
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
            child: BlocConsumer<RumahBloc, RumahState>(
              listener: (context, state) {
                if (state is RumahError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is RumahActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Refresh data with current filter
                  if (_currentFilter != null) {
                    context.read<RumahBloc>().add(
                      FilterRumahEvent(_currentFilter!),
                    );
                  } else {
                    context.read<RumahBloc>().add(LoadAllRumah());
                  }
                }
              },
              builder: (context, state) {
                if (state is RumahLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RumahEmpty) {
                  return const Center(child: Text('Belum ada data rumah'));
                } else if (state is RumahLoaded) {
                  final list = state.result;

                  if (list.isEmpty) {
                    return const Center(child: Text("Data tidak ditemukan"));
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
                              // Header dengan alamat dan menu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.home,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.alamat,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<RumahBloc>(
                                                  create: (_) => sl<RumahBloc>()
                                                    ..add(
                                                      GetDetailRumah(item.id),
                                                    ),
                                                  child: DetailRumahPage(
                                                    rumahId: item.id,
                                                  ),
                                                ),
                                          ),
                                        );
                                      } else if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<RumahBloc>(
                                                  create: (_) =>
                                                      sl<RumahBloc>(),
                                                  child: EditRumahPage(
                                                    rumah: item,
                                                  ),
                                                ),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            // Refresh data setelah edit
                                            if (_currentFilter != null) {
                                              context.read<RumahBloc>().add(
                                                FilterRumahEvent(
                                                  _currentFilter!,
                                                ),
                                              );
                                            } else {
                                              context.read<RumahBloc>().add(
                                                LoadAllRumah(),
                                              );
                                            }
                                          }
                                        });
                                      } else if (value == 'hapus') {
                                        _showDeleteConfirmation(context, item);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'detail',
                                        child: Text('Detail'),
                                      ),
                                      if (item.canDelete)
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                      if (item.canDelete)
                                        const PopupMenuItem(
                                          value: 'hapus',
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 8),
                              // Data Info
                              _buildDataRow("ID Rumah", item.id.toString()),
                              const SizedBox(height: 4),
                              _buildDataRow(
                                "Jumlah Penghuni",
                                item.riwayatPenghuni.isEmpty
                                    ? "Belum ada"
                                    : "${item.riwayatPenghuni.length} riwayat",
                              ),
                              const SizedBox(height: 8),
                              // Status Badge
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatusBadgeCard(
                                      "Status Rumah",
                                      _getStatusDisplay(item.statusRumah),
                                      _getStatusColor(item.statusRumah),
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
                }
                return const SizedBox.shrink();
              },
            ),
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
              builder: (_) => BlocProvider<RumahBloc>(
                create: (_) => sl<RumahBloc>(),
                child: const TambahRumahPage(),
              ),
            ),
          ).then((result) {
            if (result == true) {
              // Refresh data setelah tambah
              if (_currentFilter != null) {
                context.read<RumahBloc>().add(
                  FilterRumahEvent(_currentFilter!),
                );
              } else {
                context.read<RumahBloc>().add(LoadAllRumah());
              }
            }
          });
        },
      ),
    );
  }
}
