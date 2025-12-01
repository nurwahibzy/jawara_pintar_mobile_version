import '../entities/pesan_warga.dart';
import '../repositories/pesan_warga_repository.dart';

class GetAspirasiByIdUseCase {
  final AspirasiRepository repository;

  GetAspirasiByIdUseCase(this.repository);

  Future<Aspirasi> call(int id) async {
    return await repository.getAspirasiById(id);
  }
}
