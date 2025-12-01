import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

/// Remote Data Source untuk Dashboard Kependudukan
abstract class DashboardKependudukanRemoteDataSource {
  Future<int> getTotalKeluarga();
  Future<int> getTotalPenduduk();
  Future<Map<String, int>> getStatusPenduduk();
  Future<Map<String, int>> getJenisKelamin();
  Future<Map<String, int>> getPekerjaanPenduduk();
  Future<Map<String, int>> getPeranDalamKeluarga();
  Future<Map<String, int>> getAgama();
  Future<Map<String, int>> getPendidikan();
}

class DashboardKependudukanRemoteDataSourceImpl
    implements DashboardKependudukanRemoteDataSource {
  final SupabaseClient supabaseClient;

  DashboardKependudukanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<int> getTotalKeluarga() async {
    try {
      final result = await supabaseClient
          .from('keluarga')
          .select('id')
          .count();

      return result.count;
    } catch (e) {
      throw ServerException('Failed to get total keluarga: $e');
    }
  }

  @override
  Future<int> getTotalPenduduk() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('id')
          .count();

      return result.count;
    } catch (e) {
      throw ServerException('Failed to get total penduduk: $e');
    }
  }

  @override
  Future<Map<String, int>> getStatusPenduduk() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('status_penduduk');

      final Map<String, int> statusData = {
        'Aktif': 0,
        'Nonaktif': 0,
      };

      for (var row in result) {
        final status = row['status_penduduk'] as String? ?? 'Aktif';
        statusData[status] = (statusData[status] ?? 0) + 1;
      }

      return statusData;
    } catch (e) {
      throw ServerException('Failed to get status penduduk: $e');
    }
  }

  @override
  Future<Map<String, int>> getJenisKelamin() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('jenis_kelamin');

      final Map<String, int> jenisKelaminData = {
        'Laki-laki': 0,
        'Perempuan': 0,
      };

      for (var row in result) {
        final jenisKelamin = row['jenis_kelamin'] as String?;
        if (jenisKelamin != null) {
          jenisKelaminData[jenisKelamin] = 
              (jenisKelaminData[jenisKelamin] ?? 0) + 1;
        }
      }

      return jenisKelaminData;
    } catch (e) {
      throw ServerException('Failed to get jenis kelamin: $e');
    }
  }

  @override
  Future<Map<String, int>> getPekerjaanPenduduk() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('pekerjaan');

      final Map<String, int> pekerjaanData = {};

      for (var row in result) {
        final pekerjaan = row['pekerjaan'] as String?;
        if (pekerjaan != null && pekerjaan.isNotEmpty) {
          pekerjaanData[pekerjaan] = (pekerjaanData[pekerjaan] ?? 0) + 1;
        }
      }

      return pekerjaanData;
    } catch (e) {
      throw ServerException('Failed to get pekerjaan penduduk: $e');
    }
  }

  @override
  Future<Map<String, int>> getPeranDalamKeluarga() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('status_keluarga');

      final Map<String, int> peranData = {};

      for (var row in result) {
        final peran = row['status_keluarga'] as String?;
        if (peran != null && peran.isNotEmpty) {
          peranData[peran] = (peranData[peran] ?? 0) + 1;
        }
      }

      return peranData;
    } catch (e) {
      throw ServerException('Failed to get peran dalam keluarga: $e');
    }
  }

  @override
  Future<Map<String, int>> getAgama() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('agama');

      final Map<String, int> agamaData = {};

      for (var row in result) {
        final agama = row['agama'] as String?;
        if (agama != null && agama.isNotEmpty) {
          agamaData[agama] = (agamaData[agama] ?? 0) + 1;
        }
      }

      return agamaData;
    } catch (e) {
      throw ServerException('Failed to get agama: $e');
    }
  }

  @override
  Future<Map<String, int>> getPendidikan() async {
    try {
      final result = await supabaseClient
          .from('warga')
          .select('pendidikan_terakhir');

      final Map<String, int> pendidikanData = {};

      for (var row in result) {
        final pendidikan = row['pendidikan_terakhir'] as String?;
        if (pendidikan != null && pendidikan.isNotEmpty) {
          pendidikanData[pendidikan] = (pendidikanData[pendidikan] ?? 0) + 1;
        }
      }

      return pendidikanData;
    } catch (e) {
      throw ServerException('Failed to get pendidikan: $e');
    }
  }
}
