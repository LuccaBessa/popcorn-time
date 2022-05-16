import 'package:flutter/material.dart';
import 'package:popcorn_time/components/details_list.dart';
import 'package:popcorn_time/components/select_quality.dart';
import 'package:popcorn_time/components/select_subtitles.dart';
import 'package:popcorn_time/features/shows/components/episode_list_tile.dart';
import 'package:popcorn_time/features/shows/components/show_tab_bar.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDetails extends StatefulWidget {
  final String id;

  const ShowDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  ShowsService showsService = ShowsService();
  late Future<Show> futureShow;
  bool showEpisode = false;
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

  void onPressFloatingActionButton() async {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Show>(
      future: futureShow,
      builder: (context, snapshot) {
        Show? show = snapshot.data;

        if (show != null) {
          return DefaultTabController(
            length: show.seasons!.length + 1,
            child: Scaffold(
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
                    icon: const Icon(
                      Icons.favorite_outline_rounded,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              floatingActionButton: showEpisode
                  ? FloatingActionButton(
                      onPressed: onPressFloatingActionButton,
                      child: const Icon(Icons.play_arrow),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    )
                  : null,
              body: OrientationBuilder(
                builder: (context, orientation) {
                  return Image.network(
                    orientation == Orientation.portrait
                        ? show.poster!
                        : show.backdrop!,
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
                enableDrag: false,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.45,
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                onClosing: () {},
                builder: (BuildContext context) {
                  return showEpisode == false
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShowTabBar(
                              seasons: show.seasons!,
                              isOnLargeScreen: false,
                            ),
                            Expanded(
                              flex: 1,
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
                                                  .onBackground,
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
                                                  .onBackground,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                      ],
                                    ),
                                  ),
                                  for (final season in show.seasons!)
                                    ListView.builder(
                                      itemCount: season.episodes.length,
                                      itemBuilder: (context, index) {
                                        return EpisodeListTile(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          episode: season.episodes[index],
                                          onTap: () {
                                            setState(() {
                                              episode = season.episodes[index];
                                              quality['value'] = episode!
                                                  .torrents!.keys
                                                  .toList()[quality['index']];
                                              url = episode!.torrents![
                                                  quality['value']]['url'];
                                              showEpisode = true;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                title: Text(
                                  episode!.title!,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                                leading: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showEpisode = false;
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
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  episode!.overview!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  softWrap: true,
                                ),
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
                                    url = episode!.torrents![quality['value']]
                                        ['url'];
                                  });
                                },
                                seed: episode!.torrents![quality['value']]
                                    ['seeds'],
                                peer: episode!.torrents![quality['value']]
                                    ['peers'],
                                color: Theme.of(context).colorScheme.onSurface,
                                hasCloseHealth: false,
                              ),
                            ],
                          ),
                        );
                },
              ),
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
