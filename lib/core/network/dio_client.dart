import 'package:dio/dio.dart';

class DioClient {
  DioClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 8),
              headers: const {'accept': 'application/json'},
            ),
          );

  final Dio dio;
}
