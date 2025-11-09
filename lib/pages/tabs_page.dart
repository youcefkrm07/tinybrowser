import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
        actions: [
          TextButton(
            onPressed: () => state.addTab(incognito: true),
            child: const Text('New Incognito Tab'),
          ),
          TextButton(
            onPressed: () => state.addTab(),
            child: const Text('New Tab'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: state.tabs.length,
        itemBuilder: (context, index) {
          final tab = state.tabs[index];
          return ListTile(
            title: Text(tab.title),
            subtitle: Text(tab.initialUrl),
            leading: tab.faviconUrl != null
                ? Image.network(tab.faviconUrl!)
                : const Icon(Icons.public),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => state.closeTab(index),
            ),
            onTap: () => state.switchToTab(index),
          );
        },
      ),
    );
  }
}
