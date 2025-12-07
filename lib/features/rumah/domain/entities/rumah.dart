import 'package:equatable/equatable.dart';
import 'riwayat_penghuni.dart';

class Rumah extends Equatable {
  final int id;
  final String alamat;
  final String statusRumah; // Kosong, Dihuni, Disewakan
  final DateTime? createdAt;

  final List<RiwayatPenghuni> riwayatPenghuni;

  const Rumah({
    required this.id,
    required this.alamat,
    required this.statusRumah,
    this.createdAt,
    this.riwayatPenghuni = const [],
  });

  // Check apakah rumah bisa dihapus (hanya jika status Kosong)
  bool get canDelete => statusRumah.toLowerCase() == 'kosong';

  @override
  List<Object?> get props => [id, alamat, statusRumah, riwayatPenghuni];
}
