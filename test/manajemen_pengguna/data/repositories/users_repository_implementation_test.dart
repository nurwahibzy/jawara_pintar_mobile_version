import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/datasources/users_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/models/users_model.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/repositories/users_repository_implementation.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/domain/entities/users.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'users_repository_implementation_test.mocks.dart';

@GenerateMocks([UsersDataSource, SupabaseClient])
void main() {
  late UsersRepositoryImplementation repository;
  late MockUsersDataSource mockRemoteDataSource;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() {
    mockRemoteDataSource = MockUsersDataSource();
    mockSupabaseClient = MockSupabaseClient();
    repository = UsersRepositoryImplementation(
      mockRemoteDataSource,
      mockSupabaseClient,
    );
  });

  final tUsersModel = UsersModel(
    id: 1,
    wargaId: 10,
    nama: 'Budi',
    role: 'User',
    status: 'Aktif',
    authId: 'auth-123',
    createdAt: DateTime(2023, 1, 1),
  );

  final tUsers = Users(
    id: 1,
    wargaId: 10,
    nama: 'Budi',
    role: 'User',
    status: 'Aktif',
    authId: 'auth-123',
    createdAt: DateTime(2023, 1, 1),
  );

  // get all users
  group('getAllUsers', () {
    test(
      'POSITIVE: should return right list of users when datasource succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllUsers(),
        ).thenAnswer((_) async => [tUsersModel]);

        // Act
        final result = await repository.getAllUsers();

        // Assert
        verify(mockRemoteDataSource.getAllUsers()).called(1);
        expect(result, isA<Right<Failure, List<Users>>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (usersList) => expect(usersList.length, 1),
        );
      },
    );

    test(
      'NEGATIVE: should throw left failure when datasource throws error',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllUsers(),
        ).thenThrow(Exception('DB Error'));
        // Act
        final result = await repository.getAllUsers();
        // Assert
        verify(mockRemoteDataSource.getAllUsers()).called(1);
        expect(result, isA<Left<Failure, List<Users>>>());
      },
    );
  });

  // get user by id
  group('getUserById', () {
    test(
      'POSITIVE: should return right user when datasource succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getUserById(1),
        ).thenAnswer((_) async => tUsersModel);

        // Act
        final result = await repository.getUserById(1);

        // Assert
        verify(mockRemoteDataSource.getUserById(1)).called(1);
        result.fold(
          (failure) => fail('Should not return failure'),
          (users) => expect(users.id, tUsers.id),
        );
      },
    );

    test('NEGATIVE: should throw left failure when datasource fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getUserById(1),
      ).thenThrow(Exception('DB Error'));
      // Act
      final result = await repository.getUserById(1);
      // Assert
      verify(mockRemoteDataSource.getUserById(1)).called(1);
      expect(result, isA<Left<Failure, Users>>());
    });
  });

  // create user
  group('createUser', () {
    test('POSITIVE: should call createUser on datasource', () async {
      // Arrange
      when(
        mockRemoteDataSource.createUser(tUsersModel),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.createUser(tUsers);

      // Assert
      verify(mockRemoteDataSource.createUser(tUsersModel)).called(1);
    });

    test('NEGATIVE: should return failure when datasource fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.createUser(tUsersModel),
      ).thenThrow(Exception('DB Error'));

      // Act
      final result = await repository.createUser(tUsers);

      // Assert
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  // update user
  group('updateUser', () {
    test('POSITIVE: should call updateUser on datasource', () async {
      // Arrange
      when(
        mockRemoteDataSource.updateUser(tUsersModel),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.updateUser(tUsers);

      // Assert
      verify(mockRemoteDataSource.updateUser(tUsersModel)).called(1);
    });

    test('NEGATIVE: should return failure when datasource fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.updateUser(tUsersModel),
      ).thenThrow(Exception('DB Error'));

      // Act
      final result = await repository.updateUser(tUsers);

      // Assert
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  // delete user
  group('deleteUser', () {
    test('POSITIVE: should call deleteUser on datasource', () async {
      // Arrange
      when(
        mockRemoteDataSource.deleteUser(1),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.deleteUser(1);

      // Assert
      verify(mockRemoteDataSource.deleteUser(1)).called(1);
    });

    test('NEGATIVE: should return failure when datasource fails', () async {
      // Arrange
      when(mockRemoteDataSource.deleteUser(1)).thenThrow(Exception('DB Error'));

      // Act
      final result = await repository.deleteUser(1);

      // Assert
      expect(result, isA<Left<Failure, bool>>());
    });
  });
}
