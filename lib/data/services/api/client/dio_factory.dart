import 'package:dio/dio.dart';
import 'package:sun_shine/core.dart';

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
    // First in the chain, so the request line lands before anything else
    // touches it; headers added later are read back off the response.
    dio.interceptors.add(ApiLogInterceptor());
    dio.interceptors.addAll(interceptors);
    return dio;
  }
}
