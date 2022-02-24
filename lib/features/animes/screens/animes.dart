import 'package:flutter/material.dart';
import 'package:popcorn_time/components/drawer.dart';

class AnimesScreen extends StatelessWidget {
  const AnimesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        title: const Text('Animes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(),
    );
  }
}
