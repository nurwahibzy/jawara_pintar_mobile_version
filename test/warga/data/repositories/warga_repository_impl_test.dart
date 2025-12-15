import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/datasources/warga_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/keluarga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/repositories/warga_repository_impl.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';

import 'warga_repository_impl_test.mocks.dart';

@GenerateMocks([WargaRemoteDataSource])
void main() {
  late WargaRepositoryImpl repository;
  late MockWargaRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockWargaRemoteDataSource();
    repository = WargaRepositoryImpl(mockRemoteDataSource);
  });

  final tWargaModel = WargaModel(
    idWarga: 1,
    keluargaId: null,
    nik: '1234567890123456',
    nama: 'John Doe',
    nomorTelepon: '08123456789',
    tempatLahir: 'Jakarta',
    tanggalLahir: DateTime(1990, 1, 1),
    jenisKelamin: 'L',
    agama: 'Islam',
    golonganDarah: 'O',
    statusKeluarga: 'Kepala Keluarga',
    pendidikanTerakhir: 'S1',
    pekerjaan: 'Karyawan Swasta',
    statusPenduduk: 'Tetap',
    statusHidup: 'Hidup',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  final tWarga = Warga(
    idWarga: 1,
    keluargaId: null,
    nik: '1234567890123456',
    nama: 'John Doe',
    nomorTelepon: '08123456789',
    tempatLahir: 'Jakarta',
    tanggalLahir: DateTime(1990, 1, 1),
    jenisKelamin: 'L',
    agama: 'Islam',
    golonganDarah: 'O',
    statusKeluarga: 'Kepala Keluarga',
    pendidikanTerakhir: 'S1',
    pekerjaan: 'Karyawan Swasta',
    statusPenduduk: 'Tetap',
    statusHidup: 'Hidup',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  final tKeluargaModel = KeluargaModel(
    id: 1,
    nomorKk: '1234567890123456',
    statusHunian: 'Kontrak',
  );

  final tKeluarga = Keluarga(
    id: 1,
    nomorKk: '1234567890123456',
    statusHunian: 'Kontrak',
  );

  group('getAllWarga', () {
    test(
      'should return list of warga when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllWarga(),
        ).thenAnswer((_) async => [tWargaModel]);

        // Act
        final result = await repository.getAllWarga();

        // Assert
        verify(mockRemoteDataSource.getAllWarga());
        expect(result, isA<Right<Failure, List<WargaModel>>>());
        result.fold(
          (failure) => fail('Should be right'),
          (wargaList) => expect(wargaList, equals([tWargaModel])),
        );
      },
    );

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllWarga(),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.getAllWarga();

        // Assert
        verify(mockRemoteDataSource.getAllWarga());
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );

    test(
      'should return NetworkFailure when SocketException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllWarga(),
        ).thenThrow(const SocketException('No internet'));

        // Act
        final result = await repository.getAllWarga();

        // Assert
        verify(mockRemoteDataSource.getAllWarga());
        expect(
          result,
          equals(const Left(NetworkFailure('Tidak ada koneksi internet'))),
        );
      },
    );

    test(
      'should return NetworkFailure for connection related exceptions',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllWarga(),
        ).thenThrow(Exception('connection failed'));

        // Act
        final result = await repository.getAllWarga();

        // Assert
        verify(mockRemoteDataSource.getAllWarga());
        expect(
          result,
          equals(const Left(NetworkFailure('Tidak ada koneksi internet'))),
        );
      },
    );

    test('should return ServerFailure for other exceptions', () async {
      // Arrange
      when(
        mockRemoteDataSource.getAllWarga(),
      ).thenThrow(Exception('Unknown error'));

      // Act
      final result = await repository.getAllWarga();

      // Assert
      verify(mockRemoteDataSource.getAllWarga());
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be left'),
      );
    });
  });

  group('getWarga', () {
    const tId = 1;

    test(
      'should return warga when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getWargaById(any),
        ).thenAnswer((_) async => tWargaModel);

        // Act
        final result = await repository.getWarga(tId);

        // Assert
        verify(mockRemoteDataSource.getWargaById(tId));
        expect(result, isA<Right<Failure, Warga>>());
        result.fold(
          (failure) => fail('Should be right'),
          (warga) => expect(warga, equals(tWargaModel)),
        );
      },
    );

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getWargaById(any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.getWarga(tId);

        // Assert
        verify(mockRemoteDataSource.getWargaById(tId));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('createWarga', () {
    test('should return true when create is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.createWarga(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.createWarga(tWarga);

      // Assert
      verify(mockRemoteDataSource.createWarga(any));
      expect(result, equals(const Right(true)));
    });

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.createWarga(any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.createWarga(tWarga);

        // Assert
        verify(mockRemoteDataSource.createWarga(any));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('updateWarga', () {
    test('should return true when update is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.updateWarga(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateWarga(tWarga);

      // Assert
      verify(mockRemoteDataSource.updateWarga(any));
      expect(result, equals(const Right(true)));
    });

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.updateWarga(any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.updateWarga(tWarga);

        // Assert
        verify(mockRemoteDataSource.updateWarga(any));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('filterWarga', () {
    final tParams = FilterWargaParams(nama: 'John');

    test('should return list of warga when filter is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.filterWarga(any),
      ).thenAnswer((_) async => [tWargaModel]);

      // Act
      final result = await repository.filterWarga(tParams);

      // Assert
      verify(mockRemoteDataSource.filterWarga(tParams));
      expect(result, isA<Right<Failure, List<Warga>>>());
      result.fold(
        (failure) => fail('Should be right'),
        (wargaList) => expect(wargaList, equals([tWargaModel])),
      );
    });

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.filterWarga(any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.filterWarga(tParams);

        // Assert
        verify(mockRemoteDataSource.filterWarga(tParams));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('getAllKeluarga', () {
    test(
      'should return list of keluarga when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllKeluarga(),
        ).thenAnswer((_) async => [tKeluargaModel]);

        // Act
        final result = await repository.getAllKeluarga();

        // Assert
        verify(mockRemoteDataSource.getAllKeluarga());
        expect(result, isA<Right<Failure, List<Keluarga>>>());
        result.fold(
          (failure) => fail('Should be right'),
          (keluargaList) => expect(keluargaList, equals([tKeluargaModel])),
        );
      },
    );

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllKeluarga(),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.getAllKeluarga();

        // Assert
        verify(mockRemoteDataSource.getAllKeluarga());
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('createKeluarga', () {
    test('should return keluarga id when create is successful', () async {
      // Arrange
      const tKeluargaId = 1;
      when(
        mockRemoteDataSource.createKeluarga(any),
      ).thenAnswer((_) async => tKeluargaId);

      // Act
      final result = await repository.createKeluarga(tKeluarga);

      // Assert
      verify(mockRemoteDataSource.createKeluarga(any));
      expect(result, equals(const Right(tKeluargaId)));
    });

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.createKeluarga(any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.createKeluarga(tKeluarga);

        // Assert
        verify(mockRemoteDataSource.createKeluarga(any));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('updateWargaKeluargaId', () {
    const tWargaIds = [1, 2, 3];
    const tKeluargaId = 1;

    test('should return true when update is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.updateWargaKeluargaId(any, any),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateWargaKeluargaId(
        tWargaIds,
        tKeluargaId,
      );

      // Assert
      verify(
        mockRemoteDataSource.updateWargaKeluargaId(tWargaIds, tKeluargaId),
      );
      expect(result, equals(const Right(true)));
    });

    test(
      'should return ServerFailure when PostgrestException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.updateWargaKeluargaId(any, any),
        ).thenThrow(const PostgrestException(message: 'Database error'));

        // Act
        final result = await repository.updateWargaKeluargaId(
          tWargaIds,
          tKeluargaId,
        );

        // Assert
        verify(
          mockRemoteDataSource.updateWargaKeluargaId(tWargaIds, tKeluargaId),
        );
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('getWargaTanpaKeluarga', () {
    test(
      'should return list of warga without keluarga when successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getWargaTanpaKeluarga(),
        ).thenAnswer((_) async => [tWargaModel]);

        // Act
        final result = await repository.getWargaTanpaKeluarga();

        // Assert
        verify(mockRemoteDataSource.getWargaTanpaKeluarga());
        expect(result, isA<Right<Failure, List<Warga>>>());
        result.fold(
          (failure) => fail('Should be right'),
          (wargaList) => expect(wargaList, equals([tWargaModel])),
        );
      },
    );

    test(
      'should return NetworkFailure when SocketException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getWargaTanpaKeluarga(),
        ).thenThrow(const SocketException('No internet'));

        // Act
        final result = await repository.getWargaTanpaKeluarga();

        // Assert
        verify(mockRemoteDataSource.getWargaTanpaKeluarga());
        expect(
          result,
          equals(const Left(NetworkFailure('Tidak ada koneksi internet'))),
        );
      },
    );
  });
}
