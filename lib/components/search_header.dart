import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/utils.dart';

class SearchHeader extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearch;
  final ContentType type;

  const SearchHeader({Key? key, required this.onSearch, required this.type})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  String keywords = '';
  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: TextField(
        focusNode: textFieldFocusNode,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {
            keywords = value;
          });
        },
        decoration: InputDecoration(
          hintText:
              'Search for a ${widget.type == ContentType.movie ? 'movie' : 'show'}...',
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10),
        ),
        onEditingComplete: () {
          widget.onSearch(keywords);
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
