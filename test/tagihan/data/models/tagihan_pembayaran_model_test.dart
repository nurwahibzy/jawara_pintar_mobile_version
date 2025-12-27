import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/tagihan/data/models/tagihan_pembayaran_model.dart';
import 'package:jawara_pintar_mobile_version/features/tagihan/domain/entities/tagihan_pembayaran.dart';

void main() {
  final tTagihanPembayaranModel = TagihanPembayaranModel(
    id: 1,
    tagihanId: 1,
    metode: 'Transfer',
    bukti: 'https://example.com/bukti.jpg',
    tanggalBayar: DateTime(2023, 1, 15),
    statusVerifikasi: 'Pending',
    catatanAdmin: null,
    verifikatorId: null,
    createdAt: DateTime(2023, 1, 15),
    kodeTagihan: 'TG-2023-001',
    keluargaId: 1,
    masterIuranId: 1,
    periode: '2023-01',
    nominal: 50000.0,
    statusTagihan: 'Belum Lunas',
    namaIuran: 'Iuran Kebersihan',
  );

  group('TagihanPembayaranModel', () {
    test('should be a subclass of TagihanPembayaran entity', () {
      expect(tTagihanPembayaranModel, isA<TagihanPembayaran>());
    });

    group('fromJson - pembayaran_tagihan structure', () {
      test('should return a valid model from JSON with tagihan relation', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'tagihan_id': 1,
          'metode_pembayaran': 'Transfer',
          'bukti_bayar': 'https://example.com/bukti.jpg',
          'tanggal_bayar': '2023-01-15T00:00:00.000Z',
          'status_verifikasi': 'Pending',
          'catatan_admin': null,
          'verifikator_id': null,
          'created_at': '2023-01-15T00:00:00.000Z',
          'tagihan': {
            'kode_tagihan': 'TG-2023-001',
            'keluarga_id': 1,
            'master_iuran_id': 1,
            'periode': '2023-01',
            'nominal': 50000.0,
            'status_tagihan': 'Belum Lunas',
            'master_iuran': {'nama_iuran': 'Iuran Kebersihan'},
          },
        };

        final result = TagihanPembayaranModel.fromJson(jsonMap);

        expect(result, isA<TagihanPembayaranModel>());
        expect(result.id, 1);
        expect(result.tagihanId, 1);
        expect(result.metode, 'Transfer');
        expect(result.bukti, 'https://example.com/bukti.jpg');
        expect(result.statusVerifikasi, 'Pending');
        expect(result.kodeTagihan, 'TG-2023-001');
        expect(result.namaIuran, 'Iuran Kebersihan');
      });
    });

    group('fromJson - direct tagihan structure', () {
      test('should return a valid model from tagihan table structure', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'kode_tagihan': 'TG-2023-001',
          'keluarga_id': 1,
          'master_iuran_id': 1,
          'periode': '2023-01',
          'nominal': 50000.0,
          'status_tagihan': 'Belum Lunas',
          'created_at': '2023-01-15T00:00:00.000Z',
          'master_iuran': {'nama_iuran': 'Iuran Kebersihan'},
          'pembayaran_tagihan': [],
        };

        final result = TagihanPembayaranModel.fromJson(jsonMap);

        expect(result, isA<TagihanPembayaranModel>());
        expect(result.id, 1);
        expect(result.kodeTagihan, 'TG-2023-001');
        expect(result.nominal, 50000.0);
      });

      test('should parse riwayat pembayaran when available', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'kode_tagihan': 'TG-2023-001',
          'keluarga_id': 1,
          'master_iuran_id': 1,
          'periode': '2023-01',
          'nominal': 50000.0,
          'status_tagihan': 'Lunas',
          'created_at': '2023-01-15T00:00:00.000Z',
          'master_iuran': {'nama_iuran': 'Iuran Kebersihan'},
          'pembayaran_tagihan': [
            {
              'id': 10,
              'metode_pembayaran': 'Transfer',
              'bukti_bayar': 'https://example.com/bukti.jpg',
              'tanggal_bayar': '2023-01-20T00:00:00.000Z',
              'status_verifikasi': 'Verified',
            },
          ],
        };

        final result = TagihanPembayaranModel.fromJson(jsonMap);

        expect(result.riwayatPembayaranId, 10);
        expect(result.metodePembayaran, 'Transfer');
        expect(result.buktiBayar, 'https://example.com/bukti.jpg');
        expect(result.statusVerifikasiRiwayat, 'Verified');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tTagihanPembayaranModel.toJson();

        expect(result['id'], 1);
        expect(result['tagihan_id'], 1);
        expect(result['metode_pembayaran'], 'Transfer');
        expect(result['bukti_bayar'], 'https://example.com/bukti.jpg');
        expect(result['status_verifikasi'], 'Pending');
      });

      test('should handle null values in toJson', () {
        final result = tTagihanPembayaranModel.toJson();

        expect(result['catatan_admin'], null);
        expect(result['verifikator_id'], null);
      });
    });
  });
}
