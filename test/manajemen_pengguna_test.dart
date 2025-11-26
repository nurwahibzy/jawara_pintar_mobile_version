// import 'dart:async'; // WAJIB

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/datasources/manajemen_pengguna_remote_data_source.dart';
// import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/entities/manajemen_pengguna.dart';

// // --- 1. TYPE ALIAS ---
// typedef PostgrestList = List<Map<String, dynamic>>;

// // --- 2. CLASS MOCK & FAKE ---

// class MockSupabaseClient extends Mock implements SupabaseClient {}

// // SupabaseQueryBuilder ternyata implements Future, jadi harus hati-hati di Mocktail
// class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

// // Fake Builder untuk .select() dan .insert()
// class FakePostgrestFilterBuilder extends Fake
//     implements PostgrestFilterBuilder<PostgrestList> {
//   final PostgrestList _data;

//   FakePostgrestFilterBuilder([this._data = const []]);

//   // Handle .order() chaining
//   @override
//   PostgrestTransformBuilder<PostgrestList> order(
//     String column, {
//     bool ascending = true,
//     bool nullsFirst = false,
//     String? referencedTable,
//   }) {
//     return FakePostgrestTransformBuilder(_data);
//   }

//   // Handle await (Future)
//   @override
//   Future<R> then<R>(
//     FutureOr<R> Function(PostgrestList value) onValue, {
//     Function? onError,
//   }) async {
//     return onValue(_data) as R;
//   }
// }

// // Fake Builder untuk .order()
// class FakePostgrestTransformBuilder extends Fake
//     implements PostgrestTransformBuilder<PostgrestList> {
//   final PostgrestList _data;

//   FakePostgrestTransformBuilder(this._data);

//   @override
//   Future<R> then<R>(
//     FutureOr<R> Function(PostgrestList value) onValue, {
//     Function? onError,
//   }) async {
//     return onValue(_data) as R;
//   }
// }

// // Mock khusus untuk skenario Exception
// class MockSupabaseFilterBuilder extends Mock implements PostgrestFilterBuilder<PostgrestList> {}

// void main() {
//   late ManajemenPenggunaRemoteDataSourceImpl dataSource;
//   late MockSupabaseClient mockClient;
//   late MockSupabaseQueryBuilder mockQueryBuilder;

//   setUp(() {
//     mockClient = MockSupabaseClient();
//     mockQueryBuilder = MockSupabaseQueryBuilder();

//     dataSource = ManajemenPenggunaRemoteDataSourceImpl(client: mockClient);
    
//     // Fallback values
//     registerFallbackValue(''); 
//   });

//   const tTableName = 'users';

//   group('getAllUsers', () {
//     final tJsonList = [
//       {
//         "id": 1,
//         "keluarga_Id": 1,
//         "nik": "351234567890123456",
//         "nama_lengkap": "User Satu",
//         "username": "user1",
//         "password": "pass1",
//         "email": "user1@gmail.com",
//         "no_hp": "081234567890",
//         "jenis_kelamin": "Laki-laki",
//         "role": "admin",
//         "status": "pending",
//       },
//       {
//         "id": 2,
//         "keluarga_Id": 2,
//         "nik": "351234567890123457",
//         "nama_lengkap": "User Dua",
//         "username": "user2",
//         "password": "pass2",
//         "email": "user2@gmail.com",
//         "no_hp": "081234567891",
//         "jenis_kelamin": "Perempuan",
//         "role": "bendahara",
//         "status": "approved",
//       },
//     ];

//     test('Harus mengembalikan List<ManajemenPengguna> ketika request berhasil', () async {
//       // --- ARRANGE ---
      
//       // FIX 1: .from() mengembalikan QueryBuilder yang ternyata adalah Future.
//       // JANGAN gunakan thenReturn. Gunakan thenAnswer.
//       when(() => mockClient.from(tTableName))
//           .thenAnswer((_) => mockQueryBuilder);

//       // FIX 2: .select() juga mengembalikan Future. Gunakan thenAnswer.
//       when(() => mockQueryBuilder.select(any()))
//           .thenAnswer((_) => FakePostgrestFilterBuilder(tJsonList));

//       // --- ACT ---
//       final result = await dataSource.getAllUsers();

//       // --- ASSERT ---
//       expect(result, isA<List<ManajemenPengguna>>());
//       expect(result.length, 2);
//       expect(result[0].namaLengkap, 'User Satu');

//       verify(() => mockClient.from(tTableName)).called(1);
//       verify(() => mockQueryBuilder.select(any())).called(1);
//     });

//     test('Harus melempar Exception ketika terjadi error di Supabase', () async {
//        // --- ARRANGE ---
//        final mockErrorFilterBuilder = MockSupabaseFilterBuilder();

//        // FIX 1: Gunakan thenAnswer untuk .from
//        when(() => mockClient.from(tTableName))
//            .thenAnswer((_) => mockQueryBuilder);
       
//        // FIX 2: Gunakan thenAnswer untuk .select
//        when(() => mockQueryBuilder.select(any()))
//            .thenAnswer((_) => mockErrorFilterBuilder);

//        // Simulasi Error pada .order
//        when(() => mockErrorFilterBuilder.order(
//              any(), 
//              ascending: any(named: 'ascending'),
//              nullsFirst: any(named: 'nullsFirst'),
//              referencedTable: any(named: 'referencedTable'),
//            )).thenThrow(Exception('Koneksi Gagal'));

//        // --- ACT & ASSERT ---
//        expect(() => dataSource.getAllUsers(), throwsException);
//     });
//   });

//   group('addUser', () {
//     final tUser = ManajemenPengguna(
//       id: 3,
//       keluargaId: 3,
//       nik: '351234567890123458',
//       namaLengkap: 'User Tiga',
//       username: 'user3',
//       password: 'pass3',
//       email: 'user3@gmail.com',
//       noHP: '081234567892',
//       jenisKelamin: 'Laki-laki',
//       role: 'admin',
//       status: 'pending',
//     );

//     test('Harus berhasil memanggil insert tanpa error', () async {
//       // --- ARRANGE ---
      
//       // FIX 1: Gunakan thenAnswer untuk .from
//       when(() => mockClient.from(tTableName))
//           .thenAnswer((_) => mockQueryBuilder);

//       // FIX 2: Gunakan thenAnswer untuk .insert
//       when(() => mockQueryBuilder.insert(any()))
//           .thenAnswer((_) => FakePostgrestFilterBuilder([]));

//       // --- ACT ---
//       await dataSource.addUser(tUser);

//       // --- ASSERT ---
//       verify(() => mockClient.from(tTableName)).called(1);
//       verify(() => mockQueryBuilder.insert(tUser.toJson())).called(1);
//     });
//   });
// }