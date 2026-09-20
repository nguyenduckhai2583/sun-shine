import 'package:dio/dio.dart';

/// Builds the `Dio` instances the app talks to the API through.
///
/// Each call returns a brand new instance. The sign-in flow depends on that:
/// its Dio must never share headers with the active account's.
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
