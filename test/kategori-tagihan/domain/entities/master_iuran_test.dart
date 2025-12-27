import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/master_iuran.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/kategori_iuran.dart';

void main() {
  final tKategoriIuran = KategoriIuran(id: 1, namaKategori: 'Iuran Bulanan');

  final tMasterIuran = MasterIuran(
    id: 1,
    kategoriIuranId: 1,
    namaIuran: 'Iuran Kebersihan',
    nominalStandar: 50000.0,
    isActive: true,
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 2),
    kategoriIuran: tKategoriIuran,
  );

  group('MasterIuran', () {
    test('should be a MasterIuran instance', () {
      expect(tMasterIuran, isA<MasterIuran>());
    });

    test('should have correct properties', () {
      expect(tMasterIuran.id, 1);
      expect(tMasterIuran.kategoriIuranId, 1);
      expect(tMasterIuran.namaIuran, 'Iuran Kebersihan');
      expect(tMasterIuran.nominalStandar, 50000.0);
      expect(tMasterIuran.isActive, true);
      expect(tMasterIuran.kategoriIuran, tKategoriIuran);
    });

    test('should support value equality', () {
      final tMasterIuranDuplicate = MasterIuran(
        id: 1,
        kategoriIuranId: 1,
        namaIuran: 'Iuran Kebersihan',
        nominalStandar: 50000.0,
        isActive: true,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        kategoriIuran: tKategoriIuran,
      );

      expect(tMasterIuran, tMasterIuranDuplicate);
    });

    test('namaKategori getter should return correct value', () {
      expect(tMasterIuran.namaKategori, 'Iuran Bulanan');
    });

    test(
      'namaKategori getter should return dash when kategoriIuran is null',
      () {
        final masterIuranWithoutKategori = MasterIuran(
          id: 1,
          kategoriIuranId: 1,
          namaIuran: 'Iuran Kebersihan',
          nominalStandar: 50000.0,
          isActive: true,
        );

        expect(masterIuranWithoutKategori.namaKategori, '-');
      },
    );

    test('jenisKategori getter should return correct value', () {
      expect(tMasterIuran.jenisKategori, 'Iuran Bulanan');
    });

    test('formattedNominal getter should format nominal correctly', () {
      expect(tMasterIuran.formattedNominal, contains('Rp'));
      expect(tMasterIuran.formattedNominal, contains('50'));
    });

    test('statusText getter should return correct status', () {
      expect(tMasterIuran.statusText, 'Aktif');

      final inactiveMasterIuran = tMasterIuran.copyWith(isActive: false);
      expect(inactiveMasterIuran.statusText, 'Tidak Aktif');
    });

    test('copyWith should create new instance with updated values', () {
      final updated = tMasterIuran.copyWith(
        namaIuran: 'Iuran Keamanan',
        nominalStandar: 75000.0,
      );

      expect(updated.id, 1);
      expect(updated.namaIuran, 'Iuran Keamanan');
      expect(updated.nominalStandar, 75000.0);
      expect(updated.kategoriIuranId, 1);
    });

    test('should handle nullable createdAt and updatedAt', () {
      final masterIuranWithoutDates = MasterIuran(
        id: 2,
        kategoriIuranId: 1,
        namaIuran: 'Iuran Test',
        nominalStandar: 30000.0,
        isActive: true,
      );

      expect(masterIuranWithoutDates.createdAt, null);
      expect(masterIuranWithoutDates.updatedAt, null);
    });

    test('should have all required fields in props', () {
      expect(tMasterIuran.props.length, 8);
    });
  });
}
