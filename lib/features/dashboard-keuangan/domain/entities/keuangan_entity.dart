import 'package:equatable/equatable.dart';

/// Entity untuk Dashboard Summary (READ-ONLY)
/// Mewakili aggregate data dari query database Supabase
/// Data diambil dari tabel: pemasukan_lain, pengeluaran, tagihan
class DashboardSummaryEntity extends Equatable {
  final String year;
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldo;
  
  // Data monthly (index 0 = Januari, index 11 = Desember)
  final List<double> monthlyPemasukan; // 12 bulan
  final List<double> monthlyPengeluaran; // 12 bulan
  
  // Data per kategori (nama kategori : total jumlah)
  final Map<String, double> kategoriPemasukan;
  final Map<String, double> kategoriPengeluaran;
  
  // Available years untuk dropdown
  final List<String> availableYears;

  const DashboardSummaryEntity({
    required this.year,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldo,
    required this.monthlyPemasukan,
    required this.monthlyPengeluaran,
    required this.kategoriPemasukan,
    required this.kategoriPengeluaran,
    required this.availableYears,
  });

  @override
  List<Object?> get props => [
        year,
        totalPemasukan,
        totalPengeluaran,
        saldo,
        monthlyPemasukan,
        monthlyPengeluaran,
        kategoriPemasukan,
        kategoriPengeluaran,
        availableYears,
      ];

  // ========================================
  // BUSINESS LOGIC METHODS
  // ========================================
  
  /// Format total pemasukan ke currency
  String getFormattedTotalPemasukan() {
    return _formatCurrency(totalPemasukan);
  }

  /// Format total pengeluaran ke currency
  String getFormattedTotalPengeluaran() {
    return _formatCurrency(totalPengeluaran);
  }

  /// Format saldo ke currency
  String getFormattedSaldo() {
    return _formatCurrency(saldo);
  }

  /// Get average pemasukan per bulan
  double getAveragePemasukan() {
    if (monthlyPemasukan.isEmpty) return 0;
    return totalPemasukan / 12;
  }

  /// Get average pengeluaran per bulan
  double getAveragePengeluaran() {
    if (monthlyPengeluaran.isEmpty) return 0;
    return totalPengeluaran / 12;
  }

  /// Get percentage saldo dari total pemasukan
  String getPercentageSaldo() {
    if (totalPemasukan == 0) return '0%';
    return '${((saldo / totalPemasukan) * 100).toStringAsFixed(1)}%';
  }

  /// Check apakah saldo positif
  bool hasPositiveBalance() => saldo > 0;

  /// Check apakah ada data
  bool hasData() {
    return totalPemasukan > 0 || totalPengeluaran > 0;
  }

  /// Get bulan dengan pemasukan tertinggi (1-12)
  int getHighestIncomeMonth() {
    if (monthlyPemasukan.isEmpty) return 0;
    
    double maxIncome = 0;
    int maxMonth = 0;
    
    for (var i = 0; i < monthlyPemasukan.length; i++) {
      if (monthlyPemasukan[i] > maxIncome) {
        maxIncome = monthlyPemasukan[i];
        maxMonth = i + 1; // 1 = Januari, 2 = Februari, dst
      }
    }
    
    return maxMonth;
  }

  /// Get nama bulan dengan pemasukan tertinggi
  String getHighestIncomeMonthName() {
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final monthIndex = getHighestIncomeMonth();
    if (monthIndex == 0) return '-';
    return monthNames[monthIndex - 1];
  }

  /// Private helper untuk format currency
  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return 'Rp${(amount / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)} Juta';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)} Ribu';
    }
    return 'Rp${amount.toStringAsFixed(0)}';
  }

  /// Copy with method untuk immutability
  DashboardSummaryEntity copyWith({
    String? year,
    double? totalPemasukan,
    double? totalPengeluaran,
    double? saldo,
    List<double>? monthlyPemasukan,
    List<double>? monthlyPengeluaran,
    Map<String, double>? kategoriPemasukan,
    Map<String, double>? kategoriPengeluaran,
    List<String>? availableYears,
  }) {
    return DashboardSummaryEntity(
      year: year ?? this.year,
      totalPemasukan: totalPemasukan ?? this.totalPemasukan,
      totalPengeluaran: totalPengeluaran ?? this.totalPengeluaran,
      saldo: saldo ?? this.saldo,
      monthlyPemasukan: monthlyPemasukan ?? this.monthlyPemasukan,
      monthlyPengeluaran: monthlyPengeluaran ?? this.monthlyPengeluaran,
      kategoriPemasukan: kategoriPemasukan ?? this.kategoriPemasukan,
      kategoriPengeluaran: kategoriPengeluaran ?? this.kategoriPengeluaran,
      availableYears: availableYears ?? this.availableYears,
    );
  }
}