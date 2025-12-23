import '../repositories/users_repository.dart';

class GetWargaList {
  final UsersRepository repository;

  GetWargaList(this.repository);

  // Mengembalikan List Map untuk dropdown
  Future<List<Map<String, dynamic>>> execute() async {
    return await repository.getWargaList();
  }
}
