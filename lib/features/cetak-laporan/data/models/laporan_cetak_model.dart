import '../../domain/entities/laporan_cetak_entity.dart';

class LaporanCetakModel extends LaporanCetakEntity {
  const LaporanCetakModel({
    required super.tanggalMulai,
    required super.tanggalAkhir,
    required super.jenisLaporan,
    required super.totalPemasukan,
    required super.totalPengeluaran,
    required super.saldo,
    required super.jumlahTransaksiPemasukan,
    required super.jumlahTransaksiPengeluaran,
    required super.daftarPemasukan,
    required super.daftarPengeluaran,
  });

  factory LaporanCetakModel.fromEntities({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
    required List<ItemTransaksiModel> pemasukan,
    required List<ItemTransaksiModel> pengeluaran,
  }) {
    final totalPemasukan = pemasukan.fold<double>(
      0.0,
      (sum, item) => sum + item.nominal,
    );
    final totalPengeluaran = pengeluaran.fold<double>(
      0.0,
      (sum, item) => sum + item.nominal,
    );

    return LaporanCetakModel(
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      jenisLaporan: jenisLaporan,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
      saldo: totalPemasukan - totalPengeluaran,
      jumlahTransaksiPemasukan: pemasukan.length,
      jumlahTransaksiPengeluaran: pengeluaran.length,
      daftarPemasukan: pemasukan,
      daftarPengeluaran: pengeluaran,
    );
  }
}

class ItemTransaksiModel extends ItemTransaksiEntity {
  const ItemTransaksiModel({
    required super.id,
    required super.judul,
    required super.kategori,
    required super.nominal,
    required super.tanggal,
    super.keterangan,
  });

  factory ItemTransaksiModel.fromJson(Map<String, dynamic> json) {
    return ItemTransaksiModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      kategori:
          json['kategori_transaksi']?['nama_kategori'] ??
          json['master_iuran']?['nama_iuran'] ??
          'Tidak ada kategori',
      nominal: (json['nominal'] ?? 0).toDouble(),
      tanggal: DateTime.parse(json['tanggal_transaksi'] ?? json['created_at']),
      keterangan: json['keterangan'],
    );
  }
}
