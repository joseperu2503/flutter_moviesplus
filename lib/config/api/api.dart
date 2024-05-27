import 'package:dio/dio.dart';
import 'package:moviesplus/config/constants/environment.dart';

class Api {
  static final Dio _dioBase = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
  ));

  static Future<Response> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final movieApiKey = Environment.movieApiKey;

    return _dioBase.get(path, queryParameters: {
      ...queryParameters,
      'api_key': movieApiKey,
      'language': 'es-MX'
    });
  }

  static Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data);
  }
}
