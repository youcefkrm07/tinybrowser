import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/pages/user_scripts_page.dart';

import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    final homepageController = TextEditingController(text: state.homepage);

    return ListView(
      children: [
        ListTile(
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: state.darkMode,
            onChanged: (value) => state.toggleDarkMode(value),
          ),
        ),
        ListTile(
          title: const Text('Ad Block'),
          trailing: Switch(
            value: state.adBlockEnabled,
            onChanged: (value) => state.toggleAdBlock(value),
          ),
        ),
        ListTile(
          title: const Text('Background Playback'),
          trailing: Switch(
            value: state.backgroundPlaybackEnabled,
            onChanged: (value) => state.toggleBgPlayback(value),
          ),
        ),
        ListTile(
          title: const Text('Homepage'),
          subtitle: TextField(
            controller: homepageController,
            onSubmitted: (value) => state.setHomepage(value),
          ),
        ),
        ListTile(
          title: const Text('User Scripts'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserScriptsPage()),
            );
          },
        ),
      ],
    );
  }
}
