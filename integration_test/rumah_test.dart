import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - Rumah (Houses)', () {
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

    Future<void> navigateToRumah(WidgetTester tester) async {
      // Buka drawer atau menu untuk akses Rumah
      final scaffoldFinder = find.byType(Scaffold);
      if (scaffoldFinder.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu).first);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        // Tap menu Rumah
        final menuRumah = find.text('Rumah');
        if (menuRumah.evaluate().isNotEmpty) {
          await tester.tap(menuRumah);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    }

    testWidgets('Test 1: View Daftar Rumah', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToRumah(tester);

      // Verifikasi list rumah muncul
      final listRumah = find.byKey(const Key('list_rumah'));
      expect(listRumah, findsOneWidget);

      // Scroll list
      await tester.drag(listRumah, const Offset(0, -300));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);
    });

    testWidgets('Test 2: Search Rumah by Alamat', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToRumah(tester);

      final searchField = find.byKey(const Key('search_rumah'));
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'Jalan');
        await tester.pumpAndSettle();
        await userDelay(tester);

        final btnApply = find.byKey(const Key('btn_apply_filter_rumah'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 3: Filter Rumah by Status', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToRumah(tester);

      final filterToggle = find.byKey(const Key('toggle_filter_rumah'));
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      final dropdownStatus = find.byKey(const Key('dropdown_status_rumah'));
      if (dropdownStatus.evaluate().isNotEmpty) {
        await tester.tap(dropdownStatus);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final optionDihuni = find.text('Dihuni').last;
        if (optionDihuni.evaluate().isNotEmpty) {
          await tester.tap(optionDihuni);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }

        final btnApply = find.byKey(const Key('btn_apply_filter_rumah'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 4: View Detail Rumah', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToRumah(tester);

      final rumahCard = find.byKey(const Key('card_rumah_0'));
      if (rumahCard.evaluate().isEmpty) {
        final anyRumahCard = find.byType(Card).first;
        if (anyRumahCard.evaluate().isNotEmpty) {
          await tester.tap(anyRumahCard);
        } else {
          return;
        }
      } else {
        await tester.tap(rumahCard);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      final backButton = find.byType(BackButton);
      expect(backButton, findsAtLeastNWidgets(1));

      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 5: Tambah Rumah (Form Validation)', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToRumah(tester);

      final fabTambah = find.byKey(const Key('fab_tambah_rumah'));
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

      final formRumah = find.byKey(const Key('form_rumah'));
      expect(formRumah, findsOneWidget);

      // Test isi form
      final inputAlamat = find.byKey(const Key('input_alamat_rumah'));
      if (inputAlamat.evaluate().isNotEmpty) {
        await tester.enterText(inputAlamat, 'Jl. Test E2E No. 123');
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      // Batal
      final btnBatal = find.byKey(const Key('btn_batal_rumah'));
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
  });
}
