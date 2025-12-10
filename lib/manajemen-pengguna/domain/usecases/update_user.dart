import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/users.dart';
import '../repositories/users_repository.dart';

class UpdateUser {
  final UsersRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, bool>> call(Users user) async {
    return await repository.updateUser(user);
  }
}
