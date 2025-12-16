import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';

void main() {
  final tWargaModel = WargaModel(
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

  group('WargaModel', () {
    test('should be a subclass of Warga entity', () {
      // Assert
      expect(tWargaModel, isA<Warga>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nik': '1234567890123456',
          'nama_lengkap': 'John Doe',
          'no_hp': '08123456789',
          'jenis_kelamin': 'L',
          'status_keluarga': 'Kepala Keluarga',
          'status_hidup': 'Hidup',
          'tempat_lahir': 'Jakarta',
          'tanggal_lahir': '1990-01-01',
          'agama': 'Islam',
          'golongan_darah': 'A',
          'pendidikan_terakhir': 'S1',
          'pekerjaan': 'Pegawai Swasta',
          'status_penduduk': 'Tetap',
          'keluarga_id': 1,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-02T00:00:00.000Z',
        };

        // Act
        final result = WargaModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<WargaModel>());
        expect(result.idWarga, 1);
        expect(result.nik, '1234567890123456');
        expect(result.nama, 'John Doe');
        expect(result.nomorTelepon, '08123456789');
        expect(result.jenisKelamin, 'L');
        expect(result.statusKeluarga, 'Kepala Keluarga');
        expect(result.statusHidup, 'Hidup');
        expect(result.tempatLahir, 'Jakarta');
        expect(result.agama, 'Islam');
      });

      test('should return a valid model with null keluargaId', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nik': '1234567890123456',
          'nama_lengkap': 'John Doe',
          'no_hp': '08123456789',
          'jenis_kelamin': 'L',
          'status_keluarga': 'Kepala Keluarga',
          'status_hidup': 'Hidup',
          'keluarga_id': null,
          'created_at': '2023-01-01T00:00:00.000Z',
        };

        // Act
        final result = WargaModel.fromJson(jsonMap);

        // Assert
        expect(result.keluargaId, null);
      });

      test('should handle missing optional fields', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nik': '1234567890123456',
          'nama_lengkap': 'John Doe',
          'no_hp': '08123456789',
          'jenis_kelamin': 'L',
          'status_keluarga': 'Kepala Keluarga',
          'status_hidup': 'Hidup',
          'created_at': '2023-01-01T00:00:00.000Z',
        };

        // Act
        final result = WargaModel.fromJson(jsonMap);

        // Assert
        expect(result.tempatLahir, '-');
        expect(result.tanggalLahir, null);
        expect(result.agama, '-');
        expect(result.golonganDarah, '-');
        expect(result.keluargaId, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tWargaModel.toJson();

        // Assert
        final expectedMap = {
          'id': 1,
          'nik': '1234567890123456',
          'nama_lengkap': 'John Doe',
          'no_hp': '08123456789',
          'jenis_kelamin': 'L',
          'status_keluarga': 'Kepala Keluarga',
          'status_hidup': 'Hidup',
          'tempat_lahir': 'Jakarta',
          'tanggal_lahir': '1990-01-01T00:00:00.000',
          'agama': 'Islam',
          'golongan_darah': 'A',
          'pendidikan_terakhir': 'S1',
          'pekerjaan': 'Pegawai Swasta',
          'status_penduduk': 'Tetap',
          'keluarga_id': 1,
          'created_at': '2023-01-01T00:00:00.000',
          'updated_at': '2023-01-02T00:00:00.000',
        };

        expect(result, expectedMap);
      });

      test('should handle null values in toJson', () {
        // Arrange
        final wargaModel = WargaModel(
          idWarga: 1,
          nik: '1234567890123456',
          nama: 'John Doe',
          nomorTelepon: '08123456789',
          jenisKelamin: 'L',
          statusKeluarga: 'Kepala Keluarga',
          statusHidup: 'Hidup',
          tempatLahir: null,
          tanggalLahir: null,
          agama: null,
          golonganDarah: null,
          pendidikanTerakhir: null,
          pekerjaan: null,
          statusPenduduk: null,
          keluargaId: null,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: null,
        );

        // Act
        final result = wargaModel.toJson();

        // Assert
        expect(result['keluarga_id'], null);
        expect(result['tempat_lahir'], null);
        expect(result['updated_at'], null);
      });
    });
  });
}
