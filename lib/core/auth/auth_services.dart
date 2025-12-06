// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class AuthServices {
  final client = SupabaseService.client;

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await client.auth.signUp(email: email, password: password);
    return response;
  }

  String? getCurrentUserEmail() {
    // final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    return user?.email;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
    
  }
}
