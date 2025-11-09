import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/download_item.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();

    return ListView.builder(
      itemCount: state.downloads.length,
      itemBuilder: (context, index) {
        final download = state.downloads[index];
        return ListTile(
          title: Text(download.filename),
          subtitle: Text(download.url),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${(download.progress * 100).toStringAsFixed(0)}%'),
              Text(download.status.toString().split('.').last),
            ],
          ),
          leading: download.status == DownloadStatus.completed
              ? const Icon(Icons.check_circle, color: Colors.green)
              : download.status == DownloadStatus.failed
                  ? const Icon(Icons.error, color: Colors.red)
                  : SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(value: download.progress),
                    ),
        );
      },
    );
  }
}
