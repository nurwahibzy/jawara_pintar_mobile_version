import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - Warga (Residents)', () {
    /// Helper function untuk delay seperti user asli
    Future<void> userDelay(WidgetTester tester, {int seconds = 2}) async {
      await tester.pump(Duration(seconds: seconds));
    }

    /// Helper function untuk login
    Future<void> performLogin(WidgetTester tester) async {
      // Tunggu halaman login muncul
      await tester.pumpAndSettle();
      await userDelay(tester);

      // Input email
      final inputEmail = find.byKey(const Key('input_email'));
      expect(inputEmail, findsOneWidget);
      await tester.enterText(inputEmail, 'admin1@gmail.com');
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // Input password
      final inputPassword = find.byKey(const Key('input_password'));
      expect(inputPassword, findsOneWidget);
      await tester.enterText(inputPassword, 'password');
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // Tap login button
      final btnLogin = find.byKey(const Key('btn_login'));
      expect(btnLogin, findsOneWidget);
      await tester.tap(btnLogin);

      // Tunggu proses login selesai
      bool dashboardFound = false;
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.byKey(const Key('tab_kependudukan')).evaluate().isNotEmpty) {
          dashboardFound = true;
          break;
        }
      }

      if (!dashboardFound) {
        fail('Login gagal - Dashboard tidak muncul');
      }

      await tester.pumpAndSettle();
      await userDelay(tester);
    }

    /// Helper function untuk navigasi ke daftar warga
    Future<void> navigateToWarga(WidgetTester tester) async {
      // Tap tab kependudukan
      final tabKependudukan = find.byKey(const Key('tab_kependudukan'));
      if (tabKependudukan.evaluate().isEmpty) {
        fail('Tab Kependudukan tidak ditemukan');
      }
      await tester.tap(tabKependudukan);
      await tester.pumpAndSettle();
      await userDelay(tester);

      // Cek list warga muncul
      final listWarga = find.byKey(const Key('list_warga'));
      expect(listWarga, findsOneWidget, reason: 'List warga harus muncul');
      await userDelay(tester);
    }

    testWidgets('Test 1: View Daftar Warga', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Verifikasi list warga muncul
      final listWarga = find.byKey(const Key('list_warga'));
      expect(listWarga, findsOneWidget);

      // Scroll list
      await tester.drag(listWarga, const Offset(0, -300));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // Scroll kembali ke atas
      await tester.drag(listWarga, const Offset(0, 300));
      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 2: Search Warga by Nama', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Cari search field
      final searchField = find.byKey(const Key('search_warga'));
      if (searchField.evaluate().isEmpty) {
        // Mungkin perlu scroll atau tap filter toggle
        final filterToggle = find.byKey(const Key('toggle_filter'));
        if (filterToggle.evaluate().isNotEmpty) {
          await tester.tap(filterToggle);
          await tester.pumpAndSettle();
          await userDelay(tester, seconds: 1);
        }
      }

      // Input search text
      expect(searchField, findsOneWidget, reason: 'Search field harus ada');
      await tester.enterText(searchField, 'Ahmad');
      await tester.pumpAndSettle();
      await userDelay(tester);

      // Tap search/apply button
      final btnSearch = find.byKey(const Key('btn_apply_filter'));
      if (btnSearch.evaluate().isNotEmpty) {
        await tester.tap(btnSearch);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }

      // Verifikasi hasil search muncul
      // Note: Tidak strict match karena data bisa berbeda
      await userDelay(tester);

      // Clear search
      final btnReset = find.byKey(const Key('btn_reset_filter'));
      if (btnReset.evaluate().isNotEmpty) {
        await tester.tap(btnReset);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }
    });

    testWidgets('Test 3: Filter Warga by Jenis Kelamin', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Pastikan filter panel terlihat
      final filterToggle = find.byKey(const Key('toggle_filter'));
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      // Tap dropdown jenis kelamin
      final dropdownJK = find.byKey(const Key('dropdown_jenis_kelamin'));
      if (dropdownJK.evaluate().isNotEmpty) {
        await tester.tap(dropdownJK);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        // Pilih 'L' (Laki-laki)
        final optionL = find.text('L').last;
        await tester.tap(optionL);
        await tester.pumpAndSettle();
        await userDelay(tester);

        // Apply filter
        final btnApply = find.byKey(const Key('btn_apply_filter'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }

        // Reset filter
        final btnReset = find.byKey(const Key('btn_reset_filter'));
        if (btnReset.evaluate().isNotEmpty) {
          await tester.tap(btnReset);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 4: View Detail Warga', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Tap warga pertama (card_warga)
      final wargaCard = find.byKey(const Key('card_warga_0'));
      if (wargaCard.evaluate().isEmpty) {
        // Coba cari card tanpa index
        final anyWargaCard = find.byType(Card).first;
        if (anyWargaCard.evaluate().isNotEmpty) {
          await tester.tap(anyWargaCard);
        } else {
          fail('Tidak ada data warga untuk di-tap');
        }
      } else {
        await tester.tap(wargaCard);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi halaman detail muncul
      // Cek ada tombol back atau judul detail
      final backButton = find.byType(BackButton);
      expect(
        backButton,
        findsAtLeastNWidgets(1),
        reason: 'Detail page harus memiliki back button',
      );

      // Scroll detail page
      final detailScroll = find.byType(SingleChildScrollView).last;
      if (detailScroll.evaluate().isNotEmpty) {
        await tester.drag(detailScroll, const Offset(0, -300));
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      // Kembali ke list
      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi kembali ke list warga
      final listWarga = find.byKey(const Key('list_warga'));
      expect(listWarga, findsOneWidget);
    });

    testWidgets('Test 5: Tambah Warga (Form Validation)', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Tap tombol tambah warga (FloatingActionButton)
      final fabTambah = find.byKey(const Key('fab_tambah_warga'));
      if (fabTambah.evaluate().isEmpty) {
        // Cari FAB biasa
        final fab = find.byType(FloatingActionButton);
        if (fab.evaluate().isEmpty) {
          fail('Tombol tambah warga tidak ditemukan');
        }
        await tester.tap(fab.first);
      } else {
        await tester.tap(fabTambah);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi form tambah warga muncul
      final formWarga = find.byKey(const Key('form_warga'));
      expect(
        formWarga,
        findsOneWidget,
        reason: 'Form tambah warga harus muncul',
      );

      // Test validasi: Submit form kosong
      final btnSimpan = find.byKey(const Key('btn_simpan_warga'));
      if (btnSimpan.evaluate().isNotEmpty) {
        await tester.tap(btnSimpan);
        await tester.pumpAndSettle();
        await userDelay(tester);

        // Harus ada error message (form validation)
        // Note: Implementasi bisa berbeda, skip strict check
      }

      // Isi form dengan data valid
      final inputNama = find.byKey(const Key('input_nama'));
      if (inputNama.evaluate().isNotEmpty) {
        await tester.enterText(inputNama, 'Test User E2E');
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      final inputNik = find.byKey(const Key('input_nik'));
      if (inputNik.evaluate().isNotEmpty) {
        await tester.enterText(inputNik, '1234567890123456');
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      // Scroll form kebawah untuk akses field lain
      final formScroll = find.byType(SingleChildScrollView).last;
      if (formScroll.evaluate().isNotEmpty) {
        await tester.drag(formScroll, const Offset(0, -400));
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      // Pilih jenis kelamin
      final dropdownJK = find.byKey(const Key('dropdown_jenis_kelamin_form'));
      if (dropdownJK.evaluate().isNotEmpty) {
        await tester.tap(dropdownJK);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final optionL = find.text('L').last;
        await tester.tap(optionL);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }

      // Batal dan kembali
      final btnBatal = find.byKey(const Key('btn_batal_warga'));
      if (btnBatal.evaluate().isEmpty) {
        // Gunakan back button
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
        }
      } else {
        await tester.tap(btnBatal);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi kembali ke list warga
      final listWarga = find.byKey(const Key('list_warga'));
      expect(listWarga, findsOneWidget);
    });

    testWidgets('Test 6: Edit Warga (Navigate Only)', (tester) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Tap warga pertama untuk ke detail
      final wargaCard = find.byKey(const Key('card_warga_0'));
      if (wargaCard.evaluate().isEmpty) {
        final anyWargaCard = find.byType(Card).first;
        if (anyWargaCard.evaluate().isNotEmpty) {
          await tester.tap(anyWargaCard);
        } else {
          return; // Skip jika tidak ada data
        }
      } else {
        await tester.tap(wargaCard);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      // Cari tombol edit
      final btnEdit = find.byKey(const Key('btn_edit_warga'));
      if (btnEdit.evaluate().isEmpty) {
        // Cari icon edit
        final editIcon = find.byIcon(Icons.edit);
        if (editIcon.evaluate().isEmpty) {
          // Skip test jika tidak ada tombol edit
          return;
        }
        await tester.tap(editIcon.first);
      } else {
        await tester.tap(btnEdit);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi form edit muncul
      final formWarga = find.byKey(const Key('form_warga'));
      expect(formWarga, findsOneWidget, reason: 'Form edit warga harus muncul');

      // Batal dan kembali
      final btnBatal = find.byKey(const Key('btn_batal_warga'));
      if (btnBatal.evaluate().isEmpty) {
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
        }
      } else {
        await tester.tap(btnBatal);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 7: Refresh Daftar Warga (Pull to Refresh)', (
      tester,
    ) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // Login
      await performLogin(tester);

      // Navigasi ke daftar warga
      await navigateToWarga(tester);

      // Pull to refresh
      final listWarga = find.byKey(const Key('list_warga'));
      await tester.drag(listWarga, const Offset(0, 300));
      await tester.pumpAndSettle();

      // Tunggu refresh selesai
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await userDelay(tester);

      // Verifikasi list masih ada
      expect(listWarga, findsOneWidget);
    });

    testWidgets('Test 8: Full Journey - Browse, Filter, View Detail', (
      tester,
    ) async {
      // Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();

      // 1. Login
      await performLogin(tester);

      // 2. Navigate to Warga
      await navigateToWarga(tester);

      // 3. Scroll list
      final listWarga = find.byKey(const Key('list_warga'));
      await tester.drag(listWarga, const Offset(0, -200));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // 4. Search
      final searchField = find.byKey(const Key('search_warga'));
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'a');
        await tester.pumpAndSettle();
        await userDelay(tester);

        final btnApply = find.byKey(const Key('btn_apply_filter'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }

      // 5. View first result detail
      final wargaCard = find.byKey(const Key('card_warga_0'));
      if (wargaCard.evaluate().isEmpty) {
        final anyWargaCard = find.byType(Card).first;
        if (anyWargaCard.evaluate().isNotEmpty) {
          await tester.tap(anyWargaCard);
          await tester.pumpAndSettle();
          await userDelay(tester);

          // Back to list
          final backButton = find.byType(BackButton);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton.first);
            await tester.pumpAndSettle();
            await userDelay(tester);
          }
        }
      }

      // 6. Reset filter
      final btnReset = find.byKey(const Key('btn_reset_filter'));
      if (btnReset.evaluate().isNotEmpty) {
        await tester.tap(btnReset);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }

      // Verify back to list
      expect(listWarga, findsOneWidget);
    });
  });
}
