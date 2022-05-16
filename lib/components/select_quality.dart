import 'package:flutter/material.dart';
import 'package:popcorn_time/components/config_dialog.dart';
import 'package:popcorn_time/components/health.dart';

class SelectQuality extends StatefulWidget {
  final Map quality;
  final List<String> qualitiesList;
  final Function(int index, String value) onSelect;
  final int seed;
  final int peer;
  final Color color;
  final bool hasCloseHealth;

  const SelectQuality({
    Key? key,
    required this.quality,
    required this.qualitiesList,
    required this.onSelect,
    required this.seed,
    required this.peer,
    required this.color,
    required this.hasCloseHealth,
  }) : super(key: key);

  @override
  State<SelectQuality> createState() => _SelectQualityState();
}

class _SelectQualityState extends State<SelectQuality> {
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
        title: widget.hasCloseHealth
            ? Row(
                children: [
                  Text(
                    widget.quality['value'] == ''
                        ? 'No Quality'
                        : widget.quality['value'],
                    style: TextStyle(
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Health(
                    seed: widget.seed,
                    peer: widget.peer,
                  )
                ],
              )
            : Text(
                widget.quality['value'] == ''
                    ? 'No Quality'
                    : widget.quality['value'],
                style: TextStyle(
                  color: widget.color,
                ),
              ),
        leading: Icon(
          Icons.high_quality_rounded,
          color: widget.color,
        ),
        trailing: widget.hasCloseHealth
            ? null
            : Health(
                seed: widget.seed,
                peer: widget.peer,
              ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfigDialog(
                title: 'Quality',
                content: widget.qualitiesList,
                onSelect: widget.onSelect,
                selectedIndex: widget.quality['index'],
              );
            },
          );
        },
      ),
    );
  }
}
