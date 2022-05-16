import 'package:flutter/material.dart';
import 'package:popcorn_time/components/details_list.dart';
import 'package:popcorn_time/components/select_audio.dart';
import 'package:popcorn_time/components/select_quality.dart';
import 'package:popcorn_time/components/select_subtitles.dart';
import 'package:popcorn_time/components/watch_trailer.dart';
import 'package:popcorn_time/features/movies/services/movies_service.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String id;

  const MovieDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailsScreen> {
  MoviesService moviesService = MoviesService();
  late Future<Movie> futureMovie;
  Map subtitle = {
    'index': 0,
    'value': '',
  };
  Map audio = {
    'index': 0,
    'value': '',
  };
  Map quality = {
    'index': 0,
    'value': '',
  };
  String url = '';

  @override
  void initState() {
    super.initState();
    futureMovie = moviesService.getMovieById(widget.id);
  }

  void onPressFloatingActionButton() async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw ErrorDescription('Could not launch $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Could not find Torrent App',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: futureMovie,
      builder: (context, snapshot) {
        Movie? movie = snapshot.data;

        if (movie != null) {
          audio['value'] = movie.torrents.keys.toList()[audio['index']];
          quality['value'] =
              movie.torrents[audio['value']].keys.toList()[quality['index']];
          url = movie.torrents[audio['value']][quality['value']]['url'];

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.favorite_outline_rounded,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: onPressFloatingActionButton,
              child: const Icon(Icons.play_arrow),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            body: OrientationBuilder(
              builder: (context, orientation) {
                return Image.network(
                  orientation == Orientation.portrait
                      ? movie.poster!
                      : movie.backdrop!,
                  fit: orientation == Orientation.portrait
                      ? BoxFit.fitWidth
                      : BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                  },
                );
              },
            ),
            bottomSheet: BottomSheet(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.45,
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DetailsList(
                          year: movie.year,
                          runtime: movie.runtime,
                          certification: movie.certification,
                          genres: movie.genres,
                          rating: movie.rating,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          movie.synopsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 18),
                      WatchTrailer(
                        url: movie.trailer!,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SelectSubtitles(
                        subtitle: subtitle,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SelectAudio(
                        audio: audio,
                        audioList: movie.torrents.keys.toList(),
                        onSelect: (index, value) {
                          setState(() {
                            audio['index'] = index;
                            audio['value'] = value;
                          });
                        },
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SelectQuality(
                        quality: quality,
                        qualitiesList:
                            movie.torrents[audio['value']].keys.toList(),
                        onSelect: (index, value) {
                          setState(() {
                            quality['index'] = index;
                            quality['value'] = value;
                            url = movie.torrents[audio['value']]
                                [quality['value']]['url'];
                          });
                        },
                        seed: movie.torrents[audio['value']][quality['value']]
                            ['seed'],
                        peer: movie.torrents[audio['value']][quality['value']]
                            ['peer'],
                        color: Theme.of(context).colorScheme.onSurface,
                        hasCloseHealth: false,
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
