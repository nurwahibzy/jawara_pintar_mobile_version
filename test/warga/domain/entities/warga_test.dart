import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';

void main() {
  group('Warga Entity', () {
    test('should create Warga instance with all required properties', () {
      // Arrange & Act
      final warga = Warga(
        idWarga: 1,
        nik: '1234567890123456',
        nama: 'John Doe',
        nomorTelepon: '08123456789',
        jenisKelamin: 'L',
        statusKeluarga: 'Kepala Keluarga',
        statusHidup: 'Hidup',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(warga.idWarga, 1);
      expect(warga.nik, '1234567890123456');
      expect(warga.nama, 'John Doe');
      expect(warga.nomorTelepon, '08123456789');
      expect(warga.jenisKelamin, 'L');
      expect(warga.statusKeluarga, 'Kepala Keluarga');
      expect(warga.statusHidup, 'Hidup');
    });

    test('should create Warga instance with nullable keluargaId', () {
      // Arrange & Act
      final warga = Warga(
        idWarga: 1,
        nik: '1234567890123456',
        nama: 'John Doe',
        nomorTelepon: '08123456789',
        jenisKelamin: 'L',
        statusKeluarga: 'Kepala Keluarga',
        statusHidup: 'Hidup',
        keluargaId: null,
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(warga.keluargaId, null);
    });

    test('should create Warga instance with optional fields', () {
      // Arrange & Act
      final warga = Warga(
        idWarga: 1,
        nik: '1234567890123456',
        nama: 'John Doe',
        nomorTelepon: '08123456789',
        jenisKelamin: 'L',
        statusKeluarga: 'Kepala Keluarga',
        statusHidup: 'Hidup',
        tempatLahir: 'Jakarta',
        tanggalLahir: DateTime(1990, 1, 1),
        agama: 'Islam',
        golonganDarah: 'A',
        pendidikanTerakhir: 'S1',
        pekerjaan: 'Pegawai Swasta',
        statusPenduduk: 'Tetap',
        keluargaId: 1,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );

      // Assert
      expect(warga.tempatLahir, 'Jakarta');
      expect(warga.tanggalLahir, DateTime(1990, 1, 1));
      expect(warga.agama, 'Islam');
      expect(warga.golonganDarah, 'A');
      expect(warga.pendidikanTerakhir, 'S1');
      expect(warga.pekerjaan, 'Pegawai Swasta');
      expect(warga.statusPenduduk, 'Tetap');
      expect(warga.keluargaId, 1);
      expect(warga.updatedAt, DateTime(2023, 1, 2));
    });

    test('should support value equality', () {
      // Arrange
      final warga1 = Warga(
        idWarga: 1,
        nik: '1234567890123456',
        nama: 'John Doe',
        nomorTelepon: '08123456789',
        jenisKelamin: 'L',
        statusKeluarga: 'Kepala Keluarga',
        statusHidup: 'Hidup',
        createdAt: DateTime(2023, 1, 1),
      );

      final warga2 = Warga(
        idWarga: 1,
        nik: '1234567890123456',
        nama: 'John Doe',
        nomorTelepon: '08123456789',
        jenisKelamin: 'L',
        statusKeluarga: 'Kepala Keluarga',
        statusHidup: 'Hidup',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(warga1, equals(warga2));
    });
  });
}
