import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/cetak_laporan_bloc.dart';
import '../bloc/cetak_laporan_event.dart';
import '../bloc/cetak_laporan_state.dart';

class CetakLaporanPage extends StatefulWidget {
  const CetakLaporanPage({super.key});

  @override
  State<CetakLaporanPage> createState() => _CetakLaporanPageState();
}

class _CetakLaporanPageState extends State<CetakLaporanPage> {
  DateTime? tanggalMulai;
  DateTime? tanggalAkhir;
  String jenisLaporan = 'semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Laporan Keuangan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CetakLaporanBloc, CetakLaporanState>(
        listener: (context, state) {
          if (state is CetakLaporanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PdfGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF berhasil dibuat: ${state.pdfFile.path}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is PdfShared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF berhasil dibagikan'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilterSection(),
                const SizedBox(height: 24),
                _buildActionButtons(context, state),
                const SizedBox(height: 24),
                if (state is CetakLaporanLoading) _buildLoadingSection(),
                if (state is LaporanDataLoaded) _buildPreviewSection(state),
                if (state is PdfGenerating) _buildGeneratingSection(),
                if (state is PdfGenerated) _buildPdfGeneratedSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    final formatDate = DateFormat('dd MMMM yyyy');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Laporan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // Jenis Laporan
            Text(
              'Jenis Laporan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                key: const Key('dropdown_jenis_laporan'),
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
                      onChanged: (value) =>
                          setState(() => jenisLaporan = value!),
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
                      onChanged: (value) =>
                          setState(() => jenisLaporan = value!),
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
                      onChanged: (value) =>
                          setState(() => jenisLaporan = value!),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

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
              key: const Key('input_tanggal_mulai'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: tanggalMulai ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => tanggalMulai = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tanggalMulai != null
                          ? formatDate.format(tanggalMulai!)
                          : 'Pilih tanggal mulai',
                      style: TextStyle(
                        fontSize: 13,
                        color: tanggalMulai != null
                            ? Colors.black
                            : Colors.grey,
                      ),
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
              key: const Key('input_tanggal_akhir'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: tanggalAkhir ?? DateTime.now(),
                  firstDate: tanggalMulai ?? DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => tanggalAkhir = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tanggalAkhir != null
                          ? formatDate.format(tanggalAkhir!)
                          : 'Pilih tanggal akhir',
                      style: TextStyle(
                        fontSize: 13,
                        color: tanggalAkhir != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CetakLaporanState state) {
    final canLoad = tanggalMulai != null && tanggalAkhir != null;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            key: const Key('btn_submit_cetak'),
            onPressed: canLoad && state is! CetakLaporanLoading
                ? () {
                    context.read<CetakLaporanBloc>().add(
                      LoadLaporanDataEvent(
                        tanggalMulai: tanggalMulai!,
                        tanggalAkhir: tanggalAkhir!,
                        jenisLaporan: jenisLaporan,
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.visibility),
            label: const Text('Lihat Preview'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (state is LaporanDataLoaded || state is PdfGenerated) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('btn_generate_pdf'),
              onPressed: state is! PdfGenerating
                  ? () {
                      context.read<CetakLaporanBloc>().add(
                        const GeneratePdfEvent(),
                      );
                    }
                  : null,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (state is PdfGenerated) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<CetakLaporanBloc>().add(const SharePdfEvent());
              },
              icon: const Icon(Icons.share),
              label: const Text('Bagikan PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data laporan...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(LaporanDataLoaded state) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview Laporan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              'Total Pemasukan',
              formatCurrency.format(state.laporan.totalPemasukan),
              Colors.green,
            ),
            const Divider(),
            _buildSummaryItem(
              'Total Pengeluaran',
              formatCurrency.format(state.laporan.totalPengeluaran),
              Colors.red,
            ),
            if (state.laporan.jenisLaporan == 'semua') ...[
              const Divider(),
              _buildSummaryItem(
                'Saldo',
                formatCurrency.format(state.laporan.saldo),
                state.laporan.saldo >= 0 ? Colors.green : Colors.red,
              ),
            ],
            const Divider(),
            _buildSummaryItem(
              'Jumlah Transaksi Pemasukan',
              '${state.laporan.jumlahTransaksiPemasukan} transaksi',
              Colors.blue,
            ),
            const Divider(),
            _buildSummaryItem(
              'Jumlah Transaksi Pengeluaran',
              '${state.laporan.jumlahTransaksiPengeluaran} transaksi',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Membuat PDF...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfGeneratedSection(PdfGenerated state) {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 48),
            const SizedBox(height: 16),
            Text(
              'PDF Berhasil Dibuat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'File tersimpan di:',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              state.pdfFile.path,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
