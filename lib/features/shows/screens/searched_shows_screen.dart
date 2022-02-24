import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/models/show_model.dart';

class SearchedShowsScreen extends StatefulWidget {
  final String keywords;
  const SearchedShowsScreen({Key? key, required this.keywords})
      : super(key: key);

  @override
  State<SearchedShowsScreen> createState() => _SearchedShowsScreenState();
}

class _SearchedShowsScreenState extends State<SearchedShowsScreen> {
  ShowsService showsService = ShowsService();
  late PagingController<int, Show> controller =
      PagingController(firstPageKey: 0);
  int pageSize = 20;

  @override
  void initState() {
    super.initState();
    controller.addPageRequestListener(((pageKey) => getShows(pageKey)));
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
        keywords: widget.keywords,
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
      appBar: AppBar(
        title: Text(widget.keywords),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PosterGrid(controller: controller),
    );
  }
}
