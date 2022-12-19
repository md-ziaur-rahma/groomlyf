import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/widgets/questions/dropdown/submit_button.dart';

class Question13 extends StatelessWidget {
  final text3 =
      '''A GL career counselor works with users to change their life. Are you looking to speak with someone to get your ideas together?
      
Connect me with a GL Counselor.''';

  final text4 =
      '''Congratulations, you have taken the initial steps in Power to becoming a boss. **BossBoss

Next, a GL Career Counselor will reach out in 3-4 business days to via you NBX, Once you receive a message via the NBX chat please respond with your earliest time you are available to chat. 

Stay tuned the best is yet to come''';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text3,
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
          text4,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.green,
          ),
        ),
        SubmitQuestion(),
      ],
    );
  }
}
