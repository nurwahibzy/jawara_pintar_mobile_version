import '../../domain/entities/broadcast.dart';


class BroadcastModel extends Broadcast {
BroadcastModel({
required super.id,
required super.judul,
required super.isiPesan,
required super.tanggalPublikasi,
required super.lampiranGambar,
required super.lampiranDokumen,
required super.createdBy, required super.title, required super.content,
});


factory BroadcastModel.fromJson(Map<String, dynamic> json) {
return BroadcastModel(
id: json['id'],
judul: json['judul'],
isiPesan: json['isi_pesan'],
tanggalPublikasi: DateTime.parse(json['tanggal_publikasi']),
lampiranGambar: json['lampiran_gambar'],
lampiranDokumen: json['lampiran_dokumen'],
createdBy: json['created_by'], title: '', content: '',
);
}


Map<String, dynamic> toJson() => {
'id': id,
'judul': judul,
'isi_pesan': isiPesan,
'tanggal_publikasi': tanggalPublikasi.toIso8601String(),
'lampiran_gambar': lampiranGambar,
'lampiran_dokumen': lampiranDokumen,
'created_by': createdBy,
};
}