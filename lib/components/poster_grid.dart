import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/poster.dart';
import 'package:popcorn_time/utils/utils.dart';

class PosterGrid extends StatefulWidget {
  final PagingController<int, dynamic> controller;
  final ContentType contentType;
  final bool autoFocus;

  const PosterGrid({
    Key? key,
    required this.controller,
    required this.contentType,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  State<PosterGrid> createState() => _PosterGridState();
}

class _PosterGridState extends State<PosterGrid> {
  @override
  Widget build(BuildContext context) {
    return PagedGridView(
      pagingController: widget.controller,
      builderDelegate: PagedChildBuilderDelegate<dynamic>(
        itemBuilder: (context, item, index) => Poster(
          id: item.id,
          title: item.title,
          type: item.type,
          imageUrl: item.poster,
          autoFocus: widget.autoFocus ? index == 0 : false,
        ),
        noItemsFoundIndicatorBuilder: (context) {
          if (widget.contentType == ContentType.movie) {
            return Center(
              child: Text(
                'No Movies found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (widget.contentType == ContentType.show) {
            return Center(
              child: Text(
                'No Shows found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (widget.contentType == ContentType.anime) {
            return Center(
              child: Text(
                'No Animes found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (widget.contentType == ContentType.favorite) {
            return Center(
              child: Text(
                'No Favorites found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return const Text('No Items found');
        },
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 2,
        childAspectRatio: 1 / 1.47,
        maxCrossAxisExtent: 200,
      ),
    );
  }
}
