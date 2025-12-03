import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/auth/login_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/presentation/pages/dashboard_keuangan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return const LoginPage();
        } else {
          return const DashboardKeuanganPage();
        }
      },
    );
  }
}
