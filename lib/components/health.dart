import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/torrent_health.dart';

class Health extends StatelessWidget {
  final int seeds, peers;

  const Health({Key? key, required this.seeds, required this.peers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num health = TorrentHealth.calcHealth(seeds, peers);

    return Container(
      height: 5.0,
      width: 5.0,
      decoration: BoxDecoration(
        color: TorrentHealth.healthColor(health),
        shape: BoxShape.circle,
      ),
    );
  }
}
