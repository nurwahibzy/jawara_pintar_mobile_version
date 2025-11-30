import 'broad_cast_remote_data_source.dart';

class BroadCastRemoteDataSourceImpl implements BroadCastRemoteDataSource {
  const BroadCastRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
