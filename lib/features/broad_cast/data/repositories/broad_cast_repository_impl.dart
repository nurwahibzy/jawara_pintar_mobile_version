import '../../domain/repositories/broad_cast_repository.dart';

class BroadCastRepositoryImpl implements BroadCastRepository {
  const BroadCastRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
