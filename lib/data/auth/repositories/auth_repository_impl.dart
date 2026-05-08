import 'package:mini_chat/data/auth/datasources/auth_local_datasource.dart';
import 'package:mini_chat/data/auth/datasources/auth_remote_datasource.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';
import 'package:mini_chat/domain/auth/entities/user_entity.dart';
import 'package:mini_chat/domain/auth/repositories/auth_repository.dart';
import 'package:mini_chat/core/error/exceptions.dart';
import 'package:mini_chat/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      // Cache the token for future authenticated requests
      if (user.token != null) {
        await localDataSource.cacheToken(user.token!);
      }
      return user;
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return user;
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearToken();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } on CacheException {
      return false;
    }
  }
}
