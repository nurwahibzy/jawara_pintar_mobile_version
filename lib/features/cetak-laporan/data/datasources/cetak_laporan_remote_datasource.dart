import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/laporan_cetak_model.dart';

abstract class CetakLaporanRemoteDataSource {
  Future<LaporanCetakModel> getLaporanData({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
  });
}

class CetakLaporanRemoteDataSourceImpl implements CetakLaporanRemoteDataSource {
  final SupabaseClient supabaseClient;

  CetakLaporanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<LaporanCetakModel> getLaporanData({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
  }) async {
    try {
      List<ItemTransaksiModel> pemasukan = [];
      List<ItemTransaksiModel> pengeluaran = [];

      // Fetch Pemasukan (jika perlu)
      if (jenisLaporan == 'semua' || jenisLaporan == 'pemasukan') {
        pemasukan = await _fetchPemasukan(tanggalMulai, tanggalAkhir);
      }

      // Fetch Pengeluaran (jika perlu)
      if (jenisLaporan == 'semua' || jenisLaporan == 'pengeluaran') {
        pengeluaran = await _fetchPengeluaran(tanggalMulai, tanggalAkhir);
      }

      return LaporanCetakModel.fromEntities(
        tanggalMulai: tanggalMulai,
        tanggalAkhir: tanggalAkhir,
        jenisLaporan: jenisLaporan,
        pemasukan: pemasukan,
        pengeluaran: pengeluaran,
      );
    } catch (e) {
      throw Exception('Gagal mengambil data laporan: ${e.toString()}');
    }
  }

  Future<List<ItemTransaksiModel>> _fetchPemasukan(
    DateTime tanggalMulai,
    DateTime tanggalAkhir,
  ) async {
    final responsePemasukanLain = await supabaseClient
        .from('pemasukan_lain')
        .select('''
          id,
          judul,
          nominal,
          tanggal_transaksi,
          keterangan,
          kategori_transaksi(nama_kategori)
        ''')
        .gte('tanggal_transaksi', tanggalMulai.toIso8601String())
        .lte('tanggal_transaksi', tanggalAkhir.toIso8601String())
        .order('tanggal_transaksi', ascending: false);

    final responseTagihan = await supabaseClient
        .from('tagihan')
        .select('''
          id,
          kode_tagihan,
          nominal,
          created_at,
          master_iuran(nama_iuran)
        ''')
        .eq('status_tagihan', 'Lunas')
        .gte('created_at', tanggalMulai.toIso8601String())
        .lte('created_at', tanggalAkhir.toIso8601String())
        .order('created_at', ascending: false);

    final List<ItemTransaksiModel> pemasukan = [];

    for (var item in responsePemasukanLain) {
      pemasukan.add(ItemTransaksiModel.fromJson(item));
    }

    for (var item in responseTagihan) {
      pemasukan.add(
        ItemTransaksiModel.fromJson({
          ...item,
          'judul': 'Pembayaran ${item['kode_tagihan']}',
          'tanggal_transaksi': item['created_at'],
          'keterangan': null,
        }),
      );
    }

    pemasukan.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return pemasukan;
  }

  Future<List<ItemTransaksiModel>> _fetchPengeluaran(
    DateTime tanggalMulai,
    DateTime tanggalAkhir,
  ) async {
    final response = await supabaseClient
        .from('pengeluaran')
        .select('''
          id,
          judul,
          nominal,
          tanggal_transaksi,
          keterangan,
          kategori_transaksi(nama_kategori)
        ''')
        .gte('tanggal_transaksi', tanggalMulai.toIso8601String())
        .lte('tanggal_transaksi', tanggalAkhir.toIso8601String())
        .order('tanggal_transaksi', ascending: false);

    return response.map<ItemTransaksiModel>((item) {
      return ItemTransaksiModel.fromJson(item);
    }).toList();
  }
}
