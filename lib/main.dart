import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kependudukan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/keuangan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/rumah_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_daftar.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/tambah_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kegiatan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_rumah.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/daftar_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/detail_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/edit_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/daftar_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/tambah_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/edit_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/pages/Laporan/channel_transfer.dart';
import 'package:jawara_pintar_mobile_version/pages/Laporan/LaporanKeuangan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/mutasi_keluarga.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/penerimaan_warga_page.dart';


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
        '/': (context) => const DaftarPengeluaran(),
        '/kependudukan': (context) => const Kependudukan(),
        '/keuangan': (context) => const Keuangan(),
        '/login': (context) => const LoginPage(),
        '/tambah_warga': (context) => const TambahWarga(),
        '/tambah_rumah': (context) => const TambahRumah(),
        '/kegiatan': (context) => const Kegiatan(),
        '/daftar_rumah': (context) => const DaftarRumah(),
        '/daftar_warga': (context) => const DaftarWarga(),
        '/detail_warga': (context) => const DetailWarga(warga: {}),
        '/edit_warga': (context) => const EditWarga(warga: {}),
        '/pemasukan': (context) => const PemasukanLain(),
        '/tambah_pemasukan': (context) => const TambahPemasukanLain(),
        '/daftar_pengeluaran': (context) => const DaftarPengeluaran(),
        '/tambah_pengeluaran': (context) => const TambahPengeluaran(),
        '/edit_pengeluaran': (context) => const EditPengeluaranPage(pengeluaran: {}),
        // '/channel_transfer': (context) => const ChannelTransfer(),
        '/laporan_keuangan': (context) => const LaporanKeuangan(),
        // '/mutasi_keluarga': (context) => const MutasiKeluarga(),
        '/penerimaan_warga': (context) => const PenerimaanWargaPage(),

      },
    );
  }
}
