import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/tagih-iuran/data/models/tagih_iuran_model.dart';
import 'package:jawara_pintar_mobile_version/features/tagih-iuran/domain/entities/tagih_iuran.dart';

void main() {
  final tTagihIuranModel = TagihIuranModel(
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

  group('TagihIuranModel', () {
    test('should be a subclass of TagihIuran entity', () {
      expect(tTagihIuranModel, isA<TagihIuran>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        final Map<String, dynamic> jsonMap = {
          'kode_tagihan': 'TG-2023-001',
          'keluarga_id': 1,
          'master_iuran_id': 1,
          'periode': '2023-01',
          'nominal': 50000.0,
          'status_tagihan': 'Belum Lunas',
          'tanggal_bayar': null,
          'nominal_bayar': null,
          'tgl_struk_final': null,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-02T00:00:00.000Z',
        };

        final result = TagihIuranModel.fromJson(jsonMap);

        expect(result, isA<TagihIuranModel>());
        expect(result.kodeTagihan, 'TG-2023-001');
        expect(result.keluargaId, 1);
        expect(result.masterIuranId, 1);
        expect(result.periode, '2023-01');
        expect(result.nominal, 50000.0);
        expect(result.statusTagihan, 'Belum Lunas');
      });

      test('should parse payment dates correctly when provided', () {
        final Map<String, dynamic> jsonMap = {
          'kode_tagihan': 'TG-2023-002',
          'keluarga_id': 1,
          'master_iuran_id': 1,
          'periode': '2023-02',
          'nominal': 50000.0,
          'status_tagihan': 'Lunas',
          'tanggal_bayar': '2023-02-15T10:00:00.000Z',
          'nominal_bayar': 50000.0,
          'tgl_struk_final': '2023-02-15T10:00:00.000Z',
          'created_at': '2023-02-01T00:00:00.000Z',
          'updated_at': '2023-02-15T10:00:00.000Z',
        };

        final result = TagihIuranModel.fromJson(jsonMap);

        expect(result.tanggalBayar, isNotNull);
        expect(result.nominalBayar, 50000.0);
        expect(result.tglStrukFinal, isNotNull);
      });

      test('should handle null payment fields', () {
        final Map<String, dynamic> jsonMap = {
          'kode_tagihan': 'TG-2023-001',
          'keluarga_id': 1,
          'master_iuran_id': 1,
          'periode': '2023-01',
          'nominal': 50000.0,
          'status_tagihan': 'Belum Lunas',
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-02T00:00:00.000Z',
        };

        final result = TagihIuranModel.fromJson(jsonMap);

        expect(result.tanggalBayar, null);
        expect(result.nominalBayar, null);
        expect(result.tglStrukFinal, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tTagihIuranModel.toJson();

        expect(result['kode_tagihan'], 'TG-2023-001');
        expect(result['keluarga_id'], 1);
        expect(result['master_iuran_id'], 1);
        expect(result['periode'], '2023-01');
        expect(result['nominal'], 50000.0);
        expect(result['status_tagihan'], 'Belum Lunas');
        expect(result['tanggal_bayar'], null);
        expect(result['nominal_bayar'], null);
      });

      test('should handle null values in toJson', () {
        final result = tTagihIuranModel.toJson();

        expect(result['tanggal_bayar'], null);
        expect(result['nominal_bayar'], null);
        expect(result['tgl_struk_final'], null);
      });

      test('should include payment dates when provided', () {
        final paidModel = TagihIuranModel(
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

        final result = paidModel.toJson();

        expect(result['tanggal_bayar'], isNotNull);
        expect(result['nominal_bayar'], 50000.0);
        expect(result['tgl_struk_final'], isNotNull);
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final result = tTagihIuranModel.toEntity();

        expect(result, isA<TagihIuran>());
        expect(result.kodeTagihan, 'TG-2023-001');
        expect(result.keluargaId, 1);
      });
    });
  });
}
