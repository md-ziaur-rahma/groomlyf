import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question6.dart';
import 'package:groomlyfe/ui/widgets/questions/question7.dart';
import 'package:groomlyfe/ui/widgets/questions/question8.dart';
import 'package:provider/provider.dart';

class Question5 extends StatefulWidget {
  @override
  _Question5State createState() => _Question5State();
}

class _Question5State extends State<Question5> {
  int? index;

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question5 != null) {
      index = glAcademyProvider.index5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 50.0),
        Text(
          'Question: Do you have a url for this brand?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: index == 1 ? Colors.black : Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black, width: 3.0),
                  ),
                ),
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: index == 1 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 1;
                  glAcademyProvider.setQuestion5('YES', 1);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                },
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: index == 0 ? Colors.black : Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black, width: 3.0),
                  ),
                ),
                child: Text(
                  "No",
                  style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 0;
                  glAcademyProvider.setQuestion5('NO', 0);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                },
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: index == 2 ? Colors.black : Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black, width: 3.0),
                    ),
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: index == 2 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                  onPressed: () {
                    index = 2;
                    glAcademyProvider.setQuestion5('SKIP', 2);
                    setState(() {});
                    glAcademyProvider.moveToLastPage();
                  }),
            ),
          ],
        ),
        if (index == 0) Question6(),
        if (index == 1) Question7(),
        if (index == 2) Question8(),
      ],
    );
  }
}
