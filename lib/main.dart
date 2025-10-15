import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kependudukan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/keuangan.dart';
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/tambah.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // buat test sementara doang mwehehe
        '/': (context) => const LoginPage(),
        '/kependudukan': (context) => const Kependudukan(),
        '/keuangan': (context) => const Keuangan(),
        '/login': (context) => const LoginPage(),
        '/tambah_warga': (context) => const TambahWarga(),
      },
    );
  }
}
