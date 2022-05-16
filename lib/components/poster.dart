import 'package:flutter/material.dart';
import 'package:popcorn_time/utils/utils.dart';

class Poster extends StatefulWidget {
  final String id;
  final String title;
  final ContentType type;
  final String? imageUrl;
  final bool? autoFocus;

  const Poster({
    Key? key,
    required this.id,
    required this.title,
    required this.type,
    this.autoFocus,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<Poster> createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
          key: Key(widget.id),
          autofocus: widget.autoFocus ?? false,
          onFocusChange: (focused) {
            setState(() {
              isFocused = focused;
            });
          },
          canRequestFocus: true,
          focusColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            if (widget.type == ContentType.movie) {
              Navigator.pushNamed(context, '/movie', arguments: widget.id);
            }

            if (widget.type == ContentType.show) {
              Navigator.pushNamed(context, '/show', arguments: widget.id);
            }
          },
          child: widget.imageUrl == null
              ? Image.asset(
                  'images/no_image.png',
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isFocused
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.transparent,
                      width: isFocused ? 3 : 0,
                    ),
                  ),
                  child: Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'images/no_image.png',
                      );
                    },
                  ),
                )),
    );
  }
}
