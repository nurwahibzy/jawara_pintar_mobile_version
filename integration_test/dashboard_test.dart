import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Full User Journey: Login -> Dashboard -> Logout', (
      tester,
    ) async {
      Future<void> userDelay() async {
        await tester.pump(const Duration(seconds: 2));
      }

      // 1. Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();
      await userDelay();

      // 2. Login
      // Masukkan email
      final inputEmail = find.byKey(const Key('input_email'));
      expect(inputEmail, findsOneWidget);
      await tester.enterText(inputEmail, 'admin1@gmail.com');
      await tester.pumpAndSettle();
      await userDelay();

      // Masukkan password
      final inputPassword = find.byKey(const Key('input_password'));
      expect(inputPassword, findsOneWidget);
      await tester.enterText(inputPassword, 'password');
      await tester.pumpAndSettle();
      await userDelay();

      // Tekan tombol login
      final btnLogin = find.byKey(const Key('btn_login'));
      expect(btnLogin, findsOneWidget);
      await tester.tap(btnLogin);

      // Tunggu proses login (network request) dan navigasi selesai
      bool dashboardFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.byKey(const Key('tab_keuangan')).evaluate().isNotEmpty) {
          dashboardFound = true;
          break;
        }
      }

      if (!dashboardFound) {
        // Cek jika ada pesan error login
        if (find.text('Login gagal').evaluate().isNotEmpty) {
          fail(
            'Test Gagal: Login gagal (Kredensial salah atau masalah jaringan).',
          );
        }
        fail('Test Gagal: Dashboard tidak muncul setelah menunggu 10 detik.');
      }

      await tester.pumpAndSettle();
      await userDelay();

      // 3. Dashboard Keuangan (Default Page)
      final tabKeuangan = find.byKey(const Key('tab_keuangan'));
      expect(tabKeuangan, findsOneWidget);

      final listKeuangan = find.byKey(const Key('list_transaksi_keuangan'));
      expect(listKeuangan, findsOneWidget);

      await tester.drag(listKeuangan, const Offset(0, -500));
      await tester.pumpAndSettle();
      await userDelay(); // Jeda setelah scroll

      // 4. Pindah ke Dashboard Kependudukan
      final tabKependudukan = find.byKey(const Key('tab_kependudukan'));
      expect(tabKependudukan, findsOneWidget);
      await tester.tap(tabKependudukan);
      await tester.pumpAndSettle();
      await userDelay();

      final listWarga = find.byKey(const Key('list_warga'));
      expect(listWarga, findsOneWidget);

      await tester.drag(listWarga, const Offset(0, -500));
      await tester.pumpAndSettle();
      await userDelay();

      // 5. Pindah ke Dashboard Kegiatan
      final tabKegiatan = find.byKey(const Key('tab_kegiatan'));
      expect(tabKegiatan, findsOneWidget);
      await tester.tap(tabKegiatan);
      await tester.pumpAndSettle();
      await userDelay();

      final listKegiatan = find.byKey(const Key('list_kegiatan'));
      expect(listKegiatan, findsOneWidget);

      await tester.drag(listKegiatan, const Offset(0, -500));
      await tester.pumpAndSettle();
      await userDelay(); // Jeda setelah scroll

      // 6. Logout
      final btnProfile = find.byKey(const Key('btn_profile'));
      expect(btnProfile, findsOneWidget);
      await tester.tap(btnProfile);
      await tester.pumpAndSettle();
      await userDelay();

      final btnLogout = find.byKey(const Key('btn_logout'));
      expect(btnLogout, findsOneWidget);
      await tester.tap(btnLogout);
      await tester.pumpAndSettle();
      await userDelay();

      bool loginFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.byKey(const Key('input_email')).evaluate().isNotEmpty) {
          loginFound = true;
          break;
        }
      }

      if (!loginFound) {
        fail('Test Gagal: Halaman Login tidak muncul setelah logout.');
      }

      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });
  });
}
