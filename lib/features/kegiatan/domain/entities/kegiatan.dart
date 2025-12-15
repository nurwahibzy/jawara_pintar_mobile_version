import 'package:equatable/equatable.dart';

class Kegiatan extends Equatable {
  final int? id;
  final String namaKegiatan;
  final int kategoriKegiatanId;
  final String? namaKategori;
  final String deskripsi;
  final DateTime tanggalPelaksanaan;
  final String lokasi;
  final String penanggungJawab;
  final String? fotoDokumentasi;
  final int createdBy;
  final DateTime createdAt;

  const Kegiatan({
    this.id,
    required this.namaKegiatan,
    required this.kategoriKegiatanId,
    this.namaKategori,
    required this.deskripsi,
    required this.tanggalPelaksanaan,
    required this.lokasi,
    required this.penanggungJawab,
    this.fotoDokumentasi,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    namaKegiatan,
    kategoriKegiatanId,
    namaKategori,
    deskripsi,
    tanggalPelaksanaan,
    lokasi,
    penanggungJawab,
    fotoDokumentasi,
    createdBy,
    createdAt,
  ];
}
