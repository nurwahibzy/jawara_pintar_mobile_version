import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/data/models/rumah_model.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/usecases/filter_rumah.dart';

abstract interface class RumahRemoteDataSource {
  Future<List<RumahModel>> getAllRumah();
  Future<RumahModel> getRumahById(int id);
  Future<void> createRumah(RumahModel rumah);
  Future<void> updateRumah(RumahModel rumah);
  Future<void> deleteRumah(int id);
  Future<List<RumahModel>> filterRumah(FilterRumahParams params);
}

class RumahRemoteDataSourceImpl implements RumahRemoteDataSource {
  final SupabaseClient supabaseClient;

  RumahRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : supabaseClient = Supabase.instance.client;

  @override
  Future<List<RumahModel>> getAllRumah() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('rumah')
          .select();

      final data = (response).map((e) => RumahModel.fromJson(e)).toList();

      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RumahModel> getRumahById(int id) async {
    try {
      final Map<String, dynamic> response = await supabaseClient
          .from('rumah')
          .select('''
            *,
            riwayat_penghuni(
              tanggal_masuk,
              tanggal_keluar,
              keluarga(
                warga(
                  nama_lengkap,
                  status_keluarga
                )
              )
            )
          ''')
          .eq('id', id)
          .single();

      return RumahModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createRumah(RumahModel rumah) {
    try {
      return supabaseClient.from('rumah').insert(rumah.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateRumah(RumahModel rumah) {
    try {
      return supabaseClient
          .from('rumah')
          .update(rumah.toJson())
          .eq('id', rumah.id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteRumah(int id) async {
    try {
      // Cek status rumah terlebih dahulu
      final rumah = await getRumahById(id);
      if (rumah.statusRumah.toLowerCase() != 'kosong') {
        throw Exception('Rumah hanya bisa dihapus jika statusnya Kosong');
      }

      // Hapus riwayat penghuni terlebih dahulu (jika ada)
      await supabaseClient.from('riwayat_penghuni').delete().eq('rumah_id', id);

      // Hapus rumah
      await supabaseClient.from('rumah').delete().eq('id', id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<RumahModel>> filterRumah(FilterRumahParams params) async {
    try {
      var query = supabaseClient.from('rumah').select();

      if (params.alamat != null && params.alamat!.isNotEmpty) {
        query = query.ilike('alamat', '%${params.alamat}%');
      }

      if (params.status != null &&
          params.status != 'Semua' &&
          params.status != '-- Pilih Status --') {
        query = query.eq('status_rumah', params.status!);
      }
      final List<dynamic> response = await query;

      return response.map((json) => RumahModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
