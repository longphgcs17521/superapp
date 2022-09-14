import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:superapp/miniapp/logic_layer/message_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Renderer extends StatefulWidget {
  Renderer({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _RenderedViewState createState() => _RenderedViewState();
}

class _RenderedViewState extends State<Renderer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    _loadHtmlFromAssets();

    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      javascriptChannels: <JavascriptChannel>[
        logicMessageHandler(context, _controller),
      ].toSet(),
    );
  }

  _loadHtmlFromAssets() async {
    // String gido = await getApplicationDocumentsDirectory()
    //     .then((value) => value.path+'/index.html');
    String fileText = await rootBundle
        .loadString('/data/user/0/com.example.superapp/app_flutter/index.html');
    // String fileText = await rootBundle.loadStri`ng('assets/miniapp/index.html');
    _controller.future.then((controller) {
      controller.loadUrl(Uri.dataFromString(fileText,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    });
  }
}
