import '../../domain/entities/penerimaan_warga.dart';


class PenerimaanWargaModel extends PenerimaanWarga {
PenerimaanWargaModel({
required super.id,
required super.namaPemohon,
required super.nik,
required super.noHp,
required super.fotoKtpKk,
required super.dataLengkap,
required super.status,
super.alasanPenolakan,
});


factory PenerimaanWargaModel.fromJson(Map<String, dynamic> json) {
return PenerimaanWargaModel(
id: json['id'],
namaPemohon: json['nama_pemohon'],
nik: json['nik'],
noHp: json['no_hp'],
fotoKtpKk: json['foto_ktp_kk'],
dataLengkap: json['data_lengkap_json'],
status: json['status'],
alasanPenolakan: json['alasan_penolakan'],
);
}
}