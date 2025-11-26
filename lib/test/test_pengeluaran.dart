import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/datasources/remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/data/models/pengeluaran_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    final sbUrl = dotenv.env['SUPABASE_URL'];
    final sbKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (sbUrl == null || sbKey == null) {
      throw Exception(
        "File .env tidak lengkap! Pastikan SUPABASE_URL dan SUPABASE_ANON_KEY ada.",
      );
    }

    await Supabase.initialize(url: sbUrl, anonKey: sbKey);

    runApp(TestPengeluaranCRUDApp());
  } catch (e) {
    runApp(ErrorApp(message: e.toString()));
  }
}

class TestPengeluaranCRUDApp extends StatelessWidget {
  final PengeluaranRemoteDataSource datasource =
      PengeluaranRemoteDataSourceImpl();

  TestPengeluaranCRUDApp({super.key});

  // Fungsi fetch semua data
  Future<void> testFetchAll() async {
    try {
      final data = await datasource.getAllPengeluaran();
      print('\n getAllPengeluaran:');
      if (data.isEmpty) {
        print(' Table pengeluaran kosong.');
      } else {
        for (var item in data) print(item.toMap());
      }
    } catch (e) {
      print(' Error fetch all: $e');
    }
  }

  // Fungsi fetch by ID
  Future<void> testFetchById(int id) async {
    try {
      final item = await datasource.getPengeluaranById(id);
      print('\n getPengeluaranById($id): ${item.toMap()}');
    } catch (e) {
      print(' Error fetch by id: $e');
    }
  }

  // Fungsi create data
  Future<int?> testCreate() async {
    try {
      final newItem = PengeluaranModel(
        id: 0, // Supabase akan generate id
        judul: 'Test Create',
        kategoriTransaksiId: 1,
        nominal: 50000,
        tanggalTransaksi: DateTime.now(),
        buktiFoto: null,
        keterangan: 'Ini test create',
        createdBy: 1,
        verifikatorId: 1,
        tanggalVerifikasi: null,
        createdAt: DateTime.now(),
      );
      await datasource.createPengeluaran(newItem);

      print('\n createPengeluaran: berhasil');
      final all = await datasource.getAllPengeluaran();
      final created = all.last; // ambil item terakhir sebagai yang baru dibuat
      print('Created item: ${created.toMap()}');
      return created.id;
    } catch (e) {
      print(' Error create: $e');
      return null;
    }
  }

  // Fungsi update data
  Future<void> testUpdate(int id) async {
    try {
      final updateItem = PengeluaranModel(
        id: id,
        judul: 'Updated Test',
        kategoriTransaksiId: 1,
        nominal: 75000,
        tanggalTransaksi: DateTime.now(),
        buktiFoto: null,
        keterangan: 'Ini test update',
        createdBy: 1,
        verifikatorId: 1,
        tanggalVerifikasi: null,
        createdAt: DateTime.now(),
      );
      await datasource.updatePengeluaran(updateItem);
      final updated = await datasource.getPengeluaranById(id);
      print('\n updatePengeluaran: ${updated.toMap()}');
    } catch (e) {
      print(' Error update: $e');
    }
  }

  // Fungsi delete data
  Future<void> testDelete(int id) async {
    try {
      await datasource.deletePengeluaran(id);
      print('\n deletePengeluaran id=$id: berhasil');
    } catch (e) {
      print(' Error delete: $e');
    }
  }

  // Jalankan seluruh test CRUD secara berurutan
  Future<void> runCRUDTest() async {
    await testFetchAll();
    final createdId = await testCreate();
    if (createdId != null) {
      await testFetchById(createdId);
      await testUpdate(createdId);
      await testDelete(createdId);
    }
    await testFetchAll();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runCRUDTest();
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Pengeluaran CRUD')),
        body: const Center(
          child: Text('Cek console untuk hasil CRUD data pengeluaran.'),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String message;

  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            'Terjadi error:\n$message',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}