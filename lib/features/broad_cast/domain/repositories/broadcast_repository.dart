import '../entities/broadcast.dart';


abstract class BroadcastRepository {
Future<List<Broadcast>> getAllBroadcast();
Future<void> addBroadcast(Broadcast data);
}