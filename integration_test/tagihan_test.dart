import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Test - Tagihan Pembayaran', () {
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

    Future<void> navigateToTagihan(WidgetTester tester) async {
      final scaffoldFinder = find.byType(Scaffold);
      if (scaffoldFinder.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu).first);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final menuTagihan = find.text('Tagihan');
        if (menuTagihan.evaluate().isNotEmpty) {
          await tester.tap(menuTagihan);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    }

    testWidgets('Test 1: View Daftar Tagihan Pembayaran', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihan(tester);

      final listTagihan = find.byKey(const Key('list_tagihan'));
      expect(listTagihan, findsOneWidget);

      await tester.drag(listTagihan, const Offset(0, -300));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);
    });

    testWidgets('Test 2: Filter Tagihan by Status', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihan(tester);

      final filterToggle = find.byKey(const Key('toggle_filter_tagihan'));
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);
      }

      final dropdownStatus = find.byKey(const Key('dropdown_status_tagihan'));
      if (dropdownStatus.evaluate().isNotEmpty) {
        await tester.tap(dropdownStatus);
        await tester.pumpAndSettle();
        await userDelay(tester, seconds: 1);

        final optionLunas = find.text('Lunas').last;
        if (optionLunas.evaluate().isNotEmpty) {
          await tester.tap(optionLunas);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }

        final btnApply = find.byKey(const Key('btn_apply_filter_tagihan'));
        if (btnApply.evaluate().isNotEmpty) {
          await tester.tap(btnApply);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }
    });

    testWidgets('Test 3: View Detail Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihan(tester);

      final tagihanCard = find.byKey(const Key('card_tagihan_0'));
      if (tagihanCard.evaluate().isEmpty) {
        final anyCard = find.byType(Card).first;
        if (anyCard.evaluate().isNotEmpty) {
          await tester.tap(anyCard);
        } else {
          return;
        }
      } else {
        await tester.tap(tagihanCard);
      }

      await tester.pumpAndSettle();
      await userDelay(tester);

      final backButton = find.byType(BackButton);
      expect(backButton, findsAtLeastNWidgets(1));

      await tester.tap(backButton.first);
      await tester.pumpAndSettle();
      await userDelay(tester);
    });

    testWidgets('Test 4: Refresh Daftar Tagihan', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihan(tester);

      final listTagihan = find.byKey(const Key('list_tagihan'));
      await tester.drag(listTagihan, const Offset(0, 300));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await userDelay(tester);

      expect(listTagihan, findsOneWidget);
    });

    testWidgets('Test 5: Full Journey - Browse and Filter', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      await performLogin(tester);
      await navigateToTagihan(tester);

      final listTagihan = find.byKey(const Key('list_tagihan'));
      await tester.drag(listTagihan, const Offset(0, -200));
      await tester.pumpAndSettle();
      await userDelay(tester, seconds: 1);

      final filterToggle = find.byKey(const Key('toggle_filter_tagihan'));
      if (filterToggle.evaluate().isNotEmpty) {
        await tester.tap(filterToggle);
        await tester.pumpAndSettle();
        await userDelay(tester);

        final btnReset = find.byKey(const Key('btn_reset_filter_tagihan'));
        if (btnReset.evaluate().isNotEmpty) {
          await tester.tap(btnReset);
          await tester.pumpAndSettle();
          await userDelay(tester);
        }
      }

      expect(listTagihan, findsOneWidget);
    });
  });
}
