import 'package:popcorn_time/models/show_model.dart';
import 'package:uno/uno.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShowsService {
  final uno = Uno(
    baseURL: dotenv.env['BASE_URL']!,
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Linux) AppleWebkit/534.30 (KHTML, like Gecko) PT/4.4.0',
      'Access-Control-Allow-Origin': '*'
    },
  );

  Future<List<Show>> getShowsByPage({int page = 1, int pageSize = 30}) async {
    List<Show> shows = [];

    await uno.get(
      '/shows/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
      },
    ).then((response) {
      response.data.forEach((show) {
        if (show['torrents'] != null && show['torrents'].isNotEmpty) {
          shows.add(Show.fromJson(show));
        }
      });
    });

    return shows;
  }

  Future<List<Show>> getShowsByKeywords(
      {int page = 1, int pageSize = 30, required String keywords}) async {
    List<Show> shows = [];

    await uno.get(
      '/shows/$page',
      params: {
        'sort': 'trending',
        'limit': pageSize.toString(),
        'keywords': keywords,
      },
    ).then((response) {
      response.data.forEach((show) {
        if (show['torrents'] != null && show['torrents'].isNotEmpty) {
          shows.add(Show.fromJson(show));
        }
      });
    });

    return shows;
  }

  Future<Show> getShowById(String id) async {
    late Show show;

    await uno.get('/show/$id').then((response) {
      show = Show.fromJson(response.data);
    });

    return show;
  }
}
