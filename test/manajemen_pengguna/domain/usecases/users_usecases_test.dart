import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/entities/users.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/repositories/users_repository.dart';

import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/usecases/delete_user.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/usecases/get_all_users.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/usecases/get_user.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/usecases/get_warga_list.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/usecases/update_user.dart';

// memanggil generator mockito lalu mengimport file mocks yang telah digenerate
@GenerateMocks([UsersRepository])
import 'users_usecases_test.mocks.dart';

void main() {
  // deklarasi variabel use case dan mock repository
  late MockUsersRepository mockRepository;

  late DeleteUser deleteUser;
  late GetAllUsers getAllUsers;
  late GetUserById getUserById;
  late UpdateUser updateUser;
  late GetWargaList getWargaList;

  // setup sebelum menjalankan setiap test
  setUp(() {
    mockRepository = MockUsersRepository();

    // Inisialisasi semua use case dengan mock repository yang sama
    deleteUser = DeleteUser(mockRepository);
    getAllUsers = GetAllUsers(mockRepository);
    getUserById = GetUserById(mockRepository);
    updateUser = UpdateUser(mockRepository);
    getWargaList = GetWargaList(mockRepository);
  });

  // data dummy
  final tId = 1;
  final tUser = Users(
    id: 1,
    wargaId: 101,
    nama: 'Budi',
    role: 'Admin',
    status: 'Aktif',
    authId: 'auth-123',
    createdAt: DateTime(2023, 1, 1),
  );
  final tUsersList = [tUser];

  // deleteUser
  group('DeleteUser UseCase', () {
    test('harus memanggil repository.deleteUser', () async {
      // Arrange
      when(
        mockRepository.deleteUser(tId),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await deleteUser(tId);

      // Assert
      expect(result, const Right(true));
      verify(mockRepository.deleteUser(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  // getAllUsers
  group('GetAllUsers UseCase', () {
    test('harus mengembalikan List<Users> dari repository', () async {
      // Arrange
      when(
        mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Right(tUsersList));

      // Act
      final result = await getAllUsers();

      // Assert
      expect(result, Right(tUsersList));
      verify(mockRepository.getAllUsers()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  // getUserById
  group('GetUserById UseCase', () {
    test('harus mengembalikan single User dari repository', () async {
      // Arrange
      when(
        mockRepository.getUserById(tId),
      ).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await getUserById(tId);

      // Assert
      expect(result, Right(tUser));
      verify(mockRepository.getUserById(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  // updateUser
  group('UpdateUser UseCase', () {
    test('harus memanggil repository.updateUser', () async {
      // Arrange
      when(
        mockRepository.updateUser(tUser),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await updateUser(tUser);

      // Assert
      expect(result, const Right(true));
      verify(mockRepository.updateUser(tUser)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  // getWargaList
  group('GetWargaList UseCase', () {
    final tWargaListMap = [
      {'id': 1, 'nama': 'Warga 1'},
    ];

    test('harus mengembalikan List<Map> dari repository', () async {
      // Arrange
      when(
        mockRepository.getWargaList(),
      ).thenAnswer((_) async => tWargaListMap);

      // Act
      final result = await getWargaList.execute();

      // Assert
      expect(result, tWargaListMap);
      verify(mockRepository.getWargaList()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
