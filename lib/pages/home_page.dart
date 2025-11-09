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

    final adBlocker = ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: '.*',
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: '.ad, .ads, [id^="ad"], [class*="ad"]',
      ),
    );

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(tab.initialUrl)),
      initialSettings: InAppWebViewSettings(
        contentBlockers: state.adBlockEnabled ? [adBlocker] : [],
      ),
      onWebViewCreated: (controller) {
        tab.webViewController = controller;
      },
      onLoadStart: (controller, url) {
        state.updateTabMeta(state.currentTabIndex, title: url.toString());
      },
      onLoadStop: (controller, url) async {
        final title = await controller.getTitle();
        state.updateTabMeta(state.currentTabIndex, title: title);
        state.updateTabScreenshot(state.currentTabIndex);

        for (final script in state.scripts) {
          if (script.enabled) {
            controller.evaluateJavascript(source: script.script);
          }
        }
      },
      onDownloadStartRequest: (controller, downloadStartRequest) {
        state.startDownload(downloadStartRequest.url.toString());
      },
      onUpdateFavicon: (controller, url, favicons) {
        if (favicons.isNotEmpty) {
          state.updateTabMeta(state.currentTabIndex, favicon: favicons.first.url.toString());
        }
      },
    );
  }
}
