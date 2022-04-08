import 'package:flutter/material.dart';
import 'package:popcorn_time/components/health.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/components/config_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/details_list.dart';
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
              onPressed: () async {
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
              },
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
                          subtitle['index'] == 0 ? 'No Subtitles' : 'Subtitles',
                        ),
                        leading: Icon(subtitle['index'] == 0
                            ? Icons.closed_caption_disabled_rounded
                            : Icons.closed_caption_rounded),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(
                          audio['value'] == '' ? 'No Audio' : audio['value'],
                        ),
                        leading: const Icon(Icons.volume_up_rounded),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfigDialog(
                                  title: 'Audio',
                                  content: movie.torrents.keys.toList(),
                                  onSelect: (index, value) {
                                    setState(() {
                                      audio['index'] = index;
                                      audio['value'] = value;
                                    });
                                  },
                                  selectedIndex: audio['index'],
                                );
                              });
                        },
                      ),
                      ListTile(
                        title: Text(
                          quality['value'] == ''
                              ? 'No Quality'
                              : quality['value'],
                        ),
                        leading: const Icon(Icons.high_quality_rounded),
                        trailing: Health(
                          seed: movie.torrents[audio['value']][quality['value']]
                              ['seed'],
                          peer: movie.torrents[audio['value']][quality['value']]
                              ['peer'],
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfigDialog(
                                  title: 'Quality',
                                  content: movie.torrents[audio['value']].keys
                                      .toList(),
                                  onSelect: (index, value) {
                                    setState(() {
                                      quality['index'] = index;
                                      quality['value'] = value;
                                      url = movie.torrents[audio['value']]
                                          [quality['value']]['url'];
                                    });
                                  },
                                  selectedIndex: quality['index'],
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
