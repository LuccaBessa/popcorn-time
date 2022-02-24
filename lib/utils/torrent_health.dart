import 'dart:math';

import 'package:flutter/material.dart';

class TorrentHealth {
  static num calcHealth(int seeds, int peers) {
    if (seeds == 0 && peers == 0) {
      return 0;
    }

    // First calculate the seed/peer ratio
    var ratio = peers > 0 ? (seeds / peers) : seeds;

    // Normalize the data. Convert each to a percentage
    // Ratio: Anything above a ratio of 5 is good
    var normalizedRatio = min(ratio / 5 * 100, 100);
    // Seeds: Anything above 30 seeds is good
    var normalizedSeeds = min(seeds / 30 * 100, 100);

    // Weight the above metrics differently
    // Ratio is weighted 60% whilst seeders is 40%
    var weightedRatio = normalizedRatio * 0.6;
    var weightedSeeds = normalizedSeeds * 0.4;
    var weightedTotal = weightedRatio + weightedSeeds;

    // Scale from [0, 100] to [0, 3]. Drops the decimal places
    var scaledTotal = ((weightedTotal * 3) / 100);

    return scaledTotal;
  }

  static Color healthColor(num health) {
    if (health == 1) {
      return const Color(0xFFD53F3F);
    }

    if (health == 2) {
      return const Color(0xFFECE523);
    }

    if (health == 3) {
      return const Color(0xFFA3E147);
    }

    return const Color(0xFF2AD942);
  }
}
