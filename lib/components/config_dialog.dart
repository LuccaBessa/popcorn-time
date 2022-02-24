import 'package:flutter/material.dart';

class ConfigDialog extends StatelessWidget {
  final String title;
  final List<String> content;
  final Function(int) onSelect;
  final int selectedIndex;

  const ConfigDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.onSelect,
      required this.selectedIndex,
      required})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int groupValue = selectedIndex;

    return SimpleDialog(
      title: Text(title),
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            children: content.map((e) {
              return RadioListTile(
                groupValue: groupValue,
                onChanged: (value) {
                  onSelect(content.indexOf(e));
                  Navigator.pop(context);
                },
                value: content.indexOf(e),
                selected: content.indexOf(e) == selectedIndex,
                title: Text(e),
                activeColor: Theme.of(context).colorScheme.onSurface,
              );
            }).toList()),
      ],
    );
  }
}
