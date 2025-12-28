import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/tagih-iuran/domain/entities/tagih_iuran.dart';

void main() {
  final tTagihIuran = TagihIuran(
    kodeTagihan: 'TG-2023-001',
    keluargaId: 1,
    masterIuranId: 1,
    periode: '2023-01',
    nominal: 50000.0,
    statusTagihan: 'Belum Lunas',
    tanggalBayar: null,
    nominalBayar: null,
    tglStrukFinal: null,
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 2),
  );

  group('TagihIuran', () {
    test('should be a TagihIuran instance', () {
      expect(tTagihIuran, isA<TagihIuran>());
    });

    test('should have correct properties', () {
      expect(tTagihIuran.kodeTagihan, 'TG-2023-001');
      expect(tTagihIuran.keluargaId, 1);
      expect(tTagihIuran.masterIuranId, 1);
      expect(tTagihIuran.periode, '2023-01');
      expect(tTagihIuran.nominal, 50000.0);
      expect(tTagihIuran.statusTagihan, 'Belum Lunas');
    });

    test('should support value equality', () {
      final tTagihIuranDuplicate = TagihIuran(
        kodeTagihan: 'TG-2023-001',
        keluargaId: 1,
        masterIuranId: 1,
        periode: '2023-01',
        nominal: 50000.0,
        statusTagihan: 'Belum Lunas',
        tanggalBayar: null,
        nominalBayar: null,
        tglStrukFinal: null,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );

      expect(tTagihIuran, tTagihIuranDuplicate);
    });

    test('should handle nullable payment fields', () {
      expect(tTagihIuran.tanggalBayar, null);
      expect(tTagihIuran.nominalBayar, null);
      expect(tTagihIuran.tglStrukFinal, null);
    });

    test('should handle paid tagihan', () {
      final paidTagihan = TagihIuran(
        kodeTagihan: 'TG-2023-002',
        keluargaId: 1,
        masterIuranId: 1,
        periode: '2023-02',
        nominal: 50000.0,
        statusTagihan: 'Lunas',
        tanggalBayar: DateTime(2023, 2, 15),
        nominalBayar: 50000.0,
        tglStrukFinal: DateTime(2023, 2, 15),
        createdAt: DateTime(2023, 2, 1),
        updatedAt: DateTime(2023, 2, 15),
      );

      expect(paidTagihan.statusTagihan, 'Lunas');
      expect(paidTagihan.tanggalBayar, isNotNull);
      expect(paidTagihan.nominalBayar, 50000.0);
    });

    test('should have all required fields in props', () {
      expect(tTagihIuran.props.length, 11);
      expect(tTagihIuran.props[0], 'TG-2023-001');
      expect(tTagihIuran.props[1], 1);
    });
  });
}
