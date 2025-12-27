import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/pemasukan/domain/entities/pemasukan.dart';

void main() {
  final tPemasukan = Pemasukan(
    id: 1,
    judul: 'Iuran Bulanan',
    kategoriTransaksiId: 1,
    nominal: 100000.0,
    tanggalTransaksi: '2023-01-15',
    buktiFoto: null,
    keterangan: 'Iuran bulanan bulan Januari',
    createdBy: 1,
    verifikatorId: null,
    tanggalVerifikasi: null,
    createdAt: DateTime(2023, 1, 1),
    namaKategori: 'Iuran',
    namaCreatedBy: 'John Doe',
    namaVerifikator: null,
  );

  group('Pemasukan', () {
    test('should be a Pemasukan instance', () {
      // Assert
      expect(tPemasukan, isA<Pemasukan>());
    });

    test('should have correct properties', () {
      // Assert
      expect(tPemasukan.id, 1);
      expect(tPemasukan.judul, 'Iuran Bulanan');
      expect(tPemasukan.kategoriTransaksiId, 1);
      expect(tPemasukan.nominal, 100000.0);
      expect(tPemasukan.tanggalTransaksi, '2023-01-15');
      expect(tPemasukan.keterangan, 'Iuran bulanan bulan Januari');
      expect(tPemasukan.createdBy, 1);
      expect(tPemasukan.namaKategori, 'Iuran');
      expect(tPemasukan.namaCreatedBy, 'John Doe');
    });

    test('should support value equality', () {
      // Arrange
      final tPemasukanDuplicate = Pemasukan(
        id: 1,
        judul: 'Iuran Bulanan',
        kategoriTransaksiId: 1,
        nominal: 100000.0,
        tanggalTransaksi: '2023-01-15',
        buktiFoto: null,
        keterangan: 'Iuran bulanan bulan Januari',
        createdBy: 1,
        verifikatorId: null,
        tanggalVerifikasi: null,
        createdAt: DateTime(2023, 1, 1),
        namaKategori: 'Iuran',
        namaCreatedBy: 'John Doe',
        namaVerifikator: null,
      );

      // Assert
      expect(tPemasukan, tPemasukanDuplicate);
    });

    test('should handle nullable fields', () {
      // Arrange
      final tPemasukanWithNulls = Pemasukan(
        id: 2,
        judul: 'Sumbangan Sukarela',
        kategoriTransaksiId: 2,
        nominal: 50000.0,
        tanggalTransaksi: '2023-01-20',
        buktiFoto: null,
        keterangan: 'Sumbangan dari warga',
        createdBy: 2,
        verifikatorId: null,
        tanggalVerifikasi: null,
        createdAt: DateTime(2023, 1, 20),
        namaKategori: 'Sumbangan',
        namaCreatedBy: 'Jane Doe',
        namaVerifikator: null,
      );

      // Assert
      expect(tPemasukanWithNulls.buktiFoto, null);
      expect(tPemasukanWithNulls.verifikatorId, null);
      expect(tPemasukanWithNulls.tanggalVerifikasi, null);
      expect(tPemasukanWithNulls.namaVerifikator, null);
    });

    test('should have all required fields in props', () {
      // Assert
      expect(tPemasukan.props.length, 14);
      expect(tPemasukan.props[0], 1); // id
      expect(tPemasukan.props[1], 'Iuran Bulanan'); // judul
      expect(tPemasukan.props[2], 1); // kategoriTransaksiId
      expect(tPemasukan.props[3], 100000.0); // nominal
    });
  });
}
