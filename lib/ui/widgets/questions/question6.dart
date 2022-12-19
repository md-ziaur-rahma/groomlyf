import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question8.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Question6 extends StatefulWidget {
  @override
  _Question6State createState() => _Question6State();
}

class _Question6State extends State<Question6> {
  bool? isSubmitted = false;
  final text1 =
      'This is the most critical step because best business models URL’s match the Name of BRAND';
  final text2 =
      'Congrats on securing your domain, its just the first step to financial freedom.';

  final text3 = """Don't worry the GL Counselor will help you pick a domain.
When you are Ready to continue select below.
  """;
  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question6 != null) {
      isSubmitted = glAcademyProvider.question6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Divider(height: 50.0),
          Text(
            text3,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "phenomena-bold",
            ),
          ),
          /*  Text(
            text1,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "phenomena-bold",
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            'Search for domain url on GoDaddy',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          MaterialButton(
            minWidth: 250.0,
            color: Colors.purple,
            shape: StadiumBorder(),
            child: Text(
              "DOMAIN SEARCH",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              bool result = await searchURL();
              if (result) {
                isSubmitted = true;
                setState(() {});
              }
            },
          ),
          SizedBox(height: 16.0),
          if (isSubmitted == true)
            Column(
              children: [
                Text(
                  text2,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16.0),
                Question7()
              ],
            ) */
          Question8()
        ],
      ),
    );
  }

  Future<bool> searchURL() async {
    const url = 'https://godaddy.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    glAcademyProvider.setQuestion6 = true;
    glAcademyProvider.moveToLastPage();
    return true;
  }
}
