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
  String keywords = '';
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 12.0,
      title: TextField(
        focusNode: textFieldFocusNode,
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: textFieldController,
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
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          contentPadding: const EdgeInsets.all(12.0),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              setState(() {
                keywords = '';
              });
              textFieldController.clear();
            },
          ),
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
