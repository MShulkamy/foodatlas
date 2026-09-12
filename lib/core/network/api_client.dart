import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around [Dio] configured for the fake API (dummyjson.com).
class ApiClient {
  ApiClient() : dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  final Dio dio;

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return dio.get(path, queryParameters: query);
  }
}

/// Generic failure wrapper thrown by data sources / repositories.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  factory ApiException.fromDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('انتهت مهلة الاتصال، حاول مرة أخرى');
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException('تحقق من اتصالك بالإنترنت');
    }
    return ApiException('حدث خطأ أثناء تحميل البيانات');
  }

  @override
  String toString() => message;
}
