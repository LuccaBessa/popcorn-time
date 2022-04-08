import 'package:popcorn_time/models/anime_model.dart';
import 'package:uno/uno.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimesService {
  final uno = Uno(
    baseURL: dotenv.env['BASE_URL']!,
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Linux) AppleWebkit/534.30 (KHTML, like Gecko) PT/4.4.0',
      'Access-Control-Allow-Origin': '*'
    },
  );

  Future<List<Anime>> getAnimesByPage({int page = 1, int pageSize = 30}) async {
    List<Anime> animes = [];

    await uno.get(
      '/animes/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
      },
    ).then((response) {
      response.data.forEach((movie) {
        if (movie['torrents'] != null) {
          animes.add(Anime.fromJson(movie));
        }
      });
    });

    return animes;
  }

  Future<List<Anime>> getAnimesByKeywords({
    int page = 1,
    int pageSize = 30,
    required String keywords,
  }) async {
    List<Anime> animes = [];

    await uno.get(
      '/animes/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
        'keywords': keywords.trim(),
      },
    ).then((response) {
      response.data.forEach((movie) {
        if (movie['torrents'] != null) {
          animes.add(Anime.fromJson(movie));
        }
      });
    });

    return animes;
  }

  Future<Anime> getAnimesById(String id) async {
    late Anime animes;

    await uno.get('/anime/$id').then((response) {
      animes = Anime.fromJson(response.data);
    });

    return animes;
  }
}
