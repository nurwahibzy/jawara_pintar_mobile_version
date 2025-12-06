import 'package:equatable/equatable.dart';

class LaporanCetakEntity extends Equatable {
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final String jenisLaporan; // 'semua', 'pemasukan', 'pengeluaran'
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldo;
  final int jumlahTransaksiPemasukan;
  final int jumlahTransaksiPengeluaran;
  final List<ItemTransaksiEntity> daftarPemasukan;
  final List<ItemTransaksiEntity> daftarPengeluaran;

  const LaporanCetakEntity({
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.jenisLaporan,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldo,
    required this.jumlahTransaksiPemasukan,
    required this.jumlahTransaksiPengeluaran,
    required this.daftarPemasukan,
    required this.daftarPengeluaran,
  });

  @override
  List<Object?> get props => [
    tanggalMulai,
    tanggalAkhir,
    jenisLaporan,
    totalPemasukan,
    totalPengeluaran,
    saldo,
    jumlahTransaksiPemasukan,
    jumlahTransaksiPengeluaran,
    daftarPemasukan,
    daftarPengeluaran,
  ];
}

class ItemTransaksiEntity extends Equatable {
  final String id;
  final String judul;
  final String kategori;
  final double nominal;
  final DateTime tanggal;
  final String? keterangan;

  const ItemTransaksiEntity({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    this.keterangan,
  });

  @override
  List<Object?> get props => [
    id,
    judul,
    kategori,
    nominal,
    tanggal,
    keterangan,
  ];
}
