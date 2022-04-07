import 'package:popcorn_time/utils/utils.dart';

class Show {
  String? id;
  ContentType type = ContentType.show;
  String? imdbId;
  int? tmdbId;
  String? title;
  String? year;
  String? slug;
  String? originalLanguage;
  int? numberOfSeasons;
  List<dynamic>? genres;
  double? rating;
  String? runtime;
  Map<String, dynamic>? images;
  String? image;
  String? cover;
  String? backdrop;
  String? poster;
  String? synopsis;
  String? defaultAudio;
  List<Season>? seasons;

  Show({
    this.id,
    this.imdbId,
    this.tmdbId,
    this.title,
    this.year,
    this.slug,
    this.originalLanguage,
    this.numberOfSeasons,
    this.genres,
    this.rating,
    this.runtime,
    this.images,
    this.image,
    this.cover,
    this.backdrop,
    this.poster,
    this.synopsis,
    this.defaultAudio,
    this.seasons,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    List<Season> seasons = [];

    if (json['episodes'] != null) {
      for (var i = 1; i <= json['num_seasons']; i++) {
        List<Episode> episodes = [];

        for (var episode in (json['episodes'] as List<dynamic>)) {
          if (episode['season'] == i) {
            episodes.add(Episode.fromJson(episode));
          }
        }

        episodes.sort((a, b) => a.number!.compareTo(b.number!));

        seasons.add(Season(i, episodes));
      }
    }

    return Show(
      id: json['_id'],
      imdbId: json['imdb_id'],
      tmdbId: json['tmdb_id'],
      title: json['title'],
      year: json['year'],
      slug: json['slug'],
      originalLanguage: json['original_language'],
      numberOfSeasons: json['num_seasons'],
      genres: json['genres'],
      rating: json['rating']['percentage'] / 10,
      runtime: json['runtime'],
      images: json['images'],
      image: json['images'] != null ? json['images']['poster'] : null,
      cover: json['images'] != null ? json['images']['poster'] : null,
      backdrop: json['images'] != null ? json['images']['fanart'] : null,
      poster: json['images'] != null ? json['images']['poster'] : null,
      synopsis: json['synopsis'],
      defaultAudio: json['contextLocale'],
      seasons: seasons.isNotEmpty ? seasons : null,
    );
  }
}

class Season {
  int? number;
  List<Episode> episodes = [];

  Season(this.number, [this.episodes = const <Episode>[]]);

  factory Season.fromJson(Map<String, dynamic> json) {
    List<Episode> episodes = [];

    if (json['episodes'] != null) {
      for (var episode in (json['episodes'] as List<dynamic>)) {
        episodes.add(Episode.fromJson(episode));
      }

      episodes.sort((a, b) => a.number!.compareTo(b.number!));
    }

    return Season(
      json['number'],
      episodes,
    );
  }
}

class Episode {
  int? tvdbId;
  int? number;
  int? firstAired;
  String? title;
  String? overview;
  bool? isWatched;
  Map<String, dynamic>? torrents;

  Episode({
    this.tvdbId,
    this.number,
    this.firstAired,
    this.title,
    this.overview,
    this.isWatched,
    this.torrents,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> torrents = Utils.sortTorrents(
        Map<String, dynamic>.from(json['torrents']), ContentType.show);

    return Episode(
      tvdbId: json['tvdb_id'],
      number: json['episode'],
      firstAired: json['first_aired'],
      title: json['title'],
      overview: json['overview'],
      isWatched: json['is_watched'],
      torrents: torrents,
    );
  }
}
