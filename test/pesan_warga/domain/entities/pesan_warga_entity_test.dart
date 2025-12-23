import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/data/models/pesan_warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/pesan-warga/domain/entities/pesan_warga.dart';


void main() {
  group('Aspirasi Entity', () {
    test('should create Aspirasi instance with all required properties', () {
      // Arrange & Act
      final aspirasi = Aspirasi(
        id: 1,
        wargaId: 10,
        judul: 'Lampu Jalan Rusak',
        deskripsi: 'Lampu jalan di RT 02 mati',
        status: StatusAspirasi.Pending,
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(aspirasi.id, 1);
      expect(aspirasi.wargaId, 10);
      expect(aspirasi.judul, 'Lampu Jalan Rusak');
      expect(aspirasi.deskripsi, 'Lampu jalan di RT 02 mati');
      expect(aspirasi.status, StatusAspirasi.Pending);
      expect(aspirasi.createdAt, DateTime(2023, 1, 1));
    });

    test('should create Aspirasi instance with optional fields', () {
      // Arrange & Act
      final aspirasi = Aspirasi(
        id: 1,
        wargaId: 10,
        judul: 'Lampu Jalan Rusak',
        deskripsi: 'Lampu jalan di RT 02 mati',
        status: StatusAspirasi.Menunggu,
        tanggapanAdmin: 'Sedang diproses',
        updatedBy: 99,
        namaAdmin: 'Admin',
        namaWarga: 'Budi',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(aspirasi.tanggapanAdmin, 'Sedang diproses');
      expect(aspirasi.updatedBy, 99);
      expect(aspirasi.namaAdmin, 'Admin');
      expect(aspirasi.namaWarga, 'Budi');
    });

    test('should create Aspirasi instance with null optional fields', () {
      // Arrange & Act
      final aspirasi = Aspirasi(
        id: 1,
        wargaId: 10,
        judul: 'Lampu Jalan Rusak',
        deskripsi: 'Lampu jalan di RT 02 mati',
        status: StatusAspirasi.Diterima,
        tanggapanAdmin: null,
        updatedBy: null,
        namaAdmin: null,
        namaWarga: null,
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(aspirasi.tanggapanAdmin, null);
      expect(aspirasi.updatedBy, null);
      expect(aspirasi.namaAdmin, null);
      expect(aspirasi.namaWarga, null);
    });

    test('should convert Aspirasi entity to AspirasiModel', () {
      // Arrange
      final aspirasi = Aspirasi(
        id: 1,
        wargaId: 10,
        judul: 'Lampu Jalan Rusak',
        deskripsi: 'Lampu jalan di RT 02 mati',
        status: StatusAspirasi.Pending,
        tanggapanAdmin: 'Akan dicek',
        updatedBy: 99,
        namaAdmin: 'Admin',
        namaWarga: 'Budi',
        createdAt: DateTime(2023, 1, 1),
      );

      // Act
      final result = aspirasi.toModel();

      // Assert
      expect(result, isA<AspirasiModel>());
      expect(result.id, aspirasi.id);
      expect(result.wargaId, aspirasi.wargaId);
      expect(result.judul, aspirasi.judul);
      expect(result.deskripsi, aspirasi.deskripsi);
      expect(result.status, aspirasi.status);
      expect(result.namaAdmin, aspirasi.namaAdmin);
      expect(result.namaWarga, aspirasi.namaWarga);
    });
  });
}