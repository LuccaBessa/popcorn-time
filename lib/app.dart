import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_time/features/animes/screens/animes_screen.dart';
import 'package:popcorn_time/features/animes/screens/search_anime_screen.dart';
import 'package:popcorn_time/features/favorites/screens/favorites.dart';
import 'package:popcorn_time/features/movies/screens/movie_details_large_screen.dart';
import 'package:popcorn_time/features/movies/screens/movie_details_screen.dart';
import 'package:popcorn_time/features/movies/screens/movies_screen.dart';
import 'package:popcorn_time/features/movies/screens/search_movie_screen.dart';
import 'package:popcorn_time/features/settings/screens/settings_screen.dart';
import 'package:popcorn_time/features/shows/screens/search_show_screen.dart';
import 'package:popcorn_time/features/shows/screens/show_details.dart';
import 'package:popcorn_time/features/shows/screens/show_details_large_screen.dart';
import 'package:popcorn_time/features/shows/screens/shows_screen.dart';

class App extends StatelessWidget {
  final AndroidDeviceInfo? androidDeviceInfo;

  const App({Key? key, this.androidDeviceInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popcorn Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          background: Colors.white70,
          onBackground: Colors.black,
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white,
          primary: Colors.deepPurple.shade900,
          onPrimary: Colors.white,
          secondary: Colors.redAccent,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme(
          background: Colors.blueGrey.shade900,
          onBackground: Colors.white,
          brightness: Brightness.dark,
          error: Colors.red,
          onError: Colors.white,
          primary: Colors.deepPurple.shade900,
          onPrimary: Colors.white,
          secondary: Colors.redAccent,
          onSecondary: Colors.white,
          surface: Colors.grey.shade800,
          onSurface: Colors.white,
        ),
      ),
      initialRoute: '/movies',
      routes: {
        '/movies': (context) {
          if (androidDeviceInfo!.systemFeatures
              .contains('android.software.leanback')) {
            return const MoviesScreen(isTV: true);
          }

          return const MoviesScreen();
        },
        '/searchMovie': (context) => const SearchMovieScreen(),
        '/movie': (context) {
          if (Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows ||
              androidDeviceInfo!.systemFeatures
                  .contains('android.software.leanback')) {
            return MovieDetailsLargeScreen(
              id: ModalRoute.of(context)!.settings.arguments as String,
            );
          }

          return MovieDetailsScreen(
            id: ModalRoute.of(context)!.settings.arguments as String,
          );
        },
        '/shows': (context) {
          if (Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows ||
              androidDeviceInfo!.systemFeatures
                  .contains('android.software.leanback')) {
            return const ShowsScreen(isLargeScreen: true);
          }
          return const ShowsScreen();
        },
        '/show': (context) {
          if (Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows ||
              androidDeviceInfo!.systemFeatures
                  .contains('android.software.leanback')) {
            return ShowDetailsLargeScreen(
              id: ModalRoute.of(context)!.settings.arguments as String,
            );
          }

          return ShowDetails(
            id: ModalRoute.of(context)!.settings.arguments as String,
          );
        },
        '/searchShow': (context) => const SearchShowScreen(),
        '/searchAnime': (context) => const SearchAnimeScreen(),
        '/animes': (context) => const AnimesScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
