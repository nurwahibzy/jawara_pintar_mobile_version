import 'package:flutter/material.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';



class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Mengambil arguments (jika ada)
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      // dikebutt moasss
      default:
        return _errorRoute();
    }
  }

  // Halaman Error jika route tidak ditemukan
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Halaman tidak ditemukan!')),
        );
      },
    );
  }
}
