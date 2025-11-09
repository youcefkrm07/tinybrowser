import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _homepageController = TextEditingController();
  final _uaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    _homepageController.text = state.homepage;
    _uaController.text = state.userAgent ?? '';
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: state.darkMode,
          onChanged: (v) => state.toggleDarkMode(v),
        ),
        SwitchListTile(
          title: const Text('Enable Ad Block'),
          value: state.adBlockEnabled,
          onChanged: (v) => state.toggleAdBlock(v),
        ),
        SwitchListTile(
          title: const Text('Enable Background Media Playback'),
          value: state.backgroundPlaybackEnabled,
          onChanged: (v) => state.toggleBgPlayback(v),
        ),
        const Divider(),
        ListTile(
          title: TextField(
            controller: _homepageController,
            decoration: const InputDecoration(
              labelText: 'Homepage URL',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => state.setHomepage(v),
          ),
        ),
        ListTile(
          title: TextField(
            controller: _uaController,
            decoration: const InputDecoration(
              labelText: 'Custom User-Agent (blank to disable)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => state.setUserAgent(v),
          ),
        ),
        const Divider(),
        const ListTile(title: Text('Bookmarks')),
        ...state.bookmarks.map(
          (b) => ListTile(
            title: Text(b),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => state.removeBookmark(b),
            ),
          ),
        ),
        const Divider(),
        const ListTile(title: Text('History')),
        ...state.history.map((h) => ListTile(title: Text(h))),
      ],
    );
  }
}
