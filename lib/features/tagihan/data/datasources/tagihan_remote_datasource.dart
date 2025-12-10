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
      var query = supabaseClient.from('pembayaran_tagihan').select('''
            id,
            tagihan_id,
            metode_pembayaran,
            bukti_bayar,
            tanggal_bayar,
            status_verifikasi,
            catatan_admin,
            verifikator_id,
            created_at,
            tagihan:tagihan_id (
              kode_tagihan,
              keluarga_id,
              master_iuran_id,
              periode,
              nominal,
              status_tagihan,
              master_iuran:master_iuran_id (
                nama_iuran
              )
            )
          ''');

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.eq('status_verifikasi', statusFilter);
      }

      if (metodeFilter != null && metodeFilter.isNotEmpty) {
        query = query.eq('metode_pembayaran', metodeFilter);
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
          .from('pembayaran_tagihan')
          .select('''
            id,
            tagihan_id,
            metode_pembayaran,
            bukti_bayar,
            tanggal_bayar,
            status_verifikasi,
            catatan_admin,
            verifikator_id,
            created_at,
            tagihan:tagihan_id (
              kode_tagihan,
              keluarga_id,
              master_iuran_id,
              periode,
              nominal,
              status_tagihan,
              master_iuran:master_iuran_id (
                nama_iuran
              )
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
      final authId = supabaseClient.auth.currentUser?.id;

      // Ambil warga_id dari tabel users berdasarkan auth_id
      int? wargaId;
      if (authId != null) {
        final userResponse = await supabaseClient
            .from('users')
            .select('warga_id')
            .eq('auth_id', authId)
            .maybeSingle();

        if (userResponse != null) {
          wargaId = userResponse['warga_id'] as int?;
        }
      }

      final updateData = <String, dynamic>{'status_verifikasi': 'Diterima'};

      if (keterangan != null && keterangan.isNotEmpty) {
        updateData['catatan_admin'] = keterangan;
      }

      if (wargaId != null) {
        updateData['verifikator_id'] = wargaId;
      }

      await supabaseClient
          .from('pembayaran_tagihan')
          .update(updateData)
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
      final authId = supabaseClient.auth.currentUser?.id;

      // Ambil warga_id dari tabel users berdasarkan auth_id
      int? wargaId;
      if (authId != null) {
        final userResponse = await supabaseClient
            .from('users')
            .select('warga_id')
            .eq('auth_id', authId)
            .maybeSingle();

        if (userResponse != null) {
          wargaId = userResponse['warga_id'] as int?;
        }
      }

      final updateData = <String, dynamic>{
        'status_verifikasi': 'Ditolak',
        'catatan_admin': keterangan,
      };

      if (wargaId != null) {
        updateData['verifikator_id'] = wargaId;
      }

      await supabaseClient
          .from('pembayaran_tagihan')
          .update(updateData)
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
