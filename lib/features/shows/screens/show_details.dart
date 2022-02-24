import 'package:flutter/material.dart';
import 'package:popcorn_time/features/shows/services/shows_service.dart';
import 'package:popcorn_time/models/show_model.dart';

class ShowDetails extends StatefulWidget {
  final String id;
  const ShowDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  ShowsService showsService = ShowsService();
  late Future<Show> futureShow;
  int subtitleIndex = 0;
  int audioIndex = 0;
  int qualityIndex = 0;

  @override
  void initState() {
    super.initState();
    futureShow = showsService.getShowById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Show>(
      future: futureShow,
      builder: (context, snapshot) {
        Show? show = snapshot.data;

        if (show != null) {
          Center(
            child: Text(show.title!),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
