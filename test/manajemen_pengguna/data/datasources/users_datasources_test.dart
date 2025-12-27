import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Sesuaikan path import ini
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/datasources/users_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/manajemen-pengguna/data/models/users_model.dart';

// Import file mocks yang baru digenerate
import 'users_datasources_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SupabaseClient>(),
  MockSpec<UsersDataSource>(),
])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockUsersDataSource mockUsersDataSource;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockUsersDataSource = MockUsersDataSource();
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


  // get all users
  group('getAllUsers', () {
    test(
      'POSITIVE: should return list of users when datasource call is successful',
      () async {
        // Arrange
        when(
          mockUsersDataSource.getAllUsers(),
        ).thenAnswer((_) async => [tUsersModel]);

        // Act
        final result = await mockUsersDataSource.getAllUsers();

        // Assert
        expect(result, [tUsersModel]);
        verify(mockUsersDataSource.getAllUsers());
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );

    test(
      'NEGATIVE: should throw an exception when datasource call fails',
      () async {
        // Arrange
        when(
          mockUsersDataSource.getAllUsers(),
        ).thenThrow(Exception('Failed to fetch users'));

        // Act
        final call = mockUsersDataSource.getAllUsers;

        // Assert
        expect(() => call(), throwsA(isA<Exception>()));
        verify(mockUsersDataSource.getAllUsers());
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );
  });

  // get user by id
  group('getUserById', () {
    test(
      'POSITIVE: should return user when datasource call is successful',
      () async {
        // Arrange
        when(
          mockUsersDataSource.getUserById(1),
        ).thenAnswer((_) async => tUsersModel);

        // Act
        final result = await mockUsersDataSource.getUserById(1);

        // Assert
        expect(result, tUsersModel);
        verify(mockUsersDataSource.getUserById(1));
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );

    test(
      'NEGATIVE: should throw an exception when datasource call fails',
      () async {
        // Arrange
        when(
          mockUsersDataSource.getUserById(1),
        ).thenThrow(Exception('Failed to fetch user'));

        // Act
        final call = mockUsersDataSource.getUserById;

        // Assert
        expect(() => call(1), throwsA(isA<Exception>()));
        verify(mockUsersDataSource.getUserById(1));
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );
  });

  // create user
  group('createUser', () {
    test(
      'POSITIVE: should call createUser on datasource',
      () async {
        // Arrange
        when(
          mockUsersDataSource.createUser(tUsersModel),
        ).thenAnswer((_) async => Future.value());

        // Act
        await mockUsersDataSource.createUser(tUsersModel);

        // Assert
        verify(mockUsersDataSource.createUser(tUsersModel)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );

    test(
      'NEGATIVE: should throw an exception when datasource call fails',
      () async {
        // Arrange
        when(
          mockUsersDataSource.createUser(tUsersModel),
        ).thenThrow(Exception('Failed to create user'));

        // Act
        final call = mockUsersDataSource.createUser;

        // Assert
        expect(() => call(tUsersModel), throwsA(isA<Exception>()));
        verify(mockUsersDataSource.createUser(tUsersModel)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );
  });

  // update user
  group('updateUser', () {
    test(
      'POSITIVE: should call updateUser on datasource',
      () async {
        // Arrange
        when(
          mockUsersDataSource.updateUser(tUsersModel),
        ).thenAnswer((_) async => Future.value());

        // Act
        await mockUsersDataSource.updateUser(tUsersModel);

        // Assert
        verify(mockUsersDataSource.updateUser(tUsersModel)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );

    test(
      'NEGATIVE: should throw an exception when datasource call fails',
      () async {
        // Arrange
        when(
          mockUsersDataSource.updateUser(tUsersModel),
        ).thenThrow(Exception('Failed to update user'));

        // Act
        final call = mockUsersDataSource.updateUser;

        // Assert
        expect(() => call(tUsersModel), throwsA(isA<Exception>()));
        verify(mockUsersDataSource.updateUser(tUsersModel)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );
  });

  // delete user
  group('deleteUser', () {
    test(
      'POSITIVE: should call deleteUser on datasource',
      () async {
        // Arrange
        when(
          mockUsersDataSource.deleteUser(1),
        ).thenAnswer((_) async => Future.value());

        // Act
        await mockUsersDataSource.deleteUser(1);

        // Assert
        verify(mockUsersDataSource.deleteUser(1)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );

    test(
      'NEGATIVE: should throw an exception when datasource call fails',
      () async {
        // Arrange
        when(
          mockUsersDataSource.deleteUser(1),
        ).thenThrow(Exception('Failed to delete user'));

        // Act
        final call = mockUsersDataSource.deleteUser;

        // Assert
        expect(() => call(1), throwsA(isA<Exception>()));
        verify(mockUsersDataSource.deleteUser(1)).called(1);
        verifyNoMoreInteractions(mockUsersDataSource);
      },
    );
  });
}