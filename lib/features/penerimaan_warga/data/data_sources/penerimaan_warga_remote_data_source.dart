import '../models/penerimaan_warga_model.dart';


abstract class PenerimaanWargaRemoteDataSource {
Future<List<PenerimaanWargaModel>> getAll();
}