import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';

import '../../../components/search_header.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({Key? key}) : super(key: key);

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  ShowsService showsService = ShowsService();
  late PagingController<int, Show> controller =
      PagingController(firstPageKey: 0);
  late PagingController<int, Show> searchController =
      PagingController(firstPageKey: 0);
  bool isSearching = false;
  String keywords = '';
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
      final newItems = await showsService.getShowsByPage(
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
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: SearchHeader(
        title: 'TV Shows',
        onSearch: (String keywords) => Navigator.pushNamed(
          context,
          '/searchedShows',
          arguments: keywords,
        ),
      ),
      body: PosterGrid(controller: controller),
    );
  }
}