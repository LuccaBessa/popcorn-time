import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset(
                    'images/icon.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text(
                    'Popcorn-Time',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_movies_rounded),
            title: const Text('Movies'),
            onTap: () => Navigator.pushNamed(context, '/movies'),
          ),
          ListTile(
            leading: const Icon(Icons.tv_rounded),
            title: const Text('TV Shows'),
            onTap: () => Navigator.pushNamed(context, '/shows'),
          ),
          ListTile(
            leading: const Icon(Icons.catching_pokemon_rounded),
            title: const Text('Animes'),
            onTap: () => Navigator.pushNamed(context, '/animes'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Favorites'),
            onTap: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
    );
  }
}
