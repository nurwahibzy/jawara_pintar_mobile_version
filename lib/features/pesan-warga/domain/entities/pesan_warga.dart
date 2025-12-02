import '../../data/models/pesan_warga_model.dart';

class Aspirasi {
  final int id;
  final int wargaId;
  final String judul;
  final String deskripsi;
  final StatusAspirasi status;
  final String? tanggapanAdmin; 
  final int? updatedBy; 
  final DateTime createdAt;
  final String? namaAdmin;
  final String? namaWarga;

  Aspirasi({
    required this.id,
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
}

// Extension untuk konversi ke Model
extension AspirasiEntityToModel on Aspirasi {
  AspirasiModel toModel() {
    return AspirasiModel(
      id: id,
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