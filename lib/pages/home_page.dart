import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    final tab = state.tabs[state.currentTabIndex];

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(tab.initialUrl)),
      onWebViewCreated: (controller) {
        tab.webViewController = controller;
      },
      onLoadStart: (controller, url) {
        state.updateTabMeta(state.currentTabIndex, title: url.toString());
      },
      onLoadStop: (controller, url) async {
        final title = await controller.getTitle();
        final favicon = await controller.getFavicon();
        state.updateTabMeta(state.currentTabIndex, title: title, favicon: favicon?.toString());

        for (final script in state.scripts) {
          if (script.enabled) {
            controller.evaluateJavascript(source: script.script);
          }
        }
      },
      onDownloadStartRequest: (controller, downloadStartRequest) {
        state.startDownload(downloadStartRequest.url.toString());
      },
    );
  }
}
