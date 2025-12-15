import '../entities/penerimaan_warga.dart';
import '../repositories/penerimaan_warga_repository.dart';


class GetPenerimaanWarga {
final PenerimaanWargaRepository repository;


GetPenerimaanWarga(this.repository);


Future<List<PenerimaanWarga>> call() async {
return repository.getAllPenerimaanWarga();
}
}