import 'package:equatable/equatable.dart';

class Warga extends Equatable {
  final int idWarga;
  final int keluargaId;
  final String nik;
  final String nama;
  final String nomorTelepon;
  
  // Data Nullable
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  
  final String jenisKelamin;
  final String statusKeluarga;
  final String statusHidup;
  
  final String? agama;
  final String? golonganDarah;
  final String? pendidikanTerakhir;
  final String? pekerjaan;
  final String? statusPenduduk;
  
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Warga({
    required this.idWarga,
    required this.keluargaId,
    required this.nik,
    required this.nama,
    required this.nomorTelepon,
    this.tempatLahir,
    this.tanggalLahir,
    required this.jenisKelamin,
    required this.statusKeluarga,
    required this.statusHidup,
    this.agama,
    this.golonganDarah,
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.statusPenduduk,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    idWarga,
    keluargaId,
    nik,
    nama,
    nomorTelepon,
    jenisKelamin,
    statusKeluarga,
    statusHidup,
  ];
}