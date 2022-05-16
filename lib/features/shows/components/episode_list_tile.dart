import 'package:flutter/material.dart';
import 'package:popcorn_time/models/show_model.dart';

class EpisodeListTile extends StatefulWidget {
  final Episode episode;
  final Color color;
  final void Function() onTap;

  const EpisodeListTile({
    Key? key,
    required this.episode,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EpisodeListTile> createState() => _EpisodeListTileState();
}

class _EpisodeListTileState extends State<EpisodeListTile> {
  final FocusNode focusNode = FocusNode();
  Decoration? decoration;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        decoration = focusNode.hasFocus
            ? BoxDecoration(
                border: Border.all(color: widget.color),
                borderRadius: BorderRadius.circular(10),
              )
            : null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        focusNode: focusNode,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'E${widget.episode.number}',
            style: TextStyle(
              color: widget.color,
            ),
          ),
        ),
        title: Text(
          widget.episode.title!,
          style: TextStyle(
            color: widget.color,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
