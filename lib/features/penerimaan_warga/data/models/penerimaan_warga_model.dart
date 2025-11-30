import '../../domain/entities/penerimaan_warga.dart';

class PenerimaanWargaModel extends PenerimaanWarga {
  const PenerimaanWargaModel({
    required super.id,
    required super.nama,
    required super.nik,
    required super.email,
    required super.jenisKelamin,
    super.fotoIdentitas,
  });

  factory PenerimaanWargaModel.fromJson(Map<String, dynamic> json) {
    return PenerimaanWargaModel(
      id: json['id'],
      nama: json['nama'],
      nik: json['nik'],
      email: json['email'],
      jenisKelamin: json['jenis_kelamin'],
      fotoIdentitas: json['foto_identitas'],
    );
  }
}
