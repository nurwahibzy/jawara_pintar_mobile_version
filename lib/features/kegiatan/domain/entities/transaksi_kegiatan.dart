import 'package:equatable/equatable.dart';

/// Bridge entity between kegiatan and pemasukan/pengeluaran
/// Tidak menyimpan nominal, hanya reference ke transaksi
class TransaksiKegiatan extends Equatable {
  final int id;
  final int kegiatanId;
  final String jenisTransaksi; // 'Pemasukan' or 'Pengeluaran'
  final int? pemasukanId;
  final int? pengeluaranId;
  final int createdBy;
  final DateTime createdAt;

  // Data dari JOIN (optional, untuk display)
  final String? judul;
  final double? nominal;
  final DateTime? tanggalTransaksi;
  final String? keterangan;
  final String? buktiFoto;
  final String? namaKategori;
  final String? namaCreatedBy;

  const TransaksiKegiatan({
    required this.id,
    required this.kegiatanId,
    required this.jenisTransaksi,
    this.pemasukanId,
    this.pengeluaranId,
    required this.createdBy,
    required this.createdAt,
    // Optional dari JOIN
    this.judul,
    this.nominal,
    this.tanggalTransaksi,
    this.keterangan,
    this.buktiFoto,
    this.namaKategori,
    this.namaCreatedBy,
  });

  bool get isPemasukan => jenisTransaksi.toLowerCase() == 'pemasukan';
  bool get isPengeluaran => jenisTransaksi.toLowerCase() == 'pengeluaran';

  @override
  List<Object?> get props => [
    id,
    kegiatanId,
    jenisTransaksi,
    pemasukanId,
    pengeluaranId,
    createdBy,
    createdAt,
    judul,
    nominal,
    tanggalTransaksi,
    keterangan,
    buktiFoto,
    namaKategori,
    namaCreatedBy,
  ];
}
