import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';

void main() {
  group('Keluarga Entity', () {
    test('should create Keluarga instance with all required properties', () {
      // Arrange & Act
      final keluarga = Keluarga(
        id: 1,
        nomorKk: '1234567890123456',
        statusHunian: 'Aktif',
      );

      // Assert
      expect(keluarga.id, 1);
      expect(keluarga.nomorKk, '1234567890123456');
      expect(keluarga.statusHunian, 'Aktif');
    });

    test('should create Keluarga instance with optional rumahId', () {
      // Arrange & Act
      final keluarga = Keluarga(
        id: 1,
        nomorKk: '1234567890123456',
        statusHunian: 'Aktif',
        rumahId: 5,
        tanggalTerdaftar: DateTime(2023, 1, 1),
      );

      // Assert
      expect(keluarga.rumahId, 5);
      expect(keluarga.tanggalTerdaftar, DateTime(2023, 1, 1));
    });

    test('should create Keluarga instance with null rumahId', () {
      // Arrange & Act
      final keluarga = Keluarga(
        id: 1,
        nomorKk: '1234567890123456',
        statusHunian: 'Aktif',
        rumahId: null,
      );

      // Assert
      expect(keluarga.rumahId, null);
    });

    test('should support value equality', () {
      // Arrange
      final keluarga1 = Keluarga(
        id: 1,
        nomorKk: '1234567890123456',
        statusHunian: 'Aktif',
      );

      final keluarga2 = Keluarga(
        id: 1,
        nomorKk: '1234567890123456',
        statusHunian: 'Aktif',
      );

      // Assert
      expect(keluarga1, equals(keluarga2));
    });
  });
}
