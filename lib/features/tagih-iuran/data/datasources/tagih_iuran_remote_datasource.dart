import '../models/master_iuran_dropdown_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

abstract class TagihIuranRemoteDataSource {
  Future<List<MasterIuranDropdownModel>> getMasterIuranDropdown();
  Future<Map<String, dynamic>> createTagihIuran({
    required int masterIuranId,
    required String periode,
  });
}

class TagihIuranRemoteDataSourceImpl implements TagihIuranRemoteDataSource {
  final SupabaseClient supabaseClient;

  TagihIuranRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<MasterIuranDropdownModel>> getMasterIuranDropdown() async {
    try {
      final response = await supabaseClient
          .from('master_iuran')
          .select('''
            id,
            nama_iuran,
            nominal_standar,
            kategori_iuran:kategori_iuran_id (
              nama_kategori
            )
          ''')
          .eq('is_active', true)
          .order('nama_iuran');

      return (response as List)
          .map((json) => MasterIuranDropdownModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> createTagihIuran({
    required int masterIuranId,
    required String periode,
  }) async {
    try {
      // Call stored procedure atau function di Supabase
      // yang akan generate tagihan untuk semua keluarga aktif
      final response = await supabaseClient.rpc(
        'generate_tagih_iuran',
        params: {'p_master_iuran_id': masterIuranId, 'p_periode': periode},
      );

      return {
        'success': true,
        'message': 'Tagihan berhasil digenerate',
        'data': response,
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
