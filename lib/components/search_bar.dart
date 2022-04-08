import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/utils.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearch;
  final ContentType type;

  const SearchBar({Key? key, required this.onSearch, required this.type})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = true;
  late FocusNode textFieldFocusNode;
  TextEditingController textFieldController = TextEditingController();

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 12.0,
        title: TextField(
          focusNode: textFieldFocusNode,
          controller: textFieldController,
          autofocus: true,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                showClear = false;
              });
            } else {
              setState(() {
                showClear = true;
              });
            }
          },
          onSubmitted: (value) {
            textFieldFocusNode.unfocus();
            if (value.isNotEmpty) {
              widget.onSearch(value);
            }
          },
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            decoration: TextDecoration.none,
          ),
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            hintText: 'Search for a ' + widget.type.toString().split('.').last,
            border: InputBorder.none,
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            suffixIcon: showClear
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      textFieldController.clear();
                      setState(() {
                        showClear = false;
                      });
                      textFieldFocusNode.requestFocus();
                    },
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : null,
          ),
        ));
  }
}
