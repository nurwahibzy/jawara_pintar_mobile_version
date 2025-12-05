import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc/laporan_keuangan_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class CetakLaporanPage extends StatefulWidget {
  const CetakLaporanPage({super.key});

  @override
  State<CetakLaporanPage> createState() => _CetakLaporanPageState();
}

class _CetakLaporanPageState extends State<CetakLaporanPage> {
  DateTime? tanggalMulai;
  DateTime? tanggalAkhir;
  String jenisLaporan = 'semua';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (tanggalMulai ?? DateTime.now())
          : (tanggalAkhir ?? DateTime.now()),
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
          tanggalMulai = picked;
        } else {
          tanggalAkhir = picked;
        }
      });
    }
  }

  void _loadLaporan() {
    if (tanggalMulai == null || tanggalAkhir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal mulai dan tanggal akhir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<LaporanKeuanganBloc>().add(
      LoadLaporanSummaryEvent(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: jenisLaporan,
      ),
    );
  }

  Future<void> _sharePdf(File pdfFile) async {
    try {
      await Share.shareXFiles([XFile(pdfFile.path)], text: 'Laporan Keuangan');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal share PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadPdf(File pdfFile) async {
    try {
      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final fileName =
            'laporan_keuangan_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final newPath = '${directory.path}/$fileName';
        await pdfFile.copy(newPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF disimpan ke ${directory.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal download PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return BlocConsumer<LaporanKeuanganBloc, LaporanKeuanganState>(
      listener: (context, state) {
        if (state is PdfGenerated) {
          // Show options dialog after PDF generated
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('PDF Berhasil Dibuat'),
              content: const Text('Pilih aksi untuk PDF yang telah dibuat'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Tutup'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _downloadPdf(state.pdfFile);
                  },
                  child: const Text('Download'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _sharePdf(state.pdfFile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Share'),
                ),
              ],
            ),
          );
        } else if (state is LaporanKeuanganError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jenis Laporan
              Text(
                'Jenis Laporan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text(
                        'Semua',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: 'semua',
                      groupValue: jenisLaporan,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          jenisLaporan = value!;
                        });
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    RadioListTile<String>(
                      title: const Text(
                        'Pemasukan Saja',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: 'pemasukan',
                      groupValue: jenisLaporan,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          jenisLaporan = value!;
                        });
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    RadioListTile<String>(
                      title: const Text(
                        'Pengeluaran Saja',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: 'pengeluaran',
                      groupValue: jenisLaporan,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          jenisLaporan = value!;
                        });
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tanggal Mulai
              Text(
                'Tanggal Mulai',
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
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tanggalMulai != null
                            ? dateFormat.format(tanggalMulai!)
                            : '--/--/----',
                        style: TextStyle(
                          fontSize: 13,
                          color: tanggalMulai != null
                              ? Colors.grey[800]
                              : Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Akhir
              Text(
                'Tanggal Akhir',
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
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tanggalAkhir != null
                            ? dateFormat.format(tanggalAkhir!)
                            : '--/--/----',
                        style: TextStyle(
                          fontSize: 13,
                          color: tanggalAkhir != null
                              ? Colors.grey[800]
                              : Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preview Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      state is LaporanKeuanganLoading || state is PdfGenerating
                      ? null
                      : _loadLaporan,
                  icon: state is LaporanKeuanganLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search, size: 20),
                  label: Text(
                    state is LaporanKeuanganLoading
                        ? 'Memuat...'
                        : 'Lihat Preview',
                    style: const TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preview Summary
              if (state is LaporanSummaryLoaded) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Preview Laporan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Total Pemasukan',
                        currencyFormat.format(state.laporan.totalPemasukan),
                        const Color(0xFF5BA3F5),
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Total Pengeluaran',
                        currencyFormat.format(state.laporan.totalPengeluaran),
                        const Color(0xFFEB5B9D),
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Saldo',
                        currencyFormat.format(state.laporan.saldo),
                        state.laporan.saldo >= 0
                            ? AppColors.primary
                            : Colors.red,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${state.laporan.pemasukanList.length} pemasukan, ${state.laporan.pengeluaranList.length} pengeluaran',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Generate PDF Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state is PdfGenerating
                        ? null
                        : () {
                            context.read<LaporanKeuanganBloc>().add(
                              const GeneratePdfEvent(),
                            );
                          },
                    icon: state is PdfGenerating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.picture_as_pdf, size: 20),
                    label: Text(
                      state is PdfGenerating
                          ? 'Membuat PDF...'
                          : 'Download PDF',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
