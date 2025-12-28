import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/tagihan/domain/entities/tagihan_pembayaran.dart';

void main() {
  final tTagihanPembayaran = TagihanPembayaran(
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

  group('TagihanPembayaran', () {
    test('should be a TagihanPembayaran instance', () {
      expect(tTagihanPembayaran, isA<TagihanPembayaran>());
    });

    test('should have correct properties', () {
      expect(tTagihanPembayaran.id, 1);
      expect(tTagihanPembayaran.tagihanId, 1);
      expect(tTagihanPembayaran.metode, 'Transfer');
      expect(tTagihanPembayaran.bukti, 'https://example.com/bukti.jpg');
      expect(tTagihanPembayaran.statusVerifikasi, 'Pending');
      expect(tTagihanPembayaran.kodeTagihan, 'TG-2023-001');
    });

    test('should support value equality', () {
      final tTagihanPembayaranDuplicate = TagihanPembayaran(
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

      expect(tTagihanPembayaran, tTagihanPembayaranDuplicate);
    });

    test('should handle nullable fields', () {
      expect(tTagihanPembayaran.catatanAdmin, null);
      expect(tTagihanPembayaran.verifikatorId, null);
      expect(tTagihanPembayaran.riwayatPembayaranId, null);
    });

    test('should handle verified payment', () {
      final verifiedPayment = TagihanPembayaran(
        id: 2,
        tagihanId: 2,
        metode: 'Transfer',
        bukti: 'https://example.com/bukti2.jpg',
        tanggalBayar: DateTime(2023, 2, 15),
        statusVerifikasi: 'Verified',
        catatanAdmin: 'Pembayaran telah diverifikasi',
        verifikatorId: 10,
        createdAt: DateTime(2023, 2, 15),
        kodeTagihan: 'TG-2023-002',
      );

      expect(verifiedPayment.statusVerifikasi, 'Verified');
      expect(verifiedPayment.catatanAdmin, isNotNull);
      expect(verifiedPayment.verifikatorId, 10);
    });

    test('should have all required fields in props', () {
      expect(tTagihanPembayaran.props.length, 21);
    });
  });
}
