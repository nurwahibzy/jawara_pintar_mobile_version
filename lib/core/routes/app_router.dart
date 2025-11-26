import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/pages/broadcast/daftar_broadcast.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kegiatan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/kependudukan.dart';
import 'package:jawara_pintar_mobile_version/pages/dahsboard/keuangan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_keluarga.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_rumah.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/daftar_tagihan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/detail_tagihan.dart';
import 'package:jawara_pintar_mobile_version/pages/data_rumah_warga/rumah_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/kegiatan/kegiatan_daftar.dart';
import 'package:jawara_pintar_mobile_version/pages/log%20aktivitas/daftar_log_aktivitas.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/daftar_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/edit_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/manajemen_pengguna/tambah_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/daftar_kategori_iuran.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_daftar.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/pemasukan_lain_tambah.dart';
import 'package:jawara_pintar_mobile_version/pages/pemasukan_lain/tambah_kategori_iuran.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/daftar_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/profil.dart';
import 'package:jawara_pintar_mobile_version/pages/pengguna/tambah_pengguna.dart';
import 'package:jawara_pintar_mobile_version/pages/pesan_warga/daftar_pesan_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/tagihan/daftar_tagihan.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/daftar_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/detail_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/edit_warga.dart';
import 'package:jawara_pintar_mobile_version/pages/warga/tambah_warga.dart';
import '../../features/pengeluaran/presentation/pages/daftar_pengeluaran.dart';
import '../../features/pengeluaran/presentation/pages/edit_pengeluaran.dart';
import '../../features/pengeluaran/presentation/pages/tambah_pengeluaran.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';

import '../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import '../injections/injection.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Mengambil arguments (jika ada)
    // final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      //pengeluaran
      case AppRoutes.daftarPengeluaran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PengeluaranBloc>()..add(const LoadPengeluaran()),
            child: const DaftarPengeluaran(),
          ),
        );

      case AppRoutes.tambahPengeluaran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PengeluaranBloc>(),
            child: const TambahPengeluaranPage(),
          ),
        );

      case AppRoutes.editPengeluaran:
        final pengeluaran = settings.arguments as Pengeluaran;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<PengeluaranBloc>(context),
            child: EditPengeluaranPage(pengeluaran: pengeluaran),
          ),
        );

      case AppRoutes.kependudukan:
        return MaterialPageRoute(builder: (_) => const Kependudukan());

      case AppRoutes.tambahWarga:
        return MaterialPageRoute(builder: (_) => const TambahWarga());

      case AppRoutes.daftarWarga:
        return MaterialPageRoute(builder: (_) => const DaftarWarga());

      case AppRoutes.detailWarga:
        // Validasi: Pastikan args ada datanya, kalau null kirim Map kosong biar gak crash
        return MaterialPageRoute(builder: (_) => DetailWarga(warga: {}));

      case AppRoutes.editWarga:
        return MaterialPageRoute(builder: (_) => EditWarga(warga: {}));

      case AppRoutes.pesanWarga:
        return MaterialPageRoute(builder: (_) => const DaftarPesanWarga());

      case AppRoutes.daftarKeluarga:
        return MaterialPageRoute(builder: (_) => const DaftarKeluarga());

      case AppRoutes.tambahRumah:
        return MaterialPageRoute(builder: (_) => const TambahRumah());

      case AppRoutes.daftarRumah:
        return MaterialPageRoute(builder: (_) => const DaftarRumah());

      case AppRoutes.keuangan:
        return MaterialPageRoute(builder: (_) => const Keuangan());

      case AppRoutes.pemasukanLain:
        return MaterialPageRoute(builder: (_) => const PemasukanLain());

      case AppRoutes.tambahPemasukan:
        return MaterialPageRoute(builder: (_) => const TambahPemasukanLain());

      case AppRoutes.daftarTagihan:
        return MaterialPageRoute(builder: (_) => const DaftarTagihan());

      case AppRoutes.detailTagihan:
        return MaterialPageRoute(builder: (_) => DetailTagihan(tagihan: {}));

      case AppRoutes.daftarTagihanRumah:
              return MaterialPageRoute(builder: (_) => const DaftarTagihanRumah());

      case AppRoutes.daftarKategoriIuran:
        return MaterialPageRoute(builder: (_) => const DaftarKategoriIuran());

      case AppRoutes.tambahKategoriIuran:
        return MaterialPageRoute(builder: (_) => const TambahKategoriIuran());

      case AppRoutes.kegiatan:
        return MaterialPageRoute(builder: (_) => const Kegiatan());

      case AppRoutes.daftarKegiatan:
        return MaterialPageRoute(builder: (_) => const DaftarKegiatan());

      case AppRoutes.broadcast:
        return MaterialPageRoute(builder: (_) => const DaftarBroadcast());

      case AppRoutes.logAktivitas:
        return MaterialPageRoute(builder: (_) => const DaftarLogAktivitas());

      case AppRoutes.profil:
        return MaterialPageRoute(builder: (_) => Profil());

      // --- PENGGUNA (User Biasa) ---
      case AppRoutes.penggunaDaftar:
        return MaterialPageRoute(builder: (_) => const DaftarPengguna());

      case AppRoutes.penggunaTambah:
        return MaterialPageRoute(builder: (_) => const TambahPengguna());

      // --- MANAJEMEN PENGGUNA (Admin) ---
      case AppRoutes.manPenggunaDaftar:
        return MaterialPageRoute(builder: (_) => const ManDaftarPengguna());

      case AppRoutes.manPenggunaTambah:
        return MaterialPageRoute(builder: (_) => const ManTambahPengguna());

      case AppRoutes.manPenggunaEdit:
        return MaterialPageRoute(
          builder: (_) => ManEditPengguna(pengguna:  {}),
        );

      // dikebutt moasss
      default:
        return _errorRoute();
    }
  }

  // Halaman Error jika route tidak ditemukan
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Halaman tidak ditemukan!')),
        );
      },
    );
  }
}
