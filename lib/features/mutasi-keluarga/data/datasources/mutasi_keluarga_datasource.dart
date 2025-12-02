import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/mutasi_keluarga_models.dart';

abstract class MutasiKeluargaDatasource {
  Future<List<MutasiKeluargaModel>> getAllMutasiKeluarga();
  Future<MutasiKeluargaModel> getMutasiKeluarga(int id);
  Future<void> createMutasiKeluarga(MutasiKeluargaModel mutasi);
  Future<List<Map<String, dynamic>>> getOptionKeluarga(); 
  Future<List<Map<String, dynamic>>> getOptionRumah();
  Future<List<Map<String, dynamic>>> getOptionWarga();
}

class MutasiKeluargaDatasourceImplementation extends MutasiKeluargaDatasource {
  final String _table = 'mutasi_keluarga';
  final SupabaseClient client;

  MutasiKeluargaDatasourceImplementation() : client = SupabaseService.client;
  // MutasiKeluargaDatasourceImplementation({required this.client});

  @override
  Future<void> createMutasiKeluarga(MutasiKeluargaModel mutasi) async {
    await client.from(_table).insert(mutasi.toMap());
  }

  @override
  Future<List<MutasiKeluargaModel>> getAllMutasiKeluarga() async {
    try {
      // Query JOIN
      final response = await client.from(_table).select('''
        *,
        keluarga:keluarga_id (
          nomor_kk,
          warga (
            nama_lengkap,
            status_keluarga
          )
        ),
        rumah_asal:rumah_asal_id (
          alamat
        ),
        rumah_tujuan:rumah_tujuan_id (
          alamat
        )
      '''); 

      final dataList = List<Map<String, dynamic>>.from(response);
      return dataList.map((data) => MutasiKeluargaModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MutasiKeluargaModel> getMutasiKeluarga(int id) async {
    final response = await client.from(_table).select().eq('id', id).single();
    return MutasiKeluargaModel.fromJson(response);
  }

 @override
  Future<List<Map<String, dynamic>>> getOptionKeluarga() async {
    final response = await client
        .from('keluarga')
        // Ambil id, nomor_kk, dan rumah_id (foreign key)
        .select('id, nomor_kk, rumah_id, warga(nama_lengkap, status_keluarga)');
    
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getOptionRumah() async {
    final response = await client
        .from('rumah') // Pastikan nama tabel benar (rumah / rumah_warga?)
        // Ambil id dan alamat
        .select('id, alamat');
        
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getOptionWarga() async {
    final response = await client
        .from('warga') 
        .select('id, nama_lengkap, status_keluarga');
        
    return List<Map<String, dynamic>>.from(response);
  }
}
