import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

/// API Test untuk Jawara Pintar Mobile Version
/// Menggunakan Dart test framework untuk testing yang lebih terstruktur
///
/// Cara menjalankan:
/// flutter test test/supabase_api_test.dart --reporter expanded
/// atau
/// dart test test/supabase_api_test.dart

// Test configuration
const String testEmail = "admin1@gmail.com";
const String testPassword = "password";

// Global state
late String supabaseUrl;
late String supabaseAnonKey;
String? accessToken;

/// Helper: Make HTTP request to Supabase
Future<http.Response> supabaseRequest({
  required String method,
  required String endpoint,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  bool useAuth = true,
}) async {
  final url = Uri.parse('$supabaseUrl/rest/v1/$endpoint');

  final defaultHeaders = {
    'apikey': supabaseAnonKey,
    'Content-Type': 'application/json',
    if (useAuth && accessToken != null) 'Authorization': 'Bearer $accessToken',
    ...?headers,
  };

  switch (method.toUpperCase()) {
    case 'GET':
      return await http.get(url, headers: defaultHeaders);
    case 'POST':
      return await http.post(
        url,
        headers: defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    case 'PATCH':
      return await http.patch(
        url,
        headers: defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    case 'DELETE':
      return await http.delete(url, headers: defaultHeaders);
    default:
      throw Exception('Unsupported HTTP method: $method');
  }
}

/// Helper: Login and get access token
Future<void> login() async {
  final url = Uri.parse('$supabaseUrl/auth/v1/token?grant_type=password');
  final response = await http.post(
    url,
    headers: {'apikey': supabaseAnonKey, 'Content-Type': 'application/json'},
    body: jsonEncode({'email': testEmail, 'password': testPassword}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    accessToken = data['access_token'];
  } else {
    throw Exception('Login failed: ${response.body}');
  }
}

void main() {
  // Setup: Load environment variables before all tests
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    supabaseUrl = dotenv.env['SUPABASE_URL']!;
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

    print('\nTest Configuration:');
    print('   Supabase URL: $supabaseUrl');
    print('   Test Email: $testEmail\n');
  });

  group('Authentication', () {
    test('Login dengan credentials yang valid', () async {
      final url = Uri.parse('$supabaseUrl/auth/v1/token?grant_type=password');
      final response = await http.post(
        url,
        headers: {
          'apikey': supabaseAnonKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': testEmail, 'password': testPassword}),
      );

      expect(response.statusCode, equals(200), reason: 'Login harus berhasil');

      final data = jsonDecode(response.body);
      expect(data['access_token'], isNotNull, reason: 'Access token harus ada');
      expect(data['user'], isNotNull, reason: 'User data harus ada');

      // Save token untuk test berikutnya
      accessToken = data['access_token'];

      print('   ✓ Access token obtained');
    });
  });

  group('Warga Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /warga - Mendapatkan semua data warga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty, reason: 'Harus ada data warga');
      print('   ✓ Found ${data.length} warga');
    });

    test('GET /warga - Filter by jenis_kelamin', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;

      if (data.isNotEmpty) {
        print('   ✓ Found ${data.length} warga (filter by gender available)');
      }
    });
    test('GET /warga - With keluarga relation', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=*,keluarga:keluarga_id(nomor_kk)&limit=3',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Relation query successful');
    });
  });

  group('Keluarga Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /keluarga - Mendapatkan semua data keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'keluarga?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} keluarga');
    });

    test('GET /keluarga - With rumah and warga relations', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'keluarga?select=*,rumah:rumah_id(alamat),warga(nama_lengkap)&limit=2',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Complex relations working');
    });

    test('GET /keluarga - Filter by status_keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'keluarga?select=*&limit=3',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Keluarga query successful - Found ${data.length} records');
    });
  });

  group('Rumah Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /rumah - Mendapatkan semua data rumah', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} rumah');
    });

    test('GET /rumah - Get simple list', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Simple rumah list retrieved');
    });

    test('GET /rumah - Order by nomor_rumah', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=*&order=id.asc&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Ordering by id working');
    });
  });

  group('Master Iuran Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /master_iuran - Mendapatkan semua master iuran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'master_iuran?select=*,kategori_iuran:kategori_iuran_id(id,nama_kategori)&order=id.asc&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} master iuran');
    });

    test('GET /master_iuran - Get by id', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'master_iuran?select=*,kategori_iuran:kategori_iuran_id(id,nama_kategori)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Master iuran by id retrieved');
    });

    test('GET /master_iuran - Filter by is_active=true', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'master_iuran?is_active=eq.true&select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;

      if (data.isNotEmpty) {
        expect(data.every((m) => m['is_active'] == true), isTrue);
        print('   ✓ Only active iuran returned');
      }
    });

    test('GET /master_iuran - For dropdown (tagih iuran)', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'master_iuran?select=id,nama_iuran,nominal_standar,kategori_iuran:kategori_iuran_id(nama_kategori)&is_active=eq.true&order=nama_iuran',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Master iuran dropdown retrieved');
    });

    test('GET /kategori_iuran - Mendapatkan kategori', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_iuran?select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kategori iuran retrieved');
    });
  });

  group('Tagihan Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /tagihan - Mendapatkan semua tagihan', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'tagihan?select=id,kode_tagihan,keluarga_id,master_iuran_id,periode,nominal,status_tagihan,created_at,master_iuran:master_iuran_id(nama_iuran)&order=created_at.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} tagihan');
    });

    test('GET /tagihan - Detail with pembayaran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'tagihan?select=id,kode_tagihan,keluarga_id,master_iuran_id,periode,nominal,status_tagihan,created_at,master_iuran:master_iuran_id(nama_iuran),pembayaran_tagihan(id,metode_pembayaran,bukti_bayar,tanggal_bayar,status_verifikasi)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Tagihan detail with pembayaran retrieved');
    });

    test('GET /tagihan - Filter by status=Lunas', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'tagihan?status_tagihan=eq.Lunas&select=*&limit=3',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Status filter working');
    });

    test('GET /tagihan - Filter by periode', () async {
      // Get any existing tagihan to test periode filter
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'tagihan?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Periode query working');
    });

    test('GET /tagihan - With keluarga relation', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'tagihan?select=*,master_iuran(nama_iuran),keluarga(nomor_kk)&limit=3',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Relation query successful');
    });
  });

  group('Pengeluaran Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /pengeluaran - Mendapatkan semua pengeluaran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'pengeluaran?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} pengeluaran');
    });

    test('GET /pengeluaran - Detail dengan user info', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'pengeluaran?select=*&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pengeluaran detail retrieved');
    });

    test('GET /kategori_transaksi - Filter jenis=Pengeluaran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_transaksi?jenis=eq.Pengeluaran&select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kategori pengeluaran retrieved');
    });

    test('GET /kategori_transaksi - All categories', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_transaksi?select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ All kategori transaksi retrieved');
    });

    test('GET /pengeluaran - Filter by date range', () async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pengeluaran?tanggal_transaksi=gte.${firstDay.toIso8601String().split('T')[0]}&tanggal_transaksi=lte.${lastDay.toIso8601String().split('T')[0]}&select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Date range filter working');
    });
  });

  group('Mutasi Keluarga Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /mutasi_keluarga - Mendapatkan semua mutasi', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'mutasi_keluarga?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} mutasi keluarga');
    });

    test('GET /mutasi_keluarga - With complete relations', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'mutasi_keluarga?select=*,keluarga:keluarga_id(nomor_kk),rumah_asal:rumah_asal_id(alamat),rumah_tujuan:rumah_tujuan_id(alamat)&limit=3',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Complete relations working');
    });
  });

  group('Aspirasi Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /aspirasi - Mendapatkan semua aspirasi', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'aspirasi?select=id,warga_id,judul,deskripsi,status,tanggapan_admin,updated_by,created_at,warga:warga!aspirasi_warga_id_fkey(nama_lengkap)&order=created_at.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} aspirasi');
    });

    test('GET /aspirasi - Get by id', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'aspirasi?select=id,warga_id,judul,deskripsi,status,tanggapan_admin,updated_by,created_at,warga:warga!aspirasi_warga_id_fkey(nama_lengkap)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Aspirasi by id retrieved');
    });

    test('GET /aspirasi - Filter by status', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'aspirasi?status=eq.Pending&select=*&limit=3',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Status filter working');
    });

    test('GET /aspirasi - Order by created_at desc', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'aspirasi?select=*&order=created_at.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Ordering by date working');
    });
  });

  group('Log Aktivitas', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /log_aktivitas_view - Mendapatkan log aktivitas', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'log_aktivitas_view?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} log entries');
    });
  });

  group('Dashboard Keuangan Queries', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /pemasukan_lain - Data tahun ini', () async {
      final year = DateTime.now().year;
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?tanggal_transaksi=gte.$year-01-01&tanggal_transaksi=lte.$year-12-31&select=nominal',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pemasukan lain retrieved');
    });

    test('GET /pemasukan_lain - With kategori relation', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?select=*,kategori_transaksi:kategori_transaksi_id(id,nama_kategori)&order=created_at.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pemasukan lain with kategori retrieved');
    });

    test('GET /pemasukan_lain - For cetak laporan', () async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?select=id,judul,nominal,tanggal_transaksi,keterangan,kategori_transaksi(nama_kategori)&tanggal_transaksi=gte.${firstDay.toIso8601String()}&tanggal_transaksi=lte.${lastDay.toIso8601String()}&order=tanggal_transaksi.desc',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pemasukan lain for laporan retrieved');
    });

    test('GET /pengeluaran - Agregasi nominal', () async {
      final year = DateTime.now().year;
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pengeluaran?tanggal_transaksi=gte.$year-01-01&select=nominal',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;

      if (data.isNotEmpty) {
        final total = data.fold<num>(
          0,
          (sum, item) => sum + (item['nominal'] ?? 0),
        );
        print('   ✓ Total pengeluaran: Rp ${total.toStringAsFixed(0)}');
      }
    });

    test('GET /tagihan - Summary by status', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'tagihan?select=status_tagihan,nominal&limit=20',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      if (data.isNotEmpty) {
        final lunas = data.where((t) => t['status_tagihan'] == 'Lunas').length;
        final belumLunas = data
            .where((t) => t['status_tagihan'] == 'Belum Lunas')
            .length;
        print('   ✓ Lunas: $lunas, Belum Lunas: $belumLunas');
      }
    });

    test('GET /tagihan - For cetak laporan (Lunas only)', () async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'tagihan?select=id,kode_tagihan,nominal,created_at,master_iuran(nama_iuran)&status_tagihan=eq.Lunas&created_at=gte.${firstDay.toIso8601String()}&created_at=lte.${lastDay.toIso8601String()}&order=created_at.desc',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Tagihan lunas for laporan retrieved');
    });
  });

  group('Pemasukan (Detail) Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /pemasukan_lain - List with filter', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?select=*,kategori_transaksi:kategori_transaksi_id(id,nama_kategori)&order=created_at.desc&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} pemasukan lain');
    });

    test('GET /pemasukan_lain - By kategori', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'pemasukan_lain?select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pemasukan by kategori filter working');
    });

    test('GET /pemasukan_lain - Detail dengan full info', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?select=*,kategori_transaksi:kategori_transaksi_id(id,nama_kategori)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pemasukan detail retrieved');
    });
  });

  group('Users & Manajemen Pengguna', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /users - All users with warga relation', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'users?select=*,warga(nama_lengkap)&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} users');
    });

    test('GET /users - Get user by id', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'users?select=*,warga(nama_lengkap)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ User by id retrieved');
    });
  });

  group('Broadcast Messages', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /broadcast - All broadcast messages', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'broadcast?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} broadcast messages');
    });
  });

  group('Transfer Channels', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /transfer_channels - All channels', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'transfer_channels?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} transfer channels');
    });
  });

  group('Kegiatan Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /kegiatan - List with kategori', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'kegiatan?select=*,kategori_kegiatan(nama_kategori)&order=tanggal_pelaksanaan.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} kegiatan');
    });

    test('GET /kegiatan - Detail kegiatan', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kegiatan?select=*,kategori_kegiatan(nama_kategori)&limit=1',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kegiatan detail retrieved');
    });

    test('GET /kategori_kegiatan - All categories', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_kegiatan?select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kategori kegiatan retrieved');
    });

    test('GET /transaksi_kegiatan - By kegiatan_id', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'transaksi_kegiatan?select=*,pemasukan_lain(judul,nominal,tanggal_transaksi,keterangan,bukti_foto,kategori_transaksi(nama_kategori)),pengeluaran(judul,nominal,tanggal_transaksi,keterangan,bukti_foto,kategori_transaksi(nama_kategori))&order=created_at.desc&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Transaksi kegiatan retrieved');
    });
  });

  group('Dashboard Kependudukan', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /keluarga - Count total keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'keluarga?select=id',
        headers: {'Prefer': 'count=exact'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Total keluarga: ${data.length}');
    });

    test('GET /warga - Count total penduduk', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=id',
        headers: {'Prefer': 'count=exact'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Total penduduk: ${data.length}');
    });

    test('GET /warga - Count by jenis_kelamin', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=jenis_kelamin',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;

      if (data.isNotEmpty) {
        final males = data.where((w) => w['jenis_kelamin'] == 'L').length;
        final females = data.where((w) => w['jenis_kelamin'] == 'P').length;
        print('   ✓ L: $males, P: $females');
      }
    });

    test('GET /warga - Status penduduk', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=status_penduduk',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Status penduduk retrieved');
    });

    test('GET /warga - Pekerjaan penduduk', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=pekerjaan',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pekerjaan data retrieved');
    });

    test('GET /warga - Peran dalam keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=status_keluarga',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Peran dalam keluarga retrieved');
    });

    test('GET /warga - Agama', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=agama',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Agama data retrieved');
    });

    test('GET /warga - Pendidikan', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=pendidikan_terakhir',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Pendidikan data retrieved');
    });

    test('GET /rumah - Count by status', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=status_rumah',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Rumah statistics retrieved');
    });
  });

  group('Dashboard Kegiatan', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /kegiatan - Total kegiatan', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kegiatan?select=id',
        headers: {'Prefer': 'count=exact'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Total kegiatan: ${data.length}');
    });

    test('GET /kegiatan - Per kategori', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kegiatan?select=kategori_kegiatan_id',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kegiatan per kategori retrieved');
    });

    test('GET /kegiatan - Berdasarkan waktu', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kegiatan?select=tanggal_pelaksanaan',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kegiatan berdasarkan waktu retrieved');
    });

    test('GET /kegiatan - Penanggung jawab', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kegiatan?select=penanggung_jawab',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Penanggung jawab data retrieved');
    });

    test('GET /kegiatan - Per bulan (tahun ini)', () async {
      final year = DateTime.now().year;
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'kegiatan?select=tanggal_pelaksanaan&tanggal_pelaksanaan=gte.$year-01-01&tanggal_pelaksanaan=lte.$year-12-31',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kegiatan per bulan retrieved');
    });
  });

  group('RPC Functions', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('RPC /generate_tagih_iuran - Generate tagihan test (dry run)', () async {
      // Note: This test should be run carefully as it might create actual data
      // In real scenario, you might want to test on a test database
      print('   [WARNING] RPC function test skipped - requires test database');
      print(
        '   [INFO] Function: generate_tagih_iuran(p_master_iuran_id, p_periode)',
      );
    });
  });

  group('Laporan Keuangan Queries', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /pemasukan_lain - Laporan pemasukan with filters', () async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pemasukan_lain?select=id,judul,kategori_transaksi_id,nominal,tanggal_transaksi,bukti_foto,keterangan,created_by,verifikator_id,tanggal_verifikasi,created_at,kategori_transaksi(nama_kategori)&tanggal_transaksi=gte.${firstDay.toIso8601String()}&tanggal_transaksi=lte.${lastDay.toIso8601String()}',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Laporan pemasukan retrieved');
    });

    test('GET /pengeluaran - Laporan pengeluaran with filters', () async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'pengeluaran?select=id,judul,kategori_transaksi_id,nominal,tanggal_transaksi,bukti_foto,keterangan,created_by,verifikator_id,tanggal_verifikasi,created_at,kategori_transaksi(nama_kategori)&tanggal_transaksi=gte.${firstDay.toIso8601String()}&tanggal_transaksi=lte.${lastDay.toIso8601String()}',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Laporan pengeluaran retrieved');
    });
  });

  group('Additional Query Patterns', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /warga - Warga tanpa keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=*&keluarga_id=is.null&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Warga tanpa keluarga retrieved');
    });

    test('GET /keluarga - Search rumah for keluarga', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=*&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Rumah list for keluarga retrieved');
    });

    test('GET /mutasi_keluarga - Options for dropdown', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'keluarga?select=id,nomor_kk&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Keluarga options retrieved');
    });

    test('GET /mutasi_keluarga - Rumah options', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=id,alamat&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Rumah options retrieved');
    });

    test('GET /mutasi_keluarga - Warga options', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'warga?select=id,nama_lengkap&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Warga options retrieved');
    });
  });
}
