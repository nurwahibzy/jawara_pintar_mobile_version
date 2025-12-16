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
            *,
            kategori_transaksi:kategori_transaksi_id (
              id,
              nama_kategori
            )
          ''');

      if (kategoriFilter != null && kategoriFilter.isNotEmpty) {
        query = query.eq('kategori_transaksi_id', kategoriFilter);
      }

      final response = await query.order('created_at', ascending: false);

      // Ambil data pemasukan dulu
      final pemasukanList = (response as List).map((item) {
        return item as Map<String, dynamic>;
      }).toList();

      // Ambil semua warga ID yang unik
      final wargaIds = <int>{};
      for (var item in pemasukanList) {
        if (item['created_by'] != null) wargaIds.add(item['created_by'] as int);
        if (item['verifikator_id'] != null)
          wargaIds.add(item['verifikator_id'] as int);
      }

      // Fetch nama warga jika ada
      Map<int, String> wargaNames = {};
      if (wargaIds.isNotEmpty) {
        final wargaResponse = await supabaseClient
            .from('warga')
            .select('id, nama_lengkap')
            .inFilter('id', wargaIds.toList());

        for (var warga in wargaResponse) {
          wargaNames[warga['id'] as int] = warga['nama_lengkap'] as String;
        }
      }

      // Gabungkan data
      return pemasukanList.map((item) {
        final createdBy = item['created_by'] as int?;
        final verifikatorId = item['verifikator_id'] as int?;

        item['created_by_warga'] =
            createdBy != null && wargaNames.containsKey(createdBy)
            ? {'id': createdBy, 'nama_lengkap': wargaNames[createdBy]}
            : null;

        item['verifikator_warga'] =
            verifikatorId != null && wargaNames.containsKey(verifikatorId)
            ? {'id': verifikatorId, 'nama_lengkap': wargaNames[verifikatorId]}
            : null;

        return PemasukanModel.fromJson(item);
      }).toList();
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
            *,
            kategori_transaksi:kategori_transaksi_id (
              id,
              nama_kategori
            )
          ''')
          .eq('id', id)
          .single();

      final item = response as Map<String, dynamic>;

      // Fetch nama warga untuk created_by dan verifikator_id
      final createdBy = item['created_by'] as int?;
      final verifikatorId = item['verifikator_id'] as int?;

      if (createdBy != null) {
        final wargaResponse = await supabaseClient
            .from('warga')
            .select('id, nama_lengkap')
            .eq('id', createdBy)
            .maybeSingle();

        if (wargaResponse != null) {
          item['created_by_warga'] = wargaResponse;
        }
      }

      if (verifikatorId != null) {
        final wargaResponse = await supabaseClient
            .from('warga')
            .select('id, nama_lengkap')
            .eq('id', verifikatorId)
            .maybeSingle();

        if (wargaResponse != null) {
          item['verifikator_warga'] = wargaResponse;
        }
      }

      return PemasukanModel.fromJson(item);
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

      // Hapus file lama jika ada
      if (oldUrl != null && oldUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(oldUrl);
          final segments = uri.pathSegments;
          final fileIndex = segments.indexOf(bucket) + 1;
          if (fileIndex < segments.length) {
            final oldFileName = segments[fileIndex];
            await supabaseClient.storage.from(bucket).remove([oldFileName]);
          }
        } catch (e) {
          // Ignore error jika file tidak ditemukan
          print('Gagal hapus file lama: $e');
        }
      }

      // Generate nama file baru
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = file.path.split('.').last;
      final fileName = 'pemasukan_${timestamp}.$extension';

      final bytes = await file.readAsBytes();

      // Upload file baru dengan upsert
      await supabaseClient.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: 'image/*', upsert: true),
          );

      // Get public URL
      final publicUrl = supabaseClient.storage
          .from(bucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      // Berikan pesan error yang lebih jelas
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        throw Exception(
          'Gagal upload: Tidak memiliki izin. Pastikan bucket "pemasukan_lain" sudah dibuat dan memiliki policy yang benar di Supabase Storage.',
        );
      }
      throw Exception('Gagal upload bukti: $e');
    }
  }
}
