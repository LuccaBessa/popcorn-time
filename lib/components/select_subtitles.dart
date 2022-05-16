import 'package:flutter/material.dart';

class SelectSubtitles extends StatefulWidget {
  final Map subtitle;
  final Color color;

  const SelectSubtitles({
    Key? key,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  State<SelectSubtitles> createState() => _SelectSubtitlesState();
}

class _SelectSubtitlesState extends State<SelectSubtitles> {
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
          widget.subtitle['index'] == 0 ? 'No Subtitles' : 'Subtitles',
          style: TextStyle(
            color: widget.color,
          ),
        ),
        leading: Icon(
          widget.subtitle['index'] == 0
              ? Icons.closed_caption_disabled_rounded
              : Icons.closed_caption_rounded,
          color: widget.color,
        ),
        onTap: () {},
      ),
    );
  }
}
