import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question11.dart';
import 'package:groomlyfe/ui/widgets/questions/question12.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Question9 extends StatefulWidget {
  @override
  _Question9State createState() => _Question9State();
}

class _Question9State extends State<Question9> {
  bool? isSubmitted = false;
  final text1 =
      '''The first step in starting your business is acquiring the E.I.N from the federal government. 
  
  This allows you to start the separation between your personal and business income. 
  
  We suggest you visit the IRS.Gov site to request your EIN.''';

  int? index;
  List<String> list = ["Yes", "No", "Skip"];
  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question9 != null) {
      index = glAcademyProvider.index9;
      isSubmitted = glAcademyProvider.isSubmitted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 50.0),
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
        Column(
          children: <Widget>[
            Text(
              'Question: Do you have E.I.N?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                fontFamily: "phenomena-bold",
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: <Widget>[
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
                      list[0],
                      style: TextStyle(
                        color: index == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "phenomena-bold",
                      ),
                    ),
                    onPressed: () {
                      index = 0;
                      glAcademyProvider.setQuestion9(list[0], 0);
                      setState(() {});
                      glAcademyProvider.moveToLastPage(number: 300);
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
                      list[1],
                      style: TextStyle(
                        color: index == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "phenomena-bold",
                      ),
                    ),
                    onPressed: () {
                      index = 1;
                      glAcademyProvider.setQuestion9(list[1], 1);
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
                      list[2],
                      style: TextStyle(
                        color: index == 2 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "phenomena-bold",
                      ),
                    ),
                    onPressed: () {
                      index = 2;
                      glAcademyProvider.setQuestion9(list[2], 2);
                      setState(() {});
                      glAcademyProvider.moveToLastPage();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.0),
        if (index == 0) Question11(),
        if (index == 1)
          Column(children: [
            Divider(height: 50.0),
            Text(
              'Visit IRS (Internal Revenue Service)',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                fontFamily: "phenomena-bold",
              ),
            ),
            SizedBox(height: 8.0),
            MaterialButton(
              minWidth: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black, width: 3.0),
              ),
              child: Text(
                "IRS SITE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
              ),
              onPressed: () async {
                bool result = await searchURL();
                if (result) {
                  isSubmitted = true;
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                }
              },
            ),
            if (isSubmitted!) Question11(),
          ]),
        if (index == 2) Question12(),
      ],
    );
  }

  Future<bool> searchURL() async {
    const url = 'https://irs.gov/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    glAcademyProvider.isSubmitted = true;
    return true;
  }
}
