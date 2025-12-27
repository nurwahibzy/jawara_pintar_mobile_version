import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara_pintar_mobile_version/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Laporan Keuangan & Cetak Laporan E2E Test', () {
    testWidgets('User Journey: Login -> Laporan Keuangan -> Cetak Laporan',
        (tester) async {
      
      Future<void> userDelay() async {
        await tester.pump(const Duration(seconds: 2));
      }

      // 1. Jalankan aplikasi
      await app.main();
      await tester.pumpAndSettle();
      await userDelay();

      // 2. Login
      final inputEmail = find.byKey(const Key('input_email'));
      // Cek apakah kita perlu login
      if (inputEmail.evaluate().isNotEmpty) {
          await tester.enterText(inputEmail, 'admin1@gmail.com');
          await tester.pumpAndSettle();
          await userDelay();

          final inputPassword = find.byKey(const Key('input_password'));
          await tester.enterText(inputPassword, 'password');
          await tester.pumpAndSettle();
          await userDelay();

          final btnLogin = find.byKey(const Key('btn_login'));
          await tester.tap(btnLogin);
          
          // Tunggu dashboard
          bool dashboardFound = false;
          for (int i = 0; i < 10; i++) {
            await tester.pump(const Duration(seconds: 1));
            if (find.byKey(const Key('tab_keuangan')).evaluate().isNotEmpty) {
              dashboardFound = true;
              break;
            }
          }
          if (!dashboardFound) {
             fail('Dashboard tidak muncul setelah login');
          }
      }

      await tester.pumpAndSettle();
      await userDelay();

      // 3. Buka Menu Laporan Keuangan
      final menuLaporan = find.byKey(const Key('menu_laporan_keuangan'));
      // Scroll sampai ketemu jika perlu
      await tester.scrollUntilVisible(
        menuLaporan,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(menuLaporan);
      await tester.pumpAndSettle();
      await userDelay();

      // 4. Interaksi di Halaman Laporan Keuangan
      // Cek Tab Pengeluaran
      final tabPengeluaran = find.byKey(const Key('tab_pengeluaran'));
      await tester.tap(tabPengeluaran);
      await tester.pumpAndSettle();
      await userDelay();

      // Cek Tab Pemasukan
      final tabPemasukan = find.byKey(const Key('tab_pemasukan'));
      await tester.tap(tabPemasukan);
      await tester.pumpAndSettle();
      await userDelay();

      // Kembali ke Dashboard
      final btnBack = find.byKey(const Key('btn_back'));
      await tester.tap(btnBack);
      await tester.pumpAndSettle();
      await userDelay();

      // 5. Buka Menu Cetak Laporan
      final menuCetak = find.byKey(const Key('menu_cetak_laporan'));
      await tester.scrollUntilVisible(
        menuCetak,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(menuCetak);
      await tester.pumpAndSettle();
      await userDelay();

      // Helper to tap date picker confirm button
      Future<void> tapDatePickerConfirm() async {
        final okButton = find.text('OK');
        if (okButton.evaluate().isNotEmpty) {
          await tester.tap(okButton);
          return;
        }
        final pilihButton = find.text('Pilih');
        if (pilihButton.evaluate().isNotEmpty) {
          await tester.tap(pilihButton);
          return;
        }
        final selectButton = find.text('SELECT');
        if (selectButton.evaluate().isNotEmpty) {
          await tester.tap(selectButton);
          return;
        }
        // Fallback: try to find the confirm button by type in the dialog
        // Usually the last TextButton in the dialog actions
        final textButtons = find.byType(TextButton);
        if (textButtons.evaluate().isNotEmpty) {
           await tester.tap(textButtons.last);
        }
      }

      // Helper to select a specific day
      Future<void> selectDay(int day) async {
        final dayFinder = find.text(day.toString());
        if (dayFinder.evaluate().isNotEmpty) {
          // Tap the last occurrence (usually the calendar cell)
          await tester.tap(dayFinder.last);
          await tester.pumpAndSettle();
        }
      }

      // 6. Form Cetak Laporan
      // Pilih Tanggal Mulai (Pilih tanggal 1 bulan ini)
      final inputMulai = find.byKey(const Key('input_tanggal_mulai'));
      await tester.tap(inputMulai);
      await tester.pumpAndSettle();
      await userDelay();
      
      await selectDay(1);
      await userDelay();
      
      await tapDatePickerConfirm();
      await tester.pumpAndSettle();
      await userDelay();

      // Pilih Tanggal Akhir (Pilih hari ini)
      final inputAkhir = find.byKey(const Key('input_tanggal_akhir'));
      await tester.tap(inputAkhir);
      await tester.pumpAndSettle();
      await userDelay();

      await selectDay(DateTime.now().day);
      await userDelay();

      await tapDatePickerConfirm();
      await tester.pumpAndSettle();
      await userDelay();

      // Submit
      final btnSubmit = find.byKey(const Key('btn_submit_cetak'));
      await tester.tap(btnSubmit);
      await tester.pumpAndSettle();
      
      // Tunggu hasil (Preview Laporan)
      bool previewFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.text('Preview Laporan').evaluate().isNotEmpty) {
          previewFound = true;
          break;
        }
      }
      
      if (previewFound) {
        print('Preview Laporan berhasil ditampilkan');
      } else {
        print('Warning: Preview Laporan tidak muncul dalam 10 detik (mungkin data kosong atau loading lama)');
      }
      
      await userDelay();

      // 7. Generate PDF
      // Scroll ke bawah untuk melihat tombol Generate PDF jika perlu
      final btnGeneratePdf = find.byKey(const Key('btn_generate_pdf'));
      await tester.scrollUntilVisible(
        btnGeneratePdf,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      
      await tester.tap(btnGeneratePdf);
      await tester.pumpAndSettle();
      
      // Tunggu proses generate PDF selesai
      bool pdfSuccess = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.text('PDF Berhasil Dibuat').evaluate().isNotEmpty) {
          pdfSuccess = true;
          break;
        }
      }

      if (pdfSuccess) {
         print('PDF berhasil dibuat');
      } else {
         fail('Gagal membuat PDF atau timeout');
      }

      await userDelay();
    });
  });
}
