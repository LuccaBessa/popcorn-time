import 'package:flutter/material.dart';
import 'package:popcorn_time/components/config_dialog.dart';

class SelectAudio extends StatefulWidget {
  final Map audio;
  final List<String> audioList;
  final Function(int index, String value) onSelect;
  final Color color;

  const SelectAudio({
    Key? key,
    required this.audio,
    required this.audioList,
    required this.onSelect,
    required this.color,
  }) : super(key: key);

  @override
  State<SelectAudio> createState() => _SelectAudioState();
}

class _SelectAudioState extends State<SelectAudio> {
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
          widget.audio['value'] == '' ? 'No Audio' : widget.audio['value'],
          style: TextStyle(
            color: widget.color,
          ),
        ),
        leading: Icon(
          Icons.volume_up_rounded,
          color: widget.color,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfigDialog(
                title: 'Audio',
                content: widget.audioList,
                onSelect: widget.onSelect,
                selectedIndex: widget.audio['index'],
              );
            },
          );
        },
      ),
    );
  }
}
