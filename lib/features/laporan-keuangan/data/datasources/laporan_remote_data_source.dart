import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pemasukan_detail_model.dart';
import '../models/pengeluaran_detail_model.dart';

abstract class LaporanRemoteDataSource {
  Future<List<PemasukanDetailModel>> getAllPemasukan({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  });

  Future<List<PengeluaranDetailModel>> getAllPengeluaran({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  });
}

class LaporanRemoteDataSourceImpl implements LaporanRemoteDataSource {
  final SupabaseClient supabaseClient;

  LaporanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<PemasukanDetailModel>> getAllPemasukan({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    try {
      // Query untuk pemasukan_lain
      var queryPemasukanLain = supabaseClient.from('pemasukan_lain').select('''
            id,
            judul,
            kategori_transaksi_id,
            nominal,
            tanggal_transaksi,
            bukti_foto,
            keterangan,
            created_by,
            verifikator_id,
            tanggal_verifikasi,
            created_at,
            kategori_transaksi (
              nama_kategori
            )
          ''');

      // Apply filters
      if (tanggalMulai != null) {
        queryPemasukanLain = queryPemasukanLain.gte(
          'tanggal_transaksi',
          tanggalMulai.toIso8601String(),
        );
      }
      if (tanggalAkhir != null) {
        queryPemasukanLain = queryPemasukanLain.lte(
          'tanggal_transaksi',
          tanggalAkhir.toIso8601String(),
        );
      }
      if (kategori != null && kategori.isNotEmpty) {
        queryPemasukanLain = queryPemasukanLain.eq(
          'kategori_transaksi_id',
          int.parse(kategori),
        );
      }

      // Query untuk tagihan
      var queryTagihan = supabaseClient
          .from('tagihan')
          .select('''
            id,
            kode_tagihan,
            keluarga_id,
            master_iuran_id,
            periode,
            nominal,
            status_tagihan,
            file_struk_final,
            created_at,
            master_iuran (
              nama_iuran
            )
          ''')
          .eq('status_tagihan', 'Lunas');

      // Apply filters untuk tagihan
      if (tanggalMulai != null) {
        queryTagihan = queryTagihan.gte(
          'periode',
          tanggalMulai.toIso8601String(),
        );
      }
      if (tanggalAkhir != null) {
        queryTagihan = queryTagihan.lte(
          'periode',
          tanggalAkhir.toIso8601String(),
        );
      }

      final pemasukanLainResponse = await queryPemasukanLain as List;
      final tagihanResponse = await queryTagihan as List;

      // Convert pemasukan_lain
      final pemasukanLainList = pemasukanLainResponse
          .map((json) => PemasukanDetailModel.fromJson(json))
          .toList();

      // Convert tagihan to PemasukanDetailModel
      final tagihanList = tagihanResponse.map((json) {
        return PemasukanDetailModel(
          id: json['id'] as int,
          judul: 'Pembayaran ${json['master_iuran']?['nama_iuran'] ?? 'Iuran'}',
          kategori: 'Iuran/Tagihan',
          nominal: (json['nominal'] as num).toDouble(),
          tanggalTransaksi: DateTime.parse(json['periode'] as String),
          buktiFoto: json['file_struk_final'] as String?,
          keterangan: 'Pembayaran tagihan periode ${json['periode']}',
          createdBy: '-',
          tanggalVerifikasi: json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
        );
      }).toList();

      // Combine both lists
      final allPemasukan = [...pemasukanLainList, ...tagihanList];

      // Sort by date descending
      allPemasukan.sort(
        (a, b) => b.tanggalTransaksi.compareTo(a.tanggalTransaksi),
      );

      return allPemasukan;
    } catch (e) {
      throw Exception('Gagal mengambil data pemasukan: $e');
    }
  }

  @override
  Future<List<PengeluaranDetailModel>> getAllPengeluaran({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    try {
      var query = supabaseClient.from('pengeluaran').select('''
            id,
            judul,
            kategori_transaksi_id,
            nominal,
            tanggal_transaksi,
            bukti_foto,
            keterangan,
            created_by,
            verifikator_id,
            tanggal_verifikasi,
            created_at,
            kategori_transaksi (
              nama_kategori
            )
          ''');

      // Apply filters
      if (tanggalMulai != null) {
        query = query.gte('tanggal_transaksi', tanggalMulai.toIso8601String());
      }
      if (tanggalAkhir != null) {
        query = query.lte('tanggal_transaksi', tanggalAkhir.toIso8601String());
      }
      if (kategori != null && kategori.isNotEmpty) {
        query = query.eq('kategori_transaksi_id', int.parse(kategori));
      }

      final response = await query as List;

      final pengeluaranList = response
          .map((json) => PengeluaranDetailModel.fromJson(json))
          .toList();

      // Sort by date descending
      pengeluaranList.sort(
        (a, b) => b.tanggalTransaksi.compareTo(a.tanggalTransaksi),
      );

      return pengeluaranList;
    } catch (e) {
      throw Exception('Gagal mengambil data pengeluaran: $e');
    }
  }
}
