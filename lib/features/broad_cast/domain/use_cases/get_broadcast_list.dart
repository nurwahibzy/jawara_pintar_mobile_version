import '../entities/broad_cast.dart';
import '../repositories/broad_cast_repository.dart';

class GetBroadcastList {
  final BroadcastRepository repository;

  GetBroadcastList(this.repository);

  Future<List<BroadCast>> call() {
    return repository.getBroadcastList();
  }
}
