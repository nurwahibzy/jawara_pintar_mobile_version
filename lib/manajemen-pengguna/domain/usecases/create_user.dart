import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/users.dart';
import '../repositories/users_repository.dart';

class CreateUser {
  final UsersRepository repository;

  CreateUser(this.repository);

  Future<Either<Failure, bool>> call(Users user) async {
    return await repository.createUser(user);
  }
}