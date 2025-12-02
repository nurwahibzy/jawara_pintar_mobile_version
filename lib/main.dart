import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jawara_pintar_mobile_version/core/auth/auth_gate.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/erors_checkers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/injections/injection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load Env
    await dotenv.load(fileName: ".env");

    // Validasi Key sebelum Init (Mencegah error null check operator '!')
    final sbUrl = dotenv.env['SUPABASE_URL'];
    final sbKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (sbUrl == null || sbKey == null) {
      throw Exception(
        "File .env tidak lengkap! Pastikan SUPABASE_URL dan KEY ada.",
      );
    }

    // Init Supabase
    await Supabase.initialize(url: sbUrl, anonKey: sbKey);

    await init();

    runApp(const MainApp());
  } catch (e) {
    // Jika Gagal Init, Jalankan App Error Sederhana
    runApp(ErrorApp(message: e.toString()));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.appTheme,
      // initialRoute: AppRoutes.login,
      home: const AuthGate(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}