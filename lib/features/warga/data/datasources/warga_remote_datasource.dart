import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/keluarga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';

abstract interface class WargaRemoteDataSource {
  Future<List<WargaModel>> getAllWarga();
  Future<WargaModel> getWargaById(int id);
  Future<void> createWarga(WargaModel warga);
  Future<void> updateWarga(WargaModel warga);
  Future<List<WargaModel>> filterWarga(FilterWargaParams params);
  Future<List<KeluargaModel>> getAllKeluarga();
  Future<List<KeluargaModel>> searchKeluarga(String query);
  Future<List<KeluargaModel>> getAllKeluargaWithRelations();
  Future<KeluargaModel> getKeluargaById(int id);
  Future<List<Map<String, dynamic>>> getAllRumahSimple();
  Future<List<Map<String, dynamic>>> searchRumah(String query);
}

class WargaRemoteDataSourceImpl implements WargaRemoteDataSource {
  final SupabaseClient supabaseClient;

  WargaRemoteDataSourceImpl() : supabaseClient = Supabase.instance.client;

  @override
  Future<List<WargaModel>> getAllWarga() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('warga')
          .select();

      final data = (response).map((e) => WargaModel.fromJson(e)).toList();

      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WargaModel> getWargaById(int id) async {
    try {
      final Map<String, dynamic> response = await supabaseClient
          .from('warga')
          .select()
          .eq('id', id)
          .single();

      return WargaModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createWarga(WargaModel warga) {
    try {
      final data = warga.toJson();
      data.remove('id');
      return supabaseClient.from('warga').insert(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateWarga(WargaModel warga) {
    try {
      return supabaseClient
          .from('warga')
          .update(warga.toJson())
          .eq('id', warga.idWarga);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<WargaModel>> filterWarga(FilterWargaParams params) async {
    try {
      var query = supabaseClient.from('warga').select();

      // 2. Filter Nama (ILIKE = Case Insensitive Search)
      if (params.nama != null && params.nama!.isNotEmpty) {
        query = query.ilike('nama_lengkap', '%${params.nama}%');
      }

      // 3. Filter Jenis Kelamin (Exact Match)
      // Pastikan nilai di dropdown UI sesuai dengan database ('L'/'P' atau 'Laki-laki'/'Perempuan')
      if (params.jenisKelamin != null &&
          params.jenisKelamin != 'Semua' && // Handle opsi default UI
          params.jenisKelamin != '-- Pilih Jenis Kelamin --') {
        query = query.eq('jenis_kelamin', params.jenisKelamin!);
      }

      // 4. Filter Status Hidup
      if (params.status != null &&
          params.status != 'Semua' &&
          params.status != '-- Pilih Status --') {
        query = query.eq('status_hidup', params.status!);
      }

      // 5. Filter Keluarga
      if (params.keluarga != null &&
          params.keluarga != 'Semua' &&
          params.keluarga != '-- Pilih Keluarga --') {
        // Sesuaikan nama kolom di database, misal 'status_keluarga' atau 'keluarga_id'
        query = query.eq('status_keluarga', params.keluarga!);
      }

      // 6. Eksekusi Query
      // Supabase Flutter terbaru mengembalikan List<dynamic> saat di-await
      final List<dynamic> response = await query;

      // 7. Konversi ke List<WargaModel>
      return response.map((json) => WargaModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<KeluargaModel>> getAllKeluarga() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('keluarga')
          .select()
          .order('nomor_kk', ascending: true);

      return response.map((json) => KeluargaModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<KeluargaModel>> searchKeluarga(String query) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('keluarga')
          .select()
          .ilike('nomor_kk', '%$query%')
          .order('nomor_kk', ascending: true)
          .limit(20);

      return response.map((json) => KeluargaModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<KeluargaModel>> getAllKeluargaWithRelations() async {
    try {
      // Query dengan relasi ke rumah dan warga
      final List<dynamic> response = await supabaseClient
          .from('keluarga')
          .select('''
            *,
            rumah:rumah_id (
              id,
              alamat,
              status_rumah
            ),
            warga (
              id,
              nik,
              nama_lengkap,
              jenis_kelamin,
              tanggal_lahir,
              status_keluarga,
              status_hidup
            )
          ''')
          .order('nomor_kk', ascending: true);

      return response.map((json) => KeluargaModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<KeluargaModel> getKeluargaById(int id) async {
    try {
      final Map<String, dynamic> response = await supabaseClient
          .from('keluarga')
          .select('''
            *,
            rumah:rumah_id (
              id,
              alamat,
              status_rumah
            ),
            warga (
              id,
              nik,
              nama_lengkap,
              jenis_kelamin,
              tanggal_lahir,
              status_keluarga,
              status_hidup
            )
          ''')
          .eq('id', id)
          .single();

      return KeluargaModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllRumahSimple() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('rumah')
          .select('id, alamat')
          .order('alamat', ascending: true);

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchRumah(String query) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('rumah')
          .select('id, alamat')
          .ilike('alamat', '%$query%')
          .order('alamat', ascending: true)
          .limit(20);

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
