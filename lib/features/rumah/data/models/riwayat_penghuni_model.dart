import '../../domain/entities/riwayat_penghuni.dart';

class RiwayatPenghuniModel extends RiwayatPenghuni {
  const RiwayatPenghuniModel({
    required super.namaKeluarga,
    required super.namaKepalaKeluarga,
    required super.tanggalMasuk,
    super.tanggalKeluar,
  });

  factory RiwayatPenghuniModel.fromJson(Map<String, dynamic> json) {
    final listWarga = json['keluarga']?['warga'] as List<dynamic>? ?? [];

    final kepalaKeluargaData = listWarga.firstWhere(
      (warga) => warga['status_keluarga'] == 'Kepala Keluarga',
      orElse: () => null,
    );

    final namaKepala = kepalaKeluargaData?['nama_lengkap'] ?? '-';

    return RiwayatPenghuniModel(
      namaKeluarga: 'Keluarga $namaKepala', 
      namaKepalaKeluarga: namaKepala,
      
      tanggalMasuk: json['tanggal_masuk'] != null
          ? DateTime.parse(json['tanggal_masuk'])
          : DateTime.now(),
          
      tanggalKeluar: json['tanggal_keluar'] != null
          ? DateTime.parse(json['tanggal_keluar'])
          : null,
    );
  }
}