enum DownloadStatus {
  downloading,
  completed,
  failed,
}

class DownloadItem {
  final String id;
  final String url;
  final String filename;
  DownloadStatus status;
  double progress;

  DownloadItem({
    required this.id,
    required this.url,
    required this.filename,
    this.status = DownloadStatus.downloading,
    this.progress = 0.0,
  });
}
