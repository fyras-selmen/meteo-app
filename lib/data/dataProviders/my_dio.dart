import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
  validateStatus: (_) {
    return true;
  },
));

void configureDio() {
  dio.options.baseUrl = 'https://api.open-meteo.com/v1';

  dio.options.contentType = "application/json";
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
}

final dio1 = Dio(BaseOptions(
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
  validateStatus: (_) {
    return true;
  },
));

void configureDio2() {
  dio1.options.baseUrl = 'https://geocoding-api.open-meteo.com/v1';

  dio1.options.contentType = "application/json";
  dio1.options.connectTimeout = const Duration(seconds: 10);
  dio1.options.receiveTimeout = const Duration(seconds: 10);
}
