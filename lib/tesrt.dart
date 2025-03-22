import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CKEditor Mention with Profile Images'),
        ),
        body: const WebViewExample(),
      ),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  late String _localFilePath;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    // Get the temporary directory path
    final directory = await getTemporaryDirectory();
    final tempPath = directory.path;

    // Copy the HTML file from assets to the temporary directory
    final byteData = await rootBundle.load('assets/editor.html');
    final file = File('$tempPath/editor.html');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // Set the local file path for WebView
    setState(() {
      _localFilePath = 'file://$tempPath/editor.html';
    });
  }

  @override
  Widget build(BuildContext context) {
    // If the file path is not yet set, return a loading indicator
    if (_localFilePath.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(
      controller: WebViewController()
        ..loadRequest(Uri.parse(_localFilePath)), // Load the local HTML file
    );
  }
}
