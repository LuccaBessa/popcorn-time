import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/components/search_bar.dart';
import 'package:popcorn_time/features/animes/services/animes_service.dart';
import 'package:popcorn_time/models/anime_model.dart';
import 'package:popcorn_time/utils/utils.dart';

class SearchAnimeScreen extends StatefulWidget {
  const SearchAnimeScreen({Key? key}) : super(key: key);

  @override
  State<SearchAnimeScreen> createState() => _SearchAnimeScreenState();
}

class _SearchAnimeScreenState extends State<SearchAnimeScreen> {
  AnimesService animesService = AnimesService();
  late PagingController<int, Anime> controller =
      PagingController(firstPageKey: 1);
  String keywords = '';
  int pageSize = 20;
  bool didSearch = false;

  @override
  void initState() {
    super.initState();
    controller.addPageRequestListener(((pageKey) {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getMovies(int pageKey) async {
    try {
      final newItems = await animesService.getAnimesByKeywords(
        page: pageKey,
        pageSize: pageSize,
        keywords: keywords,
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
      appBar: SearchBar(
        onSearch: (String keywords) {
          setState(() {
            this.keywords = keywords;
            didSearch = true;
          });
          controller.refresh();
          getMovies(0);
          FocusScope.of(context).unfocus();
        },
        type: ContentType.anime,
      ),
      body: didSearch ? PosterGrid(controller: controller) : Container(),
    );
  }
}
