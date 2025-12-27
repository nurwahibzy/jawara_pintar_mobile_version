import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/users.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<Users>>> getAllUsers();
  Future<Either<Failure, Users>> getUserById(int id);
  Future<Either<Failure, bool>> createUser(Users user);
  Future<Either<Failure, bool>> updateUser(Users user);
  Future<Either<Failure, bool>> deleteUser(int id);
  Future<void> addUser({required String email,required String password,required int wargaId,required String role});
  Future<List<Map<String, dynamic>>> getWargaList();
}
