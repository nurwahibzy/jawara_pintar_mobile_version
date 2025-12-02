import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/datasources/mutasi_keluarga_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/models/mutasi_keluarga_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<MutasiKeluargaDatasourceImplementation>()])
import 'mutasi_keluarga_test.mocks.dart';

void main() {
  // 1. Definisi Variable di luar agar bisa dipakai semua test (mocking)
  late MockMutasiKeluargaDatasourceImplementation mockDatasource;
  late List<MutasiKeluargaModel> fakeListMutasi;
  late MutasiKeluargaModel fakeMutasiDetail;
  final int tId = 1;

  // 2. setUp: Dijalankan sebelum SETIAP test case (agar state bersih)
  setUp(() {
    mockDatasource = MockMutasiKeluargaDatasourceImplementation();

    // Inisialisasi Data Dummy
    fakeListMutasi = [
      MutasiKeluargaModel(
        id: 1,
        keluargaId: 101,
        jenisMutasi: 'Pindah Masuk',
        rumahAsalId: null,
        rumahTujuanId: 50,
        tanggalMutasi: DateTime.now(),
        keterangan: 'Pindah tugas dinas',
        fileBukti: 'bukti.jpg',
        createdAt: DateTime.now(),
      ),
    ];

    fakeMutasiDetail = fakeListMutasi[0];
  });

  group('get all data mutasi keluarga', () {
    test('berhasil mengembalikan List MutasiKeluargaModel', () async {
      // arrange (siapkan skenario)
      when(
        mockDatasource.getAllMutasiKeluarga(),
      ).thenAnswer((_) async => fakeListMutasi);

      // act (jalankan fungsi)
      final result = await mockDatasource.getAllMutasiKeluarga();

      // assert (pastikan hasilnya benar)
      expect(result, equals(fakeListMutasi));
      expect(result.length, 1);
    });

    test('gagal dan melempar Exception', () async {
      // arrange
      when(
        mockDatasource.getAllMutasiKeluarga(),
      ).thenThrow(Exception('Gagal koneksi'));

      // act
      final call = mockDatasource.getAllMutasiKeluarga;

      // assert
      expect(() => call(), throwsException);
    });
  });

  group('get data mutasi keluarga (detail)', () {
    test('berhasil mengembalikan single MutasiKeluargaModel', () async {
      // arrange
      when(
        mockDatasource.getMutasiKeluarga(tId),
      ).thenAnswer((_) async => fakeMutasiDetail);

      // act
      final result = await mockDatasource.getMutasiKeluarga(tId);

      // assert
      expect(result, equals(fakeMutasiDetail));
      expect(result.id, tId);
    });

    test('gagal (misal data tidak ditemukan)', () async {
      // arrange
      when(
        mockDatasource.getMutasiKeluarga(tId),
      ).thenThrow(Exception('Data not found'));

      // act
      final call = mockDatasource.getMutasiKeluarga;

      // assert
      expect(() => call(tId), throwsException);
    });
  });

  group('create mutasi keluarga', () {
    test('berhasil membuat data (return void/future complete)', () async {
      // arrange
      // Karena void, biasanya kita cek apakah dia complete tanpa error
      when(
        mockDatasource.createMutasiKeluarga(any),
      ).thenAnswer((_) async => Future.value());

      // act
      // Kita panggil fungsinya
      await mockDatasource.createMutasiKeluarga(fakeMutasiDetail);

      // assert
      // Kita verifikasi bahwa fungsi tersebut benar-benar dipanggil 1 kali
      verify(mockDatasource.createMutasiKeluarga(fakeMutasiDetail)).called(1);
    });

    test('gagal membuat data', () async {
      // arrange
      when(
        mockDatasource.createMutasiKeluarga(any),
      ).thenThrow(Exception('Server Error'));

      // act
      final call = mockDatasource.createMutasiKeluarga;

      // assert
      expect(() => call(fakeMutasiDetail), throwsException);
    });
  });
}
