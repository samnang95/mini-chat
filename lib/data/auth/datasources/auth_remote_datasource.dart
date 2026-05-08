import 'package:mini_chat/core/network/api_client.dart';
import 'package:mini_chat/core/network/api_endpoints.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }
}
