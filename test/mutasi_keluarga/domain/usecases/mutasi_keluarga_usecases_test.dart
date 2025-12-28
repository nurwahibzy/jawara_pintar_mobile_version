import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/repositories/mutasi_keluarga_repository.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/create_mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_all_mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_form_data_options.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_mutasi_keluarga.dart';

import 'mutasi_keluarga_usecases_test.mocks.dart';

@GenerateMocks([MutasiKeluargaRepository])
void main() {
  late MockMutasiKeluargaRepository mockRepository;

  late CreateMutasiKeluarga createUsecase;
  late GetAllMutasiKeluarga getAllUsecase;
  late GetFormDataOptions getFormOptionsUsecase;
  late GetMutasiKeluarga getUsecase;

  setUp(() {
    mockRepository = MockMutasiKeluargaRepository();
    createUsecase = CreateMutasiKeluarga(mockRepository);
    getAllUsecase = GetAllMutasiKeluarga(mockRepository);
    getFormOptionsUsecase = GetFormDataOptions(mockRepository);
    getUsecase = GetMutasiKeluarga(mockRepository);
  });

  final tMutasi = MutasiKeluarga(
    id: 1,
    keluargaId: 10,
    jenisMutasi: 'Pindah',
    tanggalMutasi: DateTime(2024, 10, 1),
  );

  final tMutasiList = [tMutasi];

  final tFormOptions = {
    'jenis_mutasi': ['Pindah', 'Datang'],
    'rumah': ['Rumah A', 'Rumah B'],
  };

  group('CreateMutasiKeluarga', () {
    test('harus mengembalikan Right(true) ketika create data sukses', () async {
      // arrange
      when(mockRepository.createMutasiKeluarga(tMutasi))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await createUsecase.execute(tMutasi);

      // assert
      expect(result, const Right(true));
      verify(mockRepository.createMutasiKeluarga(tMutasi)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('harus mengembalikan Left(Failure) ketika create data gagal', () async {
      // arrange
      when(mockRepository.createMutasiKeluarga(tMutasi))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // act
      final result = await createUsecase.execute(tMutasi);

      // assert
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  group('GetAllMutasiKeluarga', () {
    test('harus mengembalikan list mutasi keluarga', () async {
      // arrange
      when(mockRepository.getAllMutasiKeluarga())
          .thenAnswer((_) async => Right(tMutasiList));

      // act
      final result = await getAllUsecase.execute();

      // assert
      expect(result, Right(tMutasiList));
      verify(mockRepository.getAllMutasiKeluarga()).called(1);
    });
  });

  group('GetFormDataOptions', () {
    test('harus mengembalikan map form data options', () async {
      // arrange
      when(mockRepository.getFormDataOptions())
          .thenAnswer((_) async => Right(tFormOptions));

      // act
      final result = await getFormOptionsUsecase.execute();

      // assert
      expect(result, Right(tFormOptions));
      verify(mockRepository.getFormDataOptions()).called(1);
    });
  });

  group('GetMutasiKeluarga', () {
    test('harus mengembalikan detail mutasi keluarga pada saat getMutasiKeluarga', () async {
      // arrange
      when(mockRepository.getMutasiKeluarga(1))
          .thenAnswer((_) async => Right(tMutasi));

      // act
      final result = await getUsecase.execute(1);

      // assert
      expect(result, Right(tMutasi));
      verify(mockRepository.getMutasiKeluarga(1)).called(1);
    });
  });
}
