/// Interface untuk network connectivity checker
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation sederhana NetworkInfo
/// Dalam implementasi production, gunakan package seperti connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Untuk saat ini, asumsikan selalu terkoneksi
    // TODO: Implementasi dengan connectivity_plus package
    return true;
  }
}
