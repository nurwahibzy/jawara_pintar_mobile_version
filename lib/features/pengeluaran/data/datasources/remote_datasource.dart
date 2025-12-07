import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/kategori_transaksi.dart';
import '../models/kategori_model.dart';
import '../models/pengeluaran_model.dart';

abstract class PengeluaranRemoteDataSource {
  Future<List<PengeluaranModel>> getAllPengeluaran();
  Future<PengeluaranModel?> getPengeluaranById(int id);
  Future<void> createPengeluaran(PengeluaranModel model);
  Future<void> updatePengeluaran(PengeluaranModel model);
  Future<void> deletePengeluaran(int id);
  Future<List<KategoriEntity>> getKategoriPengeluaran();
  Future<String?> uploadBukti(File file, {String? oldUrl});
  Future<Map<String, String?>> getNamesByUids(List<String> uids);
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
  Future<PengeluaranModel?> getPengeluaranById(int id) async {
    final response = await client
        .from('pengeluaran')
        .select('''
          *,
          users:created_by (
  auth_id,
  role,
  warga:warga_id (nama_lengkap)
)
        ''')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    final row = Map<String, dynamic>.from(response);

    String? namaPembuat = row["users"]?["warga"]?["nama_lengkap"];

    return PengeluaranModel.fromMap(row).copyWith(createdByName: namaPembuat);
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
    await client
        .from('pengeluaran')
        .update(model.toMap(forUpdate: true))
        .eq('id', model.id!);
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
          (model) => KategoriEntity(
            id: model.id,
            nama_kategori: model.nama_kategori,
            jenis: 'Pengeluaran',
          ),
        )
        .toList();
  }

  @override
  Future<String?> uploadBukti(File file, {String? oldUrl}) async {
    try {
      final bucket = 'pengeluaran';

      String fileName;
      if (oldUrl != null && oldUrl.isNotEmpty) {
        final uri = Uri.parse(oldUrl);
        final segments = uri.pathSegments;
        final fileIndex = segments.indexOf(bucket) + 1;
        fileName = segments[fileIndex];
      } else {
        fileName =
            'pengeluaran_${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      }

      final storagePath = fileName;
      final bytes = await file.readAsBytes();

      await client.storage
          .from(bucket)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      final publicUrl = client.storage.from(bucket).getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Gagal upload bukti: $e');
    }
  }

  @override
  Future<Map<String, String?>> getNamesByUids(List<String> uids) async {
    if (uids.isEmpty) return {};

    final validUids = uids.where((uid) => uid.length == 36).toList();
    if (validUids.isEmpty) return {};

    final data = await client
        .from('users')
        .select('auth_id, warga:warga_id(nama_lengkap)')
        .filter('auth_id', 'in', validUids);

    final Map<String, String?> result = {};
    for (var item in data as List) {
      final authId = item['auth_id'];
      String? nama;
      final warga = item['warga'];
      if (warga is Map) nama = warga['nama_lengkap'];
      if (warga is List && warga.isNotEmpty) nama = warga[0]['nama_lengkap'];
      result[authId.toString()] = nama;
    }
    return result;
  }
}
