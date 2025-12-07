part of 'laporan_keuangan_bloc.dart';

abstract class LaporanKeuanganState extends Equatable {
  const LaporanKeuanganState();

  @override
  List<Object?> get props => [];
}

class LaporanKeuanganInitial extends LaporanKeuanganState {}

class LaporanKeuanganLoading extends LaporanKeuanganState {}

// State untuk list pemasukan
class PemasukanListLoaded extends LaporanKeuanganState {
  final List<PemasukanDetailEntity> pemasukanList;
  final String? kategori;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;

  const PemasukanListLoaded({
    required this.pemasukanList,
    this.kategori,
    this.tanggalMulai,
    this.tanggalAkhir,
  });

  @override
  List<Object?> get props => [
    pemasukanList,
    kategori,
    tanggalMulai,
    tanggalAkhir,
  ];
}

// State untuk list pengeluaran
class PengeluaranListLoaded extends LaporanKeuanganState {
  final List<PengeluaranDetailEntity> pengeluaranList;
  final String? kategori;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;

  const PengeluaranListLoaded({
    required this.pengeluaranList,
    this.kategori,
    this.tanggalMulai,
    this.tanggalAkhir,
  });

  @override
  List<Object?> get props => [
    pengeluaranList,
    kategori,
    tanggalMulai,
    tanggalAkhir,
  ];
}

// State untuk laporan summary (cetak laporan)
class LaporanSummaryLoaded extends LaporanKeuanganState {
  final LaporanSummaryEntity laporan;

  const LaporanSummaryLoaded(this.laporan);

  @override
  List<Object?> get props => [laporan];
}

// State untuk PDF
class PdfGenerating extends LaporanKeuanganState {}

class PdfGenerated extends LaporanKeuanganState {
  final File pdfFile;

  const PdfGenerated(this.pdfFile);

  @override
  List<Object?> get props => [pdfFile];
}

class LaporanKeuanganError extends LaporanKeuanganState {
  final String message;

  const LaporanKeuanganError(this.message);

  @override
  List<Object?> get props => [message];
}
