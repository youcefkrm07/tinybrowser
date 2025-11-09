import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    final controller = TextEditingController(text: state.homepage);
    final uaController = TextEditingController(text: state.customUserAgent);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Dark mode'),
          value: state.darkMode,
          onChanged: (v) => state.toggleDarkMode(v),
        ),
        SwitchListTile(
          title: const Text('Ad block'),
          value: state.adBlockEnabled,
          onChanged: (v) => state.toggleAdBlock(v),
        ),
        SwitchListTile(
          title: const Text('Background media playback'),
          value: state.backgroundPlaybackEnabled,
          onChanged: (v) => state.toggleBgPlayback(v),
        ),
        const Divider(),
        const Text('User agent'),
        SwitchListTile(
          title: const Text('Use custom user agent'),
          value: state.useCustomUserAgent,
          onChanged: (v) => state.setUserAgent(enabled: v),
        ),
        TextField(
          controller: uaController,
          enabled: state.useCustomUserAgent,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Mozilla/5.0 ...',
            labelText: 'Custom UA',
          ),
          onSubmitted: (v) => state.setUserAgent(enabled: true, ua: v),
        ),

        const SizedBox(height: 16),
        const Divider(),
        const Text('Homepage'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                state.setHomepage(controller.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Homepage saved')),
                );
              },
              child: const Text('Save'),
            )
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Text('Bookmarks (${state.bookmarks.length})'),
        const SizedBox(height: 8),
        ...state.bookmarks
            .map(
              (b) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(b),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => state.removeBookmark(b),
                ),
              ),
            )
            .toList(),
        const Divider(),
        const SizedBox(height: 8),
        const Text('History'),
        const SizedBox(height: 8),
        ...context.read<BrowserState>().history
            .map(
              (h) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(h),
              ),
            )
            .toList(),
      ],
    );
  }
}
