import 'dart:collection';

class Movie {
  late String id;
  String type = "movie";
  late String imdbId;
  late int tmdbId;
  late String title;
  late String year;
  late List<dynamic> genres;
  late double rating;
  late String runtime;
  late Map<String, dynamic> images;
  String? image;
  String? cover;
  String? backdrop;
  String? poster;
  late String synopsis;
  String? trailer;
  late String certification;
  late Map<String, dynamic> torrents;
  late Map<String, dynamic> langs;
  late String defaultAudio;
  String? locale;

  Movie({
    required this.id,
    required this.imdbId,
    required this.tmdbId,
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
    required this.runtime,
    required this.images,
    this.image,
    this.cover,
    this.backdrop,
    this.poster,
    required this.synopsis,
    this.trailer,
    required this.certification,
    required this.torrents,
    required this.defaultAudio,
    this.locale,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> torrents =
        sortTorrents(Map<String, dynamic>.from(json['torrents']));

    return Movie(
      id: json['_id'],
      imdbId: json['imdb_id'],
      tmdbId: json['tmdb_id'],
      title: json['title'],
      year: json['year'],
      genres: json['genres'],
      rating: json['rating']['percentage'] / 10,
      runtime: json['runtime'],
      images: json['images'],
      image: json['images'] != null ? json['images']['poster'] : null,
      cover: json['images'] != null ? json['images']['poster'] : null,
      backdrop: json['images'] != null ? json['images']['fanart'] : null,
      poster: json['images'] != null ? json['images']['poster'] : null,
      synopsis: json['synopsis'],
      trailer: json['trailer'],
      certification: json['certification'],
      torrents: torrents,
      defaultAudio: json['contextLocale'],
      locale: json['locale'],
    );
  }

  static Map<String, dynamic> sortTorrents(Map<String, dynamic> torrents) {
    torrents.forEach((key, value) {
      torrents[key] = SplayTreeMap<String, dynamic>.from(value, (a, b) {
        var regex = RegExp(r'[a-zA-Z]');
        return int.parse(a.replaceAll(regex, ''))
            .compareTo(int.parse(b.replaceAll(regex, '')));
      });
    });

    return torrents;
  }
}
