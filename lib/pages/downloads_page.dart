import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    if (state.downloads.isEmpty) {
      return const Center(child: Text('No downloads yet'));
    }
    return ListView.builder(
      itemCount: state.downloads.length,
      itemBuilder: (context, index) {
        final d = state.downloads[index];
        return ListTile(
          title: Text(d.filename),
          subtitle: Text('${d.status.name} • ${(d.progress * 100).toStringAsFixed(0)}%'),
        );
      },
    );
  }
}
