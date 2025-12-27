import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/data/models/riwayat_penghuni_model.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/riwayat_penghuni.dart';

void main() {
  final tRiwayatPenghuniModel = RiwayatPenghuniModel(
    namaKeluarga: 'Keluarga Budi',
    namaKepalaKeluarga: 'Budi Santoso',
    tanggalMasuk: DateTime(2023, 1, 1),
    tanggalKeluar: DateTime(2023, 12, 31),
  );

  group('RiwayatPenghuniModel', () {
    test('should be a subclass of RiwayatPenghuni entity', () {
      expect(tRiwayatPenghuniModel, isA<RiwayatPenghuni>());
    });

    group('fromJson', () {
      test('should handle missing keluarga data', () {
        final Map<String, dynamic> jsonMap = {
          'keluarga': {'warga': []},
          'tanggal_masuk': '2023-01-01T00:00:00.000Z',
        };

        final result = RiwayatPenghuniModel.fromJson(jsonMap);

        expect(result.namaKepalaKeluarga, '-');
        expect(result.namaKeluarga, 'Keluarga -');
      });
    });
  });
}
