import 'package:flutter/material.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/presentation/pages/dashboard_keuangan_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/presentation/pages/dashboard_kegiatan_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.dashboardKeuangan:
        return MaterialPageRoute(builder: (_) => const DashboardKeuanganPage());

      case AppRoutes.dashboardKegiatan:
        return MaterialPageRoute(builder: (_) => const DashboardKegiatanPage());

      // dikebutt moasss
      default:
        return _errorRoute();
    }
  }

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
