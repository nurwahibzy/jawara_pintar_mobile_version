import '../repositories/pesan_warga_repository.dart';

class DeleteAspirasiUseCase {
  final AspirasiRepository repository;

  DeleteAspirasiUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteAspirasi(id);
  }
}
