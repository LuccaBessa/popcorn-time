import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/utils.dart';

class DetailsList extends StatelessWidget {
  final String year;
  final String runtime;
  final String? certification;
  final List<dynamic> genres;
  final double rating;

  const DetailsList({
    Key? key,
    required this.year,
    required this.runtime,
    this.certification,
    required this.genres,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Chip(
              label: Text(
                year,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Chip(
              label: Text(
                runtime + ' min',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          certification?.isNotEmpty == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Chip(
                    label: Text(
                      certification!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Utils.certificationColor(certification!),
                  ),
                )
              : Container(),
          ...genres.map((genre) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Chip(
                  label: Text(
                    genre,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Chip(
              label: Text(
                rating.toString() + ' ★',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
