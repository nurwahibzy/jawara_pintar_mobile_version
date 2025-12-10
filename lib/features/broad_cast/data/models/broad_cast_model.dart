import '../../domain/entities/broad_cast.dart';

class BroadcastModel extends BroadCast {
  BroadcastModel({
    int? id,
    String? lampiranGambar,
    String? lampiranDokumen,
    required int createdBy,
    required String judul,
    required String pesan,
    required String createdAt,
  }) : super(
          id: id ?? 0,
          lampiranGambar: lampiranGambar,
          lampiranDokumen: lampiranDokumen,
          judul: judul,
          pesan: pesan,
          createdAt: createdAt,
          createdBy: createdBy,
        );

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'],
      lampiranGambar: json['lampiran_gambar'],
      lampiranDokumen: json['lampiran_dokumen'],
      createdBy: json['created_by'],
      judul: json['judul'],
      pesan: json['pesan'],
      createdAt: json['created_at'],
    );
  }
  
  get lampiranGambar => null;
  
  get lampiranDokumen => null;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lampiran_gambar': lampiranGambar,
      'lampiran_dokumen': lampiranDokumen,
      'created_by': createdAt,
      'judul': judul,
      'pesan': pesan,
      'created_at': createdAt,
    };
  }
}

// class BroadCastModel extends BroadCast {
//   BroadCastModel({
//     required int id,
//     required String judul,
//     required String pesan,
//     required DateTime createdAt,
//   }) : super(
//     id: id,
//     judul: judul,
//     pesan: pesan,
//     createdAt: createdAt.toIso8601String(),
//   );
// }
