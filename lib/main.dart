import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kependudukan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/keuangan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_keluarga.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_tagihan.dart'
    as rumah_tagihan;
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/rumah_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/daftar_pengguna.dart'
    as manajemen_pengguna;
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/tambah_pengguna.dart'
    as manajemen_tambah_pengguna;
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/edit_pengguna.dart'
    as manajemen_edit_pengguna;
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_daftar.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/tagihan/daftar_tagihan.dart';
import 'package:jawara_pintar_mobile_version/pages/tagihan/detail_tagihan.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/daftar_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/profil.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/tambah_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/tambah_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kegiatan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_rumah.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/daftar_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/detail_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/edit_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/daftar_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/tambah_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/pages/pengeluaran/edit_pengeluaran.dart';

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
        '/': (context) => const Kegiatan(),
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
        '/pemasukan_lain': (context) => const PemasukanLain(),
        '/tambah_pemasukan': (context) => const TambahPemasukanLain(),
        '/daftar_pengeluaran': (context) => const DaftarPengeluaran(),
        '/tambah_pengeluaran': (context) => const TambahPengeluaran(),
        '/edit_pengeluaran': (context) =>
            const EditPengeluaranPage(pengeluaran: {}),
        '/daftar_tagihan': (context) => const DaftarTagihan(),
        '/detail_tagihan': (context) => const DetailTagihan(tagihan: {}),
        '/daftar_tagihan_rumah': (context) =>
            const rumah_tagihan.DaftarTagihan(),
        '/daftar_keluarga': (context) => const DaftarKeluarga(),
        '/pengguna/daftar_pengguna': (context) => const DaftarPengguna(),
        '/pengguna/tambah_pengguna': (context) => const TambahPengguna(),
        '/profil': (context) => Profil(),
        '/manajemen_pengguna/daftar_pengguna': (context) =>
            const manajemen_pengguna.DaftarPengguna(),
        '/manajemen_pengguna/tambah_pengguna': (context) =>
            const manajemen_tambah_pengguna.TambahPengguna(),
        '/manajemen_pengguna/edit_pengguna': (context) =>
            const manajemen_edit_pengguna.EditPengguna(pengguna: {}),
      },
    );
  }
}
