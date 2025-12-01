import 'package:equatable/equatable.dart';

class Pengeluaran extends Equatable {
  final int? id;
  final String judul;
  final int kategoriTransaksiId;
  final double nominal;
  final DateTime tanggalTransaksi;
  final String? buktiFoto;
  final String? keterangan;
  final int createdBy;
  //final int? verifikatorId;
  //final DateTime? tanggalVerifikasi;
  final DateTime createdAt;

  const Pengeluaran({
    this.id,
    required this.judul,
    required this.kategoriTransaksiId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.buktiFoto,
    this.keterangan,
    required this.createdBy,
   // this.verifikatorId,
   // this.tanggalVerifikasi,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    judul,
    kategoriTransaksiId,
    nominal,
    tanggalTransaksi,
    buktiFoto,
    keterangan,
    createdBy,
   // verifikatorId,
   // tanggalVerifikasi,
    createdAt,
  ];
}