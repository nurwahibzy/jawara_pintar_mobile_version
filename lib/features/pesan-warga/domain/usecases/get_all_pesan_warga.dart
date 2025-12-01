import '../repositories/pesan_warga_repository.dart';
import '../entities/pesan_warga.dart';

class GetAllAspirasi {
  final AspirasiRepository repository;

  GetAllAspirasi(this.repository);

  Future<List<Aspirasi>> execute() async {
    return repository.getAllAspirasi();
  }
}
