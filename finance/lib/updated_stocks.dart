import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamlitWebView2 extends StatefulWidget {
  final String riskprofile;
  const StreamlitWebView2({super.key, required this.riskprofile});

  @override
  _StreamlitWebView2State createState() => _StreamlitWebView2State();
}

class _StreamlitWebView2State extends State<StreamlitWebView2> {
  late String riskProfile = widget.riskprofile;
  late String url;

  @override
  void initState() {
    super.initState();
    setStockUrl(); // Call the method to set the URL
  }

  void setStockUrl() {
    if (riskProfile == "Conservative (Low-risk Investor)") {
      url = "https://appstockprice-csrizornyvod86erguuis6.streamlit.app/";
    } else if (riskProfile == "Moderate (Medium-risk Investor)") {
      url = "https://appstockprice-fye89ibqmjcpqddzkxigcx.streamlit.app/";
    } else if (riskProfile == "Aggressive (High-risk Investor)") {
      url = "https://appstockprice-x4jxxxnakrwqcvka2wjeqb.streamlit.app/";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks For You'),
      ),
      body: WebView(
        initialUrl: url, // Use the dynamically set URL
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}