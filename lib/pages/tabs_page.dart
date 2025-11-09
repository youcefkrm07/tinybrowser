import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => state.addTab(initialUrl: state.homepage),
                icon: const Icon(Icons.add),
                label: const Text('New Tab'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => state.addTab(initialUrl: state.homepage, incognito: true),
                icon: const Icon(Icons.visibility_off_outlined),
                label: const Text('New Incognito Tab'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.tabs.length,
            itemBuilder: (context, index) {
              final t = state.tabs[index];
              return ListTile(
                leading: t.faviconUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(t.faviconUrl!),
                      )
                    : const CircleAvatar(child: Icon(Icons.public)),
                title: Text(t.title.isNotEmpty ? t.title : t.initialUrl),
                subtitle: Text(t.isIncognito ? 'Incognito' : 'Normal'),
                selected: index == state.currentTabIndex,
                onTap: () => state.switchToTab(index),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => state.closeTab(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
