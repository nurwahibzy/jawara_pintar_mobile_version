import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/core/errors/exceptions.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/data/datasources/dashboard_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/data/models/dashboard_kependudukan_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/data/repositories/dashboard_repository_impl.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/entities/kependudukan_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_repository_impl_test.mocks.dart';

@GenerateMocks([DashboardKependudukanRemoteDataSource])
void main() {
  late DashboardKependudukanRepositoryImpl repository;
  late MockDashboardKependudukanRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockDashboardKependudukanRemoteDataSource();
    repository = DashboardKependudukanRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tDashboardKependudukanModel = DashboardKependudukanModel(
    totalKeluarga: 10,
    totalPenduduk: 40,
    statusPenduduk: {'Aktif': 40},
    jenisKelamin: {'Laki-laki': 20, 'Perempuan': 20},
    pekerjaanPenduduk: {'PNS': 5},
    peranDalamKeluarga: {'Kepala Keluarga': 10},
    agama: {'Islam': 40},
    pendidikan: {'S1': 10},
  );

  group('getDashboardKependudukan', () {
    test('should return DashboardKependudukanEntity when remote data source is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalKeluarga())
          .thenAnswer((_) async => 10);
      when(mockRemoteDataSource.getTotalPenduduk())
          .thenAnswer((_) async => 40);
      when(mockRemoteDataSource.getStatusPenduduk())
          .thenAnswer((_) async => {'Aktif': 40});
      when(mockRemoteDataSource.getJenisKelamin())
          .thenAnswer((_) async => {'Laki-laki': 20, 'Perempuan': 20});
      when(mockRemoteDataSource.getPekerjaanPenduduk())
          .thenAnswer((_) async => {'PNS': 5});
      when(mockRemoteDataSource.getPeranDalamKeluarga())
          .thenAnswer((_) async => {'Kepala Keluarga': 10});
      when(mockRemoteDataSource.getAgama())
          .thenAnswer((_) async => {'Islam': 40});
      when(mockRemoteDataSource.getPendidikan())
          .thenAnswer((_) async => {'S1': 10});

      // Act
      final result = await repository.getDashboardKependudukan();

      // Assert
      verify(mockRemoteDataSource.getTotalKeluarga());
      expect(result, equals(Right(tDashboardKependudukanModel.toEntity())));
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalKeluarga())
          .thenThrow(ServerException('Server Error'));
      when(mockRemoteDataSource.getTotalPenduduk())
          .thenAnswer((_) async => 40);
      // ... mock others if needed

      // Act
      final result = await repository.getDashboardKependudukan();

      // Assert
      expect(result, isA<Left<Failure, DashboardKependudukanEntity>>());
    });
  });
}
