import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final bool hasSeparator;
  final String title;
  final List<Widget> children;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.children,
    this.hasSeparator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSeparator)
          const Divider(
            height: 1.0,
            color: Colors.grey,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 16.0,
                top: 8.0,
                bottom: 20.0,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            for (Widget child in children) child,
          ],
        ),
      ],
    );
  }
}
