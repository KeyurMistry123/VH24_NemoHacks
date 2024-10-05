import 'package:flutter/material.dart';
// ignore: unused_import'; // Add this import
import 'package:webview_flutter/webview_flutter.dart'; // Add this import

class StreamlitWebView3 extends StatefulWidget {
  const StreamlitWebView3({super.key});
  @override
  _StreamlitWebView3State createState() => _StreamlitWebView3State();
}

class _StreamlitWebView3State extends State<StreamlitWebView3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Trend Analysis'),
      ),
      body: const WebView(
        initialUrl: "https://appapp-c2hjhg7xt2we8tkgereudk.streamlit.app/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}