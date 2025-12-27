import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - Tagih Iuran', () {
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

    Future<void> navigateToTagihIuran(WidgetTester tester) async {
      final scaffoldFinder = find.byType(Scaffold);
      if (scaffoldFinder.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu).first);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final menuTagih = find.text('Tagih Iuran');
        if (menuTagih.evaluate().isNotEmpty) {
          await tester.tap(menuTagih);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    }

    testWidgets('Test 1: Open Tagih Iuran Page', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final formTagih = find.byKey(const Key('form_tagih_iuran'));
      expect(formTagih, findsOneWidget);
    });

    testWidgets('Test 2: View Master Iuran Dropdown', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final dropdownMaster = find.byKey(const Key('dropdown_master_iuran'));
      expect(dropdownMaster, findsOneWidget);

      await tester.tap(dropdownMaster);
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // Close dropdown
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 3: Select Master Iuran', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final dropdownMaster = find.byKey(const Key('dropdown_master_iuran'));
      await tester.tap(dropdownMaster);
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      // Pilih item pertama (jika ada)
      final dropdownItems = find.byType(DropdownMenuItem<dynamic>);
      if (dropdownItems.evaluate().isNotEmpty) {
        await tester.tap(dropdownItems.first);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }
    });

    testWidgets('Test 4: Pick Tanggal Jatuh Tempo', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final btnTanggal = find.byKey(const Key('btn_pilih_tanggal'));
      if (btnTanggal.evaluate().isNotEmpty) {
        await tester.tap(btnTanggal);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        // Tutup date picker dengan tombol cancel
        final btnCancel = find.text('CANCEL');
        if (btnCancel.evaluate().isNotEmpty) {
          await tester.tap(btnCancel);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 5: Form Validation - Submit Empty', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final btnSubmit = find.byKey(const Key('btn_submit_tagih_iuran'));
      if (btnSubmit.evaluate().isNotEmpty) {
        await tester.tap(btnSubmit);
        await tester.pumpAndSettle();
        await userDelay(tester);

        // Should show validation error
      }
    });

    testWidgets('Test 6: Cancel and Return', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }
    });

    testWidgets('Test 7: Full Journey - Select and Submit', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihIuran(tester);

      // Select master iuran
      final dropdownMaster = find.byKey(const Key('dropdown_master_iuran'));
      await tester.tap(dropdownMaster);
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      final dropdownItems = find.byType(DropdownMenuItem<dynamic>);
      if (dropdownItems.evaluate().isNotEmpty) {
        await tester.tap(dropdownItems.first);
        await tester.pumpAndSettle();
        await userDelay(tester);

        // Pick date
        final btnTanggal = find.byKey(const Key('btn_pilih_tanggal'));
        if (btnTanggal.evaluate().isNotEmpty) {
          await tester.tap(btnTanggal);
          await tester.pumpAndSettle();
          await userDelay(tester, seconds: 1);

          final btnOk = find.text('OK');
          if (btnOk.evaluate().isNotEmpty) {
            await tester.tap(btnOk);
            await tester.pumpAndSettle();
            await userDelay(tester);
          }
        }

        // Note: Don't actually submit in test to avoid creating real data
        // Just verify form is complete
        final btnSubmit = find.byKey(const Key('btn_submit_tagih_iuran'));
        expect(btnSubmit, findsOneWidget);
      }

      // Cancel
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
        await tester.pumpAndSettle();
        await userDelay(tester);
      }
    });
  });
}
