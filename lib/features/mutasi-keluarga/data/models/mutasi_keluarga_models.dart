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
    final List<dynamic>? wargaList = json['keluarga'] != null
        ? json['keluarga']['warga']
        : null;

    String namaKepalaKeluarga = 'Tanpa Nama';

    if (wargaList != null && wargaList.isNotEmpty) {
      // Cari Kepala Keluarga
      final kepalaList = wargaList.where(
        (w) => w['status_keluarga'] == 'Kepala Keluarga',
      );

      if (kepalaList.isNotEmpty) {
        namaKepalaKeluarga = kepalaList.first['nama_lengkap'] ?? 'Tanpa Nama';
      } else {
        // Jika tidak ada Kepala Keluarga, pakai orang pertama
        namaKepalaKeluarga = wargaList.first['nama_lengkap'] ?? 'Tanpa Nama';
      }
    }

    return MutasiKeluargaModel(
      id: json['id'],
      keluargaId: json['keluarga_id'],
      jenisMutasi: json['jenis_mutasi'],
      tanggalMutasi: json['tanggal_mutasi'] != null
          ? DateTime.parse(json['tanggal_mutasi'])
          : DateTime.now(),
      keterangan: json['keterangan'],
      fileBukti: json['file_bukti'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      alamatAsal: json['rumah_asal']?['alamat'] ?? '-',
      alamatTujuan: json['rumah_tujuan']?['alamat'] ?? '-',
      namaKepalaKeluarga: namaKepalaKeluarga,
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
