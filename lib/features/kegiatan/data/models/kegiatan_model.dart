import '../../domain/entities/kegiatan.dart';

class KegiatanModel extends Kegiatan {
  const KegiatanModel({
    super.id,
    required super.namaKegiatan,
    required super.kategoriKegiatanId,
    super.namaKategori,
    required super.deskripsi,
    required super.tanggalPelaksanaan,
    required super.lokasi,
    required super.penanggungJawab,
    super.fotoDokumentasi,
    required super.createdBy,
    required super.createdAt,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'] as int?,
      namaKegiatan: json['nama_kegiatan'] as String,
      kategoriKegiatanId: json['kategori_kegiatan_id'] as int,
      namaKategori: json['kategori_kegiatan']?['nama_kategori'] as String?,
      deskripsi: json['deskripsi'] as String,
      tanggalPelaksanaan: DateTime.parse(json['tanggal_pelaksanaan'] as String),
      lokasi: json['lokasi'] as String,
      penanggungJawab: json['penanggung_jawab'] as String,
      fotoDokumentasi: json['foto_dokumentasi'] as String?,
      createdBy: json['created_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_kegiatan': namaKegiatan,
      'kategori_kegiatan_id': kategoriKegiatanId,
      'deskripsi': deskripsi,
      'tanggal_pelaksanaan': tanggalPelaksanaan.toIso8601String(),
      'lokasi': lokasi,
      'penanggung_jawab': penanggungJawab,
      'foto_dokumentasi': fotoDokumentasi,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory KegiatanModel.fromEntity(Kegiatan kegiatan) {
    return KegiatanModel(
      id: kegiatan.id,
      namaKegiatan: kegiatan.namaKegiatan,
      kategoriKegiatanId: kegiatan.kategoriKegiatanId,
      namaKategori: kegiatan.namaKategori,
      deskripsi: kegiatan.deskripsi,
      tanggalPelaksanaan: kegiatan.tanggalPelaksanaan,
      lokasi: kegiatan.lokasi,
      penanggungJawab: kegiatan.penanggungJawab,
      fotoDokumentasi: kegiatan.fotoDokumentasi,
      createdBy: kegiatan.createdBy,
      createdAt: kegiatan.createdAt,
    );
  }
}
