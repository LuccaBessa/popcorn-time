import 'package:flutter/material.dart';
import 'package:popcorn_time/components/drawer.dart';
import 'package:popcorn_time/features/settings/components/text_input_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerComponent(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                  top: 8.0,
                  bottom: 20.0,
                ),
                child: Text(
                  'Apperance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 60.0,
                  height: 30.0,
                  child: Center(
                    child: Text(
                      'Theme:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                title: DropdownButtonFormField(
                  value: 'system',
                  alignment: Alignment.bottomRight,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onChanged: (String? value) {},
                  items: const [
                    DropdownMenuItem(child: Text('Dark'), value: 'dark'),
                    DropdownMenuItem(child: Text('System'), value: 'system'),
                    DropdownMenuItem(child: Text('Light'), value: 'light'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                  top: 8.0,
                  bottom: 20.0,
                ),
                child: Text(
                  'Servers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const TextInputListTile(title: 'Movies:'),
              const TextInputListTile(title: 'Shows:'),
              const TextInputListTile(title: 'Animes:'),
            ],
          ),
        ));
  }
}
