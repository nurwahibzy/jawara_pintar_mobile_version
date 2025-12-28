import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/riwayat_penghuni.dart';

void main() {
  final tRiwayatPenghuni = RiwayatPenghuni(
    namaKeluarga: 'Keluarga Budi',
    namaKepalaKeluarga: 'Budi Santoso',
    tanggalMasuk: DateTime(2023, 1, 1),
  );

  final tRumah = Rumah(
    id: 1,
    alamat: 'Jl. Merdeka No. 10',
    statusRumah: 'Dihuni',
    createdAt: DateTime(2023, 1, 1),
    riwayatPenghuni: [tRiwayatPenghuni],
  );

  group('Rumah', () {
    test('should be a Rumah instance', () {
      expect(tRumah, isA<Rumah>());
    });

    test('should have correct properties', () {
      expect(tRumah.id, 1);
      expect(tRumah.alamat, 'Jl. Merdeka No. 10');
      expect(tRumah.statusRumah, 'Dihuni');
      expect(tRumah.riwayatPenghuni.length, 1);
    });

    test('should support value equality', () {
      final tRumahDuplicate = Rumah(
        id: 1,
        alamat: 'Jl. Merdeka No. 10',
        statusRumah: 'Dihuni',
        createdAt: DateTime(2023, 1, 1),
        riwayatPenghuni: [tRiwayatPenghuni],
      );

      expect(tRumah, tRumahDuplicate);
    });

    test('canDelete should return true when status is Kosong', () {
      final rumahKosong = Rumah(
        id: 2,
        alamat: 'Jl. Merdeka No. 11',
        statusRumah: 'Kosong',
      );

      expect(rumahKosong.canDelete, true);
    });

    test('canDelete should return false when status is not Kosong', () {
      expect(tRumah.canDelete, false);

      final rumahDisewakan = Rumah(
        id: 3,
        alamat: 'Jl. Merdeka No. 12',
        statusRumah: 'Disewakan',
      );

      expect(rumahDisewakan.canDelete, false);
    });

    test('canDelete should be case insensitive', () {
      final rumahKosongUpperCase = Rumah(
        id: 4,
        alamat: 'Jl. Merdeka No. 13',
        statusRumah: 'KOSONG',
      );

      expect(rumahKosongUpperCase.canDelete, true);
    });

    test('should handle empty riwayatPenghuni list', () {
      final rumahWithoutRiwayat = Rumah(
        id: 5,
        alamat: 'Jl. Merdeka No. 14',
        statusRumah: 'Kosong',
      );

      expect(rumahWithoutRiwayat.riwayatPenghuni, isEmpty);
    });

    test('should have correct props for equality', () {
      expect(tRumah.props.length, 4);
      expect(tRumah.props[0], 1);
      expect(tRumah.props[1], 'Jl. Merdeka No. 10');
      expect(tRumah.props[2], 'Dihuni');
    });
  });
}
