import 'package:dio/dio.dart';
import 'package:mini_chat/core/error/exceptions.dart';

/// A standardized API response wrapper.
/// All API responses are expected to have this shape:
/// { "status": true, "message": "...", "data": { ... } }
class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });
}

/// Centralized Dio wrapper that handles all HTTP operations
/// and provides consistent error handling.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // ── GET ────────────────────────────────────────────────
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── POST ───────────────────────────────────────────────
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── PUT ────────────────────────────────────────────────
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── DELETE ─────────────────────────────────────────────
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Error Mapping ──────────────────────────────────────
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timed out');

      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message = 'Something went wrong';
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          message = data['message'] as String;
        }

        return ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Invalid certificate');

      case DioExceptionType.unknown:
      return const ServerException(message: 'An unexpected error occurred');
    }
  }
}
