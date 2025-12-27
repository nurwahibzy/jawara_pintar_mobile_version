import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/data/models/pemasukan_model.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/domain/entities/pemasukan.dart';

void main() {
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

  group('PemasukanModel', () {
    test('should be a subclass of Pemasukan entity', () {
      // Assert
      expect(tPemasukanModel, isA<Pemasukan>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'judul': 'Iuran Bulanan',
          'kategori_transaksi_id': 1,
          'nominal': 100000.0,
          'tanggal_transaksi': '2023-01-15',
          'bukti_foto': null,
          'keterangan': 'Iuran bulanan bulan Januari',
          'created_by': 1,
          'verifikator_id': null,
          'tanggal_verifikasi': null,
          'created_at': '2023-01-01T00:00:00.000Z',
          'kategori_transaksi': {'id': 1, 'nama_kategori': 'Iuran'},
          'created_by_warga': {'id': 1, 'nama_lengkap': 'John Doe'},
          'verifikator_warga': null,
        };

        // Act
        final result = PemasukanModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<PemasukanModel>());
        expect(result.id, 1);
        expect(result.judul, 'Iuran Bulanan');
        expect(result.kategoriTransaksiId, 1);
        expect(result.nominal, 100000.0);
        expect(result.tanggalTransaksi, '2023-01-15');
        expect(result.keterangan, 'Iuran bulanan bulan Januari');
        expect(result.createdBy, 1);
        expect(result.namaKategori, 'Iuran');
        expect(result.namaCreatedBy, 'John Doe');
      });

      test('should return a valid model with null verifikator fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'judul': 'Iuran Bulanan',
          'kategori_transaksi_id': 1,
          'nominal': 100000.0,
          'tanggal_transaksi': '2023-01-15',
          'bukti_foto': null,
          'keterangan': 'Iuran bulanan bulan Januari',
          'created_by': 1,
          'verifikator_id': null,
          'tanggal_verifikasi': null,
          'created_at': '2023-01-01T00:00:00.000Z',
        };

        // Act
        final result = PemasukanModel.fromJson(jsonMap);

        // Assert
        expect(result.verifikatorId, null);
        expect(result.tanggalVerifikasi, null);
        expect(result.namaVerifikator, null);
      });

      test('should handle missing nested objects', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'judul': 'Sumbangan Sukarela',
          'kategori_transaksi_id': 2,
          'nominal': 50000.0,
          'tanggal_transaksi': '2023-01-20',
          'bukti_foto': null,
          'keterangan': 'Sumbangan dari warga',
          'created_by': 2,
          'verifikator_id': null,
          'tanggal_verifikasi': null,
          'created_at': '2023-01-20T00:00:00.000Z',
          'kategori_transaksi': null,
          'created_by_warga': null,
          'verifikator_warga': null,
        };

        // Act
        final result = PemasukanModel.fromJson(jsonMap);

        // Assert
        expect(result.namaKategori, null);
        expect(result.namaCreatedBy, null);
        expect(result.namaVerifikator, null);
      });

      test('should parse tanggal_verifikasi correctly when provided', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'judul': 'Iuran Bulanan',
          'kategori_transaksi_id': 1,
          'nominal': 100000.0,
          'tanggal_transaksi': '2023-01-15',
          'bukti_foto': null,
          'keterangan': 'Iuran bulanan bulan Januari',
          'created_by': 1,
          'verifikator_id': 2,
          'tanggal_verifikasi': '2023-01-16T10:30:00.000Z',
          'created_at': '2023-01-01T00:00:00.000Z',
        };

        // Act
        final result = PemasukanModel.fromJson(jsonMap);

        // Assert
        expect(result.verifikatorId, 2);
        expect(result.tanggalVerifikasi, isNotNull);
        expect(
          result.tanggalVerifikasi,
          DateTime.parse('2023-01-16T10:30:00.000Z'),
        );
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tPemasukanModel.toJson();

        // Assert
        final expectedMap = {
          'id': 1,
          'judul': 'Iuran Bulanan',
          'kategori_transaksi_id': 1,
          'nominal': 100000.0,
          'tanggal_transaksi': '2023-01-15',
          'bukti_foto': null,
          'keterangan': 'Iuran bulanan bulan Januari',
          'created_by': 1,
          'verifikator_id': null,
          'tanggal_verifikasi': null,
          'created_at': '2023-01-01T00:00:00.000',
        };

        expect(result, expectedMap);
      });

      test('should handle null values in toJson', () {
        // Arrange
        final pemasukanModel = PemasukanModel(
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
          namaKategori: null,
          namaCreatedBy: null,
          namaVerifikator: null,
        );

        // Act
        final result = pemasukanModel.toJson();

        // Assert
        expect(result['bukti_foto'], null);
        expect(result['verifikator_id'], null);
        expect(result['tanggal_verifikasi'], null);
      });

      test('should include bukti_foto when provided', () {
        // Arrange
        final pemasukanModel = PemasukanModel(
          id: 1,
          judul: 'Iuran Bulanan',
          kategoriTransaksiId: 1,
          nominal: 100000.0,
          tanggalTransaksi: '2023-01-15',
          buktiFoto: 'https://example.com/foto.jpg',
          keterangan: 'Iuran bulanan bulan Januari',
          createdBy: 1,
          verifikatorId: null,
          tanggalVerifikasi: null,
          createdAt: DateTime(2023, 1, 1),
          namaKategori: 'Iuran',
          namaCreatedBy: 'John Doe',
          namaVerifikator: null,
        );

        // Act
        final result = pemasukanModel.toJson();

        // Assert
        expect(result['bukti_foto'], 'https://example.com/foto.jpg');
      });
    });
  });
}
