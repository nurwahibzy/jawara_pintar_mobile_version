import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/pesan_warga_model.dart';

abstract class AspirasiRemoteDataSource {
  Future<List<AspirasiModel>> getAllAspirasi();
  Future<AspirasiModel> getAspirasiById(int id);
  Future<void> addAspirasi(AspirasiModel model);
  Future<AspirasiModel> updateAspirasi(AspirasiModel model);
  Future<void> deleteAspirasi(int id);
}

class AspirasiRemoteDataSourceImpl implements AspirasiRemoteDataSource {
  final SupabaseClient client;
  AspirasiRemoteDataSourceImpl() : client = SupabaseService.client;

  @override
  Future<List<AspirasiModel>> getAllAspirasi() async {
    final response = await client
        .from('aspirasi')
        .select('''
          id,
          warga_id,
          judul,
          deskripsi,
          status,
          tanggapan_admin,
          updated_by,
          created_at,
          warga:warga!aspirasi_warga_id_fkey(nama_lengkap)
        ''')
        .order('created_at', ascending: false);

    final dataList = List<Map<String, dynamic>>.from(response);
    return dataList.map((e) => AspirasiModel.fromMap(e)).toList();
  }

  @override
  Future<AspirasiModel> getAspirasiById(int id) async {
    final response = await client
        .from('aspirasi')
        .select('''
          id,
          warga_id,
          judul,
          deskripsi,
          status,
          tanggapan_admin,
          updated_by,
          created_at,
          warga:warga!aspirasi_warga_id_fkey(nama_lengkap)
        ''')
        .eq('id', id)
        .maybeSingle();

    if (response == null) throw Exception('Aspirasi dengan id $id tidak ditemukan');
    return AspirasiModel.fromMap(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> addAspirasi(AspirasiModel model) async {
    await client.from('aspirasi').insert(model.toMap());
  }

 @override
  Future<AspirasiModel> updateAspirasi(AspirasiModel model) async {
    if (model.id == null) throw Exception('ID tidak boleh null saat update');

    final response = await client
        .from('aspirasi')
        .update(model.toMap(forUpdate: true))
        .eq('id', model.id!)
        .select('''
        *,
        warga:warga!aspirasi_warga_id_fkey(nama_lengkap)
      ''')
        .maybeSingle();

    if (response == null) throw Exception('Update gagal');
    return AspirasiModel.fromMap(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> deleteAspirasi(int id) async {
    await client.from('aspirasi').delete().eq('id', id);
  }
}