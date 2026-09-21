import 'package:dio/dio.dart';

abstract final class DioFactory {
  static Dio create({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.addAll(interceptors);
    return dio;
  }
}
