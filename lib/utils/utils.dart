import 'dart:collection';

import 'package:flutter/material.dart';

class Utils {
  static Map<String, dynamic> sortTorrents(
      Map<String, dynamic> torrents, bool isShow) {
    if (isShow) {
      torrents = SplayTreeMap<String, dynamic>.from(torrents, (a, b) {
        var regex = RegExp(r'[a-zA-Z]');
        return int.parse(a.replaceAll(regex, ''))
            .compareTo(int.parse(b.replaceAll(regex, '')));
      });
    } else {
      torrents.forEach((key, value) {
        torrents[key] = SplayTreeMap<String, dynamic>.from(value, (a, b) {
          var regex = RegExp(r'[a-zA-Z]');
          return int.parse(a.replaceAll(regex, ''))
              .compareTo(int.parse(b.replaceAll(regex, '')));
        });
      });
    }

    return torrents;
  }

  static Color certificationColor(String certification) {
    if (certification == 'G') {
      return Colors.green;
    }

    if (certification == 'PG') {
      return Colors.orangeAccent.shade700;
    }

    if (certification == 'PG-13') {
      return Colors.purple.shade800;
    }

    if (certification == 'R') {
      return Colors.redAccent.shade700;
    }

    if (certification == 'NC-17') {
      return Colors.indigo.shade700;
    }

    return Colors.grey;
  }
}
