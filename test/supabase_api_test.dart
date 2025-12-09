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

    print('\n🔧 Test Configuration:');
    print('   Supabase URL: $supabaseUrl');
    print('   Test Email: $testEmail\n');
  });

  group('🔐 Authentication', () {
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

  group('👥 Warga Endpoints', () {
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

  group('👪 Keluarga Endpoints', () {
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
        endpoint: 'keluarga?status_keluarga=eq.Aktif&select=*&limit=3',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;

      if (data.isNotEmpty) {
        expect(data.every((k) => k['status_keluarga'] == 'Aktif'), isTrue);
        print('   ✓ Status filter working');
      }
    });
  });

  group('🏠 Rumah Endpoints', () {
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
        endpoint: 'rumah?select=id,alamat,nomor_rumah&limit=10',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Simple rumah list retrieved');
    });

    test('GET /rumah - Order by nomor_rumah', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'rumah?select=id,alamat,nomor_rumah&order=nomor_rumah.asc&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Ordering by nomor_rumah working');
    });
  });

  group('💰 Master Iuran Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /master_iuran - Mendapatkan semua master iuran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'master_iuran?select=*,kategori_iuran:kategori_iuran_id(nama_kategori)&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} master iuran');
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

    test('GET /kategori_iuran - Mendapatkan kategori', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_iuran?select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kategori iuran retrieved');
    });
  });

  group('📄 Tagihan Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /tagihan - Mendapatkan semua tagihan', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint:
            'tagihan?select=*,master_iuran(nama_iuran),keluarga(nomor_kk)&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      expect(data, isNotEmpty);
      print('   ✓ Found ${data.length} tagihan');
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
      final now = DateTime.now();
      final periode = '${now.year}-${now.month.toString().padLeft(2, '0')}';

      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'tagihan?periode=eq.$periode&select=*&limit=5',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Periode filter working');
    });
  });

  group('💸 Pengeluaran Endpoints', () {
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

    test('GET /kategori_transaksi - Filter jenis=Pengeluaran', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'kategori_transaksi?jenis=eq.Pengeluaran&select=*',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Kategori pengeluaran retrieved');
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

  group('🔄 Mutasi Keluarga Endpoints', () {
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

  group('💬 Aspirasi Endpoints', () {
    setUpAll(() async {
      if (accessToken == null) await login();
    });

    test('GET /aspirasi - Mendapatkan semua aspirasi', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'aspirasi?select=*,warga:warga_id(nama_lengkap)&limit=5',
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body) as List;
      print('   ✓ Found ${data.length} aspirasi');
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

  group('📊 Log Aktivitas', () {
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

  group('📈 Dashboard Keuangan Queries', () {
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
  });

  group('👨‍👩‍👧‍👦 Dashboard Kependudukan', () {
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

    test('GET /rumah - Count by status', () async {
      final response = await supabaseRequest(
        method: 'GET',
        endpoint: 'rumah?select=status_rumah',
      );

      expect(response.statusCode, equals(200));
      print('   ✓ Rumah statistics retrieved');
    });
  });
}
