import 'package:equatable/equatable.dart';

class Pemasukan extends Equatable {
  final int id;
  final String judul;
  final int kategoriTransaksiId;
  final double nominal;
  final String tanggalTransaksi;
  final String? buktiFoto;
  final String keterangan;
  final int createdBy;
  final int? verifikatorId;
  final DateTime? tanggalVerifikasi;
  final DateTime createdAt;
  final String? namaKategori;
  final String? namaCreatedBy;
  final String? namaVerifikator;

  const Pemasukan({
    required this.id,
    required this.judul,
    required this.kategoriTransaksiId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.buktiFoto,
    required this.keterangan,
    required this.createdBy,
    this.verifikatorId,
    this.tanggalVerifikasi,
    required this.createdAt,
    this.namaKategori,
    this.namaCreatedBy,
    this.namaVerifikator,
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
    verifikatorId,
    tanggalVerifikasi,
    createdAt,
    namaKategori,
    namaCreatedBy,
    namaVerifikator,
  ];
}
