import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextInputListTile extends StatelessWidget {
  final String title;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const TextInputListTile({
    Key? key,
    required this.title,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 60.0,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16.0,
          ),
        ),
      ),
      title: TextField(
        decoration: InputDecoration(
          hintText: dotenv.env['BASE_URL']!,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ),
        keyboardType: TextInputType.url,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
