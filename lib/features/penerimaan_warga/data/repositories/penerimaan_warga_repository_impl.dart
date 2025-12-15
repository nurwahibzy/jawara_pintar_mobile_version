import '../../domain/entities/penerimaan_warga.dart';
import '../../domain/repositories/penerimaan_warga_repository.dart';
import '../data_sources/penerimaan_warga_remote_data_source.dart';


class PenerimaanWargaRepositoryImpl implements PenerimaanWargaRepository {
final PenerimaanWargaRemoteDataSource remote;


PenerimaanWargaRepositoryImpl(this.remote);


@override
Future<List<PenerimaanWarga>> getAllPenerimaanWarga() async {
return await remote.getAll();
}
}