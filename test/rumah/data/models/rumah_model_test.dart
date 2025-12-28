import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/data/models/rumah_model.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';

void main() {
  final tRumahModel = RumahModel(
    id: 1,
    alamat: 'Jl. Merdeka No. 10',
    statusRumah: 'Dihuni',
    createdAt: DateTime(2023, 1, 1),
    riwayatPenghuni: const [],
  );

  group('RumahModel', () {
    test('should be a subclass of Rumah entity', () {
      expect(tRumahModel, isA<Rumah>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON with all fields', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'alamat': 'Jl. Merdeka No. 10',
          'status_rumah': 'Dihuni',
          'created_at': '2023-01-01T00:00:00.000Z',
          'riwayat_penghuni': [],
        };

        final result = RumahModel.fromJson(jsonMap);

        expect(result, isA<RumahModel>());
        expect(result.id, 1);
        expect(result.alamat, 'Jl. Merdeka No. 10');
        expect(result.statusRumah, 'Dihuni');
        expect(result.riwayatPenghuni, isEmpty);
      });

      test('should use default values for missing fields', () {
        final Map<String, dynamic> jsonMap = {'id': 1};

        final result = RumahModel.fromJson(jsonMap);

        expect(result.alamat, '-');
        expect(result.statusRumah, 'Kosong');
      });

      test('should handle null created_at', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'alamat': 'Jl. Merdeka No. 10',
          'status_rumah': 'Dihuni',
          'created_at': null,
        };

        final result = RumahModel.fromJson(jsonMap);

        expect(result.createdAt, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tRumahModel.toJson();

        final expectedMap = {
          'alamat': 'Jl. Merdeka No. 10',
          'status_rumah': 'Dihuni',
        };

        expect(result, expectedMap);
      });
    });

    group('toJsonWithId', () {
      test('should return a JSON map with id', () {
        final result = tRumahModel.toJsonWithId();

        expect(result['id'], 1);
        expect(result['alamat'], 'Jl. Merdeka No. 10');
        expect(result['status_rumah'], 'Dihuni');
      });
    });

    group('fromEntity', () {
      test('should convert entity to model', () {
        final entity = Rumah(
          id: 2,
          alamat: 'Jl. Kemerdekaan No. 5',
          statusRumah: 'Kosong',
        );

        final result = RumahModel.fromEntity(entity);

        expect(result, isA<RumahModel>());
        expect(result.id, 2);
        expect(result.alamat, 'Jl. Kemerdekaan No. 5');
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final result = tRumahModel.toEntity();

        expect(result, isA<Rumah>());
        expect(result.id, 1);
        expect(result.alamat, 'Jl. Merdeka No. 10');
      });
    });

    group('fromJsonList', () {
      test('should convert list of json to list of models', () {
        final List<dynamic> jsonList = [
          {'id': 1, 'alamat': 'Jl. Merdeka No. 10', 'status_rumah': 'Dihuni'},
          {
            'id': 2,
            'alamat': 'Jl. Kemerdekaan No. 5',
            'status_rumah': 'Kosong',
          },
        ];

        final result = RumahModel.fromJsonList(jsonList);

        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[1].id, 2);
      });

      test('should return empty list when input is null', () {
        final result = RumahModel.fromJsonList(null);

        expect(result, isEmpty);
      });

      test('should return empty list when input is empty', () {
        final result = RumahModel.fromJsonList([]);

        expect(result, isEmpty);
      });
    });
  });
}
