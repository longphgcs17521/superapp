import 'package:flutter/material.dart';
import 'package:superapp/miniapp/view_layer/renderer.dart';

class MiniApp extends StatelessWidget {
  const MiniApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini App'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Renderer(url: 'anything');
        },
      ),
    );
  }
}
