import 'package:jawara_pintar_mobile_version/features/penerimaan_warga/domain/entities/penerimaan_warga.dart' show PenerimaanWarga;

import '../repositories/penerimaan_warga_repository.dart';

class GetPenerimaanWarga {
  final PenerimaanWargaRepository repository;

  GetPenerimaanWarga(this.repository);

  Future<List<PenerimaanWarga>> call() async {
    return await repository.getPenerimaanWarga();
  }
}
