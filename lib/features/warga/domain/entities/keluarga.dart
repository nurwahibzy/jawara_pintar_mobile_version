import 'package:equatable/equatable.dart';

/// Anggota Keluarga sederhana untuk tampilan
class AnggotaKeluarga extends Equatable {
  final int id;
  final String nik;
  final String nama;
  final String jenisKelamin;
  final DateTime? tanggalLahir;
  final String statusKeluarga; // Kepala Keluarga, Istri, Anak, dll
  final String statusHidup;

  const AnggotaKeluarga({
    required this.id,
    required this.nik,
    required this.nama,
    required this.jenisKelamin,
    this.tanggalLahir,
    required this.statusKeluarga,
    required this.statusHidup,
  });

  @override
  List<Object?> get props => [id, nik, nama, statusKeluarga];
}

/// Info Rumah sederhana untuk tampilan keluarga
class RumahInfo extends Equatable {
  final int id;
  final String alamat;
  final String statusRumah; // Dihuni, Kosong, Disewakan

  const RumahInfo({
    required this.id,
    required this.alamat,
    required this.statusRumah,
  });

  @override
  List<Object?> get props => [id, alamat, statusRumah];
}

class Keluarga extends Equatable {
  final int id;
  final String nomorKk;
  final int? rumahId;
  final String statusHunian; // Aktif, Pindah Internal, Keluar Wilayah
  final DateTime? tanggalTerdaftar;
  final DateTime? createdAt;

  // Relasi
  final RumahInfo? rumah;
  final List<AnggotaKeluarga> anggota;

  // Computed properties
  // Nama Keluarga = "Keluarga" + status_keluarga kepala keluarga
  String get namaKeluarga {
    final kepala = kepalaKeluarga;
    if (kepala != null) {
      return 'Keluarga ${kepala.nama}';
    }
    return 'Keluarga #$id';
  }

  AnggotaKeluarga? get kepalaKeluarga {
    try {
      return anggota.firstWhere(
        (a) => a.statusKeluarga.toLowerCase() == 'kepala keluarga',
      );
    } catch (_) {
      return anggota.isNotEmpty ? anggota.first : null;
    }
  }

  // Nama kepala keluarga (nama_lengkap)
  String get namaKepalaKeluarga => kepalaKeluarga?.nama ?? '-';

  String get alamatRumah => rumah?.alamat ?? '-';

  // Status kepemilikan = status_rumah dari tabel rumah
  String get statusKepemilikan => rumah?.statusRumah ?? '-';

  // Status penduduk = status_hidup dari tabel warga (kepala keluarga)
  String get statusPenduduk => kepalaKeluarga?.statusHidup ?? '-';

  const Keluarga({
    required this.id,
    required this.nomorKk,
    this.rumahId,
    required this.statusHunian,
    this.tanggalTerdaftar,
    this.createdAt,
    this.rumah,
    this.anggota = const [],
  });

  @override
  List<Object?> get props => [id, nomorKk, rumahId, statusHunian, anggota];
}
