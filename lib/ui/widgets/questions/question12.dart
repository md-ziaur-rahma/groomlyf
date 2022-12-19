import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/widgets/questions/question13.dart';

class Question12 extends StatefulWidget {
  @override
  _Question12State createState() => _Question12State();
}

class _Question12State extends State<Question12> {
  bool? isReady;
  final text1 =
      'Your career counselor will discuss with you options for completing your business setup.';

  final text2 = 'We noticed that you didn’t complete the EIN.';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 50.0),
        Text(
          text2,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          text1,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.0),
        Question13(),
      ],
    );
  }
}
