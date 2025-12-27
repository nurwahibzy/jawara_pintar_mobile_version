import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jawara_pintar_mobile_version/core/errors/exceptions.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/data/datasources/pemasukan_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/data/models/pemasukan_model.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/data/repositories/pemasukan_repository_impl.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/domain/entities/pemasukan.dart';

import 'pemasukan_repository_impl_test.mocks.dart';

@GenerateMocks([PemasukanRemoteDataSource])
void main() {
  late PemasukanRepositoryImpl repository;
  late MockPemasukanRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPemasukanRemoteDataSource();
    repository = PemasukanRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  final tPemasukanModel = PemasukanModel(
    id: 1,
    judul: 'Iuran Bulanan',
    kategoriTransaksiId: 1,
    nominal: 100000.0,
    tanggalTransaksi: '2023-01-15',
    buktiFoto: null,
    keterangan: 'Iuran bulanan bulan Januari',
    createdBy: 1,
    verifikatorId: null,
    tanggalVerifikasi: null,
    createdAt: DateTime(2023, 1, 1),
    namaKategori: 'Iuran',
    namaCreatedBy: 'John Doe',
    namaVerifikator: null,
  );

  final tPemasukan = Pemasukan(
    id: 1,
    judul: 'Iuran Bulanan',
    kategoriTransaksiId: 1,
    nominal: 100000.0,
    tanggalTransaksi: '2023-01-15',
    buktiFoto: null,
    keterangan: 'Iuran bulanan bulan Januari',
    createdBy: 1,
    verifikatorId: null,
    tanggalVerifikasi: null,
    createdAt: DateTime(2023, 1, 1),
    namaKategori: 'Iuran',
    namaCreatedBy: 'John Doe',
    namaVerifikator: null,
  );

  group('getPemasukanList', () {
    test(
      'should return list of pemasukan when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanList(
            kategoriFilter: anyNamed('kategoriFilter'),
          ),
        ).thenAnswer((_) async => [tPemasukanModel]);

        // Act
        final result = await repository.getPemasukanList();

        // Assert
        verify(mockRemoteDataSource.getPemasukanList(kategoriFilter: null));
        expect(result, isA<Right<Failure, List<Pemasukan>>>());
        result.fold(
          (failure) => fail('Should be right'),
          (pemasukanList) => expect(pemasukanList, equals([tPemasukanModel])),
        );
      },
    );

    test('should return list of pemasukan with kategori filter', () async {
      // Arrange
      const tKategoriFilter = '1';
      when(
        mockRemoteDataSource.getPemasukanList(
          kategoriFilter: anyNamed('kategoriFilter'),
        ),
      ).thenAnswer((_) async => [tPemasukanModel]);

      // Act
      final result = await repository.getPemasukanList(
        kategoriFilter: tKategoriFilter,
      );

      // Assert
      verify(
        mockRemoteDataSource.getPemasukanList(kategoriFilter: tKategoriFilter),
      );
      expect(result, isA<Right<Failure, List<Pemasukan>>>());
      result.fold(
        (failure) => fail('Should be right'),
        (pemasukanList) => expect(pemasukanList, equals([tPemasukanModel])),
      );
    });

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanList(
            kategoriFilter: anyNamed('kategoriFilter'),
          ),
        ).thenThrow(ServerException('Database error'));

        // Act
        final result = await repository.getPemasukanList();

        // Assert
        verify(mockRemoteDataSource.getPemasukanList(kategoriFilter: null));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );

    test(
      'should return ServerFailure when other exceptions are thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanList(
            kategoriFilter: anyNamed('kategoriFilter'),
          ),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getPemasukanList();

        // Assert
        verify(mockRemoteDataSource.getPemasukanList(kategoriFilter: null));
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should be left'),
        );
      },
    );
  });

  group('getPemasukanDetail', () {
    const tId = 1;

    test(
      'should return pemasukan when call to data source is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanDetail(any),
        ).thenAnswer((_) async => tPemasukanModel);

        // Act
        final result = await repository.getPemasukanDetail(tId);

        // Assert
        verify(mockRemoteDataSource.getPemasukanDetail(tId));
        expect(result, isA<Right<Failure, Pemasukan>>());
        result.fold(
          (failure) => fail('Should be right'),
          (pemasukan) => expect(pemasukan, equals(tPemasukanModel)),
        );
      },
    );

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanDetail(any),
        ).thenThrow(ServerException('Database error'));

        // Act
        final result = await repository.getPemasukanDetail(tId);

        // Assert
        verify(mockRemoteDataSource.getPemasukanDetail(tId));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );

    test(
      'should return ServerFailure when other exceptions are thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getPemasukanDetail(any),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getPemasukanDetail(tId);

        // Assert
        verify(mockRemoteDataSource.getPemasukanDetail(tId));
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should be left'),
        );
      },
    );
  });

  group('createPemasukan', () {
    test('should return unit when create is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.createPemasukan(
          judul: anyNamed('judul'),
          kategoriTransaksiId: anyNamed('kategoriTransaksiId'),
          nominal: anyNamed('nominal'),
          tanggalTransaksi: anyNamed('tanggalTransaksi'),
          buktiFoto: anyNamed('buktiFoto'),
          keterangan: anyNamed('keterangan'),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.createPemasukan(
        judul: 'Iuran Bulanan',
        kategoriTransaksiId: 1,
        nominal: 100000.0,
        tanggalTransaksi: '2023-01-15',
        buktiFoto: null,
        keterangan: 'Iuran bulanan bulan Januari',
      );

      // Assert
      verify(
        mockRemoteDataSource.createPemasukan(
          judul: 'Iuran Bulanan',
          kategoriTransaksiId: 1,
          nominal: 100000.0,
          tanggalTransaksi: '2023-01-15',
          buktiFoto: null,
          keterangan: 'Iuran bulanan bulan Januari',
        ),
      );
      expect(result, equals(const Right(null)));
    });

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.createPemasukan(
            judul: anyNamed('judul'),
            kategoriTransaksiId: anyNamed('kategoriTransaksiId'),
            nominal: anyNamed('nominal'),
            tanggalTransaksi: anyNamed('tanggalTransaksi'),
            buktiFoto: anyNamed('buktiFoto'),
            keterangan: anyNamed('keterangan'),
          ),
        ).thenThrow(ServerException('Database error'));

        // Act
        final result = await repository.createPemasukan(
          judul: 'Iuran Bulanan',
          kategoriTransaksiId: 1,
          nominal: 100000.0,
          tanggalTransaksi: '2023-01-15',
          buktiFoto: null,
          keterangan: 'Iuran bulanan bulan Januari',
        );

        // Assert
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('updatePemasukan', () {
    test('should return unit when update is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.updatePemasukan(
          id: anyNamed('id'),
          judul: anyNamed('judul'),
          kategoriTransaksiId: anyNamed('kategoriTransaksiId'),
          nominal: anyNamed('nominal'),
          tanggalTransaksi: anyNamed('tanggalTransaksi'),
          buktiFoto: anyNamed('buktiFoto'),
          keterangan: anyNamed('keterangan'),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updatePemasukan(
        id: 1,
        judul: 'Iuran Bulanan Updated',
        kategoriTransaksiId: 1,
        nominal: 150000.0,
        tanggalTransaksi: '2023-01-15',
        buktiFoto: null,
        keterangan: 'Iuran bulanan updated',
      );

      // Assert
      verify(
        mockRemoteDataSource.updatePemasukan(
          id: 1,
          judul: 'Iuran Bulanan Updated',
          kategoriTransaksiId: 1,
          nominal: 150000.0,
          tanggalTransaksi: '2023-01-15',
          buktiFoto: null,
          keterangan: 'Iuran bulanan updated',
        ),
      );
      expect(result, equals(const Right(null)));
    });

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.updatePemasukan(
            id: anyNamed('id'),
            judul: anyNamed('judul'),
            kategoriTransaksiId: anyNamed('kategoriTransaksiId'),
            nominal: anyNamed('nominal'),
            tanggalTransaksi: anyNamed('tanggalTransaksi'),
            buktiFoto: anyNamed('buktiFoto'),
            keterangan: anyNamed('keterangan'),
          ),
        ).thenThrow(ServerException('Database error'));

        // Act
        final result = await repository.updatePemasukan(
          id: 1,
          judul: 'Iuran Bulanan Updated',
          kategoriTransaksiId: 1,
          nominal: 150000.0,
          tanggalTransaksi: '2023-01-15',
          buktiFoto: null,
          keterangan: 'Iuran bulanan updated',
        );

        // Assert
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('deletePemasukan', () {
    const tId = 1;

    test('should return unit when delete is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.deletePemasukan(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deletePemasukan(tId);

      // Assert
      verify(mockRemoteDataSource.deletePemasukan(tId));
      expect(result, equals(const Right(null)));
    });

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.deletePemasukan(any),
        ).thenThrow(ServerException('Database error'));

        // Act
        final result = await repository.deletePemasukan(tId);

        // Assert
        verify(mockRemoteDataSource.deletePemasukan(tId));
        expect(result, equals(const Left(ServerFailure('Database error'))));
      },
    );
  });

  group('uploadBukti', () {
    test('should return file path when upload is successful', () async {
      // Arrange
      final tFile = File('test_file.jpg');
      const tFilePath = 'https://example.com/bukti.jpg';

      when(
        mockRemoteDataSource.uploadBukti(any, oldUrl: anyNamed('oldUrl')),
      ).thenAnswer((_) async => tFilePath);

      // Act
      final result = await repository.uploadBukti(tFile);

      // Assert
      verify(mockRemoteDataSource.uploadBukti(tFile, oldUrl: null));
      expect(result, equals(tFilePath));
    });

    test('should pass oldUrl when provided', () async {
      // Arrange
      final tFile = File('test_file.jpg');
      const tOldUrl = 'https://example.com/old_bukti.jpg';
      const tNewPath = 'https://example.com/bukti.jpg';

      when(
        mockRemoteDataSource.uploadBukti(any, oldUrl: anyNamed('oldUrl')),
      ).thenAnswer((_) async => tNewPath);

      // Act
      final result = await repository.uploadBukti(tFile, oldUrl: tOldUrl);

      // Assert
      verify(mockRemoteDataSource.uploadBukti(tFile, oldUrl: tOldUrl));
      expect(result, equals(tNewPath));
    });

    test('should return null when upload fails', () async {
      // Arrange
      final tFile = File('test_file.jpg');

      when(
        mockRemoteDataSource.uploadBukti(any, oldUrl: anyNamed('oldUrl')),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.uploadBukti(tFile);

      // Assert
      expect(result, null);
    });
  });
}
