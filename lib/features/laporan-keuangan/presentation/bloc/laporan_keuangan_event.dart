part of 'laporan_keuangan_bloc.dart';

abstract class LaporanKeuanganEvent extends Equatable {
  const LaporanKeuanganEvent();

  @override
  List<Object?> get props => [];
}

class LoadPemasukanListEvent extends LaporanKeuanganEvent {
  final String? kategori;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;

  const LoadPemasukanListEvent({
    this.kategori,
    this.tanggalMulai,
    this.tanggalAkhir,
  });

  @override
  List<Object?> get props => [kategori, tanggalMulai, tanggalAkhir];
}

class LoadPengeluaranListEvent extends LaporanKeuanganEvent {
  final String? kategori;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;

  const LoadPengeluaranListEvent({
    this.kategori,
    this.tanggalMulai,
    this.tanggalAkhir,
  });

  @override
  List<Object?> get props => [kategori, tanggalMulai, tanggalAkhir];
}

class LoadLaporanSummaryEvent extends LaporanKeuanganEvent {
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;
  final String? jenisLaporan; // 'semua', 'pemasukan', 'pengeluaran'

  const LoadLaporanSummaryEvent({
    this.tanggalMulai,
    this.tanggalAkhir,
    this.jenisLaporan,
  });

  @override
  List<Object?> get props => [tanggalMulai, tanggalAkhir, jenisLaporan];
}

class GeneratePdfEvent extends LaporanKeuanganEvent {
  const GeneratePdfEvent();
}
