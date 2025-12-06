import '../../domain/entities/pesan_warga.dart';

enum StatusAspirasi { Pending, Menunggu, Diterima, Ditolak }

class AspirasiModel {
  final int? id;
  final int wargaId;
  final String judul;
  final String deskripsi;
  final StatusAspirasi status;
  final String? tanggapanAdmin;
  final int? updatedBy;
  final DateTime createdAt;
  final String? namaAdmin; 
  final String? namaWarga; 

  AspirasiModel({
    this.id,
    required this.wargaId,
    required this.judul,
    required this.deskripsi,
    required this.status,
    this.tanggapanAdmin,
    this.updatedBy,
    required this.createdAt,
    this.namaAdmin,
    this.namaWarga,
  });

 factory AspirasiModel.fromMap(Map<String, dynamic> map) {
    String? getNamaAdmin(dynamic adminData) {
      if (adminData == null) return null;
      if (adminData is List && adminData.isNotEmpty) {
        return adminData[0]['nama_lengkap'] as String?;
      }
      if (adminData is Map) {
        return adminData['nama_lengkap'] as String?;
      }
      return null;
    }

    String? getNamaWarga(dynamic wargaData) {
      if (wargaData == null) return null;
      if (wargaData is List && wargaData.isNotEmpty) {
        return wargaData[0]['nama_lengkap'] as String?;
      }
      if (wargaData is Map) {
        return wargaData['nama_lengkap'] as String?;
      }
      return null;
    }

    return AspirasiModel(
      id: map['id'] as int?,
      wargaId: map['warga_id'] as int? ?? 0,
      judul: map['judul'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      status: _statusFromString(map['status'] as String? ?? 'Pending'),
      tanggapanAdmin: map['tanggapan_admin'] as String?,
      updatedBy: map['updated_by'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      namaAdmin: getNamaAdmin(map['admin']),
      namaWarga: getNamaWarga(map['warga']),
    );
  }

  Map<String, dynamic> toMap({bool forUpdate = false}) {
    final map = {
      'warga_id': wargaId,
      'judul': judul,
      'deskripsi': deskripsi,
      'status': _statusToString(status),
      'tanggapan_admin': tanggapanAdmin,
      'updated_by': updatedBy,
    };
    if (forUpdate) {
      map['created_at'] = createdAt.toIso8601String();
      if (id != null) map['id'] = id;
    }
    return map;
  }

  static StatusAspirasi _statusFromString(String s) {
    switch (s) {
      case 'Pending':
        return StatusAspirasi.Pending;
      case 'Menunggu':
        return StatusAspirasi.Menunggu;
      case 'Diterima':
        return StatusAspirasi.Diterima;
      case 'Ditolak':
        return StatusAspirasi.Ditolak;
      default:
        throw Exception("Status tidak dikenal: $s");
    }
  }

  static String _statusToString(StatusAspirasi status) {
    switch (status) {
      case StatusAspirasi.Pending:
        return 'Pending';
      case StatusAspirasi.Menunggu:
        return 'Menunggu';
      case StatusAspirasi.Diterima:
        return 'Diterima';
      case StatusAspirasi.Ditolak:
        return 'Ditolak';
    }
  }
}

// Konversi ke entity
extension AspirasiModelToEntity on AspirasiModel {
  Aspirasi toEntity() {
    return Aspirasi(
      id: id ?? 0,
      wargaId: wargaId,
      judul: judul,
      deskripsi: deskripsi,
      status: status,
      tanggapanAdmin: tanggapanAdmin,
      updatedBy: updatedBy,
      createdAt: createdAt,
      namaAdmin: namaAdmin,
      namaWarga: namaWarga,
    );
  }
}

// copyWith untuk update
extension AspirasiModelCopy on AspirasiModel {
  AspirasiModel copyWith({int? wargaId, int? updatedBy}) {
    return AspirasiModel(
      id: id,
      wargaId: wargaId ?? this.wargaId,
      judul: judul,
      deskripsi: deskripsi,
      status: status,
      tanggapanAdmin: tanggapanAdmin,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt,
      namaAdmin: namaAdmin,
      namaWarga: namaWarga,
    );
  }
}