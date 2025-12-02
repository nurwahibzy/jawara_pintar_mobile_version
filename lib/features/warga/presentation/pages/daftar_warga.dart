import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/tambah_warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/detail_warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/edit_warga.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  // State UI
  bool _showFilter = true;
  final TextEditingController _searchController = TextEditingController();

  // Filter Variables
  String? _filterJenisKelamin; // Dropdown Jenis Kelamin
  String? _filterStatus; // Dropdown Status Hidup
  String? _filterKeluarga; // Dropdown Status Keluarga

  // Temp variables for filter panel
  String? _filterJenisKelaminTemp;
  String? _filterStatusTemp;
  String? _filterKeluargaTemp;
  String? _filterSearchTemp;

  // Current applied filters
  FilterWargaParams? _currentFilter;

  @override
  void initState() {
    super.initState();
    context.read<WargaBloc>().add(LoadWarga());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to apply filters
  void _applyFilter() {
    final params = FilterWargaParams(
      nama: _searchController.text.isEmpty ? null : _searchController.text,
      jenisKelamin:
          _filterJenisKelamin == null ||
              _filterJenisKelamin == '-- Pilih Jenis Kelamin --'
          ? null
          : _filterJenisKelamin,
      status: _filterStatus == null || _filterStatus == '-- Pilih Status --'
          ? null
          : _filterStatus,
      keluarga:
          _filterKeluarga == null || _filterKeluarga == '-- Pilih Keluarga --'
          ? null
          : _filterKeluarga,
    );

    if (params.nama != null ||
        params.jenisKelamin != null ||
        params.status != null ||
        params.keluarga != null) {
      context.read<WargaBloc>().add(FilterWargaEvent(params));
      _currentFilter = params;
    } else {
      context.read<WargaBloc>().add(LoadWarga());
      _currentFilter = null;
    }
  }

  // Method to reset all filters
  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _filterJenisKelamin = null;
      _filterStatus = null;
      _filterKeluarga = null;
      _filterJenisKelaminTemp = null;
      _filterStatusTemp = null;
      _filterKeluargaTemp = null;
      _filterSearchTemp = null;
      _currentFilter = null;
    });
    context.read<WargaBloc>().add(LoadWarga());
  }

  // Helper warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hidup':
      case 'Aktif':
        return Colors.green.shade700;
      case 'Meninggal':
      case 'Pindah':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // Helper untuk nama lengkap jenis kelamin
  String _getJenisKelaminFull(String jenisKelamin) {
    if (jenisKelamin.toLowerCase().startsWith('l')) {
      return 'Laki-laki';
    } else if (jenisKelamin.toLowerCase().startsWith('p')) {
      return 'Perempuan';
    }
    return '-';
  }

  // Helper warna untuk status domisili
  Color _getDomisiliColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'aktif':
        return Colors.blue.shade700;
      case 'nonaktif':
        return Colors.red.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  // Widget untuk menampilkan data row
  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
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

  // Widget untuk membuat dropdown
  Widget _buildCompactDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    Color? fillColor,
  ) {
    return SizedBox(
      height: 36,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        value: value,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        items: items.map((e) {
          String displayText = e;
          if (label == 'Jenis Kelamin') {
            displayText = e == 'L'
                ? 'Laki-laki'
                : e == 'P'
                ? 'Perempuan'
                : e;
          }
          return DropdownMenuItem(
            value: e,
            child: Text(displayText, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        onChanged: onChanged,
        isDense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Warga',
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
          // --- FILTER PANEL (AnimatedCrossFade) ---
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
                            'Filter Data',
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
                      const SizedBox(height: 8),

                      // Input Search Nama
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Cari nama warga...',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: const Icon(Icons.search, size: 18),
                            filled: true,
                            fillColor: AppColors.secondBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (v) => _filterSearchTemp = v,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Compact filter row layout
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactDropdown(
                              'Jenis Kelamin',
                              _filterJenisKelamin ?? 'Semua',
                              ['Semua', 'L', 'P'],
                              (v) => _filterJenisKelaminTemp = v == 'Semua'
                                  ? null
                                  : v,
                              AppColors.secondBackground,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCompactDropdown(
                              'Status Hidup',
                              _filterStatus ?? 'Semua',
                              ['Semua', 'Hidup', 'Meninggal'],
                              (v) =>
                                  _filterStatusTemp = v == 'Semua' ? null : v,
                              AppColors.secondBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildCompactDropdown(
                        'Status Keluarga',
                        _filterKeluarga ?? 'Semua',
                        [
                          'Semua',
                          'Kepala Keluarga',
                          'Famili Lain',
                          'Istri',
                          'Anak',
                        ],
                        (v) => _filterKeluargaTemp = v == 'Semua' ? null : v,
                        AppColors.secondBackground,
                      ),
                      const SizedBox(height: 12),

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
                            onPressed: () {
                              setState(() {
                                _filterJenisKelamin = _filterJenisKelaminTemp;
                                _filterStatus = _filterStatusTemp;
                                _filterKeluarga = _filterKeluargaTemp;
                                _searchController.text =
                                    _filterSearchTemp ?? "";
                              });
                              _applyFilter();
                            },
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
                if (state is WargaError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is WargaActionSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  // Refresh data with current filter
                  if (_currentFilter != null) {
                    context.read<WargaBloc>().add(
                      FilterWargaEvent(_currentFilter!),
                    );
                  } else {
                    context.read<WargaBloc>().add(LoadWarga());
                  }
                }
              },
              builder: (context, state) {
                if (state is WargaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WargaEmpty) {
                  return const Center(child: Text('Belum ada data warga'));
                } else if (state is WargaLoaded) {
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
                              // Header dengan nama dan menu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.nama,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<WargaBloc>(
                                                  create: (_) =>
                                                      sl<WargaBloc>(),
                                                  child: EditWargaPage(
                                                    warga: item,
                                                  ),
                                                ),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            // Refresh data setelah edit
                                            if (_currentFilter != null) {
                                              context.read<WargaBloc>().add(
                                                FilterWargaEvent(
                                                  _currentFilter!,
                                                ),
                                              );
                                            } else {
                                              context.read<WargaBloc>().add(
                                                LoadWarga(),
                                              );
                                            }
                                          }
                                        });
                                      } else if (value == 'detail') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<WargaBloc>(
                                                  create: (_) =>
                                                      sl<WargaBloc>(),
                                                  child: DetailWargaPage(
                                                    warga: item,
                                                  ),
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
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
                              _buildDataRow("NIK", item.nik),
                              const SizedBox(height: 4),
                              _buildDataRow("Keluarga", item.statusKeluarga),
                              const SizedBox(height: 4),
                              _buildDataRow(
                                "Jenis Kelamin",
                                _getJenisKelaminFull(item.jenisKelamin),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatusBadge(
                                      "Status  Domisili",
                                      item.statusPenduduk ?? "-",
                                      _getDomisiliColor(item.statusPenduduk),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatusBadge(
                                      "Status Hidup",
                                      item.statusHidup,
                                      _getStatusColor(item.statusHidup),
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
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<WargaBloc>(
                create: (_) => sl<WargaBloc>(),
                child:
                    const WargaFormPage(), // Create mode - keluarga akan dipilih di form
              ),
            ),
          );
        },
      ),
    );
  }
}
