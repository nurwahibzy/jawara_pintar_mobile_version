import '../entities/penerimaan_warga.dart';


abstract class PenerimaanWargaRepository {
Future<List<PenerimaanWarga>> getAllPenerimaanWarga();
}