import '../../domain/repositories/broad_cast_repository.dart';
import '../../domain/entities/broad_cast.dart';

class BroadCastRepositoryImpl implements BroadcastRepository {
  const BroadCastRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addBroadcast(BroadCast broadcast) async {
    // TODO: implement addBroadcast
    throw UnimplementedError();
  }

  @override
  Future<List<BroadCast>> getBroadcastList() async {
    // TODO: implement getBroadcastList
    throw UnimplementedError();
  }
}
