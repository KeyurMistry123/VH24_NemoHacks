import 'package:flutter/material.dart';
// ignore: unused_import'; // Add this import
import 'package:webview_flutter/webview_flutter.dart'; // Add this import

class StreamlitWebView2 extends StatefulWidget {
  @override
  _StreamlitWebView2State createState() => _StreamlitWebView2State();
}

class _StreamlitWebView2State extends State<StreamlitWebView2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Recommendation'),
      ),
      body: const WebView(
        initialUrl: "https://appnews-a35ukjdaqqpgt2btgncpcn.streamlit.app/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
