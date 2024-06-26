import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi/core/errors/exceptions.dart';
import 'package:mochi/core/errors/failure.dart';
import 'package:mochi/src/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mochi/src/auth/data/models/user_model.dart';
import 'package:mochi/src/auth/data/repositories/auth_repo_implementation.dart';
import 'package:mochi/src/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImplementation(remoteDataSource);
  });

  const tException =
      ApiException(message: 'Unknown Error Occurred', statusCode: 500);

  group('createUser', () {
    const createdAt = 'mock.createdAt';
    const name = 'mock.name';
    const avatar = 'mock.avatar';

    test(
        'should call [RemoteDataSource.createUser] and complete successfully '
        'when the call is successful', () async {
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      expect(result, equals(const Right<Failure, void>(null)));
      verify(
        () => remoteDataSource.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [ApiFailure] when the call to the remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenThrow(tException);

      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      expect(
        result,
        equals(
          Left<Failure, void>(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
        'should call [RemoteDataSource.getUsers] and return [List<User>] '
        'when call to remote source is successful', () async {
      const expecteedUsers = [UserModel.empty()];
      when(
        () => remoteDataSource.getUsers(),
      ).thenAnswer((_) async => expecteedUsers);

      final result = await repoImpl.getUsers();

      // lists are difficult to equate
      // they don't have value equality
      expect(result, isA<Right<Failure, List<User>>>());
      verify(
        () => remoteDataSource.getUsers(),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [ApiFailure] when the call to the remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSource.getUsers(),
      ).thenThrow(tException);

      final result = await repoImpl.getUsers();

      expect(
        result,
        equals(
          Left<Failure, void>(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.getUsers(),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
