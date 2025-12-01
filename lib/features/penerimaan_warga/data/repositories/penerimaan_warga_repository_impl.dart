import '../../domain/entities/penerimaan_warga.dart';
import '../../domain/repositories/penerimaan_warga_repository.dart';
import '../data_sources/penerimaan_warga_remote_data_source.dart';

class PenerimaanWargaRepositoryImpl implements PenerimaanWargaRepository {
  final PenerimaanWargaRemoteDataSource remoteDataSource;

  PenerimaanWargaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PenerimaanWarga>> getPenerimaanWarga() async {
    return await remoteDataSource.getPenerimaanWarga();
  }
}
