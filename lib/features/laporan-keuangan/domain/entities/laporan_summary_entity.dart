import 'package:equatable/equatable.dart';
import 'pemasukan_detail_entity.dart';
import 'pengeluaran_detail_entity.dart';

class LaporanSummaryEntity extends Equatable {
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final String? kategori;
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldo;
  final List<PemasukanDetailEntity> pemasukanList;
  final List<PengeluaranDetailEntity> pengeluaranList;

  const LaporanSummaryEntity({
    required this.tanggalMulai,
    required this.tanggalAkhir,
    this.kategori,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldo,
    required this.pemasukanList,
    required this.pengeluaranList,
  });

  @override
  List<Object?> get props => [
    tanggalMulai,
    tanggalAkhir,
    kategori,
    totalPemasukan,
    totalPengeluaran,
    saldo,
    pemasukanList,
    pengeluaranList,
  ];
}
