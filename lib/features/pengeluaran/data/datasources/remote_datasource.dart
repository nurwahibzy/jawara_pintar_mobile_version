import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/kategori_transaksi.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/pengeluaran_model.dart';
import '../models/kategori_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PengeluaranRemoteDataSource {
  Future<List<PengeluaranModel>> getAllPengeluaran();
  Future<PengeluaranModel> getPengeluaranById(int id);
  Future<void> createPengeluaran(PengeluaranModel model);
  Future<void> updatePengeluaran(PengeluaranModel model);
  Future<void> deletePengeluaran(int id);
  Future<List<KategoriEntity>> getKategoriPengeluaran();
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

 @override
  Future<List<KategoriEntity>> getKategoriPengeluaran() async {
    final response = await client
        .from('kategori_transaksi')
        .select()
        .eq('jenis', 'Pengeluaran');

   return (response as List)
        .map((json) => KategoriModel.fromJson(json))
        .map(
          (model) =>
              KategoriEntity(id: model.id, nama_kategori: model.nama_kategori, jenis: 'Pengeluaran'),
        )
        .toList();
  }
}

