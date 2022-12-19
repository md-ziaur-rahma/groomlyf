import 'dart:ui';

import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String content;

  CardContent(this.content);

  @override
  Widget build(BuildContext context) {
    // the context of the type in help
    return Text(
      content,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: "phenomena-bold",
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
