import 'package:mini_chat/domain/auth/entities/user_entity.dart';

/// Abstract contract for auth operations.
/// The data layer provides the concrete implementation.
abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();
}
