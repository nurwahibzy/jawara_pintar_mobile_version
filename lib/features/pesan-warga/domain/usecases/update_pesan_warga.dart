import '../entities/pesan_warga.dart';
import '../repositories/pesan_warga_repository.dart';

class UpdateAspirasiUseCase {
  final AspirasiRepository repository;

  UpdateAspirasiUseCase(this.repository);

  Future<void> call(Aspirasi aspirasi) async {
    await repository.updateAspirasi(aspirasi);
  }
}
