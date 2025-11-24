import '../../../../core/services/supabase_service.dart';
import '../models/pengeluaran_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PengeluaranRemoteDataSource {
  Future<List<PengeluaranModel>> getAllPengeluaran();
  Future<PengeluaranModel> getPengeluaranById(int id);
  Future<void> createPengeluaran(PengeluaranModel model);
  Future<void> updatePengeluaran(PengeluaranModel model);
  Future<void> deletePengeluaran(int id);
}

class PengeluaranRemoteDataSourceImpl implements PengeluaranRemoteDataSource {
  final SupabaseClient client;

  PengeluaranRemoteDataSourceImpl() : client = SupabaseService.client;

  @override
  Future<List<PengeluaranModel>> getAllPengeluaran() async {
    final response = await client.from('pengeluaran').select();

    final dataList = List<Map<String, dynamic>>.from(response);
    return dataList.map((e) => PengeluaranModel.fromMap(e)).toList();
  }


  @override
  Future<PengeluaranModel> getPengeluaranById(int id) async {
    final response = await client
        .from('pengeluaran')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      throw Exception('Pengeluaran dengan id $id tidak ditemukan');
    }
    return PengeluaranModel.fromMap(response);
  }

 @override
  Future<void> createPengeluaran(PengeluaranModel model) async {
    await client.from('pengeluaran').insert(model.toMapForInsert());
  }
@override
  Future<void> updatePengeluaran(PengeluaranModel model) async {
    if (model.id == null) {
      throw Exception("ID tidak boleh null saat update");
    }
    await client.from('pengeluaran').update(model.toMap(forUpdate: true)).eq('id', model.id!);
  }

  @override
  Future<void> deletePengeluaran(int id) async {
    await client.from('pengeluaran').delete().eq('id', id);
  }
}
