import 'package:flutter/material.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/components/config_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/details_list.dart';
import '../../../components/health.dart';
import '../services/movies_service.dart';

class MovieDetailsBigScreen extends StatefulWidget {
  final String id;

  const MovieDetailsBigScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailBigScreenState createState() => _MovieDetailBigScreenState();
}

class _MovieDetailBigScreenState extends State<MovieDetailsBigScreen> {
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
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.grey.shade600,
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
            body: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    movie.poster!,
                    fit: BoxFit.fitHeight,
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
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                    onSelect: (index) {
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
                          title: Row(
                            children: [
                              Text(
                                movie
                                    .torrents[movie.torrents.keys
                                        .toList()[audioIndex]]
                                    .keys
                                    .toList()[qualityIndex],
                              ),
                              const SizedBox(width: 8),
                              Health(
                                seed: movie
                                    .torrents[movie.torrents.keys
                                        .toList()[audioIndex]]
                                    .values
                                    .toList()[qualityIndex]['seed'],
                                peer: movie
                                    .torrents[movie.torrents.keys
                                        .toList()[audioIndex]]
                                    .values
                                    .toList()[qualityIndex]['peer'],
                              ),
                            ],
                          ),
                          leading: const Icon(Icons.high_quality_rounded),
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
                                    onSelect: (index) {
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
                  ),
                ),
              ],
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
