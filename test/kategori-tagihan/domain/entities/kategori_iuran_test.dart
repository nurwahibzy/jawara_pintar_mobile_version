import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/kategori_iuran.dart';

void main() {
  final tKategoriIuran = KategoriIuran(id: 1, namaKategori: 'Iuran Bulanan');

  group('KategoriIuran', () {
    test('should be a KategoriIuran instance', () {
      expect(tKategoriIuran, isA<KategoriIuran>());
    });

    test('should have correct properties', () {
      expect(tKategoriIuran.id, 1);
      expect(tKategoriIuran.namaKategori, 'Iuran Bulanan');
    });

    test('should support value equality', () {
      final tKategoriIuranDuplicate = KategoriIuran(
        id: 1,
        namaKategori: 'Iuran Bulanan',
      );

      expect(tKategoriIuran, tKategoriIuranDuplicate);
    });

    test('copyWith should create new instance with updated values', () {
      final updated = tKategoriIuran.copyWith(namaKategori: 'Iuran Khusus');

      expect(updated.id, 1);
      expect(updated.namaKategori, 'Iuran Khusus');
    });

    test('copyWith should keep old values when not provided', () {
      final updated = tKategoriIuran.copyWith();

      expect(updated.id, 1);
      expect(updated.namaKategori, 'Iuran Bulanan');
    });

    test('should have correct props for equality', () {
      expect(tKategoriIuran.props.length, 2);
      expect(tKategoriIuran.props[0], 1);
      expect(tKategoriIuran.props[1], 'Iuran Bulanan');
    });
  });
}
