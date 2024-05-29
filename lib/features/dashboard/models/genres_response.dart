import 'package:moviesplus/features/dashboard/models/genre.dart';

class GenresResponse {
  final List<Genre> genres;

  GenresResponse({
    required this.genres,
  });

  factory GenresResponse.fromJson(Map<String, dynamic> json) => GenresResponse(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}
