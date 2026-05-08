import 'package:get/get.dart';
import 'package:mini_chat/core/network/api_client.dart';
import 'package:mini_chat/data/auth/datasources/auth_local_datasource.dart';
import 'package:mini_chat/data/auth/datasources/auth_remote_datasource.dart';
import 'package:mini_chat/data/auth/repositories/auth_repository_impl.dart';
import 'package:mini_chat/domain/auth/repositories/auth_repository.dart';
import 'package:mini_chat/domain/auth/usecases/login_usecase.dart';
import 'package:mini_chat/features/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find()));

    // Controller
    Get.lazyPut(() => AuthController(loginUseCase: Get.find()));
  }
}
