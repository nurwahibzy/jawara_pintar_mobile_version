import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;
import 'package:flutter/material.dart';

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

  Future<void> waitForAndTap(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      if (finder.evaluate().isNotEmpty) {
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        return;
      }
      await tester.pump(const Duration(milliseconds: 200));
    }
    throw Exception('Widget not found to tap: $finder');
  }

  testWidgets('E2E: fitur Pesan Warga', (tester) async {
    Future<void> userDelay() async {
      await tester.pump(const Duration(seconds: 2));
    }

    // --- Start app ---
    app.main();
    await tester.pumpAndSettle();

    // --- Login ---
    final emailField = find.byKey(const Key('input_email'));
    final passwordField = find.byKey(const Key('input_password'));
    final loginButton = find.byKey(const Key('login_btn'));
    await waitForWidget(tester, emailField);

    await tester.enterText(emailField, 'p@example.com');
    await waitForWidget(tester, passwordField);
    await tester.enterText(passwordField, 'password');
    await waitForWidget(tester, loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // --- Navigate ke Keuangan & Kegiatan ---
    final keuanganButton = find.text('Keuangan');
    final kegiatanButton = find.text('Kegiatan');

    await waitForWidget(tester, keuanganButton, timeout: Duration(seconds: 30));
    await tester.tap(keuanganButton);
    await tester.pumpAndSettle();

    await waitForWidget(tester, kegiatanButton, timeout: Duration(seconds: 30));
    await tester.tap(kegiatanButton);
    await tester.pumpAndSettle();

    // --- Pilih Pesan Warga ---
    final pesanWargaFinder = find.byWidgetPredicate((widget) {
      if (widget is InkWell) {
        return find
            .descendant(
              of: find.byWidget(widget),
              matching: find.textContaining('Pesan'),
            )
            .evaluate()
            .isNotEmpty;
      }
      return false;
    });
    await waitForWidget(tester, pesanWargaFinder);
    await tester.tap(pesanWargaFinder.first);
    await tester.pumpAndSettle();

    // --- Tambah Pesan ---
    await waitForWidget(tester, find.text('Aspirasi Warga'));
    await waitForAndTap(tester, find.byKey(const Key('fab_add_pesan')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await waitForWidget(tester, find.text('Tambah Pesan Warga'));
    await tester.pump(const Duration(seconds: 1));

    final judulField = find.byKey(const Key('judul_field'));
    final deskripsiField = find.byKey(const Key('deskripsi_field'));

    expect(judulField, findsOneWidget);
    expect(deskripsiField, findsOneWidget);

    await tester.enterText(judulField, 'Pesan Test');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(deskripsiField, 'Deskripsi test E2E');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(const Key('tambah_simpan_button')));
    await tester.pumpAndSettle();
    await waitForSnackBarToDisappear(tester);

    // --- Pilih menu detail ---
    final menuButton = find.byType(PopupMenuButton<String>).first;

    await waitForWidget(tester,menuButton,timeout: const Duration(seconds: 20),);
    await tester.ensureVisible(menuButton);
    await tester.tap(menuButton);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // --- Klik menu Detail ---
    final detailItem = find.text('Detail').first;

    await waitForWidget(tester,detailItem,timeout: const Duration(seconds: 10),);
    await tester.tap(detailItem);
    await tester.pumpAndSettle();

    // --- Edit Pesan ---
    await tester.tap(find.byKey(const Key('detail_edit_button')));
    await tester.pumpAndSettle();

    final editJudulField = find.byType(TextFormField).first;
    await tester.enterText(editJudulField, 'Pesan Test Edited');

    await tester.tap(find.byKey(const Key('edit_simpan_button')));
    await tester.pump(); // start snackbar
    await waitForSnackBarToDisappear(tester);
    await tester.pumpAndSettle();

    // --- Kembali ke list ---
    await waitForWidget(tester, find.byKey(const Key('detail_back_button')));
    await tester.tap(find.byKey(const Key('detail_back_button')));
    await tester.pumpAndSettle();

    await waitForWidget(tester, find.text('Aspirasi Warga'));

    // --- FILTER FLOW ---
    final filterButton = find.byKey(const Key('btn_filter'));

    await waitForWidget(tester, filterButton);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    await waitForWidget(tester, find.text('Filter'));

    await tester.enterText(find.byType(TextField).first, 'Pesan');
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

    // --- Kembali ke Dashboard (Kegiatan) ---
    final backButton = find.byKey(const Key('btn_back_aspirasi'));

    await waitForWidget(tester, backButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    await waitForWidget(tester, find.text('Kegiatan'));

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

    // Tunggu hingga halaman login muncul
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
}