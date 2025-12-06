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
    final model = aspirasi.toModel();
    final updatedModel = await remoteDataSource.updateAspirasi(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteAspirasi(int id) async {
    await remoteDataSource.deleteAspirasi(id);
  }
}