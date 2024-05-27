import 'package:moviesplus/config/api/api.dart';
import 'package:moviesplus/features/dashboard/models/movies_response.dart';

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
}
