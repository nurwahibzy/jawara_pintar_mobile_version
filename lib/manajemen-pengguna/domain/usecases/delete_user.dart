import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/users_repository.dart';

class DeleteUser {
  final UsersRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, bool>> call(int id) async {
    return await repository.deleteUser(id);
  }
}
