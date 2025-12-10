import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/users.dart';
import '../repositories/users_repository.dart';

class GetAllUsers {
  final UsersRepository repository;

  GetAllUsers(this.repository);

  Future<Either<Failure, List<Users>>> call() async {
    return await repository.getAllUsers();
  }
}
