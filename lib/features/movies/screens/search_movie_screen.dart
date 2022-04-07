import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/components/search_header.dart';
import 'package:popcorn_time/features/movies/services/movies_service.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/utils/utils.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  MoviesService moviesService = MoviesService();
  late PagingController<int, Movie> controller =
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

  void getMovies(int pageKey) async {
    try {
      final newItems = await moviesService.getMoviesByKeywords(
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
          getMovies(0);
          FocusScope.of(context).unfocus();
        },
        type: ContentType.movie,
      ),
      body: didSearch ? PosterGrid(controller: controller) : Container(),
    );
  }
}
