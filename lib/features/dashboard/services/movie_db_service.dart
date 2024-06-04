import 'package:moviesplus/config/api/api.dart';
import 'package:moviesplus/features/dashboard/models/genre.dart';
import 'package:moviesplus/features/dashboard/models/genres_response.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';
import 'package:moviesplus/features/profile/models/country.dart';
import 'package:moviesplus/features/profile/models/language.dart';

class MovieDbService {
  static Future<MoviesResponse> getMovies({
    int page = 1,
    required String path,
    Map<String, dynamic> queryParameters = const {},
  }) async {
    Map<String, dynamic> query = {
      "page": page,
      ...queryParameters,
    };

    try {
      final response = await Api.get(
        path,
        queryParameters: query,
      );

      return MoviesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<MovieDetail> getMovieDetail({
    required int id,
  }) async {
    try {
      final response = await Api.get(
        '/movie/$id',
      );

      return MovieDetail.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<MovieCredits> getMovieCredits({
    required int id,
  }) async {
    try {
      final response = await Api.get(
        '/movie/$id/credits',
      );

      return MovieCredits.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Genre>> getMovieGenres() async {
    try {
      final response = await Api.get(
        '/genre/movie/list',
      );

      return GenresResponse.fromJson(response.data).genres;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Genre>> getTvGenres() async {
    try {
      final response = await Api.get(
        '/genre/tv/list',
      );

      return GenresResponse.fromJson(response.data).genres;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Country>> getCountries() async {
    try {
      final response = await Api.get(
        '/configuration/countries',
      );

      return List<Country>.from(response.data.map((x) => Country.fromJson(x)));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Language>> getLanguages() async {
    try {
      final response = await Api.get(
        '/configuration/languages',
      );

      return List<Language>.from(
          response.data.map((x) => Language.fromJson(x)));
    } catch (e) {
      throw Exception(e);
    }
  }
}
