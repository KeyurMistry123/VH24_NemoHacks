import 'package:flutter/material.dart';
// ignore: unused_import'; // Add this import
import 'package:webview_flutter/webview_flutter.dart'; // Add this import

class StreamlitWebView4 extends StatefulWidget {
  @override
  _StreamlitWebView4State createState() => _StreamlitWebView4State();
}

class _StreamlitWebView4State extends State<StreamlitWebView4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock News For You'),
      ),
      body: const WebView(
        initialUrl: "https://appnews-a35ukjdaqqpgt2btgncpcn.streamlit.app/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}