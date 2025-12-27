import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/entities/users.dart';

void main() {
  // tanggal dummy untuk createdAt
  final tDate = DateTime(2023, 1, 1);

  final tUser = Users(
    id: 1,
    wargaId: 101,
    nama: 'Budi Santoso',
    role: 'Warga',
    status: 'Aktif',
    authId: 'auth-uuid-123',
    createdAt: tDate,
  );

  group('Users Entity', () {
    // memastikan inheritance dari Equatable
    test('harus merupakan turunan dari Equatable', () {
      expect(tUser, isA<Equatable>());
    });

    // memastikan value comparison berfungsi
    test(
      'mendukung value comparison (dua objek dengan data yang sama dianggap sama)',
      () {
        // Arrange
        final tUserDuplicate = Users(
          id: 1,
          wargaId: 101,
          nama: 'Budi Santoso',
          role: 'Warga',
          status: 'Aktif',
          authId: 'auth-uuid-123',
          createdAt: tDate,
        );

        // Assert
        // Berkat Equatable, ini akan bernilai True meskipun instance memorinya berbeda
        expect(tUser, equals(tUserDuplicate));
      },
    );

    test('dua objek dengan data berbeda dianggap tidak sama', () {
      // Arrange
      final tUserDifferent = Users(
        id: 2, // ID berbeda
        wargaId: 101,
        nama: 'Budi Santoso',
        role: 'Warga',
        status: 'Aktif',
        authId: 'auth-uuid-123',
        createdAt: tDate,
      );

      // Assert
      expect(tUser, isNot(equals(tUserDifferent)));
    });

    // test fungsi copyWith
    group('copyWith', () {
      test('harus mengembalikan objek baru dengan field yang diubah melalui parameter', () {
        // Act
        // Kita ubah nama dan role saja
        final result = tUser.copyWith(nama: 'Nama Baru', role: 'Admin');

        // Assert
        // Cek field yang diubah
        expect(result.nama, 'Nama Baru');
        expect(result.role, 'Admin');

        // Cek field yang tidak diubah (harus sama dengan tUser awal)
        expect(result.id, tUser.id);
        expect(result.wargaId, tUser.wargaId);
        expect(result.status, tUser.status);
        expect(result.authId, tUser.authId);
        expect(result.createdAt, tUser.createdAt);
      });

      test(
        'harus mengembalikan objek yang sama persis jika tidak ada parameter yang diisi',
        () {
          // Act
          final result = tUser.copyWith();

          // Assert
          // Karena Equatable, result harus equals dengan tUser
          expect(result, equals(tUser));

          // Opsional: Pastikan instance-nya baru tapi isinya sama
          // (Equatable membuat == true, tapi identical() akan false)
          expect(identical(result, tUser), false);
        },
      );

      test(
        'harus bisa mengubah ID (termasuk menjadi null)',
        () {
          // catatan: meskipun id nullable, di copyWith kita tidak mengirim null secara eksplisit (akan error)

          // Act
          final result = tUser.copyWith(id: 999);

          // Assert
          expect(result.id, 999);
        },
      );
    });

    // test properti props
    test('props harus berisi semua field yang benar untuk perbandingan', () {
      // Assert
      final expectedProps = [
        1, // id
        101, // wargaId
        'Budi Santoso', // nama
        'Warga', // role
        'Aktif', // status
        'auth-uuid-123', // authId
        tDate, // createdAt
      ];

      expect(tUser.props, expectedProps);
    });
  });
}
