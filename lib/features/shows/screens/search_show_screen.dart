import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/components/search_header.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';
import 'package:popcorn_time/utils/utils.dart';

class SearchShowScreen extends StatefulWidget {
  const SearchShowScreen({Key? key}) : super(key: key);

  @override
  State<SearchShowScreen> createState() => _SearchShowScreenState();
}

class _SearchShowScreenState extends State<SearchShowScreen> {
  ShowsService showsService = ShowsService();
  late PagingController<int, Show> controller =
      PagingController(firstPageKey: 0);
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

  void getShows(int pageKey) async {
    try {
      final newItems = await showsService.getShowsByKeywords(
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
      print('Movies error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: SearchHeader(
        onSearch: (String keywords) {
          setState(() {
            this.keywords = keywords;
            didSearch = true;
          });
          controller.refresh();
          getShows(0);
          FocusScope.of(context).unfocus();
        },
        type: ContentType.show,
      ),
      body: didSearch ? PosterGrid(controller: controller) : Container(),
    );
  }
}
