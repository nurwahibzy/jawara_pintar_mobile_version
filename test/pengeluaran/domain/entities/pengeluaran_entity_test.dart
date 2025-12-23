import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/pengeluaran.dart';

void main() {
  group('Pengeluaran Entity', () {
    test('should create Pengeluaran instance with all required properties', () {
      // Arrange & Act
      final pengeluaran = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        createdBy: '123',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(pengeluaran.id, 1);
      expect(pengeluaran.judul, 'Beli ATK');
      expect(pengeluaran.kategoriTransaksiId, 2);
      expect(pengeluaran.nominal, 50000);
      expect(pengeluaran.tanggalTransaksi, DateTime(2023, 1, 1));
      expect(pengeluaran.createdBy, '123');
      expect(pengeluaran.createdAt, DateTime(2023, 1, 1));
    });

    test('should create Pengeluaran instance with optional fields', () {
      // Arrange & Act
      final pengeluaran = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        buktiFoto: 'bukti.jpg',
        keterangan: 'Pembelian alat tulis',
        createdBy: '123',
        createdByName: 'Budi',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(pengeluaran.buktiFoto, 'bukti.jpg');
      expect(pengeluaran.keterangan, 'Pembelian alat tulis');
      expect(pengeluaran.createdByName, 'Budi');
    });

    test('should create Pengeluaran instance with null optional fields', () {
      // Arrange & Act
      final pengeluaran = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        buktiFoto: null,
        keterangan: null,
        createdBy: '123',
        createdByName: null,
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(pengeluaran.buktiFoto, null);
      expect(pengeluaran.keterangan, null);
      expect(pengeluaran.createdByName, null);
    });

    test('should support copyWith', () {
      // Arrange
      final pengeluaran = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        createdBy: '123',
        createdAt: DateTime(2023, 1, 1),
      );

      // Act
      final updated = pengeluaran.copyWith(
        judul: 'Bayar Listrik',
        nominal: 100000,
      );

      // Assert
      expect(updated.judul, 'Bayar Listrik');
      expect(updated.nominal, 100000);
      expect(updated.kategoriTransaksiId, pengeluaran.kategoriTransaksiId);
    });

    test('should support value equality', () {
      // Arrange
      final pengeluaran1 = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        createdBy: '123',
        createdAt: DateTime(2023, 1, 1),
      );

      final pengeluaran2 = Pengeluaran(
        id: 1,
        judul: 'Beli ATK',
        kategoriTransaksiId: 2,
        nominal: 50000,
        tanggalTransaksi: DateTime(2023, 1, 1),
        createdBy: '123',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(pengeluaran1, equals(pengeluaran2));
    });
  });
}