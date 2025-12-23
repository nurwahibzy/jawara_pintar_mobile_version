import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/users_model.dart';

abstract class UsersDataSource {
  Future<List<UsersModel>> getAllUsers();
  Future<UsersModel?> getUserById(int id);
  Future<void> createUser(UsersModel user);
  Future<void> updateUser(UsersModel user);
  Future<void> deleteUser(int id);
}

class UsersDataSourceImplementation implements UsersDataSource {
  final SupabaseClient client;
  final _table = 'users';

  UsersDataSourceImplementation() : client = SupabaseService.client;

  @override
  Future<List<UsersModel>> getAllUsers() async {
    final response = await client.from(_table).select('''
        *,
        warga(
            nama_lengkap  
        )
''');

    final dataList = List<Map<String, dynamic>>.from(response);
    return dataList.map((e) => UsersModel.fromMap(e)).toList();
  }

  @override
  Future<UsersModel?> getUserById(int id) async {
    final response = await client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    final row = Map<String, dynamic>.from(response);

    return UsersModel.fromMap(row).copyWith();
  }

  @override
  Future<void> createUser(UsersModel user) async {
    await client.from(_table).insert(user.toMapForInsert());
  }

  @override
  Future<void> updateUser(UsersModel user) async {
    if (user.id == null) {
      throw Exception("ID tidak boleh null saat update");
    }
    await client
        .from(_table)
        .update(user.toMap(forUpdate: true))
        .eq('id', user.id!);
  }

  @override
  Future<void> deleteUser(int id) async {
    await client.from(_table).delete().eq('id', id);
  }
}
