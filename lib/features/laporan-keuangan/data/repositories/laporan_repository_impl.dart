import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/pemasukan_detail_entity.dart';
import '../../domain/entities/pengeluaran_detail_entity.dart';
import '../../domain/entities/laporan_summary_entity.dart';
import '../../domain/repositories/laporan_repository.dart';
import '../datasources/laporan_remote_data_source.dart';

class LaporanRepositoryImpl implements LaporanRepository {
  final LaporanRemoteDataSource remoteDataSource;

  LaporanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PemasukanDetailEntity>>> getAllPemasukan({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    try {
      final result = await remoteDataSource.getAllPemasukan(
        kategori: kategori,
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PengeluaranDetailEntity>>> getAllPengeluaran({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    try {
      final result = await remoteDataSource.getAllPengeluaran(
        kategori: kategori,
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LaporanSummaryEntity>> getLaporanSummary({
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
    String? jenisList,
  }) async {
    try {
      List<PemasukanDetailEntity> pemasukanList = [];
      List<PengeluaranDetailEntity> pengeluaranList = [];

      // Fetch data based on jenis laporan
      if (jenisList == null ||
          jenisList == 'semua' ||
          jenisList == 'pemasukan') {
        final pemasukanResult = await remoteDataSource.getAllPemasukan(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
        );
        pemasukanList = pemasukanResult;
      }

      if (jenisList == null ||
          jenisList == 'semua' ||
          jenisList == 'pengeluaran') {
        final pengeluaranResult = await remoteDataSource.getAllPengeluaran(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
        );
        pengeluaranList = pengeluaranResult;
      }

      // Calculate totals
      final totalPemasukan = pemasukanList.fold<double>(
        0,
        (sum, item) => sum + item.nominal,
      );

      final totalPengeluaran = pengeluaranList.fold<double>(
        0,
        (sum, item) => sum + item.nominal,
      );

      final saldo = totalPemasukan - totalPengeluaran;

      final summary = LaporanSummaryEntity(
        tanggalMulai: tanggalMulai ?? DateTime(2000),
        tanggalAkhir: tanggalAkhir ?? DateTime.now(),
        totalPemasukan: totalPemasukan,
        totalPengeluaran: totalPengeluaran,
        saldo: saldo,
        pemasukanList: pemasukanList,
        pengeluaranList: pengeluaranList,
      );

      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, File>> generatePdfLaporan({
    required LaporanSummaryEntity laporan,
  }) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('dd MMM yyyy');
      final currencyFormat = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );

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
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Periode: ${dateFormat.format(laporan.tanggalMulai)} - ${dateFormat.format(laporan.tanggalAkhir)}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Dicetak: ${dateFormat.format(DateTime.now())}',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Summary Box
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                children: [
                  _buildSummaryRow(
                    'Total Pemasukan',
                    currencyFormat.format(laporan.totalPemasukan),
                    PdfColors.green,
                  ),
                  pw.Divider(),
                  _buildSummaryRow(
                    'Total Pengeluaran',
                    currencyFormat.format(laporan.totalPengeluaran),
                    PdfColors.red,
                  ),
                  pw.Divider(thickness: 2),
                  _buildSummaryRow(
                    'Saldo',
                    currencyFormat.format(laporan.saldo),
                    laporan.saldo >= 0 ? PdfColors.blue : PdfColors.red,
                    isBold: true,
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Pemasukan Section
            if (laporan.pemasukanList.isNotEmpty) ...[
              pw.Text(
                'PEMASUKAN',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              _buildTransactionTable(
                laporan.pemasukanList
                    .map(
                      (e) => {
                        'tanggal': dateFormat.format(e.tanggalTransaksi),
                        'judul': e.judul,
                        'kategori': e.kategori,
                        'nominal': currencyFormat.format(e.nominal),
                      },
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 24),
            ],

            // Pengeluaran Section
            if (laporan.pengeluaranList.isNotEmpty) ...[
              pw.Text(
                'PENGELUARAN',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              _buildTransactionTable(
                laporan.pengeluaranList
                    .map(
                      (e) => {
                        'tanggal': dateFormat.format(e.tanggalTransaksi),
                        'judul': e.judul,
                        'kategori': e.kategori,
                        'nominal': currencyFormat.format(e.nominal),
                      },
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      );

      // Save PDF to file
      final output = await getTemporaryDirectory();
      final fileName =
          'laporan_keuangan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return Right(file);
    } catch (e) {
      return Left(ServerFailure('Gagal generate PDF: $e'));
    }
  }

  pw.Widget _buildSummaryRow(
    String label,
    String value,
    PdfColor color, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTransactionTable(List<Map<String, String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Tanggal', isHeader: true),
            _buildTableCell('Judul', isHeader: true),
            _buildTableCell('Kategori', isHeader: true),
            _buildTableCell('Nominal', isHeader: true),
          ],
        ),
        // Data rows
        ...data.map(
          (row) => pw.TableRow(
            children: [
              _buildTableCell(row['tanggal']!),
              _buildTableCell(row['judul']!),
              _buildTableCell(row['kategori']!),
              _buildTableCell(
                row['nominal']!,
                alignment: pw.Alignment.centerRight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.Alignment? alignment,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Align(
        alignment: alignment ?? pw.Alignment.centerLeft,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
