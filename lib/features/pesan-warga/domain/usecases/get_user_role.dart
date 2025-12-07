import 'package:supabase_flutter/supabase_flutter.dart';

class GetUserRole {
  final SupabaseClient client;
  GetUserRole(this.client);

  Future<String?> call() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    final res = await client
        .from('users')
        .select('role')
        .eq('auth_id', user.id)
        .maybeSingle();

    return res?['role'];
  }
}
