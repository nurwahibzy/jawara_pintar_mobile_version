import '../models/tagihan_pembayaran_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

abstract class TagihanRemoteDataSource {
  Future<List<TagihanPembayaranModel>> getTagihanPembayaranList({
    String? statusFilter,
    String? metodeFilter,
  });
  Future<TagihanPembayaranModel> getTagihanPembayaranDetail(int id);
  Future<void> approveTagihanPembayaran({required int id, String? keterangan});
  Future<void> rejectTagihanPembayaran({
    required int id,
    required String keterangan,
  });
}

class TagihanRemoteDataSourceImpl implements TagihanRemoteDataSource {
  final SupabaseClient supabaseClient;

  TagihanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TagihanPembayaranModel>> getTagihanPembayaranList({
    String? statusFilter,
    String? metodeFilter,
  }) async {
    try {
      var query = supabaseClient.from('tagihan').select('''
            id,
            kode_tagihan,
            keluarga_id,
            master_iuran_id,
            periode,
            nominal,
            status_tagihan,
            created_at,
            master_iuran:master_iuran_id (
              nama_iuran
            )
          ''');

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.eq('status_tagihan', statusFilter);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => TagihanPembayaranModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TagihanPembayaranModel> getTagihanPembayaranDetail(int id) async {
    try {
      final response = await supabaseClient
          .from('tagihan')
          .select('''
            id,
            kode_tagihan,
            keluarga_id,
            master_iuran_id,
            periode,
            nominal,
            status_tagihan,
            created_at,
            master_iuran:master_iuran_id (
              nama_iuran
            ),
            pembayaran_tagihan (
              id,
              metode_pembayaran,
              bukti_bayar,
              tanggal_bayar,
              status_verifikasi
            )
          ''')
          .eq('id', id)
          .single();

      return TagihanPembayaranModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> approveTagihanPembayaran({
    required int id,
    String? keterangan,
  }) async {
    try {
      await supabaseClient
          .from('tagihan')
          .update({'status_tagihan': 'Lunas'})
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> rejectTagihanPembayaran({
    required int id,
    required String keterangan,
  }) async {
    try {
      await supabaseClient
          .from('tagihan')
          .update({'status_tagihan': 'Belum Lunas'})
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
