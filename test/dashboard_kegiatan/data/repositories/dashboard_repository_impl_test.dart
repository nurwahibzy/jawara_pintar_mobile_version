import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/core/errors/exceptions.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/data/datasources/dashboard_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/data/models/dashboard_kegiatan_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/data/repositories/dashboard_repository_impl.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/entities/kegiatan_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_repository_impl_test.mocks.dart';

@GenerateMocks([DashboardKegiatanRemoteDataSource])
void main() {
  late DashboardKegiatanRepositoryImpl repository;
  late MockDashboardKegiatanRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockDashboardKegiatanRemoteDataSource();
    repository = DashboardKegiatanRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tDashboardKegiatanModel = DashboardKegiatanModel(
    totalKegiatan: 10,
    kegiatanPerKategori: {'Rapat': 5},
    kegiatanBerdasarkanWaktu: {'Hari Ini': 2},
    penanggungJawabTerbanyak: [],
    kegiatanPerBulan: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
  );

  group('getDashboardKegiatan', () {
    test('should return DashboardKegiatanEntity when remote data source is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalKegiatan())
          .thenAnswer((_) async => 10);
      when(mockRemoteDataSource.getKegiatanPerKategori())
          .thenAnswer((_) async => {'Rapat': 5});
      when(mockRemoteDataSource.getKegiatanBerdasarkanWaktu())
          .thenAnswer((_) async => {'Hari Ini': 2});
      when(mockRemoteDataSource.getPenanggungJawabTerbanyak())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getKegiatanPerBulan())
          .thenAnswer((_) async => [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0]);

      // Act
      final result = await repository.getDashboardKegiatan();

      // Assert
      verify(mockRemoteDataSource.getTotalKegiatan());
      expect(result, equals(Right(tDashboardKegiatanModel.toEntity())));
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      // Arrange
      when(mockRemoteDataSource.getTotalKegiatan())
          .thenThrow(ServerException('Server Error'));
      when(mockRemoteDataSource.getKegiatanPerKategori())
          .thenAnswer((_) async => {'Rapat': 5});
      // ... mock others if needed, but one failure is enough

      // Act
      final result = await repository.getDashboardKegiatan();

      // Assert
      expect(result, isA<Left<Failure, DashboardKegiatanEntity>>());
    });
  });
}
