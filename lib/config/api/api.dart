import 'package:dio/dio.dart';
import 'package:moviesplus/config/constants/environment.dart';
import 'package:moviesplus/features/profile/models/country.dart';
import 'package:moviesplus/features/profile/models/language.dart';
import 'package:moviesplus/features/profile/services/profile_service.dart';

class Api {
  static final Dio _dioBase = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
  ));

  static Future<Response> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final movieApiKey = Environment.movieApiKey;
    final Language language = await ProfileService.getLanguage();
    final Country country = await ProfileService.getCountry();

    return _dioBase.get(path, queryParameters: {
      'api_key': movieApiKey,
      'language': language.iso6391,
      'region': country.iso31661,
      ...queryParameters,
    });
  }

  static Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data);
  }
}
