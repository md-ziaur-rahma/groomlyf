import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/dropdown/submit_button.dart';
import 'package:groomlyfe/ui/widgets/questions/question9.dart';
import 'package:provider/provider.dart';

class Question8 extends StatefulWidget {
  @override
  _Question8State createState() => _Question8State();
}

class _Question8State extends State<Question8> {
  int? index;

  final text2 =
      'Reminder: Creating your brand is important because you are placing your work in front of a global audience.';

  final text3 =
      'Ok I understand lets get you to a GL career counselor for some support. A career counselor with reach out to you via your NBX in 3-5 business days.';

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question8 != null) {
      index = glAcademyProvider.index8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 50.0),
        Text(
          text2,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  "I'm not ready yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 0;
                  glAcademyProvider.setQuestion8("I'm not ready yet", 0);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                },
              ),
            ),
            SizedBox(width: 16.0),
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
                  "I'm ready",
                  style: TextStyle(
                    color: index == 1 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: () {
                  index = 1;
                  glAcademyProvider.setQuestion8("I'm ready", 1);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                },
              ),
            )
          ],
        ),
        if (index == 0) Divider(height: 50.0),
        if (index == 0)
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
        if (index == 0) SubmitQuestion(),
        if (index == 1) Question9(),
      ],
    );
  }
}
