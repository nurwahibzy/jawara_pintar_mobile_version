import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/laporan_keuangan_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class PemasukanListPage extends StatefulWidget {
  const PemasukanListPage({super.key});

  @override
  State<PemasukanListPage> createState() => _PemasukanListPageState();
}

class _PemasukanListPageState extends State<PemasukanListPage> {
  String? selectedKategori;
  DateTime? tanggalMulai;
  DateTime? tanggalAkhir;
  List<Map<String, dynamic>> kategoriList = [];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<LaporanKeuanganBloc>().add(const LoadPemasukanListEvent());
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    try {
      final response = await Supabase.instance.client
          .from('kategori_transaksi')
          .select('id, nama_kategori')
          .eq('jenis', 'Pemasukan');

      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => _FilterDialog(
        selectedKategori: selectedKategori,
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        kategoriList: kategoriList,
        onApply: (kategori, mulai, akhir) {
          setState(() {
            selectedKategori = kategori;
            tanggalMulai = mulai;
            tanggalAkhir = akhir;
          });
          context.read<LaporanKeuanganBloc>().add(
            LoadPemasukanListEvent(
              kategori: kategori,
              tanggalMulai: mulai,
              tanggalAkhir: akhir,
            ),
          );
        },
        onReset: () {
          setState(() {
            selectedKategori = null;
            tanggalMulai = null;
            tanggalAkhir = null;
          });
          context.read<LaporanKeuanganBloc>().add(
            const LoadPemasukanListEvent(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy');

    return Column(
      children: [
        // Filter Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: Text(
                    _getFilterText(),
                    style: const TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: BlocBuilder<LaporanKeuanganBloc, LaporanKeuanganState>(
            builder: (context, state) {
              if (state is LaporanKeuanganLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is PemasukanListLoaded) {
                final pemasukanList = state.pemasukanList;

                if (pemasukanList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada data pemasukan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Calculate total
                final total = pemasukanList.fold<double>(
                  0,
                  (sum, item) => sum + item.nominal,
                );

                return Column(
                  children: [
                    // Total Summary
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF5BA3F5).withOpacity(0.1),
                            const Color(0xFF6B5CE7).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF6B5CE7).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pemasukan',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            currencyFormat.format(total),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B5CE7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pemasukanList.length,
                        itemBuilder: (context, index) {
                          final item = pemasukanList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF5BA3F5,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.trending_up,
                                        color: Color(0xFF5BA3F5),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.judul,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.kategori,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      currencyFormat.format(item.nominal),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5BA3F5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dateFormat.format(item.tanggalTransaksi),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.keterangan != null &&
                                    item.keterangan!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    item.keterangan!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is LaporanKeuanganError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 16,
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
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<LaporanKeuanganBloc>().add(
                            LoadPemasukanListEvent(
                              kategori: selectedKategori,
                              tanggalMulai: tanggalMulai,
                              tanggalAkhir: tanggalAkhir,
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Text(
                  'Pilih filter untuk menampilkan data',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getFilterText() {
    if (selectedKategori != null ||
        tanggalMulai != null ||
        tanggalAkhir != null) {
      return 'Filter Aktif';
    }
    return 'Filter Pemasukan';
  }
}

class _FilterDialog extends StatefulWidget {
  final String? selectedKategori;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;
  final Function(String?, DateTime?, DateTime?) onApply;
  final VoidCallback onReset;
  final List<Map<String, dynamic>> kategoriList;

  const _FilterDialog({
    this.selectedKategori,
    this.tanggalMulai,
    this.tanggalAkhir,
    required this.kategoriList,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  String? _selectedKategori;
  DateTime? _tanggalMulai;
  DateTime? _tanggalAkhir;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.selectedKategori;
    _tanggalMulai = widget.tanggalMulai;
    _tanggalAkhir = widget.tanggalAkhir;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_tanggalMulai ?? DateTime.now())
          : (_tanggalAkhir ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _tanggalMulai = picked;
        } else {
          _tanggalAkhir = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Pemasukan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kategori
            Text(
              'Kategori',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedKategori,
                hint: Text(
                  '-- Semua Kategori --',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                isExpanded: true,
                underline: const SizedBox(),
                items: widget.kategoriList.map((kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori['id'].toString(),
                    child: Text(
                      kategori['nama_kategori'] as String,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Mulai
            Text(
              'Dari Tanggal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tanggalMulai != null
                          ? dateFormat.format(_tanggalMulai!)
                          : '--/--/----',
                      style: TextStyle(
                        fontSize: 13,
                        color: _tanggalMulai != null
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Akhir
            Text(
              'Sampai Tanggal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tanggalAkhir != null
                          ? dateFormat.format(_tanggalAkhir!)
                          : '--/--/----',
                      style: TextStyle(
                        fontSize: 13,
                        color: _tanggalAkhir != null
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _selectedKategori,
                        _tanggalMulai,
                        _tanggalAkhir,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
