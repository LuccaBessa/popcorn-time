import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchTrailer extends StatefulWidget {
  final String url;
  final Color color;

  const WatchTrailer({
    Key? key,
    required this.url,
    required this.color,
  }) : super(key: key);

  @override
  State<WatchTrailer> createState() => _WatchTrailerState();
}

class _WatchTrailerState extends State<WatchTrailer> {
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
        title: Text(
          'Watch Trailer',
          style: TextStyle(
            color: widget.color,
          ),
        ),
        leading: Icon(
          Icons.play_circle_filled_rounded,
          color: widget.color,
        ),
        onTap: () async {
          if (await canLaunch(widget.url)) {
            await launch(widget.url);
          } else {
            throw 'Could not launch ${widget.url}';
          }
        },
      ),
    );
  }
}
