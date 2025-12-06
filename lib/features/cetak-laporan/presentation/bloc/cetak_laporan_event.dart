import 'package:equatable/equatable.dart';

abstract class CetakLaporanEvent extends Equatable {
  const CetakLaporanEvent();

  @override
  List<Object?> get props => [];
}

class LoadLaporanDataEvent extends CetakLaporanEvent {
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final String jenisLaporan;

  const LoadLaporanDataEvent({
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.jenisLaporan,
  });

  @override
  List<Object?> get props => [tanggalMulai, tanggalAkhir, jenisLaporan];
}

class GeneratePdfEvent extends CetakLaporanEvent {
  const GeneratePdfEvent();
}

class SharePdfEvent extends CetakLaporanEvent {
  const SharePdfEvent();
}
