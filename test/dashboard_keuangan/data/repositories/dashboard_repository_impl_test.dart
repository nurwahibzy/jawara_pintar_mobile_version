import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/core/errors/exceptions.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/data/datasources/dashboard_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/data/models/dashboard_summary_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/data/repositories/dashboard_repository_impl.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/entities/keuangan_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_repository_impl_test.mocks.dart';

@GenerateMocks([DashboardRemoteDataSource])
void main() {
  late DashboardKeuanganRepositoryImpl repository;
  late MockDashboardRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockDashboardRemoteDataSource();
    repository = DashboardKeuanganRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tYear = '2025';
  const tDashboardSummaryModel = DashboardSummaryModel(
    year: tYear,
    totalPemasukan: 1000000,
    totalPengeluaran: 500000,
    saldo: 500000,
    monthlyPemasukan: [100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 0, 0],
    monthlyPengeluaran: [50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 0, 0],
    kategoriPemasukan: {'Lainnya': 1000000},
    kategoriPengeluaran: {'Lainnya': 500000},
    availableYears: ['2024', '2025'],
  );

  group('getDashboardSummary', () {
    test('should return DashboardSummaryEntity when remote data source is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalPemasukanByYear(tYear))
          .thenAnswer((_) async => 1000000.0);
      when(mockRemoteDataSource.getTotalPengeluaranByYear(tYear))
          .thenAnswer((_) async => 500000.0);
      when(mockRemoteDataSource.getMonthlyPemasukan(tYear))
          .thenAnswer((_) async => [100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 0.0, 0.0]);
      when(mockRemoteDataSource.getMonthlyPengeluaran(tYear))
          .thenAnswer((_) async => [50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 50000.0, 0.0, 0.0]);
      when(mockRemoteDataSource.getKategoriPemasukanSummary(tYear))
          .thenAnswer((_) async => {'Lainnya': 1000000.0});
      when(mockRemoteDataSource.getKategoriPengeluaranSummary(tYear))
          .thenAnswer((_) async => {'Lainnya': 500000.0});
      when(mockRemoteDataSource.getAvailableYears())
          .thenAnswer((_) async => ['2024', '2025']);

      // Act
      final result = await repository.getDashboardSummary(tYear);

      // Assert
      verify(mockRemoteDataSource.getTotalPemasukanByYear(tYear));
      verify(mockRemoteDataSource.getTotalPengeluaranByYear(tYear));
      expect(result, equals(Right(tDashboardSummaryModel.toEntity())));
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalPemasukanByYear(tYear))
          .thenThrow(ServerException('Server Error'));
      when(mockRemoteDataSource.getTotalPengeluaranByYear(tYear))
          .thenAnswer((_) async => 500000.0); // Others might be called in parallel, but one fails
      // Note: Future.wait behavior depends on implementation. If one fails, it throws.
      // We need to mock all to be safe or just the one that fails if we know the order/behavior.
      // Since it's Future.wait, if one throws, the whole thing throws.
      
      // Act
      final result = await repository.getDashboardSummary(tYear);

      // Assert
      expect(result, isA<Left<Failure, DashboardSummaryEntity>>());
    });
  });

  group('getAvailableYears', () {
    test('should return list of years when remote data source is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getAvailableYears())
          .thenAnswer((_) async => ['2024', '2025']);

      // Act
      final result = await repository.getAvailableYears();

      // Assert
      verify(mockRemoteDataSource.getAvailableYears());
      expect(result, equals(const Right(['2024', '2025'])));
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // Arrange
      when(mockRemoteDataSource.getAvailableYears())
          .thenThrow(ServerException('Server Error'));

      // Act
      final result = await repository.getAvailableYears();

      // Assert
      expect(result, isA<Left<Failure, List<String>>>());
    });
  });
}
