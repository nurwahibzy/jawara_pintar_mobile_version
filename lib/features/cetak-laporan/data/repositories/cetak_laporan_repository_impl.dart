import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/laporan_cetak_entity.dart';
import '../../domain/repositories/cetak_laporan_repository.dart';
import '../datasources/cetak_laporan_remote_datasource.dart';

class CetakLaporanRepositoryImpl implements CetakLaporanRepository {
  final CetakLaporanRemoteDataSource remoteDataSource;

  CetakLaporanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LaporanCetakEntity>> getLaporanData({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
  }) async {
    try {
      final result = await remoteDataSource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: jenisLaporan,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, File>> generatePdfLaporan({
    required LaporanCetakEntity laporan,
  }) async {
    try {
      final pdf = pw.Document();
      final formatCurrency = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      final formatDate = DateFormat('dd MMMM yyyy');

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'LAPORAN KEUANGAN',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'RT 001 RW 002',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),

            // Periode
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Jenis Laporan:'),
                      pw.Text(
                        _getJenisLaporanText(laporan.jenisLaporan),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Periode:'),
                      pw.Text(
                        '${formatDate.format(laporan.tanggalMulai)} - ${formatDate.format(laporan.tanggalAkhir)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Ringkasan
            pw.Text(
              'Ringkasan',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildSummaryTable(laporan, formatCurrency),

            pw.SizedBox(height: 24),

            // Detail Pemasukan
            if (laporan.jenisLaporan == 'semua' ||
                laporan.jenisLaporan == 'pemasukan') ...[
              pw.Text(
                'Detail Pemasukan',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildDetailTable(
                laporan.daftarPemasukan,
                formatCurrency,
                formatDate,
              ),
              pw.SizedBox(height: 20),
            ],

            // Detail Pengeluaran
            if (laporan.jenisLaporan == 'semua' ||
                laporan.jenisLaporan == 'pengeluaran') ...[
              pw.Text(
                'Detail Pengeluaran',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildDetailTable(
                laporan.daftarPengeluaran,
                formatCurrency,
                formatDate,
              ),
            ],

            // Footer
            pw.SizedBox(height: 40),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Dicetak pada:'),
                    pw.Text(
                      DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now()),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final fileName =
          'Laporan_Keuangan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return Right(file);
    } catch (e) {
      return Left(ServerFailure('Gagal membuat PDF: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> sharePdfLaporan({required File pdfFile}) async {
    try {
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: 'Laporan Keuangan',
        text: 'Berikut adalah laporan keuangan yang diminta.',
      );
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Gagal membagikan PDF: ${e.toString()}'));
    }
  }

  pw.Widget _buildSummaryTable(
    LaporanCetakEntity laporan,
    NumberFormat formatCurrency,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Keterangan', isHeader: true),
            _buildTableCell('Jumlah Transaksi', isHeader: true),
            _buildTableCell('Total', isHeader: true),
          ],
        ),
        if (laporan.jenisLaporan == 'semua' ||
            laporan.jenisLaporan == 'pemasukan')
          pw.TableRow(
            children: [
              _buildTableCell('Pemasukan'),
              _buildTableCell(
                laporan.jumlahTransaksiPemasukan.toString(),
                align: pw.TextAlign.center,
              ),
              _buildTableCell(
                formatCurrency.format(laporan.totalPemasukan),
                align: pw.TextAlign.right,
              ),
            ],
          ),
        if (laporan.jenisLaporan == 'semua' ||
            laporan.jenisLaporan == 'pengeluaran')
          pw.TableRow(
            children: [
              _buildTableCell('Pengeluaran'),
              _buildTableCell(
                laporan.jumlahTransaksiPengeluaran.toString(),
                align: pw.TextAlign.center,
              ),
              _buildTableCell(
                formatCurrency.format(laporan.totalPengeluaran),
                align: pw.TextAlign.right,
              ),
            ],
          ),
        if (laporan.jenisLaporan == 'semua')
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              _buildTableCell('Saldo', isHeader: true),
              _buildTableCell('', isHeader: true),
              _buildTableCell(
                formatCurrency.format(laporan.saldo),
                align: pw.TextAlign.right,
                isHeader: true,
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildDetailTable(
    List<ItemTransaksiEntity> items,
    NumberFormat formatCurrency,
    DateFormat formatDate,
  ) {
    if (items.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Center(child: pw.Text('Tidak ada transaksi')),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('No', isHeader: true),
            _buildTableCell('Keterangan', isHeader: true),
            _buildTableCell('Tanggal', isHeader: true),
            _buildTableCell('Nominal', isHeader: true),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell(index.toString(), align: pw.TextAlign.center),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.judul,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      item.kategori,
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTableCell(
                formatDate.format(item.tanggal),
                align: pw.TextAlign.center,
              ),
              _buildTableCell(
                formatCurrency.format(item.nominal),
                align: pw.TextAlign.right,
              ),
            ],
          );
        }),
        // Total Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('', isHeader: true),
            _buildTableCell('Total', isHeader: true),
            _buildTableCell('', isHeader: true),
            _buildTableCell(
              formatCurrency.format(
                items.fold<double>(0, (sum, item) => sum + item.nominal),
              ),
              align: pw.TextAlign.right,
              isHeader: true,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 10 : 9,
        ),
        textAlign: align,
      ),
    );
  }

  String _getJenisLaporanText(String jenis) {
    switch (jenis) {
      case 'semua':
        return 'Semua Transaksi';
      case 'pemasukan':
        return 'Pemasukan Saja';
      case 'pengeluaran':
        return 'Pengeluaran Saja';
      default:
        return jenis;
    }
  }
}
