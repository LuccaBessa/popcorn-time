import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popcorn_time/components/details_list.dart';
import 'package:popcorn_time/components/select_audio.dart';
import 'package:popcorn_time/components/select_quality.dart';
import 'package:popcorn_time/components/select_subtitles.dart';
import 'package:popcorn_time/components/watch_trailer.dart';
import 'package:popcorn_time/features/movies/services/movies_service.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsLargeScreen extends StatefulWidget {
  final String id;

  const MovieDetailsLargeScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailLargeScreenState createState() => _MovieDetailLargeScreenState();
}

class _MovieDetailLargeScreenState extends State<MovieDetailsLargeScreen> {
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
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
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
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movie.backdrop!),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          movie.poster!,
                          height: MediaQuery.of(context).size.height * 0.7,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                          },
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                Text(
                                  snapshot.data!.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 12),
                                DetailsList(
                                  year: movie.year,
                                  runtime: movie.runtime,
                                  certification: movie.certification,
                                  genres: movie.genres,
                                  rating: movie.rating,
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  movie.synopsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 18),
                                WatchTrailer(
                                  url: movie.trailer!,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                SelectSubtitles(
                                  subtitle: subtitle,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                SelectQuality(
                                  quality: quality,
                                  qualitiesList: movie
                                      .torrents[audio['value']].keys
                                      .toList(),
                                  onSelect: (index, value) {
                                    setState(() {
                                      quality['index'] = index;
                                      quality['value'] = value;
                                      url = movie.torrents[audio['value']]
                                          [quality['value']]['url'];
                                    });
                                  },
                                  seed: movie.torrents[audio['value']]
                                      [quality['value']]['seed'],
                                  peer: movie.torrents[audio['value']]
                                      [quality['value']]['peer'],
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  hasCloseHealth: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
