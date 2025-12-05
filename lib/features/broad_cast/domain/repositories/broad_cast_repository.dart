import '../entities/broad_cast.dart';

abstract class BroadcastRepository {
  Future<List<BroadCast>> getBroadcastList();
  Future<bool> addBroadcast(BroadCast entity);
}
