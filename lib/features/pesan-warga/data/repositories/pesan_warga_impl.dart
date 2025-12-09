import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/pesan_warga.dart';
import '../../domain/repositories/pesan_warga_repository.dart';
import '../datasources/pesan_warga_remote.dart';
import '../models/pesan_warga_model.dart';

class AspirasiRepositoryImpl implements AspirasiRepository {
  final AspirasiRemoteDataSource remoteDataSource;
  AspirasiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Aspirasi>> getAllAspirasi() async {
    final models = await remoteDataSource.getAllAspirasi();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Aspirasi> getAspirasiById(int id) async {
    final model = await remoteDataSource.getAspirasiById(id);
    return model.toEntity();
  }

  @override
  Future<void> addAspirasi(Aspirasi aspirasi) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) throw Exception('User belum login');

    final userResponse = await Supabase.instance.client
        .from('users')
        .select('warga_id')
        .eq('auth_id', currentUser.id)
        .maybeSingle();

    final wargaId = userResponse?['warga_id'];
    if (wargaId == null) throw Exception('User belum memiliki warga_id');

    final model = aspirasi.toModel().copyWith(wargaId: wargaId);
    await remoteDataSource.addAspirasi(model);
  }

 @override
  Future<Aspirasi> updateAspirasi(Aspirasi aspirasi) async {
    final currentUserId = await getCurrentUserId();

    final model = aspirasi.toModel().copyWith(updatedBy: currentUserId);

    final updatedModel = await remoteDataSource.updateAspirasi(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteAspirasi(int id) async {
    await remoteDataSource.deleteAspirasi(id);
  }

 @override
  Future<String?> getCurrentUserRole() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) return null;
    final res = await Supabase.instance.client
        .from('users')
        .select('role')
        .eq('auth_id', currentUser.id)
        .maybeSingle();
    return res?['role'] as String?;
  }

 @override
  Future<int> getCurrentUserId() async {
    final authId = Supabase.instance.client.auth.currentUser?.id;
    if (authId == null) throw Exception("User belum login");

    final res = await Supabase.instance.client
        .from('users')
        .select('id')
        .eq('auth_id', authId)
        .maybeSingle();

    final userId = res?['id'];
    if (userId == null) throw Exception("User tidak ditemukan di tabel users");

    return userId as int; 
  }
}