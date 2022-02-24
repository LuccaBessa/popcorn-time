import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcorn_time/components/poster.dart';

class PosterGrid extends StatefulWidget {
  final PagingController<int, dynamic> controller;

  const PosterGrid({
    Key? key,
    required this.controller,
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
        ),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 2,
        childAspectRatio: 1 / 1.47,
        maxCrossAxisExtent: 200,
      ),
    );
  }
}
