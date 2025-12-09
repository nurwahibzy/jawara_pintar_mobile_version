import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/cetak-laporan/data/datasources/cetak_laporan_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/cetak-laporan/data/models/laporan_cetak_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<CetakLaporanRemoteDataSourceImpl>()])
import 'cetak_laporan_test.mocks.dart';

void main() {
  // Definisi Variable di luar agar bisa dipakai semua test (mocking)
  late MockCetakLaporanRemoteDataSourceImpl mockDatasource;
  late LaporanCetakModel fakeLaporanData;
  late DateTime tanggalMulai;
  late DateTime tanggalAkhir;
  late String jenisLaporan;

  // setUp: Dijalankan sebelum setiap test case (agar state bersih)
  setUp(() {
    mockDatasource = MockCetakLaporanRemoteDataSourceImpl();
    tanggalMulai = DateTime(2025, 1, 1);
    tanggalAkhir = DateTime(2025, 1, 31);
    jenisLaporan = 'semua';

    // Inisialisasi Data Dummy
    final daftarPemasukan = [
      ItemTransaksiModel(
        id: '1',
        judul: 'Iuran Bulanan',
        kategori: 'Iuran',
        nominal: 50000,
        tanggal: DateTime(2025, 1, 15),
        keterangan: 'Iuran Januari',
      ),
      ItemTransaksiModel(
        id: '2',
        judul: 'Donasi Warga',
        kategori: 'Donasi',
        nominal: 100000,
        tanggal: DateTime(2025, 1, 20),
        keterangan: null,
      ),
    ];

    final daftarPengeluaran = [
      ItemTransaksiModel(
        id: '3',
        judul: 'Pembelian Perlengkapan',
        kategori: 'Operasional',
        nominal: 75000,
        tanggal: DateTime(2025, 1, 18),
        keterangan: 'Beli alat kebersihan',
      ),
    ];

    fakeLaporanData = LaporanCetakModel.fromEntities(
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      jenisLaporan: jenisLaporan,
      pemasukan: daftarPemasukan,
      pengeluaran: daftarPengeluaran,
    );
  });

  group('get laporan data', () {
    test('berhasil mengembalikan LaporanCetakModel untuk semua transaksi',
        () async {
      // arrange (mempersiapkan skenario)
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'semua',
        ),
      ).thenAnswer((_) async => fakeLaporanData);

      // act (menjalankan fungsi)
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
      );

      // assert (memastikan hasilnya benar)
      expect(result, equals(fakeLaporanData));
      expect(result.jenisLaporan, 'semua');
      expect(result.totalPemasukan, 150000);
      expect(result.totalPengeluaran, 75000);
      expect(result.saldo, 75000);
      expect(result.jumlahTransaksiPemasukan, 2);
      expect(result.jumlahTransaksiPengeluaran, 1);
    });

    test('berhasil mengembalikan LaporanCetakModel untuk pemasukan saja',
        () async {
      final laporanPemasukan = LaporanCetakModel.fromEntities(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'pemasukan',
        pemasukan: fakeLaporanData.daftarPemasukan.cast<ItemTransaksiModel>(),
        pengeluaran: [],
      );

      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'pemasukan',
        ),
      ).thenAnswer((_) async => laporanPemasukan);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'pemasukan',
      );

      // assert
      expect(result.jenisLaporan, 'pemasukan');
      expect(result.totalPemasukan, 150000);
      expect(result.totalPengeluaran, 0);
      expect(result.daftarPengeluaran.length, 0);
    });

    test('berhasil mengembalikan LaporanCetakModel untuk pengeluaran saja',
        () async {
      final laporanPengeluaran = LaporanCetakModel.fromEntities(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'pengeluaran',
        pemasukan: [],
        pengeluaran: fakeLaporanData.daftarPengeluaran.cast<ItemTransaksiModel>(),
      );

      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'pengeluaran',
        ),
      ).thenAnswer((_) async => laporanPengeluaran);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'pengeluaran',
      );

      // assert
      expect(result.jenisLaporan, 'pengeluaran');
      expect(result.totalPemasukan, 0);
      expect(result.totalPengeluaran, 75000);
      expect(result.daftarPemasukan.length, 0);
    });

    test('gagal dan melempar Exception', () async {
      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: jenisLaporan,
        ),
      ).thenThrow(Exception('Gagal koneksi ke database'));

      // act
      final call = mockDatasource.getLaporanData;

      // assert
      expect(
        () => call(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: jenisLaporan,
        ),
        throwsException,
      );
    });
  });

  group('validasi data laporan', () {
    test('laporan dengan data kosong (tidak ada transaksi)', () async {
      final laporanKosong = LaporanCetakModel.fromEntities(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
        pemasukan: [],
        pengeluaran: [],
      );

      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'semua',
        ),
      ).thenAnswer((_) async => laporanKosong);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
      );

      // assert
      expect(result.totalPemasukan, 0);
      expect(result.totalPengeluaran, 0);
      expect(result.saldo, 0);
      expect(result.jumlahTransaksiPemasukan, 0);
      expect(result.jumlahTransaksiPengeluaran, 0);
    });

    test('validasi perhitungan total dan saldo', () async {
      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'semua',
        ),
      ).thenAnswer((_) async => fakeLaporanData);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
      );

      // assert
      final expectedSaldo =
          result.totalPemasukan - result.totalPengeluaran;
      expect(result.saldo, expectedSaldo);
      expect(result.saldo, 75000);
    });

    test('validasi jumlah transaksi sesuai dengan daftar', () async {
      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'semua',
        ),
      ).thenAnswer((_) async => fakeLaporanData);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
      );

      // assert
      expect(
        result.jumlahTransaksiPemasukan,
        result.daftarPemasukan.length,
      );
      expect(
        result.jumlahTransaksiPengeluaran,
        result.daftarPengeluaran.length,
      );
    });
  });

  group('validasi rentang tanggal', () {
    test('tanggal mulai lebih besar dari tanggal akhir (invalid)', () async {
      final tanggalMulaiInvalid = DateTime(2025, 2, 1);
      final tanggalAkhirInvalid = DateTime(2025, 1, 1);

      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulaiInvalid,
          tanggalAkhir: tanggalAkhirInvalid,
          jenisLaporan: 'semua',
        ),
      ).thenThrow(Exception('Tanggal tidak valid'));

      // act
      final call = mockDatasource.getLaporanData;

      // assert
      expect(
        () => call(
          tanggalMulai: tanggalMulaiInvalid,
          tanggalAkhir: tanggalAkhirInvalid,
          jenisLaporan: 'semua',
        ),
        throwsException,
      );
    });

    test('rentang tanggal valid (tanggal mulai <= tanggal akhir)', () async {
      // arrange
      when(
        mockDatasource.getLaporanData(
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          jenisLaporan: 'semua',
        ),
      ).thenAnswer((_) async => fakeLaporanData);

      // act
      final result = await mockDatasource.getLaporanData(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: 'semua',
      );

      // assert
      expect(result.tanggalMulai.isBefore(result.tanggalAkhir.add(const Duration(days: 1))), true);
    });
  });
}
