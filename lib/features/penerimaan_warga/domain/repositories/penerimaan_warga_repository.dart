import 'package:jawara_pintar_mobile_version/features/penerimaan_warga/domain/entities/penerimaan_warga.dart';

abstract class PenerimaanWargaRepository {
  Future<List<PenerimaanWarga>> getPenerimaanWarga();
}
