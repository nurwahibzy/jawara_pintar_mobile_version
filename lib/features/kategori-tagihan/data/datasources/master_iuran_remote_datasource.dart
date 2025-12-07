import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/master_iuran_model.dart';

abstract class MasterIuranRemoteDataSource {
  Future<List<MasterIuranModel>> getMasterIuranList();
  Future<MasterIuranModel> getMasterIuranById(int id);
  Future<MasterIuranModel> createMasterIuran(MasterIuranModel masterIuran);
  Future<MasterIuranModel> updateMasterIuran(MasterIuranModel masterIuran);
  Future<void> deleteMasterIuran(int id);
  Future<List<MasterIuranModel>> getMasterIuranByKategori(int kategoriId);
}

class MasterIuranRemoteDataSourceImpl implements MasterIuranRemoteDataSource {
  final SupabaseClient supabaseClient;

  MasterIuranRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<MasterIuranModel>> getMasterIuranList() async {
    try {
      final response = await supabaseClient
          .from('master_iuran')
          .select('''
            *,
            kategori_iuran:kategori_iuran_id (
              id,
              nama_kategori
            )
          ''')
          .order('id', ascending: true);

      return (response as List)
          .map((json) => MasterIuranModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get master iuran list: $e');
    }
  }

  @override
  Future<MasterIuranModel> getMasterIuranById(int id) async {
    try {
      final response = await supabaseClient
          .from('master_iuran')
          .select('''
            *,
            kategori_iuran:kategori_iuran_id (
              id,
              nama_kategori
            )
          ''')
          .eq('id', id)
          .single();

      return MasterIuranModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get master iuran by id: $e');
    }
  }

  @override
  Future<MasterIuranModel> createMasterIuran(
    MasterIuranModel masterIuran,
  ) async {
    try {
      final data = {
        'kategori_iuran_id': masterIuran.kategoriIuranId,
        'nama_iuran': masterIuran.namaIuran,
        'nominal_standar': masterIuran.nominalStandar,
        'is_active': masterIuran.isActive,
      };

      final response = await supabaseClient
          .from('master_iuran')
          .insert(data)
          .select('''
            *,
            kategori_iuran:kategori_iuran_id (
              id,
              nama_kategori
            )
          ''')
          .single();

      return MasterIuranModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create master iuran: $e');
    }
  }

  @override
  Future<MasterIuranModel> updateMasterIuran(
    MasterIuranModel masterIuran,
  ) async {
    try {
      final data = {
        'kategori_iuran_id': masterIuran.kategoriIuranId,
        'nama_iuran': masterIuran.namaIuran,
        'nominal_standar': masterIuran.nominalStandar,
        'is_active': masterIuran.isActive,
      };

      final response = await supabaseClient
          .from('master_iuran')
          .update(data)
          .eq('id', masterIuran.id)
          .select('''
            *,
            kategori_iuran:kategori_iuran_id (
              id,
              nama_kategori
            )
          ''')
          .single();

      return MasterIuranModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update master iuran: $e');
    }
  }

  @override
  Future<void> deleteMasterIuran(int id) async {
    try {
      await supabaseClient.from('master_iuran').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete master iuran: $e');
    }
  }

  @override
  Future<List<MasterIuranModel>> getMasterIuranByKategori(
    int kategoriId,
  ) async {
    try {
      final response = await supabaseClient
          .from('master_iuran')
          .select('''
            *,
            kategori_iuran:kategori_iuran_id (
              id,
              nama_kategori
            )
          ''')
          .eq('kategori_iuran_id', kategoriId)
          .order('nama_iuran', ascending: true);

      return (response as List)
          .map((json) => MasterIuranModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get master iuran by kategori: $e');
    }
  }
}
