import 'package:flutter/material.dart';

class CertificationColors {
  static Color getColor(String certification) {
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
