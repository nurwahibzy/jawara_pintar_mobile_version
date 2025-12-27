import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/datasources/pesan_warga_remote.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/models/pesan_warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/repositories/pesan_warga_impl.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/domain/entities/pesan_warga.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pesan_warga_repository_impl_test.mocks.dart';

@GenerateMocks([AspirasiRemoteDataSource])
void main() {
  late AspirasiRepositoryImpl repository;
  late MockAspirasiRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAspirasiRemoteDataSource();
    repository = AspirasiRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tAspirasiModel = AspirasiModel(
    id: 1,
    wargaId: 10,
    judul: 'Lampu Rusak',
    deskripsi: 'Lampu mati',
    status: StatusAspirasi.Pending,
    createdAt: DateTime(2023, 1, 1),
  );

  final tAspirasi = Aspirasi(
    id: 1,
    wargaId: 10,
    judul: 'Lampu Rusak',
    deskripsi: 'Lampu mati',
    status: StatusAspirasi.Pending,
    createdAt: DateTime(2023, 1, 1),
  );

  // =====================================================
  // GET ALL ASPIRASI
  // =====================================================
  group('getAllAspirasi', () {
    test(
      'POSITIVE: should return list of aspirasi when datasource succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllAspirasi(),
        ).thenAnswer((_) async => [tAspirasiModel]);

        // Act
        final result = await repository.getAllAspirasi();

        // Assert
        verify(mockRemoteDataSource.getAllAspirasi()).called(1);
        expect(result, isA<List<Aspirasi>>());
        expect(result.first.id, tAspirasi.id);
      },
    );

    test(
      'NEGATIVE: should throw exception when datasource throws error',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllAspirasi(),
        ).thenThrow(Exception('DB Error'));

        // Act & Assert
        expect(() => repository.getAllAspirasi(), throwsException);
      },
    );
  });

  // =====================================================
  // GET ASPIRASI BY ID
  // =====================================================
  group('getAspirasiById', () {
    test('POSITIVE: should return aspirasi when datasource succeeds', () async {
      // Arrange
      when(
        mockRemoteDataSource.getAspirasiById(1),
      ).thenAnswer((_) async => tAspirasiModel);

      // Act
      final result = await repository.getAspirasiById(1);

      // Assert
      verify(mockRemoteDataSource.getAspirasiById(1)).called(1);
      expect(result.id, 1);
      expect(result.judul, tAspirasi.judul);
    });

    test('NEGATIVE: should throw exception when datasource fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getAspirasiById(1),
      ).thenThrow(Exception('DB Error'));

      // Act & Assert
      expect(() => repository.getAspirasiById(1), throwsException);
    });
  });

  // =====================================================
  // ADD ASPIRASI
  // =====================================================
  group('addAspirasi', () {
    test('NEGATIVE: should throw error when user not logged in', () async {
      expect(
        () => repository.addAspirasi(tAspirasi),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
  'NEGATIVE: should NOT call datasource when auth fails',
  () async {
    expect(
      () => repository.addAspirasi(tAspirasi),
      throwsA(isA<AssertionError>()),
    );

    verifyNever(mockRemoteDataSource.addAspirasi(any));
  },
);
  });

  // =====================================================
  // UPDATE ASPIRASI
  // =====================================================
  group('updateAspirasi', () {
    test('NEGATIVE: should throw error when user not logged in', () async {
      expect(
        () => repository.updateAspirasi(tAspirasi),
        throwsA(isA<AssertionError>()),
      );
    });


    test(
  'NEGATIVE: should NOT call datasource when auth fails',
  () async {
    expect(
      () => repository.updateAspirasi(tAspirasi),
      throwsA(isA<AssertionError>()),
    );

    verifyNever(mockRemoteDataSource.updateAspirasi(any));
  },
);
  });

  // =====================================================
  // DELETE ASPIRASI
  // =====================================================
  group('deleteAspirasi', () {
    test('POSITIVE: should call deleteAspirasi on datasource', () async {
      // Arrange
      when(
        mockRemoteDataSource.deleteAspirasi(1),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.deleteAspirasi(1);

      // Assert
      verify(mockRemoteDataSource.deleteAspirasi(1)).called(1);
    });

    test('NEGATIVE: should throw exception when datasource fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.deleteAspirasi(1),
      ).thenThrow(Exception('DB Error'));

      // Act & Assert
      expect(() => repository.deleteAspirasi(1), throwsException);
    });
  });
}