import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/riwayat_penghuni.dart';

void main() {
  final tRiwayatPenghuni = RiwayatPenghuni(
    namaKeluarga: 'Keluarga Budi',
    namaKepalaKeluarga: 'Budi Santoso',
    tanggalMasuk: DateTime(2023, 1, 1),
    tanggalKeluar: DateTime(2023, 12, 31),
  );

  group('RiwayatPenghuni', () {
    test('should be a RiwayatPenghuni instance', () {
      expect(tRiwayatPenghuni, isA<RiwayatPenghuni>());
    });

    test('should have correct properties', () {
      expect(tRiwayatPenghuni.namaKeluarga, 'Keluarga Budi');
      expect(tRiwayatPenghuni.namaKepalaKeluarga, 'Budi Santoso');
      expect(tRiwayatPenghuni.tanggalMasuk, DateTime(2023, 1, 1));
      expect(tRiwayatPenghuni.tanggalKeluar, DateTime(2023, 12, 31));
    });

    test('should support value equality', () {
      final tRiwayatPenghuniDuplicate = RiwayatPenghuni(
        namaKeluarga: 'Keluarga Budi',
        namaKepalaKeluarga: 'Budi Santoso',
        tanggalMasuk: DateTime(2023, 1, 1),
        tanggalKeluar: DateTime(2023, 12, 31),
      );

      expect(tRiwayatPenghuni, tRiwayatPenghuniDuplicate);
    });

    test('should handle nullable tanggalKeluar', () {
      final riwayatWithoutKeluar = RiwayatPenghuni(
        namaKeluarga: 'Keluarga Ahmad',
        namaKepalaKeluarga: 'Ahmad Fadli',
        tanggalMasuk: DateTime(2024, 1, 1),
      );

      expect(riwayatWithoutKeluar.tanggalKeluar, null);
    });

    test('should have correct props for equality', () {
      expect(tRiwayatPenghuni.props.length, 4);
      expect(tRiwayatPenghuni.props[0], 'Keluarga Budi');
      expect(tRiwayatPenghuni.props[1], 'Budi Santoso');
    });
  });
}
