import 'package:flutter/material.dart';

class SearchHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function onSearch;

  const SearchHeader({Key? key, required this.title, required this.onSearch})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  bool isSearching = false;
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
      title: isSearching
          ? TextField(
              focusNode: textFieldFocusNode,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  keywords = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
              ),
              onEditingComplete: () {
                setState(() {
                  isSearching = false;
                });

                widget.onSearch(keywords);
              },
            )
          : Text(widget.title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [
        IconButton(
          icon: Icon(!isSearching ? Icons.search : Icons.close),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
            textFieldFocusNode.requestFocus();
          },
        ),
      ],
    );
  }
}
