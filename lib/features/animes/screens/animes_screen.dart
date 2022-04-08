import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/features/animes/services/animes_service.dart';
import 'package:popcorn_time/models/anime_model.dart';

class AnimesScreen extends StatefulWidget {
  const AnimesScreen({Key? key}) : super(key: key);

  @override
  State<AnimesScreen> createState() => _AnimesScreenState();
}

class _AnimesScreenState extends State<AnimesScreen> {
  AnimesService animesService = AnimesService();
  late PagingController<int, Anime> controller =
      PagingController(firstPageKey: 1);
  bool isSearching = false;
  String keywords = '';
  int pageSize = 20;

  @override
  void initState() {
    super.initState();
    controller.addPageRequestListener(((pageKey) => getAnimes(pageKey)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getAnimes(int pageKey) async {
    try {
      final newItems = await animesService.getAnimesByPage(
        page: pageKey,
        pageSize: pageSize,
      );
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      controller.error = error;
      // ignore: avoid_print
      print('Animes error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Animes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/searchAnime',
                arguments: keywords,
              );
            },
          ),
        ],
      ),
      body: PosterGrid(controller: controller),
    );
  }
}
