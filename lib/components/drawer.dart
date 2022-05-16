import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Color(0xFF292926),
                        Color(0xFF000000),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'images/banner.jpg',
                    fit: BoxFit.cover,
                  )),
              ListTile(
                leading: const Icon(Icons.local_movies_rounded),
                title: const Text('Movies'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/movies",
                  (r) => false,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.tv_rounded),
                title: const Text('TV Shows'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/shows",
                  (r) => false,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.catching_pokemon_rounded),
                title: const Text('Animes'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/animes",
                  (r) => false,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_rounded),
                title: const Text('Favorites'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/favorites",
                  (r) => false,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                "/settings",
                (r) => false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
