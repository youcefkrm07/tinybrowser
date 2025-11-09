import 'package.flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: ListView.builder(
        itemCount: state.downloads.length,
        itemBuilder: (context, index) {
          final download = state.downloads[index];
          return ListTile(
            title: Text(download.filename),
            subtitle: Text(download.url),
            trailing: Text('${download.progress}%'),
          );
        },
      ),
    );
  }
}
