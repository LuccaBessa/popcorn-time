class Show {
  String? id;
  String type = 'show';
  String? imdbId;
  int? tmdbId;
  String? title;
  String? year;
  List<dynamic>? genres;
  double? rating;
  String? runtime;
  Map<String, dynamic>? images;
  String? image;
  String? cover;
  String? backdrop;
  String? poster;
  String? synopsis;
  String? trailer;
  String? certification;
  Map<String, dynamic>? torrents;
  Map<String, dynamic>? langs;
  String? defaultAudio;
  String? locale;

  Show({
    this.id,
    this.imdbId,
    this.tmdbId,
    this.title,
    this.year,
    this.genres,
    this.rating,
    this.runtime,
    this.images,
    this.image,
    this.cover,
    this.backdrop,
    this.poster,
    this.synopsis,
    this.trailer,
    this.certification,
    this.defaultAudio,
    this.locale,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
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
      defaultAudio: json['contextLocale'],
      locale: json['locale'],
    );
  }
}
