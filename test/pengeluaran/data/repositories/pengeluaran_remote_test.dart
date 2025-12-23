import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/datasources/remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/models/pengeluaran_model.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/models/kategori_model.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/kategori_transaksi.dart';

import 'pengeluaran_remote_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PengeluaranRemoteDataSourceImpl>()])


void main() {
  late MockPengeluaranRemoteDataSourceImpl mockDatasource;
  late PengeluaranModel fakePengeluaran;
  late List<PengeluaranModel> fakePengeluaranList;
  late KategoriModel fakeKategori;
  final int tId = 1;

  setUp(() {
    mockDatasource = MockPengeluaranRemoteDataSourceImpl();

    fakePengeluaran = PengeluaranModel(
      id: tId,
      judul: "Beli Barang",
      kategoriTransaksiId: 1,
      nominal: 50000,
      tanggalTransaksi: DateTime.now(),
      buktiFoto: "bukti.jpg",
      keterangan: "Pembelian alat RT",
      createdBy: "123",
      createdAt: DateTime.now(),
      createdByName: "Budi",
    );

    fakePengeluaranList = [fakePengeluaran];

    fakeKategori = KategoriModel(id: 1, jenis:"Pengeluaran", nama_kategori: "Operasional");
  });

  group('PengeluaranRemoteDataSourceImpl', () {
    // GET ALL PENGELUARAN
    test('getAllPengeluaran berhasil', () async {
      when(
        mockDatasource.getAllPengeluaran(),
      ).thenAnswer((_) async => fakePengeluaranList);

      final result = await mockDatasource.getAllPengeluaran();

      expect(result, equals(fakePengeluaranList));
      expect(result.first.judul, fakePengeluaran.judul);
    });

    test('getAllPengeluaran gagal', () async {
      when(mockDatasource.getAllPengeluaran()).thenThrow(Exception('DB Error'));

      expect(() => mockDatasource.getAllPengeluaran(), throwsException);
    });

    // GET PENGELUARAN BY ID
    test('getPengeluaranById berhasil', () async {
      when(
        mockDatasource.getPengeluaranById(tId),
      ).thenAnswer((_) async => fakePengeluaran);

      final result = await mockDatasource.getPengeluaranById(tId);

      expect(result, equals(fakePengeluaran));
      expect(result?.id, tId);
    });

    test('getPengeluaranById gagal', () async {
      when(
        mockDatasource.getPengeluaranById(tId),
      ).thenThrow(Exception('DB Error'));

      expect(() => mockDatasource.getPengeluaranById(tId), throwsException);
    });

    // CREATE PENGELUARAN
    test('createPengeluaran berhasil', () async {
      when(
        mockDatasource.createPengeluaran(fakePengeluaran),
      ).thenAnswer((_) async => Future.value());

      await mockDatasource.createPengeluaran(fakePengeluaran);

      verify(mockDatasource.createPengeluaran(fakePengeluaran)).called(1);
    });

    test('createPengeluaran gagal', () async {
      when(
        mockDatasource.createPengeluaran(fakePengeluaran),
      ).thenThrow(Exception('DB Error'));

      expect(
        () => mockDatasource.createPengeluaran(fakePengeluaran),
        throwsException,
      );
    });

    // UPDATE PENGELUARAN
    test('updatePengeluaran berhasil', () async {
      when(
        mockDatasource.updatePengeluaran(fakePengeluaran),
      ).thenAnswer((_) async => Future.value());

      await mockDatasource.updatePengeluaran(fakePengeluaran);

      verify(mockDatasource.updatePengeluaran(fakePengeluaran)).called(1);
    });

    test('updatePengeluaran gagal', () async {
      when(
        mockDatasource.updatePengeluaran(fakePengeluaran),
      ).thenThrow(Exception('DB Error'));

      expect(
        () => mockDatasource.updatePengeluaran(fakePengeluaran),
        throwsException,
      );
    });

    // DELETE PENGELUARAN
    test('deletePengeluaran berhasil', () async {
      when(
        mockDatasource.deletePengeluaran(tId),
      ).thenAnswer((_) async => Future.value());

      await mockDatasource.deletePengeluaran(tId);

      verify(mockDatasource.deletePengeluaran(tId)).called(1);
    });

    test('deletePengeluaran gagal', () async {
      when(
        mockDatasource.deletePengeluaran(tId),
      ).thenThrow(Exception('DB Error'));

      expect(() => mockDatasource.deletePengeluaran(tId), throwsException);
    });

    // GET KATEGORI PENGELUARAN
    test('getKategoriPengeluaran berhasil', () async {
      when(mockDatasource.getKategoriPengeluaran()).thenAnswer(
        (_) async => [
          KategoriEntity(
            id: fakeKategori.id,
            nama_kategori: fakeKategori.nama_kategori,
            jenis: "Pengeluaran",
          ),
        ],
      );

      final result = await mockDatasource.getKategoriPengeluaran();

      expect(result.first.nama_kategori, fakeKategori.nama_kategori);
    });

    test('getKategoriPengeluaran gagal', () async {
      when(
        mockDatasource.getKategoriPengeluaran(),
      ).thenThrow(Exception('DB Error'));

      expect(() => mockDatasource.getKategoriPengeluaran(), throwsException);
    });
    // UPLOAD BUKTI
    test('uploadBukti berhasil', () async {
      final file = File('bukti.jpg');

      when(
        mockDatasource.uploadBukti(file),
      ).thenAnswer((_) async => "url.com/bukti.jpg");

      final result = await mockDatasource.uploadBukti(file);

      expect(result, "url.com/bukti.jpg");
    });

    test('uploadBukti gagal', () async {
      final file = File('bukti.jpg');

      when(
        mockDatasource.uploadBukti(file),
      ).thenThrow(Exception('Upload error'));

      expect(() => mockDatasource.uploadBukti(file), throwsException);
    });

    // GET NAMES BY UIDS
    test('getNamesByUids berhasil', () async {
      final uids = ["11111111-1111-1111-1111-111111111111"];

      when(
        mockDatasource.getNamesByUids(uids),
      ).thenAnswer((_) async => {uids.first: "Budi"});

      final result = await mockDatasource.getNamesByUids(uids);

      expect(result[uids.first], "Budi");
    });

    test('getNamesByUids gagal', () async {
      final uids = ["11111111-1111-1111-1111-111111111111"];

      when(
        mockDatasource.getNamesByUids(uids),
      ).thenThrow(Exception('DB Error'));

      expect(() => mockDatasource.getNamesByUids(uids), throwsException);
    });
  });
}