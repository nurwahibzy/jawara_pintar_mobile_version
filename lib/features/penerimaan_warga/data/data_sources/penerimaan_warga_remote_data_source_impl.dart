import 'package:jawara_pintar_mobile_version/features/penerimaan_warga/data/models/penerimaan_warga_model.dart';

import 'penerimaan_warga_remote_data_source.dart';

class PenerimaanWargaRemoteDataSourceImpl
    implements PenerimaanWargaRemoteDataSource {
  const PenerimaanWargaRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PenerimaanWargaModel>> getPenerimaanWarga() {
    // TODO: implement getPenerimaanWarga
    throw UnimplementedError();
  }
}
