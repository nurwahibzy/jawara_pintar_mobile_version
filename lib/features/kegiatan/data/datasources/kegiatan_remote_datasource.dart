import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/kegiatan_model.dart';
import '../models/transaksi_kegiatan_model.dart';

abstract class KegiatanRemoteDataSource {
  Future<List<KegiatanModel>> getKegiatanList();
  Future<KegiatanModel> getKegiatanDetail(int id);
  Future<void> createKegiatan(KegiatanModel kegiatan);
  Future<void> updateKegiatan(KegiatanModel kegiatan);
  Future<String> uploadFoto(File file, String fileName);
  Future<List<Map<String, dynamic>>> getKategoriKegiatan();

  // Transaksi methods
  Future<List<TransaksiKegiatanModel>> getTransaksiByKegiatan(int kegiatanId);
  Future<void> createTransaksi(TransaksiKegiatanModel transaksi);
  Future<void> deleteTransaksi(int transaksiId);
}

class KegiatanRemoteDataSourceImpl implements KegiatanRemoteDataSource {
  final SupabaseClient supabaseClient;

  KegiatanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<KegiatanModel>> getKegiatanList() async {
    try {
      final response = await supabaseClient
          .from('kegiatan')
          .select('*, kategori_kegiatan(nama_kategori)')
          .order('tanggal_pelaksanaan', ascending: false);

      return (response as List)
          .map((json) => KegiatanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<KegiatanModel> getKegiatanDetail(int id) async {
    try {
      final response = await supabaseClient
          .from('kegiatan')
          .select('*, kategori_kegiatan(nama_kategori)')
          .eq('id', id)
          .single();

      return KegiatanModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createKegiatan(KegiatanModel kegiatan) async {
    try {
      await supabaseClient.from('kegiatan').insert(kegiatan.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateKegiatan(KegiatanModel kegiatan) async {
    try {
      await supabaseClient
          .from('kegiatan')
          .update(kegiatan.toJson())
          .eq('id', kegiatan.id!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadFoto(File file, String fileName) async {
    try {
      // Delete old file if exists
      try {
        await supabaseClient.storage.from('kegiatan').remove([fileName]);
      } catch (_) {}

      // Upload new file
      await supabaseClient.storage
          .from('kegiatan')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final url = supabaseClient.storage
          .from('kegiatan')
          .getPublicUrl(fileName);
      return url;
    } catch (e) {
      throw ServerException('Gagal upload foto: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getKategoriKegiatan() async {
    try {
      final response = await supabaseClient
          .from('kategori_kegiatan')
          .select('id, nama_kategori')
          .order('nama_kategori', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ServerException('Gagal memuat kategori kegiatan: ${e.toString()}');
    }
  }

  // ==================== TRANSAKSI METHODS ====================

  @override
  Future<List<TransaksiKegiatanModel>> getTransaksiByKegiatan(
    int kegiatanId,
  ) async {
    try {
      final response = await supabaseClient
          .from('transaksi_kegiatan')
          .select('''
            *,
            pemasukan_lain (
              judul,
              nominal,
              tanggal_transaksi,
              keterangan,
              bukti_foto,
              kategori_transaksi (nama_kategori)
            ),
            pengeluaran (
              judul,
              nominal,
              tanggal_transaksi,
              keterangan,
              bukti_foto,
              kategori_transaksi (nama_kategori)
            ),
            created_by_user:users!created_by(
              warga_id,
              warga:warga(nama_lengkap)
            )
          ''')
          .eq('kegiatan_id', kegiatanId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TransaksiKegiatanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Gagal memuat transaksi: ${e.toString()}');
    }
  }

  @override
  Future<void> createTransaksi(TransaksiKegiatanModel transaksi) async {
    try {
      await supabaseClient
          .from('transaksi_kegiatan')
          .insert(transaksi.toJson());
    } catch (e) {
      throw ServerException('Gagal menambah transaksi: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaksi(int transaksiId) async {
    try {
      // Get transaksi to delete photo
      final transaksi = await supabaseClient
          .from('transaksi_kegiatan')
          .select('bukti_foto')
          .eq('id', transaksiId)
          .single();

      // Delete photo if exists
      if (transaksi['bukti_foto'] != null) {
        final fileName = (transaksi['bukti_foto'] as String).split('/').last;
        try {
          await supabaseClient.storage.from('kegiatan').remove([fileName]);
        } catch (_) {}
      }

      // Delete transaksi
      await supabaseClient
          .from('transaksi_kegiatan')
          .delete()
          .eq('id', transaksiId);
    } catch (e) {
      throw ServerException('Gagal menghapus transaksi: ${e.toString()}');
    }
  }
}
