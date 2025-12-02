import '../../domain/entities/mutasi_keluarga.dart';

class MutasiKeluargaModel extends MutasiKeluarga {
  const MutasiKeluargaModel({
    super.id,
    required super.keluargaId,
    required super.jenisMutasi,
    super.rumahAsalId,
    super.rumahTujuanId,
    required super.tanggalMutasi,
    super.keterangan,
    super.fileBukti,
    super.createdAt,
    super.namaKepalaKeluarga,
    super.alamatAsal,
    super.alamatTujuan,
  });

  factory MutasiKeluargaModel.fromJson(Map<String, dynamic> json) {
    // 1. LOGIKA MENCARI NAMA KEPALA KELUARGA
    String namaFound = 'Tanpa Nama';

    // Ambil objek keluarga (bisa null)
    final keluargaObj = json['keluarga'];

    if (keluargaObj != null && keluargaObj['warga'] != null) {
      // Ambil list warga
      final List listWarga = keluargaObj['warga'] as List;

      if (listWarga.isNotEmpty) {
        // Cari yang statusnya 'Kepala Keluarga'
        final kepala = listWarga.firstWhere(
          (w) =>
              w['status_keluarga'] ==
              'Kepala Keluarga', // Sesuaikan string di DB kamu
          orElse: () => listWarga.first, // Fallback: ambil orang pertama
        );
        namaFound = kepala['nama_lengkap'] ?? 'Tanpa Nama';
      }
    }

    // 2. LOGIKA MENGAMBIL ALAMAT RUMAH
    final rumahAsalObj = json['rumah_asal'];
    final rumahTujuanObj = json['rumah_tujuan'];

    return MutasiKeluargaModel(
      id: json['id'] as int?,
      keluargaId: json['keluarga_id'] as int,
      jenisMutasi: json['jenis_mutasi'] as String,
      rumahAsalId: json['rumah_asal_id'] as int?,
      rumahTujuanId: json['rumah_tujuan_id'] as int?,
      tanggalMutasi: DateTime.parse(json['tanggal_mutasi'] as String),
      keterangan: json['keterangan'] as String?,
      fileBukti: json['file_bukti'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      namaKepalaKeluarga: namaFound,
      alamatAsal: rumahAsalObj != null ? rumahAsalObj['alamat'] : '-',
      alamatTujuan: rumahTujuanObj != null ? rumahTujuanObj['alamat'] : '-',
    );
  }

  // Di dalam class MutasiKeluargaModel

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'keluarga_id': keluargaId,
      'jenis_mutasi': jenisMutasi,
      'rumah_asal_id': rumahAsalId,
      'rumah_tujuan_id': rumahTujuanId,
      'tanggal_mutasi': tanggalMutasi.toIso8601String(),
      'keterangan': keterangan,
      'file_bukti': fileBukti,
    };

    // LOGIKA PENTING:
    // Hanya masukkan 'id' ke dalam Map jika nilainya TIDAK null.
    // Jika null (saat create baru), key 'id' tidak akan dikirim ke Supabase.
    if (id != null) {
      map['id'] = id;
    }

    // Sama juga untuk created_at, biarkan database yang set default now()
    if (createdAt != null) {
      map['created_at'] = createdAt?.toIso8601String();
    }

    return map;
  }

  factory MutasiKeluargaModel.fromEntity(MutasiKeluarga entity) {
    return MutasiKeluargaModel(
      id: entity.id,
      keluargaId: entity.keluargaId,
      jenisMutasi: entity.jenisMutasi,
      rumahAsalId: entity.rumahAsalId,
      rumahTujuanId: entity.rumahTujuanId,
      tanggalMutasi: entity.tanggalMutasi,
      keterangan: entity.keterangan,
      fileBukti: entity.fileBukti,
      createdAt: entity.createdAt,
    );
  }
}
