import 'package:equatable/equatable.dart';

class TagihanPembayaran extends Equatable {
  final int id;
  final int tagihanId;
  final String metode;
  final String bukti;
  final DateTime tanggalBayar;
  final String statusVerifikasi;
  final String? catatanAdmin;
  final int? verifikatorId;
  final DateTime createdAt;

  // Relasi dengan tagihan
  final String? kodeTagihan;
  final int? keluargaId;
  final int? masterIuranId;
  final String? periode;
  final double? nominal;
  final String? statusTagihan;
  final String? namaIuran;

  const TagihanPembayaran({
    required this.id,
    required this.tagihanId,
    required this.metode,
    required this.bukti,
    required this.tanggalBayar,
    required this.statusVerifikasi,
    this.catatanAdmin,
    this.verifikatorId,
    required this.createdAt,
    this.kodeTagihan,
    this.keluargaId,
    this.masterIuranId,
    this.periode,
    this.nominal,
    this.statusTagihan,
    this.namaIuran,
  });

  @override
  List<Object?> get props => [
    id,
    tagihanId,
    metode,
    bukti,
    tanggalBayar,
    statusVerifikasi,
    catatanAdmin,
    verifikatorId,
    createdAt,
    kodeTagihan,
    keluargaId,
    masterIuranId,
    periode,
    nominal,
    statusTagihan,
    namaIuran,
  ];
}
