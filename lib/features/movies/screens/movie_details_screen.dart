import 'package:flutter/material.dart';
import 'package:popcorn_time/components/health.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/components/config_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/movies_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String id;

  const MovieDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailsScreen> {
  MoviesService moviesService = MoviesService();
  late Future<Movie> futureMovie;
  int subtitleIndex = 0;
  int audioIndex = 0;
  int qualityIndex = 0;

  @override
  void initState() {
    super.initState();
    futureMovie = moviesService.getMovieById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: futureMovie,
      builder: (context, snapshot) {
        Movie? movie = snapshot.data;

        if (movie != null) {
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
              onPressed: () {},
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          snapshot.data!.title,
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
                        child: Text(
                          '${movie.year}  •  ${movie.runtime} min  •  ${movie.certification}  •  ${movie.genres.join(' / ')}  •  ${movie.rating} ★',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
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
                      ListTile(
                        title: const Text(
                          'Watch Trailer',
                        ),
                        leading: const Icon(Icons.play_circle_filled_rounded),
                        onTap: () async {
                          if (await canLaunch(movie.trailer!)) {
                            await launch(movie.trailer!);
                          } else {
                            throw 'Could not launch ${movie.trailer}';
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          subtitleIndex == 0 ? 'No Subtitles' : 'Subtitles',
                        ),
                        leading: Icon(subtitleIndex == 0
                            ? Icons.closed_caption_disabled_rounded
                            : Icons.closed_caption_rounded),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          movie.torrents.keys.toList()[audioIndex],
                        ),
                        leading: const Icon(Icons.volume_up_rounded),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfigDialog(
                                  title: 'Audio',
                                  content: movie.torrents.keys.toList(),
                                  onSelect: (int index) {
                                    setState(() {
                                      audioIndex = index;
                                    });
                                  },
                                  selectedIndex: audioIndex,
                                );
                              });
                        },
                      ),
                      ListTile(
                        title: Text(
                          movie
                              .torrents[
                                  movie.torrents.keys.toList()[audioIndex]]
                              .keys
                              .toList()[qualityIndex],
                        ),
                        leading: const Icon(Icons.high_quality_rounded),
                        trailing: Health(
                          seeds: movie
                              .torrents[
                                  movie.torrents.keys.toList()[audioIndex]]
                              .values
                              .toList()[qualityIndex]['seeds'],
                          peers: movie
                              .torrents[
                                  movie.torrents.keys.toList()[audioIndex]]
                              .values
                              .toList()[qualityIndex]['peers'],
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfigDialog(
                                  title: 'Quality',
                                  content: movie
                                      .torrents[movie.torrents.keys
                                          .toList()[audioIndex]]
                                      .keys
                                      .toList(),
                                  onSelect: (int index) {
                                    setState(() {
                                      qualityIndex = index;
                                    });
                                  },
                                  selectedIndex: qualityIndex,
                                );
                              });
                        },
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
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
