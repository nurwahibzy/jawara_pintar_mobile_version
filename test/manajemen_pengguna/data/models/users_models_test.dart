import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/models/users_model.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/entities/users.dart';

void main() {
  //  data dummy
  final tDate = DateTime(2023, 1, 1, 10, 0, 0);
  const tDateString = "2023-01-01T10:00:00.000";

  // mendefinisikan Model
  final tUsersModel = UsersModel(
    id: 1,
    wargaId: 101,
    nama: 'Budi Santoso',
    role: 'Admin',
    status: 'Aktif',
    authId: 'auth-123',
    createdAt: tDate,
  );

  // mendefinisikan Entity untuk perbandingan
  final tUsersEntity = Users(
    id: 1,
    wargaId: 101,
    nama: 'Budi Santoso',
    role: 'Admin',
    status: 'Aktif',
    authId: 'auth-123',
    createdAt: tDate,
  );

  // test inheritance
  test('Users model harus merupakan turunan dari Users entity', () {
    expect(tUsersModel, isA<Users>());
  });

  // test fromJson / fromMap
  group('Test fungsi fromJson / fromMap', () {
    // Skenario 1: Data 'nama' diambil dari nested object 'warga'
    test(
      'harus mengambil nama dari nested object warga["nama_lengkap"] jika ada',
      () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'warga_id': 101,
          'warga': {
            'nama_lengkap': 'Budi Santoso', 
          },
          'role': 'Admin',
          'status_user': 'Aktif', 
          'auth_id': 'auth-123',
          'created_at': tDateString,
        };

        // Act
        final result = UsersModel.fromJson(jsonMap);

        // Assert
        expect(result.nama, 'Budi Santoso');
        expect(result.wargaId, 101);
      },
    );

    // Skenario 2: Data 'nama' diambil langsung (flat) jika nested 'warga' = null
    test(
      'harus mengambil nama dari field "nama_lengkap" jika object warga null',
      () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'warga_id': 101,
          'warga': null, 
          'nama_lengkap': 'Budi Santoso', // Logic ambil dari sini
          'role': 'Admin',
          'status_user': 'Aktif',
          'auth_id': 'auth-123',
          'created_at': tDateString,
        };

        // Act
        final result = UsersModel.fromJson(jsonMap);

        // Assert
        expect(result.nama, 'Budi Santoso');
      },
    );

    // Skenario 3: Nama menjadi '-' jika keduanya tidak ada
    test('harus mengembalikan nama "-" jika data nama kosong', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'warga_id': 101,
        // nama_lengkap tidak ada, warga tidak ada
        'role': 'Admin',
        'status_user': 'Aktif',
        'auth_id': 'auth-123',
        'created_at': tDateString,
      };

      // Act
      final result = UsersModel.fromJson(jsonMap);

      // Assert
      expect(result.nama, '-');
    });
  });

  // test fungsi toMap
  group('toMap', () {
    test('harus mengembalikan Map yang sesuai', () {
      // Act
      final result = tUsersModel.toMap();

      // Assert
      final expectedMap = {
        'id': 1,
        'warga_id': 101,
        'role': 'Admin',
        'nama_lengkap': 'Budi Santoso',
        'status_user': 'Aktif',
        'auth_id': 'auth-123',
        'created_at': tDateString, // toIso8601String
      };

      expect(result, expectedMap);
    });

    test('harus menyertakan ID jika forUpdate: true dan id tidak null', () {
      // Act
      final result = tUsersModel.toMap(forUpdate: true);

      // Assert
      expect(result['id'], 1);
    });
  });

  // test fungsi toMapForInsert
  group('toMapForInsert', () {
    test('harus menyertakan key "nama_lengkap"', () {
      // Act
      final result = tUsersModel.toMapForInsert();

      // Assert
      // Berbeda dengan toMap, method ini harusnya punya nama_lengkap
      expect(result['nama_lengkap'], 'Budi Santoso');
      expect(result['status_user'], 'Aktif');
    });
  });

  // test fungsi copyWith
  group('copyWith', () {
    test('harus mengembalikan object baru dengan data yang diubah', () {
      // Act
      final result = tUsersModel.copyWith(nama: 'Nama Baru', role: 'User');

      // Assert
      expect(result.nama, 'Nama Baru');
      expect(result.role, 'User');
      expect(result.id, tUsersModel.id); // Data lama tetap ada
      expect(result.authId, tUsersModel.authId); // Data lama tetap ada
    });
  });

  // test ubah ke Entity
  group('Entity Conversion', () {
    test('fromEntity harus mengembalikan Model yang valid', () {
      // Act
      final result = UsersModel.fromEntity(tUsersEntity);

      // Assert
      expect(result.id, tUsersModel.id);
      expect(result.nama, tUsersModel.nama);
    });

    test('toEntity harus mengembalikan Entity yang valid', () {
      // Act
      final result = tUsersModel.toEntity();

      // Assert
      expect(result, isA<Users>());
      expect(result.nama, 'Budi Santoso');
    });
  });
}
