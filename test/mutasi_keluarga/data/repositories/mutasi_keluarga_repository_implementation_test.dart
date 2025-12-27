import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/datasources/mutasi_keluarga_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/models/mutasi_keluarga_models.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/repositories/mutasi_keluarga_repository_implementation.dart';
import 'mutasi_keluarga_repository_implementation_test.mocks.dart';

@GenerateMocks([MutasiKeluargaDatasource])
void main() {
  late MockMutasiKeluargaDatasource mockDatasource;
  late MutasiKeluargaRepositoryImplementation repository;

  setUp(() {
    mockDatasource = MockMutasiKeluargaDatasource();
    repository = MutasiKeluargaRepositoryImplementation(
      datasource: mockDatasource,
    );
  });

  final tMutasi = MutasiKeluarga(
    id: 1,
    keluargaId: 10,
    jenisMutasi: 'Pindah',
    tanggalMutasi: DateTime(2024, 10, 1),
  );

  final tMutasiModel = MutasiKeluargaModel.fromEntity(tMutasi);

  final tMutasiList = [tMutasi];

  final tKeluargaOptions = [
    {'id': 1, 'nama': 'Keluarga A'}
  ];
  final tRumahOptions = [
    {'id': 1, 'alamat': 'Jl Mawar'}
  ];
  final tWargaOptions = [
    {'id': 1, 'nama': 'Budi'}
  ];

  group('createMutasiKeluarga', () {
    test('harus mengembalikan Right(true) ketika create ke datasource sukses', () async {
      // arrange
      when(mockDatasource.createMutasiKeluarga(tMutasiModel))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.createMutasiKeluarga(tMutasi);

      // assert
      expect(result, const Right(true));
      verify(mockDatasource.createMutasiKeluarga(tMutasiModel)).called(1);
    });

    test('harus mengembalikan Left(ServerFailure) ketika create ke datasource error', () async {
      // arrange
      when(mockDatasource.createMutasiKeluarga(tMutasiModel))
          .thenThrow(Exception('Server error'));

      // act
      final result = await repository.createMutasiKeluarga(tMutasi);

      // assert
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  group('getAllMutasiKeluarga', () {
    test('harus mengembalikan Right(List<MutasiKeluarga>) ketika sukses mengambil all data', () async {
      // arrange
      final tMutasiModelList = tMutasiList.map((e) => MutasiKeluargaModel.fromEntity(e)).toList();
      when(mockDatasource.getAllMutasiKeluarga())
          .thenAnswer((_) async => tMutasiModelList);

      // act
      final result = await repository.getAllMutasiKeluarga();

      // assert
      expect(result, Right(tMutasiModelList));
      verify(mockDatasource.getAllMutasiKeluarga()).called(1);
    });

    test('harus mengembalikan Left(ServerFailure) ketika error', () async {
      // arrange
      when(mockDatasource.getAllMutasiKeluarga())
          .thenThrow(Exception('Error'));

      // act
      final result = await repository.getAllMutasiKeluarga();

      // assert
      expect(result, isA<Left<Failure, List<MutasiKeluarga>>>());
    });
  });

  group('getMutasiKeluarga', () {
    test('harus mengembalikan Right(MutasiKeluarga) ketika sukses mengambil 1 data', () async {
      // arrange
      when(mockDatasource.getMutasiKeluarga(1))
          .thenAnswer((_) async => tMutasiModel);

      // act
      final result = await repository.getMutasiKeluarga(1);

      // assert
      expect(result, Right(tMutasiModel));
      verify(mockDatasource.getMutasiKeluarga(1)).called(1);
    });

    test('harus mengembalikan Left(ServerFailure) ketika error', () async {
      // arrange
      when(mockDatasource.getMutasiKeluarga(1))
          .thenThrow(Exception('Not found'));

      // act
      final result = await repository.getMutasiKeluarga(1);

      // assert
      expect(result, isA<Left<Failure, MutasiKeluarga>>());
    });
  });

  group('getFormDataOptions', () {
    test('harus mengembalikan map form data options ketika sukses', () async {
      // arrange
      when(mockDatasource.getOptionKeluarga())
          .thenAnswer((_) async => tKeluargaOptions);
      when(mockDatasource.getOptionRumah())
          .thenAnswer((_) async => tRumahOptions);
      when(mockDatasource.getOptionWarga())
          .thenAnswer((_) async => tWargaOptions);

      // act
      final result = await repository.getFormDataOptions();

      // assert
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (data) {
          expect(data['keluarga'], tKeluargaOptions);
          expect(data['rumah'], tRumahOptions);
          expect(data['warga'], tWargaOptions);
        },
      );
      verify(mockDatasource.getOptionKeluarga()).called(1);
      verify(mockDatasource.getOptionRumah()).called(1);
      verify(mockDatasource.getOptionWarga()).called(1);
    });

    test('harus mengembalikan Left(ServerFailure) jika getOptionKeluarga error', () async {
      // arrange
      when(mockDatasource.getOptionKeluarga())
          .thenThrow(Exception('Error API'));

      // act
      final result = await repository.getFormDataOptions();

      // assert
      expect(result, isA<Left<Failure, Map<String, List<dynamic>>>>());
    });

    test('harus mengembalikan Left(ServerFailure) jika getOptionRumah error', () async {
      // arrange
      when(mockDatasource.getOptionKeluarga())
          .thenAnswer((_) async => tKeluargaOptions);
      when(mockDatasource.getOptionRumah())
          .thenThrow(Exception('Rumah API error'));

      // act
      final result = await repository.getFormDataOptions();

      // assert
      expect(result, isA<Left<Failure, Map<String, List<dynamic>>>>());
    });

    test('harus mengembalikan Left(ServerFailure) jika getOptionWarga error', () async {
      // arrange
      when(mockDatasource.getOptionKeluarga())
          .thenAnswer((_) async => tKeluargaOptions);
      when(mockDatasource.getOptionRumah())
          .thenAnswer((_) async => tRumahOptions);
      when(mockDatasource.getOptionWarga())
          .thenThrow(Exception('Warga API error'));

      // act
      final result = await repository.getFormDataOptions();

      // assert
      expect(result, isA<Left<Failure, Map<String, List<dynamic>>>>());
    });
  });
}
