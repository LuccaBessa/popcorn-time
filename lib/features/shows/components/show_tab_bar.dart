import 'package:flutter/material.dart';
import 'package:popcorn_time/models/show_model.dart';

class ShowTabBar extends StatelessWidget {
  final List<Season> seasons;
  final bool isOnLargeScreen;

  const ShowTabBar({
    Key? key,
    required this.seasons,
    required this.isOnLargeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      labelColor: isOnLargeScreen
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface,
      indicatorColor: isOnLargeScreen
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface,
      tabs: [
        const Tab(
          text: 'About',
        ),
        for (final season in seasons)
          Tab(
            text: 'Season ${season.number}',
          ),
      ],
    );
  }
}
