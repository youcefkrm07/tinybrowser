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
  InAppWebViewController? _controller;
  String? _currentTabId;
  String? _lastLoadedUrl;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrowserState>();
    final tab = state.tabs[state.currentTabIndex];

    // If user switched tab, reset last loaded tracking
    if (_currentTabId != tab.id) {
      _currentTabId = tab.id;
      _lastLoadedUrl = null;
    }

    // Navigate the existing webview when the target URL changes
    if (_controller != null && _lastLoadedUrl != tab.initialUrl) {
      // Avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await _controller!.loadUrl(
            urlRequest: URLRequest(url: WebUri(tab.initialUrl)),
          );
          _lastLoadedUrl = tab.initialUrl;
        } catch (_) {}
      });
    }

    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      initialUrlRequest: URLRequest(url: WebUri(tab.initialUrl)),
      onWebViewCreated: (controller) {
        _controller = controller;
        _lastLoadedUrl = tab.initialUrl;
      },
      shouldOverrideUrlLoading: (controller, navAction) async {
        // Let all http(s) load inside; block others
        final uri = navAction.request.url;
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          return NavigationActionPolicy.ALLOW;
        }
        return NavigationActionPolicy.CANCEL;
      },
      onLoadStop: (controller, url) async {
        // Update address bar text with the final URL
        if (url != null) {
          state.addressController.text = url.toString();
        }

        // Update title
        try {
          final title = await controller.getTitle();
          if (title != null && mounted) {
            state.updateTabMeta(state.currentTabIndex, title: title);
          }
        } catch (_) {}

        // Update favicon using v6 API (replacement for removed onUpdateFavicon)
        try {
          final favicons = await controller.getFavicons();
          if (favicons != null && favicons.isNotEmpty && mounted) {
            favicons.sort((a, b) {
              final aSize = (a.width ?? 0) * (a.height ?? 0);
              final bSize = (b.width ?? 0) * (b.height ?? 0);
              return bSize.compareTo(aSize);
            });
            final best = favicons.first.url;
            if (best != null) {
              state.updateTabMeta(
                state.currentTabIndex,
                favicon: best.toString(),
              );
            }
          }
        } catch (_) {}
      },
      onProgressChanged: (controller, progress) async {
        // When page fully loaded, ensure title and favicon are captured
        if (progress == 100) {
          try {
            final title = await controller.getTitle();
            if (title != null && mounted) {
              state.updateTabMeta(state.currentTabIndex, title: title);
            }
          } catch (_) {}
        }
      },
      onConsoleMessage: (controller, consoleMessage) {
        // You can log console messages in debug if needed
      },
    );
  }
}
