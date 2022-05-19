import 'package:popcorn_time/models/movie_model.dart';
import 'package:uno/uno.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoviesService {
  final uno = Uno(
    baseURL: dotenv.env['BASE_URL']!,
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Linux) AppleWebkit/534.30 (KHTML, like Gecko) PT/4.4.0',
      'Access-Control-Allow-Origin': '*'
    },
  );

  Future<List<Movie>> getMoviesByPage({int page = 1, int pageSize = 30}) async {
    List<Movie> movies = [];

    await uno.get(
      '/movies/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
      },
    ).then((response) {
      response.data.forEach((movie) {
        if (movie['torrents'] != null && movie['torrents'].isNotEmpty) {
          movies.add(Movie.fromJson(movie));
        }
      });
    });

    return movies;
  }

  Future<List<Movie>> getMoviesByKeywords({
    int page = 1,
    int pageSize = 30,
    required String keywords,
  }) async {
    List<Movie> movies = [];

    await uno.get(
      '/movies/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
        'keywords': keywords.trim(),
      },
    ).then((response) {
      response.data.forEach((movie) {
        if (movie['torrents'] != null && movie['torrents'].isNotEmpty) {
          movies.add(Movie.fromJson(movie));
        }
      });
    });

    return movies;
  }

  Future<Movie> getMovieById(String id) async {
    late Movie movie;

    await uno.get('/movie/$id').then((response) {
      movie = Movie.fromJson(response.data);
    });

    return movie;
  }
}
