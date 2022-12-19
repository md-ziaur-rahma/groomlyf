import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/dropdown/submit_button.dart';
import 'package:provider/provider.dart';

class Question14 extends StatefulWidget {
  @override
  _Question14State createState() => _Question14State();
}

class _Question14State extends State<Question14> {
  final text1 =
      'At the time you speak with your counselor, they will let you know about your local state options for incorporating.';
  final text2 =
      'A GL career counselor works with users that wish to bank in business name and will even explain the process of opening an bank account for your new company';

  final text3 =
      '''Congratulations, you have taken the initial steps in Power to becoming a boss. **BossBoss

Next, a GL Career Counselor will reach out in 3-4 business days to via you NBX, Once you receive a message via the NBX chat please respond with your earliest time you are available to chat.

Stay tuned the best is yet to come''';

  bool isClicked1 = false;
  bool isClicked2 = false;
  bool isClicked3 = false;
  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30.0),
        MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          minWidth: double.maxFinite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black, width: 3.0),
          ),
          child: Text(
            "I'm Ready to be a Boss",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: "phenomena-bold",
              color: Colors.black,
            ),
          ),
          onPressed: () {
            isClicked3 = true;
            setState(() {});
            glAcademyProvider.moveToLastPage();
          },
        ),
        if (isClicked3) Divider(height: 50.0),
        if (isClicked3)
          Text(
            text3,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "phenomena-bold",
              color: Colors.green,
            ),
          ),
        if (isClicked3) SubmitQuestion(),
      ],
    );
  }
}
