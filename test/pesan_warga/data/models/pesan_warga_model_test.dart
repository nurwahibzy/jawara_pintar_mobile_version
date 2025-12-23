import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/models/pesan_warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/domain/entities/pesan_warga.dart';

void main() {
  final tAspirasiModel = AspirasiModel(
    id: 1,
    wargaId: 10,
    judul: 'Lampu Jalan Rusak',
    deskripsi: 'Lampu jalan di RT 02 mati',
    status: StatusAspirasi.Pending,
    tanggapanAdmin: null,
    updatedBy: null,
    createdAt: DateTime(2023, 1, 1),
    namaAdmin: 'Admin',
    namaWarga: 'Budi',
  );

  group('AspirasiModel', () {
    group('fromMap', () {
      test('should return valid model when admin and warga are Map', () {
        // Arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'warga_id': 10,
          'judul': 'Lampu Jalan Rusak',
          'deskripsi': 'Lampu jalan di RT 02 mati',
          'status': 'Pending',
          'tanggapan_admin': null,
          'updated_by': null,
          'created_at': '2023-01-01',
          'admin': {'nama_lengkap': 'Admin'},
          'warga': {'nama_lengkap': 'Budi'},
        };

        // Act
        final result = AspirasiModel.fromMap(map);

        // Assert
        expect(result, isA<AspirasiModel>());
        expect(result.id, 1);
        expect(result.wargaId, 10);
        expect(result.judul, 'Lampu Jalan Rusak');
        expect(result.deskripsi, 'Lampu jalan di RT 02 mati');
        expect(result.status, StatusAspirasi.Pending);
        expect(result.namaAdmin, 'Admin');
        expect(result.namaWarga, 'Budi');
      });

      test('should return valid model when admin and warga are List', () {
        // Arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'warga_id': 10,
          'judul': 'Lampu Jalan Rusak',
          'deskripsi': 'Lampu jalan di RT 02 mati',
          'status': 'Diterima',
          'created_at': '2023-01-01',
          'admin': [
            {'nama_lengkap': 'Admin'},
          ],
          'warga': [
            {'nama_lengkap': 'Budi'},
          ],
        };

        // Act
        final result = AspirasiModel.fromMap(map);

        // Assert
        expect(result.status, StatusAspirasi.Diterima);
        expect(result.namaAdmin, 'Admin');
        expect(result.namaWarga, 'Budi');
      });

      test('should handle null admin and warga data', () {
        // Arrange
        final Map<String, dynamic> map = {
          'id': 1,
          'warga_id': 10,
          'judul': 'Lampu Jalan Rusak',
          'deskripsi': 'Lampu jalan di RT 02 mati',
          'status': 'Menunggu',
          'created_at': '2023-01-01',
          'admin': null,
          'warga': null,
        };

        // Act
        final result = AspirasiModel.fromMap(map);

        // Assert
        expect(result.namaAdmin, null);
        expect(result.namaWarga, null);
        expect(result.status, StatusAspirasi.Menunggu);
      });
    });

    group('toMap', () {
      test('should return proper map for insert', () {
        // Act
        final result = tAspirasiModel.toMap();

        // Assert
        expect(result['warga_id'], 10);
        expect(result['judul'], 'Lampu Jalan Rusak');
        expect(result['deskripsi'], 'Lampu jalan di RT 02 mati');
        expect(result['status'], 'Pending');
        expect(result.containsKey('id'), false);
      });

      test('should include id and created_at when forUpdate is true', () {
        // Act
        final result = tAspirasiModel.toMap(forUpdate: true);

        // Assert
        expect(result['id'], 1);
        expect(result['created_at'], '2023-01-01T00:00:00.000');
      });
    });

    group('toEntity', () {
      test('should convert AspirasiModel to Aspirasi entity', () {
        // Act
        final result = tAspirasiModel.toEntity();

        // Assert
        expect(result, isA<Aspirasi>());
        expect(result.id, 1);
        expect(result.wargaId, 10);
        expect(result.judul, 'Lampu Jalan Rusak');
        expect(result.status, StatusAspirasi.Pending);
        expect(result.namaAdmin, 'Admin');
        expect(result.namaWarga, 'Budi');
      });
    });

    group('copyWith', () {
      test('should return new instance with updated fields', () {
        // Act
        final result = tAspirasiModel.copyWith(wargaId: 20, updatedBy: 99);

        // Assert
        expect(result.wargaId, 20);
        expect(result.updatedBy, 99);
        expect(result.judul, tAspirasiModel.judul);
      });
    });

    group('status conversion', () {
      test('should throw exception for unknown status', () {
        // Arrange
        final Map<String, dynamic> map = {
          'warga_id': 10,
          'judul': 'Test',
          'deskripsi': 'Test',
          'status': 'UNKNOWN',
          'created_at': '2023-01-01',
        };

        // Assert
        expect(() => AspirasiModel.fromMap(map), throwsException);
      });
    });
  });
}