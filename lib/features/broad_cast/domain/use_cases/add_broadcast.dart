import '../entities/broad_cast.dart';
import '../repositories/broad_cast_repository.dart';

class AddBroadcast {
  final BroadcastRepository repository;

  AddBroadcast(this.repository);

  Future<bool> call(BroadCast entity) {
    return repository.addBroadcast(entity);
  }
}