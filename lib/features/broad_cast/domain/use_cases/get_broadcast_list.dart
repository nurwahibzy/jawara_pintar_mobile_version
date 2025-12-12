import '../entities/broadcast.dart';
import '../repositories/broadcast_repository.dart';


class GetBroadcastUseCase {
final BroadcastRepository repository;
GetBroadcastUseCase(this.repository);


Future<List<Broadcast>> call() async {
return await repository.getAllBroadcast();
}
}