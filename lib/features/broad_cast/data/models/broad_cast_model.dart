import '../../domain/entities/broad_cast.dart';

class BroadCastModel extends BroadCast {
  BroadCastModel({
    required int id,
    required String judul,
    required String pesan,
    required DateTime createdAt,
  }) : super(
    id: id,
    judul: judul,
    pesan: pesan,
    createdAt: createdAt.toIso8601String(),
  );
}
