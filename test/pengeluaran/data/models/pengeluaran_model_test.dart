import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/models/pengeluaran_model.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/pengeluaran.dart';

void main() {
  final tPengeluaranModel = PengeluaranModel(
    id: 1,
    judul: 'Beli ATK',
    kategoriTransaksiId: 2,
    nominal: 50000,
    tanggalTransaksi: DateTime(2023, 1, 1),
    buktiFoto: 'bukti.jpg',
    keterangan: 'Pembelian alat tulis',
    createdBy: '123',
    createdAt: DateTime(2023, 1, 1),
    createdByName: 'Budi',
  );

  group('PengeluaranModel', () {
    test('should be a subclass of Pengeluaran entity', () {
      // Assert
      expect(tPengeluaranModel, isA<Pengeluaran>());
    });

    group('fromJson / fromMap', () {
      test('should return a valid model from JSON with all fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'judul': 'Beli ATK',
          'kategori_transaksi_id': 2,
          'nominal': 50000,
          'tanggal_transaksi': '2023-01-01',
          'bukti_foto': 'bukti.jpg',
          'keterangan': 'Pembelian alat tulis',
          'created_by': '123',
          'created_at': '2023-01-01',
          'created_by_name': 'Budi',
        };

        // Act
        final result = PengeluaranModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<PengeluaranModel>());
        expect(result.id, 1);
        expect(result.judul, 'Beli ATK');
        expect(result.kategoriTransaksiId, 2);
        expect(result.nominal, 50000);
        expect(result.tanggalTransaksi, DateTime(2023, 1, 1));
        expect(result.buktiFoto, 'bukti.jpg');
        expect(result.keterangan, 'Pembelian alat tulis');
        expect(result.createdBy, '123');
        expect(result.createdAt, DateTime(2023, 1, 1));
        expect(result.createdByName, 'Budi');
      });

      test('should handle null optional fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'judul': 'Beli ATK',
          'kategori_transaksi_id': 2,
          'nominal': 50000,
          'tanggal_transaksi': '2023-01-01',
          'created_by': null,
          'created_at': '2023-01-01',
        };

        // Act
        final result = PengeluaranModel.fromJson(jsonMap);

        // Assert
        expect(result.buktiFoto, null);
        expect(result.keterangan, null);
        expect(result.createdBy, '');
        expect(result.createdByName, null);
      });
    });

    group('toJson / toMap', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tPengeluaranModel.toJson();

        // Assert
        final expectedMap = {
          'judul': 'Beli ATK',
          'kategori_transaksi_id': 2,
          'nominal': 50000,
          'tanggal_transaksi': '2023-01-01T00:00:00.000',
          'bukti_foto': 'bukti.jpg',
          'keterangan': 'Pembelian alat tulis',
          'created_by': '123',
          'created_at': '2023-01-01T00:00:00.000',
        };

        expect(result, expectedMap);
      });

      test('should include id when forUpdate is true', () {
        // Act
        final result = tPengeluaranModel.toMap(forUpdate: true);

        // Assert
        expect(result['id'], 1);
      });

      test('should not include id when forUpdate is false', () {
        // Act
        final result = tPengeluaranModel.toMap(forUpdate: false);

        // Assert
        expect(result.containsKey('id'), false);
      });
    });

    group('fromEntity', () {
      test('should convert Pengeluaran entity to PengeluaranModel', () {
        // Arrange
        final entity = Pengeluaran(
          id: 1,
          judul: 'Beli ATK',
          kategoriTransaksiId: 2,
          nominal: 50000,
          tanggalTransaksi: DateTime(2023, 1, 1),
          buktiFoto: 'bukti.jpg',
          keterangan: 'Pembelian alat tulis',
          createdBy: '123',
          createdAt: DateTime(2023, 1, 1),
          createdByName: 'Budi',
        );

        // Act
        final result = PengeluaranModel.fromEntity(entity);

        // Assert
        expect(result, isA<PengeluaranModel>());
        expect(result.id, entity.id);
        expect(result.judul, entity.judul);
        expect(result.nominal, entity.nominal);
        expect(result.createdByName, entity.createdByName);
      });
    });

    group('toEntity', () {
      test('should convert PengeluaranModel to Pengeluaran entity', () {
        // Act
        final result = tPengeluaranModel.toEntity();

        // Assert
        expect(result, isA<Pengeluaran>());
        expect(result.id, tPengeluaranModel.id);
        expect(result.judul, tPengeluaranModel.judul);
        expect(
          result.kategoriTransaksiId,
          tPengeluaranModel.kategoriTransaksiId,
        );
        expect(result.nominal, tPengeluaranModel.nominal);
        expect(result.createdBy, tPengeluaranModel.createdBy);
      });
    });

    group('copyWith', () {
      test('should return a new instance with updated values', () {
        // Act
        final result = tPengeluaranModel.copyWith(
          judul: 'Bayar Listrik',
          nominal: 100000,
        );

        // Assert
        expect(result.judul, 'Bayar Listrik');
        expect(result.nominal, 100000);
        expect(
          result.kategoriTransaksiId,
          tPengeluaranModel.kategoriTransaksiId,
        );
      });
    });
  });
}