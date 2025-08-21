import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class BasketballWidget extends StatefulWidget {
  const BasketballWidget({super.key});

  @override
  State<BasketballWidget> createState() => _BasketballWidgetState();
}

class _BasketballWidgetState extends State<BasketballWidget> {
  late final WebViewController _controller;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isloading = true;
    });
    // Choose correct platform
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..loadHtmlString(_htmlContent);
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
    setState(() {
      _isloading = false;
    });
  }

  final String _htmlContent = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Basketball Widget</title>
    <style>
      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        background-color: transparent;;
      }
    </style>
  </head>
  <body>
<div id="wg-api-basketball-games"
     data-host="v1.basketball.api-sports.io"
     data-key="42a10dd9641d44738f11510755906690"
     data-date=""
     data-league=""
     data-season=""
     data-theme="grey"
     data-refresh="15"
     data-show-toolbar="true"
     data-show-errors="false"
     data-show-logos="false"
     data-modal-game="true"
     data-modal-standings="true"
     data-modal-show-logos="true">
</div>
<script
    type="module"
    src="https://widgets.api-sports.io/2.0.3/widgets.js">
</script>
  </body>
</html>
""";

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isloading,
      appBar: AppBar(
        title: const Text('Basketball', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
