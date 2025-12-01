import '../../domain/entities/pesan_warga.dart';
import '../../domain/repositories/pesan_warga_repository.dart';
import '../datasources/pesan_warga_remote.dart';
import '../models/pesan_warga_model.dart'; 


class AspirasiRepositoryImpl implements AspirasiRepository {
  final AspirasiRemoteDataSource remoteDataSource;

  AspirasiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Aspirasi>> getAllAspirasi() async {
    final models = await remoteDataSource.getAllAspirasi();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Aspirasi> getAspirasiById(int id) async {
    final model = await remoteDataSource.getAspirasiById(id);
    return model.toEntity();
  }

  @override
  Future<void> addAspirasi(Aspirasi aspirasi) async {
    final model = aspirasi.toModel();
    await remoteDataSource.addAspirasi(model);
  }

  @override
  Future<void> updateAspirasi(Aspirasi aspirasi) async {
    final model = aspirasi.toModel();
    await remoteDataSource.updateAspirasi(model);
  }

  @override
  Future<void> deleteAspirasi(int id) async {
    await remoteDataSource.deleteAspirasi(id);
  }
}