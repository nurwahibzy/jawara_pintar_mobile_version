import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/data/models/master_iuran_model.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/data/models/kategori_iuran_model.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/master_iuran.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/kategori_iuran.dart';

void main() {
  final tKategoriIuranModel = KategoriIuranModel(
    id: 1,
    namaKategori: 'Iuran Bulanan',
  );

  final tMasterIuranModel = MasterIuranModel(
    id: 1,
    kategoriIuranId: 1,
    namaIuran: 'Iuran Kebersihan',
    nominalStandar: 50000.0,
    isActive: true,
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 2),
    kategoriIuran: tKategoriIuranModel,
  );

  group('MasterIuranModel', () {
    test('should be a subclass of MasterIuran entity', () {
      expect(tMasterIuranModel, isA<MasterIuran>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'kategori_iuran_id': 1,
          'nama_iuran': 'Iuran Kebersihan',
          'nominal_standar': 50000.0,
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-02T00:00:00.000Z',
          'kategori_iuran': {'id': 1, 'nama_kategori': 'Iuran Bulanan'},
        };

        final result = MasterIuranModel.fromJson(jsonMap);

        expect(result, isA<MasterIuranModel>());
        expect(result.id, 1);
        expect(result.kategoriIuranId, 1);
        expect(result.namaIuran, 'Iuran Kebersihan');
        expect(result.nominalStandar, 50000.0);
        expect(result.isActive, true);
        expect(result.kategoriIuran, isNotNull);
        expect(result.kategoriIuran?.namaKategori, 'Iuran Bulanan');
      });

      test('should return a valid model with null kategoriIuran', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'kategori_iuran_id': 1,
          'nama_iuran': 'Iuran Kebersihan',
          'nominal_standar': 50000.0,
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000Z',
          'kategori_iuran': null,
        };

        final result = MasterIuranModel.fromJson(jsonMap);

        expect(result.kategoriIuran, null);
      });

      test('should handle missing optional fields', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'kategori_iuran_id': 1,
          'nama_iuran': 'Iuran Kebersihan',
          'nominal_standar': 50000.0,
        };

        final result = MasterIuranModel.fromJson(jsonMap);

        expect(result.isActive, true); // default value
        expect(result.createdAt, null);
        expect(result.updatedAt, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tMasterIuranModel.toJson();

        expect(result['id'], 1);
        expect(result['kategori_iuran_id'], 1);
        expect(result['nama_iuran'], 'Iuran Kebersihan');
        expect(result['nominal_standar'], 50000.0);
        expect(result['is_active'], true);
        expect(result['kategori_iuran'], isNotNull);
        expect(result['kategori_iuran']['nama_kategori'], 'Iuran Bulanan');
      });

      test('should handle null values in toJson', () {
        final masterIuranModel = MasterIuranModel(
          id: 1,
          kategoriIuranId: 1,
          namaIuran: 'Iuran Kebersihan',
          nominalStandar: 50000.0,
          isActive: true,
          createdAt: null,
          updatedAt: null,
          kategoriIuran: null,
        );

        final result = masterIuranModel.toJson();

        expect(result['created_at'], null);
        expect(result['updated_at'], null);
        expect(result['kategori_iuran'], null);
      });
    });

    group('fromEntity', () {
      test('should convert entity to model', () {
        final entity = MasterIuran(
          id: 2,
          kategoriIuranId: 1,
          namaIuran: 'Iuran Keamanan',
          nominalStandar: 75000.0,
          isActive: true,
          kategoriIuran: tKategoriIuranModel,
        );

        final result = MasterIuranModel.fromEntity(entity);

        expect(result, isA<MasterIuranModel>());
        expect(result.id, 2);
        expect(result.namaIuran, 'Iuran Keamanan');
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final result = tMasterIuranModel.toEntity();

        expect(result, isA<MasterIuran>());
        expect(result.id, 1);
        expect(result.namaIuran, 'Iuran Kebersihan');
      });
    });
  });
}
