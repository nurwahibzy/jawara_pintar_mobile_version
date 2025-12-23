import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/kategori_transaksi.dart';

void main() {
  group('KategoriEntity', () {
    test('should create KategoriEntity instance with required properties', () {
      // Arrange & Act
      final kategori = KategoriEntity(
        id: 1,
        jenis: 'Pengeluaran',
        nama_kategori: 'Operasional',
      );

      // Assert
      expect(kategori.id, 1);
      expect(kategori.jenis, 'Pengeluaran');
      expect(kategori.nama_kategori, 'Operasional');
    });

    test('should create KategoriEntity instance with null nama_kategori', () {
      // Arrange & Act
      final kategori = KategoriEntity(
        id: 1,
        jenis: 'Pengeluaran',
        nama_kategori: null,
      );

      // Assert
      expect(kategori.nama_kategori, null);
    });
  });
}