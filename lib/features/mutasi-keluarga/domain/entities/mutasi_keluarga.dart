import 'package:equatable/equatable.dart';

class MutasiKeluarga extends Equatable {
  final int? id; // Integer (Nullable karena auto-generate saat insert)
  final int keluargaId; // Integer
  final String jenisMutasi; // Enum di DB, kita handle sebagai String di Dart
  final int? rumahAsalId; // Integer (Nullable)
  final int? rumahTujuanId; // Integer (Nullable)
  final DateTime tanggalMutasi; // Date
  final String? keterangan; // Text (Nullable)
  final String? fileBukti; // Varchar (Nullable)
  final DateTime? createdAt; // Timestamp (Nullable)
final String? namaKepalaKeluarga; // Untuk menampung nama dari tabel warga
  final String? alamatAsal;         // Untuk menampung blok nomor rumah asal
  final String? alamatTujuan;

  const MutasiKeluarga({
    this.id,
    required this.keluargaId,
    required this.jenisMutasi,
    this.rumahAsalId,
    this.rumahTujuanId,
    required this.tanggalMutasi,
    this.keterangan,
    this.fileBukti,
    this.createdAt,
    this.namaKepalaKeluarga,
    this.alamatAsal,
    this.alamatTujuan,
  });

  @override
  List<Object?> get props => [
    id,
    keluargaId,
    jenisMutasi,
    rumahAsalId,
    rumahTujuanId,
    tanggalMutasi,
    keterangan,
    fileBukti,
    createdAt,
    namaKepalaKeluarga,
  ];
}
