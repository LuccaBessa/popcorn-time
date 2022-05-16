import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popcorn_time/components/details_list.dart';
import 'package:popcorn_time/components/select_quality.dart';
import 'package:popcorn_time/components/select_subtitles.dart';
import 'package:popcorn_time/features/shows/components/episode_list_tile.dart';
import 'package:popcorn_time/features/shows/components/show_tab_bar.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDetailsLargeScreen extends StatefulWidget {
  final String id;
  const ShowDetailsLargeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowDetailsLargeScreen> createState() => _ShowDetailsLargeScreenState();
}

class _ShowDetailsLargeScreenState extends State<ShowDetailsLargeScreen> {
  ShowsService showsService = ShowsService();
  late Future<Show> futureShow;
  Episode? episode;
  Map subtitle = {
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
    futureShow = showsService.getShowById(widget.id);
  }

  void onPressFloatingButton(context) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Could not find a Torrent App',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  void showEpisodeInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {
              setState(() {
                subtitle = {
                  'index': 0,
                  'value': '',
                };
                quality = {
                  'index': 0,
                  'value': '',
                };
                url = '';
                episode = null;
              });
            },
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  episode!.title!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      subtitle = {
                        'index': 0,
                        'value': '',
                      };
                      quality = {
                        'index': 0,
                        'value': '',
                      };
                      url = '';
                      episode = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => onPressFloatingButton(context),
                child: const Icon(Icons.play_arrow),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode!.overview!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 18),
                      SelectSubtitles(
                        subtitle: subtitle,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SelectQuality(
                        quality: quality,
                        qualitiesList: episode!.torrents!.keys.toList(),
                        onSelect: (index, value) {
                          setState(() {
                            quality['index'] = index;
                            quality['value'] = value;
                            url = episode!.torrents![quality['value']]['url'];
                          });
                        },
                        seed: episode!.torrents![quality['value']]['seeds'],
                        peer: episode!.torrents![quality['value']]['peers'],
                        color: Theme.of(context).colorScheme.onSurface,
                        hasCloseHealth: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Show>(
      future: futureShow,
      builder: (context, snapshot) {
        Show? show = snapshot.data;

        if (show != null) {
          return DefaultTabController(
            length: show.seasons!.length + 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(show.backdrop!),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Scaffold(
                    extendBodyBehindAppBar: false,
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(
                        color: Theme.of(context).colorScheme.onPrimary,
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
                    body: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.network(
                            show.poster!,
                            height: MediaQuery.of(context).size.height * 0.7,
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    );
                            },
                            alignment: Alignment.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShowTabBar(
                                seasons: show.seasons!,
                                isOnLargeScreen: true,
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              show.title!,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: DetailsList(
                                              year: show.year!,
                                              runtime: show.runtime!,
                                              genres: show.genres!,
                                              rating: show.rating!,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              show.synopsis!,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                        ],
                                      ),
                                    ),
                                    for (final season in show.seasons!)
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: ListView.builder(
                                          itemCount: season.episodes.length,
                                          itemBuilder: (context, index) {
                                            return EpisodeListTile(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              episode: season.episodes[index],
                                              onTap: () {
                                                setState(() {
                                                  episode =
                                                      season.episodes[index];
                                                  quality['value'] = episode!
                                                          .torrents!.keys
                                                          .toList()[
                                                      quality['index']];
                                                  url = episode!.torrents![
                                                      quality['value']]['url'];
                                                });
                                                showEpisodeInfo(context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
