import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/kegiatan_entity.dart';

/// Remote Data Source untuk Dashboard Kegiatan
abstract class DashboardKegiatanRemoteDataSource {
  Future<int> getTotalKegiatan();
  Future<Map<String, int>> getKegiatanPerKategori();
  Future<Map<String, int>> getKegiatanBerdasarkanWaktu();
  Future<List<PenanggungJawabEntity>> getPenanggungJawabTerbanyak();
  Future<List<int>> getKegiatanPerBulan();
}

class DashboardKegiatanRemoteDataSourceImpl implements DashboardKegiatanRemoteDataSource {
  final SupabaseClient supabaseClient;

  DashboardKegiatanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<int> getTotalKegiatan() async {
    try {
      final result = await supabaseClient
          .from('kegiatan')
          .select('id')
          .count();

      return result.count;
    } catch (e) {
      throw ServerException('Failed to get total kegiatan: $e');
    }
  }

  @override
  Future<Map<String, int>> getKegiatanPerKategori() async {
    try {
      final result = await supabaseClient
          .from('kegiatan')
          .select('kategori_kegiatan_id, kategori_kegiatan(nama_kategori)');

      final Map<String, int> kategoriData = {};

      for (var row in result) {
        final kategori = row['kategori_kegiatan'];
        final namaKategori = kategori != null 
            ? kategori['nama_kategori'] as String? ?? 'Lainnya'
            : 'Lainnya';

        kategoriData[namaKategori] = (kategoriData[namaKategori] ?? 0) + 1;
      }

      return kategoriData;
    } catch (e) {
      throw ServerException('Failed to get kegiatan per kategori: $e');
    }
  }

  @override
  Future<Map<String, int>> getKegiatanBerdasarkanWaktu() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final result = await supabaseClient
          .from('kegiatan')
          .select('tanggal_pelaksanaan');

      final Map<String, int> waktuData = {
        'Sudah Lewat': 0,
        'Hari Ini': 0,
        'Akan Datang': 0,
      };

      for (var row in result) {
        final tanggalStr = row['tanggal_pelaksanaan'] as String?;
        if (tanggalStr != null) {
          final tanggal = DateTime.parse(tanggalStr);
          final tanggalOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);

          if (tanggalOnly.isBefore(today)) {
            waktuData['Sudah Lewat'] = waktuData['Sudah Lewat']! + 1;
          } else if (tanggalOnly.isAtSameMomentAs(today)) {
            waktuData['Hari Ini'] = waktuData['Hari Ini']! + 1;
          } else {
            waktuData['Akan Datang'] = waktuData['Akan Datang']! + 1;
          }
        }
      }

      return waktuData;
    } catch (e) {
      throw ServerException('Failed to get kegiatan berdasarkan waktu: $e');
    }
  }

  @override
  Future<List<PenanggungJawabEntity>> getPenanggungJawabTerbanyak() async {
    try {
      final result = await supabaseClient
          .from('kegiatan')
          .select('penanggung_jawab');

      final Map<String, int> penanggungJawabCount = {};

      for (var row in result) {
        final penanggungJawab = row['penanggung_jawab'] as String?;
        if (penanggungJawab != null && penanggungJawab.isNotEmpty) {
          penanggungJawabCount[penanggungJawab] = 
              (penanggungJawabCount[penanggungJawab] ?? 0) + 1;
        }
      }

      // Sort by jumlah descending dan ambil top 5
      final sortedList = penanggungJawabCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedList
          .take(5)
          .map((entry) => PenanggungJawabEntity(
                nama: entry.key,
                jumlah: entry.value,
              ))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get penanggung jawab terbanyak: $e');
    }
  }

  @override
  Future<List<int>> getKegiatanPerBulan() async {
    try {
      final now = DateTime.now();
      final currentYear = now.year;

      final result = await supabaseClient
          .from('kegiatan')
          .select('tanggal_pelaksanaan')
          .gte('tanggal_pelaksanaan', '$currentYear-01-01')
          .lte('tanggal_pelaksanaan', '$currentYear-12-31');

      // Initialize dengan 12 bulan
      final List<int> monthlyData = List.filled(12, 0);

      for (var row in result) {
        final tanggalStr = row['tanggal_pelaksanaan'] as String?;
        if (tanggalStr != null) {
          final tanggal = DateTime.parse(tanggalStr);
          final bulan = tanggal.month - 1; // 0-11
          monthlyData[bulan] += 1;
        }
      }

      return monthlyData;
    } catch (e) {
      throw ServerException('Failed to get kegiatan per bulan: $e');
    }
  }
}
