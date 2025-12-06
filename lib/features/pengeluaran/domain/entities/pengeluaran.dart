import 'package:equatable/equatable.dart';

class Pengeluaran extends Equatable {
  final int? id;
  final String judul;
  final int kategoriTransaksiId;
  final double nominal;
  final DateTime tanggalTransaksi;
  final String? buktiFoto;
  final String? keterangan;
  final String createdBy;
  final String? createdByName;
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
    this.createdByName,
   // this.verifikatorId,
   // this.tanggalVerifikasi,
    required this.createdAt,
  });

  Pengeluaran copyWith({
    int? id,
    String? judul,
    int? kategoriTransaksiId,
    double? nominal,
    DateTime? tanggalTransaksi,
    String? buktiFoto,
    String? keterangan,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
  }) {
    return Pengeluaran(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      kategoriTransaksiId: kategoriTransaksiId ?? this.kategoriTransaksiId,
      nominal: nominal ?? this.nominal,
      tanggalTransaksi: tanggalTransaksi ?? this.tanggalTransaksi,
      buktiFoto: buktiFoto ?? this.buktiFoto,
      keterangan: keterangan ?? this.keterangan,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
    createdByName,
   // verifikatorId,
   // tanggalVerifikasi,
    createdAt,
  ];
}