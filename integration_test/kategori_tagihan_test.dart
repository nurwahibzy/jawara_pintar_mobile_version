import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - Kategori Tagihan (Master Iuran)', () {
    Future<void> userDelay(WidgetTester tester, {int seconds = 2}) async {
      await tester.pump(Duration(seconds: seconds));
    }

    Future<void> performLogin(WidgetTester tester) async {
      await tester.pumpAndSettle();
      await userDelay(tester);

      final inputEmail = find.byKey(const Key('input_email'));
      expect(inputEmail, findsOneWidget);
      await tester.enterText(inputEmail, 'admin1@gmail.com');
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      final inputPassword = find.byKey(const Key('input_password'));
      expect(inputPassword, findsOneWidget);
      await tester.enterText(inputPassword, 'password');
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      final btnLogin = find.byKey(const Key('btn_login'));
      expect(btnLogin, findsOneWidget);
      await tester.tap(btnLogin);

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

    Future<void> navigateToKategoriTagihan(WidgetTester tester) async {
      final scaffoldFinder = find.byType(Scaffold);
      if (scaffoldFinder.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu).first);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final menuKategori = find.text('Kategori Tagihan');
        if (menuKategori.evaluate().isNotEmpty) {
          await tester.tap(menuKategori);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    }

    testWidgets('Test 1: View Daftar Kategori Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToKategoriTagihan(tester);

      final listKategori = find.byKey(const Key('list_kategori_tagihan'));
      expect(listKategori, findsOneWidget);

      await tester.drag(listKategori, const Offset(0, -300));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);
    });

    testWidgets('Test 2: Search Kategori Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToKategoriTagihan(tester);

      final searchField = find.byKey(const Key('search_kategori_tagihan'));
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'Iuran');
        await tester.pumpAndSettle();
        await userDelay(tester);

        final btnApply = find.byKey(const Key('btn_apply_filter_kategori'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 3: View Detail Kategori Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToKategoriTagihan(tester);

      final kategoriCard = find.byKey(const Key('card_kategori_0'));
      if (kategoriCard.evaluate().isEmpty) {
        final anyCard = find.byType(Card).first;
        if (anyCard.evaluate().isNotEmpty) {
          await tester.tap(anyCard);
        } else {
          return;
        }
      } else {
        await tester.tap(kategoriCard);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      final backButton = find.byType(BackButton);
      expect(backButton, findsAtLeastNWidgets(1));

      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 4: Tambah Kategori Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToKategoriTagihan(tester);

      final fabTambah = find.byKey(const Key('fab_tambah_kategori'));
      if (fabTambah.evaluate().isEmpty) {
        final fab = find.byType(FloatingActionButton);
        if (fab.evaluate().isNotEmpty) {
          await tester.tap(fab.first);
        }
      } else {
        await tester.tap(fabTambah);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      final formKategori = find.byKey(const Key('form_kategori_tagihan'));
      expect(formKategori, findsOneWidget);

      final inputNama = find.byKey(const Key('input_nama_kategori'));
      if (inputNama.evaluate().isNotEmpty) {
        await tester.enterText(inputNama, 'Test E2E Kategori');
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      final btnBatal = find.byKey(const Key('btn_batal_kategori'));
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

    testWidgets('Test 5: Filter by Kategori', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToKategoriTagihan(tester);

      final filterToggle = find.byKey(const Key('toggle_filter_kategori'));
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      final dropdownKategori = find.byKey(
        const Key('dropdown_filter_kategori'),
      );
      if (dropdownKategori.evaluate().isNotEmpty) {
        await tester.tap(dropdownKategori);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        // Reset filter
        final btnReset = find.byKey(const Key('btn_reset_filter_kategori'));
        if (btnReset.evaluate().isNotEmpty) {
          await tester.tap(btnReset);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });
  });
}
