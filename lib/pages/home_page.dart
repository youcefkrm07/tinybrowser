import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    final tab = state.tabs[state.currentTabIndex];
    return InAppWebView(
      key: ValueKey(tab.id),
      initialUrlRequest: URLRequest(url: WebUri(tab.initialUrl)),
      initialSettings: InAppWebViewSettings(
        userAgent: state.userAgent,
        javaScriptEnabled: true,
        supportMultipleWindows: true,
        allowsInlineMediaPlayback: true,
      ),
      onWebViewCreated: (controller) {
        // TODO
      },
      onLoadStop: (controller, url) async {
        if (url == null) return;
        final favicons = await controller.getFavicons();
        context.read<BrowserState>().updateTabMeta(
              state.currentTabIndex,
              title: await controller.getTitle(),
              favicon: favicons.firstOrNull?.url.toString(),
            );
        state.recordHistory(url.toString());
      },
      shouldOverrideUrlLoading: (controller, navAction) async {
        final urlStr = navAction.request.url.toString();
        if (state.backgroundPlaybackEnabled &&
            (urlStr.endsWith('.mp3') ||
                urlStr.endsWith('.m4a') ||
                urlStr.endsWith('.aac') ||
                urlStr.endsWith('.wav') ||
                urlStr.endsWith('.ogg'))) {
          unawaited(context.read<BrowserState>().playInBackground(urlStr));
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
