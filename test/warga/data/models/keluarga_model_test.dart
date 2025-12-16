import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/keluarga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';

void main() {
  final tKeluargaModel = KeluargaModel(
    id: 1,
    nomorKk: '1234567890123456',
    statusHunian: 'Kontrak',
    rumahId: 1,
    tanggalTerdaftar: DateTime(2023, 1, 1),
  );

  group('KeluargaModel', () {
    test('should be a subclass of Keluarga entity', () {
      // Assert
      expect(tKeluargaModel, isA<Keluarga>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nomor_kk': '1234567890123456',
          'status_hunian': 'Kontrak',
          'rumah_id': 1,
          'tanggal_terdaftar': '2023-01-01',
        };

        // Act
        final result = KeluargaModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<KeluargaModel>());
        expect(result.id, 1);
        expect(result.nomorKk, '1234567890123456');
        expect(result.statusHunian, 'Kontrak');
        expect(result.rumahId, 1);
        expect(result.tanggalTerdaftar, DateTime(2023, 1, 1));
      });

      test('should return a valid model with null rumahId', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nomor_kk': '1234567890123456',
          'status_hunian': 'Kontrak',
          'rumah_id': null,
        };

        // Act
        final result = KeluargaModel.fromJson(jsonMap);

        // Assert
        expect(result.rumahId, null);
      });

      test('should handle missing optional tanggal_terdaftar', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nomor_kk': '1234567890123456',
          'status_hunian': 'Kontrak',
        };

        // Act
        final result = KeluargaModel.fromJson(jsonMap);

        // Assert
        expect(result.tanggalTerdaftar, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tKeluargaModel.toJson();

        // Assert
        final expectedMap = {
          'id': 1,
          'nomor_kk': '1234567890123456',
          'rumah_id': 1,
          'status_hunian': 'Kontrak',
          'tanggal_terdaftar': '2023-01-01T00:00:00.000',
          'created_at': null,
        };

        expect(result, expectedMap);
      });

      test('should handle null values in toJson', () {
        // Arrange
        final keluargaModel = KeluargaModel(
          id: 1,
          nomorKk: '1234567890123456',
          statusHunian: 'Kontrak',
          rumahId: null,
          tanggalTerdaftar: null,
        );

        // Act
        final result = keluargaModel.toJson();

        // Assert
        expect(result['rumah_id'], null);
        expect(result['tanggal_terdaftar'], null);
      });
    });

    group('fromEntity', () {
      test('should convert Keluarga entity to KeluargaModel', () {
        // Arrange
        final keluargaEntity = Keluarga(
          id: 1,
          nomorKk: '1234567890123456',
          statusHunian: 'Kontrak',
          rumahId: 1,
          tanggalTerdaftar: DateTime(2023, 1, 1),
        );

        // Act
        final result = KeluargaModel.fromEntity(keluargaEntity);

        // Assert
        expect(result, isA<KeluargaModel>());
        expect(result.id, keluargaEntity.id);
        expect(result.nomorKk, keluargaEntity.nomorKk);
        expect(result.statusHunian, keluargaEntity.statusHunian);
        expect(result.rumahId, keluargaEntity.rumahId);
        expect(result.tanggalTerdaftar, keluargaEntity.tanggalTerdaftar);
      });
    });
  });
}
