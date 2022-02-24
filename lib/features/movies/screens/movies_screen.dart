import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/models/movie_model.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/components/poster_grid.dart';
import 'package:popcorn_time/features/movies/services/movies_service.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  MoviesService moviesService = MoviesService();
  late PagingController<int, Movie> controller =
      PagingController(firstPageKey: 0);
  bool isSearching = false;
  String keywords = '';
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
      final newItems = await moviesService.getMoviesByPage(
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
      print('Movies error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    keywords = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
                onEditingComplete: () {
                  setState(() {
                    isSearching = false;
                  });

                  Navigator.pushNamed(
                    context,
                    '/searchedMovies',
                    arguments: keywords,
                  );
                },
              )
            : const Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(!isSearching ? Icons.search : Icons.close),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: PosterGrid(controller: controller),
    );
  }
}
