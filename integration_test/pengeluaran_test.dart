import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 500));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw Exception('Widget not found: $finder');
  }

  Future<void> waitForSnackBarToDisappear(WidgetTester tester) async {
    final timeout = DateTime.now().add(const Duration(seconds: 10));
    await tester.pump(const Duration(milliseconds: 200));
    while (find.byType(SnackBar).evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 100));
      if (DateTime.now().isAfter(timeout)) break;
    }
    await tester.pumpAndSettle();
  }

  group('E2E Test - Full User Journey Pengeluaran', () {
    testWidgets('Login -> Tambah -> Detail -> Filter -> Logout', (
      WidgetTester tester,
    ) async {
      Future<void> userDelay() async {
        await tester.pump(const Duration(seconds: 2));
      }

      /// LOGIN
      app.main();
      await tester.pumpAndSettle();

      // --- Login ---
      final emailField = find.byKey(const Key('input_email'));
      final passwordField = find.byKey(const Key('input_password'));
      final loginButton = find.byKey(const Key('login_btn'));
      await waitForWidget(tester, emailField);

      await tester.enterText(emailField, 'admin1@gmail.com');
      await waitForWidget(tester, passwordField);
      await tester.enterText(passwordField, 'password');
      await waitForWidget(tester, loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // --- Navigate ke Keuangan  ---
      final keuanganButton = find.text('Keuangan');

      await waitForWidget(
        tester,
        keuanganButton,
        timeout: Duration(seconds: 30),
      );
      await tester.tap(keuanganButton);
      await tester.pumpAndSettle();

      // --- Pilih Pengeluaran---
      final pengeluaranFinder = find.byWidgetPredicate((widget) {
        if (widget is InkWell) {
          return find
              .descendant(
                of: find.byWidget(widget),
                matching: find.textContaining('Pengeluaran'),
              )
              .evaluate()
              .isNotEmpty;
        }
        return false;
      });
      await waitForWidget(tester, pengeluaranFinder);
      await tester.tap(pengeluaranFinder.first);
      await tester.pumpAndSettle();

      /// TAMBAH PENGELUARAN
      final btnTambah = find.byKey(const Key('btn_tambah_pengeluaran'));
      expect(btnTambah, findsOneWidget);

      await tester.tap(btnTambah);
      await tester.pumpAndSettle();

      // Isi Nama Pengeluaran
      await tester.enterText(
        find.byKey(const Key('input_nama_pengeluaran')),
        'Pengeluaran Test E2E',
      );

      // Pilih tanggal pengeluaran
      await tester.tap(find.byKey(const Key('input_tanggal_pengeluaran')));
      await tester.pumpAndSettle();

      // Misal pilih tanggal pertama di calendar
      final firstDay = find.byType(InkWell).first;
      await tester.tap(firstDay);
      await tester.pumpAndSettle();

      // Tekan tombol OK di date picker
      final okButton = find.text('OKE');
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Isi Nominal
      await tester.enterText(find.byKey(const Key('input_nominal')), '50000');

      // Tap dropdown kategori
      final dropdownFinder = find.byKey(const Key('dropdown_kategori'));
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Pilih kategori pertama berdasarkan text
      final kategoriItem = find.text('Operasional').last;
      await tester.tap(kategoriItem);
      await tester.pumpAndSettle();

      // Tap tombol Simpan
      final saveButton = find.byKey(const Key('btn_simpan_form'));

      // Tunggu tombol muncul
      bool found = false;
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 200));
        if (saveButton.evaluate().isNotEmpty) {
          found = true;
          break;
        }
      }

      if (!found) {
        throw Exception('Tombol Simpan belum muncul');
      }

      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      // Tap tombol
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      await waitForSnackBarToDisappear(tester);

      /// FILTER
      final filterButton = find.byKey(const Key('btn_filter'));

      await waitForWidget(tester, filterButton);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      await waitForWidget(tester, find.text('Filter'));

      await tester.enterText(find.byType(TextField).first, 'E2E');
      await tester.pump(const Duration(milliseconds: 300));

      await waitForWidget(tester, find.byKey(const Key('filter_apply_button')));
      await tester.tap(find.byKey(const Key('filter_apply_button')));
      await tester.pumpAndSettle();

      await tester.tap(filterButton);
      await tester.pumpAndSettle();
      await waitForWidget(tester, find.byType(ListView));

      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      await waitForWidget(tester, find.text('Filter'));

      await waitForWidget(tester, find.byKey(const Key('filter_reset_button')));
      await tester.tap(find.byKey(const Key('filter_reset_button')));
      await tester.pumpAndSettle();

      // --- Kembali ke Dashboard  ---
      final backButtonDashboard = find.byKey(
        const Key('btn_back_to_dashboard'),
      );

      await waitForWidget(tester, backButtonDashboard);
      await tester.tap(backButtonDashboard);
      await tester.pumpAndSettle();
      await waitForWidget(tester, find.text('Keuangan'));

      // --- Tap Logout di AppBar ---
      final btnProfile = find.byKey(const Key('btn_profile'));
      expect(btnProfile, findsOneWidget);
      await tester.tap(btnProfile);
      await tester.pumpAndSettle();
      await userDelay();

      // Tap konfirmasi logout di dialog
      final btnLogout = find.byKey(const Key('btn_logout'));
      expect(btnLogout, findsOneWidget);
      await tester.tap(btnLogout);
      await tester.pumpAndSettle();
      await userDelay();

      //Tunggu hingga halaman login muncul
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
    });
  });
}