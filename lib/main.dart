import 'package:flutter/material.dart';
import 'package:superapp/pages/download_pages.dart';
import 'package:superapp/pages/miniapp_pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperApp PoC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SuperApp PoC', test: 'XXX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.test}) : super(key: key);

  final String title;
  final String test;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          TextButton(
              onPressed: () {
                print('nothing');
              },
              child: Text('Nothing')),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DownloadZip()));
              },
              child: Text('DownloadZip')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MiniApp()));
              },
              child: Text('Push to mini app'))
        ],
      ),
    );
  }
}
