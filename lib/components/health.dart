import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/torrent_health.dart';

class Health extends StatelessWidget {
  final int seed, peer;

  const Health({Key? key, required this.seed, required this.peer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num health = TorrentHealth.calcHealth(seed, peer);

    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: TorrentHealth.healthColor(health),
        shape: BoxShape.circle,
      ),
    );
  }
}
