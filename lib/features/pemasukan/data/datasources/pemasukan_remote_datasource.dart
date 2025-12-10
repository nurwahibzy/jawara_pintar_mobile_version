import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/pemasukan_model.dart';

abstract class PemasukanRemoteDataSource {
  Future<List<PemasukanModel>> getPemasukanList({String? kategoriFilter});
  Future<PemasukanModel> getPemasukanDetail(int id);
  Future<void> createPemasukan({
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  });
  Future<void> updatePemasukan({
    required int id,
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  });
  Future<void> deletePemasukan(int id);
  Future<String?> uploadBukti(File file, {String? oldUrl});
}

class PemasukanRemoteDataSourceImpl implements PemasukanRemoteDataSource {
  final SupabaseClient supabaseClient;

  PemasukanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<PemasukanModel>> getPemasukanList({
    String? kategoriFilter,
  }) async {
    try {
      var query = supabaseClient.from('pemasukan_lain').select('''
            id,
            judul,
            kategori_transaksi_id,
            nominal,
            tanggal_transaksi,
            bukti_foto,
            keterangan,
            created_by,
            verifikator_id,
            tanggal_verifikasi,
            created_at,
            kategori_transaksi:kategori_transaksi_id (
              nama_kategori
            )
          ''');

      if (kategoriFilter != null && kategoriFilter.isNotEmpty) {
        query = query.eq('kategori_transaksi_id', kategoriFilter);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => PemasukanModel.fromJson(item))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PemasukanModel> getPemasukanDetail(int id) async {
    try {
      final response = await supabaseClient
          .from('pemasukan_lain')
          .select('''
            id,
            judul,
            kategori_transaksi_id,
            nominal,
            tanggal_transaksi,
            bukti_foto,
            keterangan,
            created_by,
            verifikator_id,
            tanggal_verifikasi,
            created_at,
            kategori_transaksi:kategori_transaksi_id (
              nama_kategori
            )
          ''')
          .eq('id', id)
          .single();

      return PemasukanModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createPemasukan({
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) async {
    try {
      final authId = supabaseClient.auth.currentUser?.id;

      int? createdBy;
      if (authId != null) {
        final userResponse = await supabaseClient
            .from('users')
            .select('warga_id')
            .eq('auth_id', authId)
            .maybeSingle();

        if (userResponse != null) {
          createdBy = userResponse['warga_id'] as int?;
        }
      }

      final insertData = <String, dynamic>{
        'judul': judul,
        'kategori_transaksi_id': kategoriTransaksiId,
        'nominal': nominal,
        'tanggal_transaksi': tanggalTransaksi,
        'keterangan': keterangan,
        'created_by': createdBy,
      };

      if (buktiFoto != null && buktiFoto.isNotEmpty) {
        insertData['bukti_foto'] = buktiFoto;
      }

      await supabaseClient.from('pemasukan_lain').insert(insertData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePemasukan({
    required int id,
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'judul': judul,
        'kategori_transaksi_id': kategoriTransaksiId,
        'nominal': nominal,
        'tanggal_transaksi': tanggalTransaksi,
        'keterangan': keterangan,
      };

      if (buktiFoto != null && buktiFoto.isNotEmpty) {
        updateData['bukti_foto'] = buktiFoto;
      }

      await supabaseClient
          .from('pemasukan_lain')
          .update(updateData)
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePemasukan(int id) async {
    try {
      await supabaseClient.from('pemasukan_lain').delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> uploadBukti(File file, {String? oldUrl}) async {
    try {
      final bucket = 'pemasukan_lain';

      String fileName;
      if (oldUrl != null && oldUrl.isNotEmpty) {
        final uri = Uri.parse(oldUrl);
        final segments = uri.pathSegments;
        final fileIndex = segments.indexOf(bucket) + 1;
        fileName = segments[fileIndex];
      } else {
        fileName =
            'pemasukan_${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      }

      final storagePath = fileName;
      final bytes = await file.readAsBytes();

      await supabaseClient.storage
          .from(bucket)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      final publicUrl = supabaseClient.storage
          .from(bucket)
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Gagal upload bukti: $e');
    }
  }
}
