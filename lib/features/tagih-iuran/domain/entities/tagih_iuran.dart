import 'package:equatable/equatable.dart';

class TagihIuran extends Equatable {
  final String kodeTagihan;
  final int keluargaId;
  final int masterIuranId;
  final String periode;
  final double nominal;
  final String statusTagihan;
  final DateTime? tanggalBayar;
  final double? nominalBayar;
  final DateTime? tglStrukFinal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TagihIuran({
    required this.kodeTagihan,
    required this.keluargaId,
    required this.masterIuranId,
    required this.periode,
    required this.nominal,
    required this.statusTagihan,
    this.tanggalBayar,
    this.nominalBayar,
    this.tglStrukFinal,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    kodeTagihan,
    keluargaId,
    masterIuranId,
    periode,
    nominal,
    statusTagihan,
    tanggalBayar,
    nominalBayar,
    tglStrukFinal,
    createdAt,
    updatedAt,
  ];
}
