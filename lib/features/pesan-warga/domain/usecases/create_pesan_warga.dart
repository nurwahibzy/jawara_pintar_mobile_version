import '../entities/pesan_warga.dart';
import '../repositories/pesan_warga_repository.dart';

class AddAspirasiUseCase {
  final AspirasiRepository repository;

  AddAspirasiUseCase(this.repository);

  Future<void> call(Aspirasi aspirasi) async {
    await repository.addAspirasi(aspirasi);
  }
}
