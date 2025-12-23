import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/models/kategori_model.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/kategori_transaksi.dart';

void main() {
  final tKategoriModel = KategoriModel(
    id: 1,
    jenis: 'Pengeluaran',
    nama_kategori: 'Operasional',
  );

  group('KategoriModel', () {
    test('should be a subclass of KategoriEntity', () {
      // Assert
      expect(tKategoriModel, isA<KategoriEntity>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'jenis': 'Pengeluaran',
          'nama_kategori': 'Operasional',
        };

        // Act
        final result = KategoriModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<KategoriModel>());
        expect(result.id, 1);
        expect(result.jenis, 'Pengeluaran');
        expect(result.nama_kategori, 'Operasional');
      });

      test('should handle missing optional nama_kategori', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {'id': 1, 'jenis': 'Pengeluaran'};

        // Act
        final result = KategoriModel.fromJson(jsonMap);

        // Assert
        expect(result.nama_kategori, null);
      });
    });
  });
}