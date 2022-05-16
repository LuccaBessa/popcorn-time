import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';
import 'package:popcorn_time/utils/utils.dart';

class ShowsScreen extends StatefulWidget {
  final bool isLargeScreen;
  const ShowsScreen({Key? key, this.isLargeScreen = false}) : super(key: key);

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  ShowsService showsService = ShowsService();
  late PagingController<int, Show> controller =
      PagingController(firstPageKey: 1);
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('TV Shows'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/searchShow',
                arguments: keywords,
              );
            },
          ),
        ],
      ),
      body: PosterGrid(
        controller: controller,
        contentType: ContentType.show,
        autoFocus: widget.isLargeScreen,
      ),
    );
  }
}
