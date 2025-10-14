import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kependudukan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/keuangan.dart';
import 'package:jawara_pintar_mobile_version/sigin/sigin_page.dart';
import 'package:jawara_pintar_mobile_version/sigin/home_page.dart';

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
        '/': (context) => const Kependudukan(),
        '/kependudukan': (context) => const Kependudukan(),
        '/keuangan': (context) => const Keuangan(),
      },
    );
  }
  class JawaraApp extends StatelessWidget {
  const JawaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jawara App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignInPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
  }
}
