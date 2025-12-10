import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/users.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_datasource.dart';
import '../models/users_model.dart';

class UsersRepositoryImplementation implements UsersRepository {
  final SupabaseClient client;
  final UsersDataSource remote;

  UsersRepositoryImplementation(this.remote, this.client);

  @override
  Future<Either<Failure, List<Users>>> getAllUsers() async {
    try {
      final results = await remote.getAllUsers();

      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Users>> getUserById(int id) async {
    try {
      final response = await remote.getUserById(id);

      if (response == null) {
        return Left(ServerFailure("User tidak ditemukan"));
      }

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createUser(Users user) async {
    try {
      await remote.createUser(UsersModel.fromEntity(user));
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(Users user) async {
    try {
      await remote.updateUser(UsersModel.fromEntity(user));
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(int id) async {
    try {
      await remote.deleteUser(id);
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWargaList() async {
    try {
      // Ambil id dan nama, urutkan berdasarkan nama
      final response = await client
          .from('warga')
          .select('id, nama_lengkap')
          .order('nama_lengkap', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal memuat data warga: $e');
    }
  }

  @override
  Future<void> addUser({
    required String email,
    required String password,
    required int wargaId,
    required String role,
  }) async {
    try {
      // LANGKAH 1: Daftarkan ke Supabase Auth
      // Note: Ini akan membuat user di tabel auth.users
      final AuthResponse res = await client.auth.signUp(
        email: email,
        password: password,
      );

      final User? newUser = res.user;

      if (newUser == null) {
        throw 'Gagal membuat user Auth. Coba gunakan email lain.';
      }

      // LANGKAH 2: Masukkan data pelengkap ke tabel public.users
      // Kita menghubungkan auth_id (UUID dari langkah 1) dengan data warga
      await client.from('users').insert({
        'auth_id': newUser.id, // KUNCI UTAMA: UUID dari Auth
        'warga_id': wargaId,
        'role': role,
        'status_user': 'approved', // Default langsung aktif
        'created_at': DateTime.now().toIso8601String(),
      });
    } on AuthException catch (e) {
      // Menangkap error khusus Auth (misal: Email sudah terdaftar, Password lemah)
      throw e.message;
    } on PostgrestException catch (e) {
      // Menangkap error Database (misal: Warga ID tidak ditemukan/Foreign Key error)
      throw 'Database Error: ${e.message}';
    } catch (e) {
      throw 'Terjadi kesalahan tidak terduga: $e';
    }
  }
}
