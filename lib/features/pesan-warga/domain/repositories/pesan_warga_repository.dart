import '../entities/pesan_warga.dart';

abstract class AspirasiRepository {
  Future<List<Aspirasi>> getAllAspirasi();
  Future<Aspirasi> getAspirasiById(int id);
  Future<void> addAspirasi(Aspirasi aspirasi);
  Future<void> updateAspirasi(Aspirasi aspirasi);
  Future<void> deleteAspirasi(int id);
}
