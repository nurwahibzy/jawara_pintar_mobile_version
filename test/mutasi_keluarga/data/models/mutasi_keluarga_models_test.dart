import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/models/mutasi_keluarga_models.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';

void main() {
  final tDate = DateTime(2023, 1, 1, 10, 0, 0);
  const tDateString = "2023-01-01T10:00:00.000";

  final tMutasiKeluargaModel = MutasiKeluargaModel(
    keluargaId: 1,
    jenisMutasi: 'Pindah',
    tanggalMutasi: tDate,
    createdAt: null,
  );

  final tMutasiKeluargaEntity = MutasiKeluarga(
    keluargaId: 1,
    jenisMutasi: 'Pindah',
    tanggalMutasi: tDate,
    createdAt: null,
  );

  test('Mutasi Keluarga model harus merupakan turunan dari Mutasi Keluarga entity', () {
    expect(tMutasiKeluargaModel, isA<MutasiKeluarga>());
  });

  group('Test fungsi fromJson / fromMap', () {
    test('harus mengembalikan MutasiKeluargaModel yang valid dari JSON dengan keluarga', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'keluarga_id': 1,
        'jenis_mutasi': 'Pindah',
        'rumah_asal_id': null,
        'rumah_tujuan_id': null,
        'tanggal_mutasi': tDateString,
        'keterangan': null,
        'file_bukti': null,
        'created_at': tDateString,
        'rumah_asal': {'alamat': 'Jl. Merdeka No.1'},
        'rumah_tujuan': {'alamat': 'Jl. Sudirman No.2'},
        'keluarga': {
          'warga': [
            {'nama_lengkap': 'Andi Wijaya', 'status_keluarga': 'Kepala Keluarga'},
            {'nama_lengkap': 'Siti Wijaya', 'status_keluarga': 'Istri'},
          ]
        },
      };

      final result = MutasiKeluargaModel.fromJson(jsonMap);

      expect(result, isA<MutasiKeluargaModel>());
      expect(result.id, 1);
      expect(result.keluargaId, 1);
      expect(result.jenisMutasi, 'Pindah');
      expect(result.namaKepalaKeluarga, 'Andi Wijaya');
      expect(result.alamatAsal, 'Jl. Merdeka No.1');
      expect(result.alamatTujuan, 'Jl. Sudirman No.2');
    });

    test('harus handle JSON tanpa keluarga object', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'keluarga_id': 1,
        'jenis_mutasi': 'Pindah',
        'rumah_asal_id': null,
        'rumah_tujuan_id': null,
        'tanggal_mutasi': tDateString,
        'keterangan': null,
        'file_bukti': null,
        'created_at': null,
      };

      final result = MutasiKeluargaModel.fromJson(jsonMap);

      expect(result.namaKepalaKeluarga, 'Tanpa Nama');
      expect(result.alamatAsal, '-');
      expect(result.alamatTujuan, '-');
    });

    test('harus handle JSON dengan warga list kosong', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'keluarga_id': 1,
        'jenis_mutasi': 'Pindah',
        'rumah_asal_id': null,
        'rumah_tujuan_id': null,
        'tanggal_mutasi': tDateString,
        'keterangan': null,
        'file_bukti': null,
        'created_at': null,
        'keluarga': {'warga': []},
      };

      final result = MutasiKeluargaModel.fromJson(jsonMap);

      expect(result.namaKepalaKeluarga, 'Tanpa Nama');
    });

    test('harus menggunakan orang pertama jika tidak ada Kepala Keluarga', () {
      final Map<String, dynamic> jsonMap = {
        'id': 2,
        'keluarga_id': 2,
        'jenis_mutasi': 'Pindah',
        'tanggal_mutasi': tDateString,
        'keluarga': {
          'warga': [
            {'nama_lengkap': 'Budi Santoso', 'status_keluarga': 'Anak'},
          ]
        },
      };

      final result = MutasiKeluargaModel.fromJson(jsonMap);

      expect(result.namaKepalaKeluarga, 'Budi Santoso');
    });

    test('harus handle null nama_lengkap di warga', () {
      final Map<String, dynamic> jsonMap = {
        'id': 3,
        'keluarga_id': 3,
        'jenis_mutasi': 'Pindah',
        'tanggal_mutasi': tDateString,
        'keluarga': {
          'warga': [
            {'status_keluarga': 'Kepala Keluarga'},
          ]
        },
      };

      final result = MutasiKeluargaModel.fromJson(jsonMap);

      expect(result.namaKepalaKeluarga, 'Tanpa Nama');
    });
  });

  group('Test fungsi toMap', () {
    test('harus mengembalikan Map yang valid dari MutasiKeluargaModel', () {
      final result = tMutasiKeluargaModel.toMap();

      expect(result['keluarga_id'], 1);
      expect(result['jenis_mutasi'], 'Pindah');
      expect(result['tanggal_mutasi'], tDate.toIso8601String());
      expect(result['rumah_asal_id'], null);
      expect(result['rumah_tujuan_id'], null);
      expect(result['keterangan'], null);
      expect(result['file_bukti'], null);
    });

    test('harus tidak include id jika null', () {
      final result = tMutasiKeluargaModel.toMap();

      expect(result.containsKey('id'), false);
    });

    test('harus include id jika tidak null', () {
      final modelWithId = MutasiKeluargaModel(
        id: 5,
        keluargaId: 1,
        jenisMutasi: 'Pindah',
        tanggalMutasi: tDate,
      );

      final result = modelWithId.toMap();

      expect(result.containsKey('id'), true);
      expect(result['id'], 5);
    });

    test('harus tidak include created_at jika null', () {
      final result = tMutasiKeluargaModel.toMap();

      expect(result.containsKey('created_at'), false);
    });

    test('harus include created_at jika tidak null', () {
      final modelWithCreatedAt = MutasiKeluargaModel(
        keluargaId: 1,
        jenisMutasi: 'Pindah',
        tanggalMutasi: tDate,
        createdAt: tDate,
      );

      final result = modelWithCreatedAt.toMap();

      expect(result.containsKey('created_at'), true);
      expect(result['created_at'], tDate.toIso8601String());
    });
  });

  group('Test fungsi fromEntity', () {
    test('harus mengembalikan MutasiKeluargaModel yang valid dari Entity', () {
      final result = MutasiKeluargaModel.fromEntity(tMutasiKeluargaEntity);

      expect(result, isA<MutasiKeluargaModel>());
      expect(result.keluargaId, tMutasiKeluargaEntity.keluargaId);
      expect(result.jenisMutasi, tMutasiKeluargaEntity.jenisMutasi);
      expect(result.tanggalMutasi, tMutasiKeluargaEntity.tanggalMutasi);
    });

    test('harus copy semua field dari Entity', () {
      final entityWithAllFields = MutasiKeluarga(
        id: 1,
        keluargaId: 1,
        jenisMutasi: 'Pindah',
        rumahAsalId: 10,
        rumahTujuanId: 20,
        tanggalMutasi: tDate,
        keterangan: 'Keterangan test',
        fileBukti: 'bukti.pdf',
        createdAt: tDate,
      );

      final result = MutasiKeluargaModel.fromEntity(entityWithAllFields);

      expect(result.id, 1);
      expect(result.keluargaId, 1);
      expect(result.jenisMutasi, 'Pindah');
      expect(result.rumahAsalId, 10);
      expect(result.rumahTujuanId, 20);
      expect(result.tanggalMutasi, tDate);
      expect(result.keterangan, 'Keterangan test');
      expect(result.fileBukti, 'bukti.pdf');
      expect(result.createdAt, tDate);
    });
  });
}
