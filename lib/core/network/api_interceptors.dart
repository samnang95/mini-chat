import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ REQUEST: ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      debugPrint('│ Headers: ${options.headers}');
    }
    if (options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    debugPrint('└──────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ RESPONSE [${response.statusCode}]: ${response.requestOptions.uri}');
    debugPrint('│ Data: ${response.data}');
    debugPrint('└──────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ ERROR [${err.response?.statusCode}]: ${err.requestOptions.uri}');
    debugPrint('│ Message: ${err.message}');
    debugPrint('└──────────────────────────────────────────');
    handler.next(err);
  }
}

class AuthInterceptor extends Interceptor {
  // Inject your token storage here
  // final AuthLocalDataSource _authLocalDataSource;
  // AuthInterceptor(this._authLocalDataSource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final token = _authLocalDataSource.getCachedToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token refresh or logout
      // Example: Get.offAllNamed(AppRoutes.login);
    }
    handler.next(err);
  }
}
