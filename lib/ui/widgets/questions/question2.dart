import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/screens/settings/components/custom_dialogs.dart';
import 'package:groomlyfe/ui/widgets/questions/question3.dart';
import 'package:groomlyfe/ui/widgets/questions/question4.dart';
import 'package:groomlyfe/ui/widgets/questions/question5.dart';
import 'package:provider/provider.dart';

class Question2 extends StatefulWidget {
  @override
  _Question2State createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  int? index;
  final message =
      '''We understand there are other issues such as Trademarking and Copyright of the brand name. We will discuss this at a later time with the career counselors. 

In the meantime, lets choose our brand name for now.''';
  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question2 != null) {
      index = glAcademyProvider.index2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final glAcademyProvider =
        Provider.of<GlAcademyProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Divider(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question: Do you have a brand?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                fontFamily: "phenomena-bold",
                color: Colors.black,
              ),
            ),
            SizedBox(width: 5.0),
            InkWell(
              child: Icon(
                Icons.help,
                color: Colors.black,
                size: 28.0,
              ),
              onTap: () =>
                  CustomDialogs.dialog(context: context, content: message),
            )
          ],
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
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 1;
                  glAcademyProvider.setQuestion2('YES', 1);
                  setState(() {});
                  glAcademyProvider.moveToLastPage(number: 0.0);
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
                  "NO",
                  style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 0;
                  glAcademyProvider.setQuestion2('NO', 0);
                  setState(() {});
                  glAcademyProvider.moveToLastPage(number: 100);
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
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 2;
                  glAcademyProvider.setQuestion2('SKIP', 2);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                },
              ),
            ),
          ],
        ),
        if (index == 0) Question3(),
        if (index == 1) Question4(),
        if (index == 2) Question5(),
      ],
    );
  }
}
