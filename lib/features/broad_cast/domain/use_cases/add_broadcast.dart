import '../entities/broadcast.dart';
import '../repositories/broadcast_repository.dart';


class AddBroadcastUseCase {
final BroadcastRepository repository;
AddBroadcastUseCase(this.repository);


Future<void> call(Broadcast data) async {
await repository.addBroadcast(data);
}
}