import 'package:equatable/equatable.dart';

class PengeluaranDetailEntity extends Equatable {
  final int id;
  final String judul;
  final String kategori;
  final double nominal;
  final DateTime tanggalTransaksi;
  final String? buktiFoto;
  final String? keterangan;
  final String createdBy;
  final DateTime? tanggalVerifikasi;

  const PengeluaranDetailEntity({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.nominal,
    required this.tanggalTransaksi,
    this.buktiFoto,
    this.keterangan,
    required this.createdBy,
    this.tanggalVerifikasi,
  });

  @override
  List<Object?> get props => [
    id,
    judul,
    kategori,
    nominal,
    tanggalTransaksi,
    buktiFoto,
    keterangan,
    createdBy,
    tanggalVerifikasi,
  ];
}
