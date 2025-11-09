import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/user_script.dart';

class UserScriptsPage extends StatelessWidget {
  const UserScriptsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Scripts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showScriptDialog(context, state),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: state.scripts.length,
        itemBuilder: (context, index) {
          final script = state.scripts[index];
          return ListTile(
            title: Text(script.name),
            subtitle: Text(script.script, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Switch(
              value: script.enabled,
              onChanged: (value) => state.toggleScript(index, value),
            ),
            onTap: () => _showScriptDialog(context, state, index: index),
          );
        },
      ),
    );
  }

  void _showScriptDialog(BuildContext context, BrowserState state, {int? index}) {
    final script = index != null ? state.scripts[index] : null;
    final nameController = TextEditingController(text: script?.name);
    final scriptController = TextEditingController(text: script?.script);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(script == null ? 'Add Script' : 'Edit Script'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: scriptController,
                decoration: const InputDecoration(labelText: 'Script'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            if (index != null)
              TextButton(
                onPressed: () {
                  state.removeScript(index);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newScript = UserScriptModel(
                  name: nameController.text,
                  script: scriptController.text,
                );
                if (index != null) {
                  state.updateScript(newScript, index);
                } else {
                  state.addScript(newScript);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
