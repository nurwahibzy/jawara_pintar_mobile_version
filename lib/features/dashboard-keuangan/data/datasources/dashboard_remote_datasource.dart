import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

/// Remote Data Source untuk Dashboard Keuangan
/// Mengambil data dari Supabase: pemasukan_lain, pengeluaran, tagihan
abstract class DashboardRemoteDataSource {
  /// Get total pemasukan by year (dari pemasukan_lain + tagihan)
  Future<double> getTotalPemasukanByYear(String year);
  
  /// Get total pengeluaran by year
  Future<double> getTotalPengeluaranByYear(String year);
  
  /// Get monthly pemasukan (12 bulan)
  Future<List<double>> getMonthlyPemasukan(String year);
  
  /// Get monthly pengeluaran (12 bulan)
  Future<List<double>> getMonthlyPengeluaran(String year);
  
  /// Get kategori pemasukan summary
  Future<Map<String, double>> getKategoriPemasukanSummary(String year);
  
  /// Get kategori pengeluaran summary
  Future<Map<String, double>> getKategoriPengeluaranSummary(String year);
  
  /// Get available years
  Future<List<String>> getAvailableYears();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;

  DashboardRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<double> getTotalPemasukanByYear(String year) async {
    try {
      // 1. Total dari pemasukan_lain
      final pemasukanLainResult = await supabaseClient
          .from('pemasukan_lain')
          .select('nominal')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      double totalPemasukanLain = 0;
      for (var row in pemasukanLainResult) {
        totalPemasukanLain += (row['nominal'] as num?)?.toDouble() ?? 0;
      }

      // 2. Total dari tagihan (iuran warga)
      final tagihanResult = await supabaseClient
          .from('tagihan')
          .select('nominal')
          .gte('periode', '$year-01-01')
          .lte('periode', '$year-12-31')
          .eq('status_tagihan', 'Lunas'); // Hanya yang sudah lunas

      double totalTagihan = 0;
      for (var row in tagihanResult) {
        totalTagihan += (row['nominal'] as num?)?.toDouble() ?? 0;
      }

      return totalPemasukanLain + totalTagihan;
    } catch (e) {
      throw ServerException('Failed to get total pemasukan: $e');
    }
  }

  @override
  Future<double> getTotalPengeluaranByYear(String year) async {
    try {
      final result = await supabaseClient
          .from('pengeluaran')
          .select('nominal')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      double total = 0;
      for (var row in result) {
        total += (row['nominal'] as num?)?.toDouble() ?? 0;
      }

      return total;
    } catch (e) {
      throw ServerException('Failed to get total pengeluaran: $e');
    }
  }

  @override
  Future<List<double>> getMonthlyPemasukan(String year) async {
    try {
      // Initialize dengan 12 bulan (Januari - Desember)
      final List<double> monthlyData = List.filled(12, 0.0);

      // 1. Pemasukan dari pemasukan_lain
      final pemasukanLainResult = await supabaseClient
          .from('pemasukan_lain')
          .select('tanggal_transaksi, nominal')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      for (var row in pemasukanLainResult) {
        final tanggal = DateTime.parse(row['tanggal_transaksi']);
        final bulan = tanggal.month - 1; // 0-11
        final nominal = (row['nominal'] as num?)?.toDouble() ?? 0;
        monthlyData[bulan] += nominal;
      }

      // 2. Pemasukan dari tagihan
      final tagihanResult = await supabaseClient
          .from('tagihan')
          .select('periode, nominal')
          .gte('periode', '$year-01-01')
          .lte('periode', '$year-12-31')
          .eq('status_tagihan', 'Lunas');

      for (var row in tagihanResult) {
        final periode = DateTime.parse(row['periode']);
        final bulan = periode.month - 1; // 0-11
        final nominal = (row['nominal'] as num?)?.toDouble() ?? 0;
        monthlyData[bulan] += nominal;
      }

      return monthlyData;
    } catch (e) {
      throw ServerException('Failed to get monthly pemasukan: $e');
    }
  }

  @override
  Future<List<double>> getMonthlyPengeluaran(String year) async {
    try {
      // Initialize dengan 12 bulan
      final List<double> monthlyData = List.filled(12, 0.0);

      final result = await supabaseClient
          .from('pengeluaran')
          .select('tanggal_transaksi, nominal')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      for (var row in result) {
        final tanggal = DateTime.parse(row['tanggal_transaksi']);
        final bulan = tanggal.month - 1; // 0-11
        final nominal = (row['nominal'] as num?)?.toDouble() ?? 0;
        monthlyData[bulan] += nominal;
      }

      return monthlyData;
    } catch (e) {
      throw ServerException('Failed to get monthly pengeluaran: $e');
    }
  }

  @override
  Future<Map<String, double>> getKategoriPemasukanSummary(String year) async {
    try {
      final Map<String, double> kategoriData = {};

      // 1. Kategori dari pemasukan_lain
      final pemasukanLainResult = await supabaseClient
          .from('pemasukan_lain')
          .select('kategori_transaksi_id, nominal, kategori_transaksi(nama_kategori)')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      for (var row in pemasukanLainResult) {
        final kategori = row['kategori_transaksi'];
        final namaKategori = kategori != null ? kategori['nama_kategori'] as String? : 'Lain-lain';
        final nominal = (row['nominal'] as num?)?.toDouble() ?? 0;

        if (namaKategori != null) {
          kategoriData[namaKategori] = (kategoriData[namaKategori] ?? 0) + nominal;
        }
      }

      // 2. Kategori dari tagihan (semua masuk ke "Iuran")
      final tagihanResult = await supabaseClient
          .from('tagihan')
          .select('nominal')
          .gte('periode', '$year-01-01')
          .lte('periode', '$year-12-31')
          .eq('status_tagihan', 'Lunas');

      double totalIuran = 0;
      for (var row in tagihanResult) {
        totalIuran += (row['nominal'] as num?)?.toDouble() ?? 0;
      }
      if (totalIuran > 0) {
        kategoriData['Iuran Bulanan'] = (kategoriData['Iuran Bulanan'] ?? 0) + totalIuran;
      }

      return kategoriData;
    } catch (e) {
      throw ServerException('Failed to get kategori pemasukan: $e');
    }
  }

  @override
  Future<Map<String, double>> getKategoriPengeluaranSummary(String year) async {
    try {
      final Map<String, double> kategoriData = {};

      final result = await supabaseClient
          .from('pengeluaran')
          .select('kategori_transaksi_id, nominal, kategori_transaksi(nama_kategori)')
          .gte('tanggal_transaksi', '$year-01-01')
          .lte('tanggal_transaksi', '$year-12-31');

      for (var row in result) {
        final kategori = row['kategori_transaksi'];
        final namaKategori = kategori != null ? kategori['nama_kategori'] as String? : 'Lain-lain';
        final nominal = (row['nominal'] as num?)?.toDouble() ?? 0;

        if (namaKategori != null) {
          kategoriData[namaKategori] = (kategoriData[namaKategori] ?? 0) + nominal;
        }
      }

      return kategoriData;
    } catch (e) {
      throw ServerException('Failed to get kategori pengeluaran: $e');
    }
  }

  @override
  Future<List<String>> getAvailableYears() async {
    try {
      final Set<String> years = {};

      // 1. Tahun dari pemasukan_lain
      final pemasukanLainResult = await supabaseClient
          .from('pemasukan_lain')
          .select('tanggal_transaksi')
          .order('tanggal_transaksi', ascending: false)
          .limit(1000);

      for (var row in pemasukanLainResult) {
        final tanggal = DateTime.parse(row['tanggal_transaksi']);
        years.add(tanggal.year.toString());
      }

      // 2. Tahun dari pengeluaran
      final pengeluaranResult = await supabaseClient
          .from('pengeluaran')
          .select('tanggal_transaksi')
          .order('tanggal_transaksi', ascending: false)
          .limit(1000);

      for (var row in pengeluaranResult) {
        final tanggal = DateTime.parse(row['tanggal_transaksi']);
        years.add(tanggal.year.toString());
      }

      // 3. Tahun dari tagihan
      final tagihanResult = await supabaseClient
          .from('tagihan')
          .select('periode')
          .order('periode', ascending: false)
          .limit(1000);

      for (var row in tagihanResult) {
        final periode = DateTime.parse(row['periode']);
        years.add(periode.year.toString());
      }

      // Convert Set to List dan sort descending
      final List<String> sortedYears = years.toList();
      sortedYears.sort((a, b) => b.compareTo(a)); // 2025, 2024, 2023, ...

      return sortedYears;
    } catch (e) {
      throw ServerException('Failed to get available years: $e');
    }
  }
}
