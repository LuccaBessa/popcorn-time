import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/features/movies/services/movies_service.dart';

class SearchedMoviesScreen extends StatefulWidget {
  final String keywords;
  const SearchedMoviesScreen({Key? key, required this.keywords})
      : super(key: key);

  @override
  State<SearchedMoviesScreen> createState() => _SearchedMoviesScreenState();
}

class _SearchedMoviesScreenState extends State<SearchedMoviesScreen> {
  MoviesService moviesService = MoviesService();
  late PagingController<int, Movie> controller =
      PagingController(firstPageKey: 0);
  int pageSize = 20;

  @override
  void initState() {
    super.initState();
    controller.addPageRequestListener(((pageKey) => getMovies(pageKey)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getMovies(int pageKey) async {
    try {
      final newItems = await moviesService.getMoviesByKeywords(
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
