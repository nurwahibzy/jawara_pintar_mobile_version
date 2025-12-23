import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/users.dart';
import '../repositories/users_repository.dart';

class GetUserById {
  final UsersRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, Users>> call(int id) async {
    return await repository.getUserById(id);
  }
}
