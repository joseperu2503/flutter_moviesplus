import 'package:moviesplus/config/api/api.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';
import 'package:moviesplus/features/movie/models/movie_credits.dart';
import 'package:moviesplus/features/movie/models/movie_detail.dart';

class MovieDbService {
  static Future<MoviesResponse> getMovies({
    int page = 1,
    required String path,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };

    try {
      final response = await Api.get(
        path,
        queryParameters: queryParameters,
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
}
