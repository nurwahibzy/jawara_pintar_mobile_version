import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';

void main() {
  final tTanggal = DateTime(2024, 10, 1);
  final tCreatedAt = DateTime(2024, 10, 2);

  final tMutasi1 = MutasiKeluarga(
    id: 1,
    keluargaId: 10,
    jenisMutasi: 'Pindah',
    rumahAsalId: 5,
    rumahTujuanId: 8,
    tanggalMutasi: tTanggal,
    keterangan: 'Pindah rumah',
    fileBukti: 'bukti.pdf',
    createdAt: tCreatedAt,
    namaKepalaKeluarga: 'Budi',
    alamatAsal: 'Jl. Mawar',
    alamatTujuan: 'Jl. Melati',
  );

  final tMutasi2 = MutasiKeluarga(
    id: 1,
    keluargaId: 10,
    jenisMutasi: 'Pindah',
    rumahAsalId: 5,
    rumahTujuanId: 8,
    tanggalMutasi: tTanggal,
    keterangan: 'Pindah rumah',
    fileBukti: 'bukti.pdf',
    createdAt: tCreatedAt,
    namaKepalaKeluarga: 'Budi',
    alamatAsal: 'Jl. Mawar',
    alamatTujuan: 'Jl. Melati',
  );

  final tMutasiDifferent = MutasiKeluarga(
    id: 2,
    keluargaId: 11,
    jenisMutasi: 'Datang',
    tanggalMutasi: tTanggal,
  );

  group('MutasiKeluarga Entity', () {
    test('harus merupakan subclass dari Equatable', () {
      expect(tMutasi1, isA<Equatable>());
    });

    test('dua object dengan nilai sama harus equal', () {
      // assert
      expect(tMutasi1, equals(tMutasi2));
    });

    test('object dengan nilai berbeda tidak equal', () {
      // assert
      expect(tMutasi1 == tMutasiDifferent, false);
    });

    test('props harus mengembalikan list yang sesuai', () {
      // act
      final props = tMutasi1.props;

      // assert
      expect(props, [
        1,
        10,
        'Pindah',
        5,
        8,
        tTanggal,
        'Pindah rumah',
        'bukti.pdf',
        tCreatedAt,
        'Budi',
      ]);
    });
  });
}
