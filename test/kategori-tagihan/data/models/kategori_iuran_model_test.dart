import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/data/models/kategori_iuran_model.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/domain/entities/kategori_iuran.dart';

void main() {
  final tKategoriIuranModel = KategoriIuranModel(
    id: 1,
    namaKategori: 'Iuran Bulanan',
  );

  group('KategoriIuranModel', () {
    test('should be a subclass of KategoriIuran entity', () {
      expect(tKategoriIuranModel, isA<KategoriIuran>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'nama_kategori': 'Iuran Bulanan',
        };

        final result = KategoriIuranModel.fromJson(jsonMap);

        expect(result, isA<KategoriIuranModel>());
        expect(result.id, 1);
        expect(result.namaKategori, 'Iuran Bulanan');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tKategoriIuranModel.toJson();

        final expectedMap = {'id': 1, 'nama_kategori': 'Iuran Bulanan'};

        expect(result, expectedMap);
      });
    });

    group('fromEntity', () {
      test('should convert entity to model', () {
        final entity = KategoriIuran(id: 2, namaKategori: 'Iuran Khusus');

        final result = KategoriIuranModel.fromEntity(entity);

        expect(result, isA<KategoriIuranModel>());
        expect(result.id, 2);
        expect(result.namaKategori, 'Iuran Khusus');
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final result = tKategoriIuranModel.toEntity();

        expect(result, isA<KategoriIuran>());
        expect(result.id, 1);
        expect(result.namaKategori, 'Iuran Bulanan');
      });
    });
  });
}
