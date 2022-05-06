import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popcorn_time/components/config_dialog.dart';
import 'package:popcorn_time/components/details_list.dart';
import 'package:popcorn_time/components/health.dart';
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

  void showEpisodeInfo(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              setState(() {
                showEpisode = false;
              });
              return Future.value(true);
            },
            child: BottomSheet(
              onClosing: () {
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
              builder: (context) => SingleChildScrollView(
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        episode!.overview!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 18),
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
                        quality['value'] == ''
                            ? 'No Quality'
                            : quality['value'],
                      ),
                      leading: const Icon(Icons.high_quality_rounded),
                      trailing: Health(
                        seed: episode!.torrents![quality['value']]['seeds'],
                        peer: episode!.torrents![quality['value']]['peers'],
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfigDialog(
                                title: 'Quality',
                                content: episode!.torrents!.keys.toList(),
                                onSelect: (index, value) {
                                  setState(() {
                                    quality['index'] = index;
                                    quality['value'] = value;
                                    url = episode!.torrents![quality['value']]
                                        ['url'];
                                  });
                                },
                                selectedIndex: quality['index'],
                              );
                            });
                      },
                    ),
                  ],
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
                    floatingActionButton: showEpisode
                        ? FloatingActionButton(
                            onPressed: () async {
                              try {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    content: Text(
                                      'Could not find a Torrent App',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Icon(Icons.play_arrow),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          )
                        : null,
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
                              TabBar(
                                isScrollable: true,
                                labelColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                indicatorColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                tabs: [
                                  const Tab(
                                    text: 'About',
                                  ),
                                  for (final season in show.seasons!)
                                    Tab(
                                      text: 'Season ${season.number}',
                                    ),
                                ],
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
                                      ListView.builder(
                                        itemCount: season.episodes.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'E${season.episodes[index].number}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              season.episodes[index].title!,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                episode =
                                                    season.episodes[index];
                                                quality['value'] = episode!
                                                    .torrents!.keys
                                                    .toList()[quality['index']];
                                                url = episode!.torrents![
                                                    quality['value']]['url'];
                                                showEpisode = true;
                                              });
                                              showEpisodeInfo(context);
                                            },
                                          );
                                        },
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
