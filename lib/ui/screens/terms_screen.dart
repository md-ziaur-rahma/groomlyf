import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:groomlyfe/ui/screens/help/terms.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: GestureDetector(
          child: Icon(
            Icons.navigate_before,
            size: 35.0,
            color: Colors.black,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          "Terms and Conditions and Privacy Policy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
//          maxLines: 1,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: HtmlWidget(
              terms,
            ),
          ),
        ),
      ),
    );
  }
}
