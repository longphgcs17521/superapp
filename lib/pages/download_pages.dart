import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superapp/pages/miniapp_pages.dart';

class DownloadAssetsDemo extends StatefulWidget {
  DownloadAssetsDemo() : super();

  final String title = "Download & Extract ZIP Demo";

  @override
  DownloadAssetsDemoState createState() => DownloadAssetsDemoState();
}

class DownloadAssetsDemoState extends State<DownloadAssetsDemo> {
  //
  bool _downloading = false;
  String _dir = "";
  List<String> _images = [], _tempImages = [];
  String _zipPath = 'https://coderzheaven.com/youtube_flutter/images.zip';
  String _localZipFileName = 'images.zip';

  String _zipPath2 =
      'https://drive.google.com/uc?export=download&id=1ikyVAbcbQctwvyjVwz88y9J-Q0siN0sD';
  String _localZipFileName2 = 'Achive.zip';

  getHistoryImageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _images = prefs.getStringList("images");
    });
    // prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _images = [];
    getHistoryImageList();
    _tempImages = [];
    _downloading = false;
    _initDir();
  }

  _initDir() async {
    if (_dir.isEmpty) {
      _dir = (await getApplicationDocumentsDirectory()).path;
      print("init Dir nè: $_dir");
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_dir/$fileName');
    print("file.path ${file.path}");
    var result = file.writeAsBytes(req.bodyBytes);
    return result;
  }

  Future<void> _downloadZip() async {
    setState(() {
      _downloading = true;
    });
    if (_images != null) {
      _images.clear();
    }
    if (_tempImages != null) {
      _tempImages.clear();
    }

    var zippedFile = await _downloadFile(_zipPath2, _localZipFileName2);
    await unarchiveAndSave(zippedFile);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("images", _tempImages);
    setState(() {
      _images = List<String>.from(_tempImages);
      _downloading = false;
    });
  }

  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      print("fileName ${fileName}");
      if (file.isFile && !fileName.contains("__MACOSX")) {
        var outFile = File(fileName);
        print('File Out nèe:: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  buildList() {
    return _images == null || _images.isEmpty
        ? Container(child: Text('Empty'))
        : Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (BuildContext context, int index) {
                return Text('${_images[index]}');
              },
            ),
          );
  }

  progress() {
    return Container(
      width: 25,
      height: 25,
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          _downloading ? progress() : Container(),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              _downloadZip();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            buildList(),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MiniApp()));
                },
                child: Text('Push to mini app'))
          ],
        ),
      ),
    );
  }
}

class DownloadZip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DownloadAssetsDemo(),
    );
  }
}
