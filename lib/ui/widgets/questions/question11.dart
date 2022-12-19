import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/screens/settings/components/custom_dialogs.dart';
import 'package:groomlyfe/ui/widgets/questions/question14.dart';
import 'package:url_launcher/url_launcher.dart';

class Question11 extends StatefulWidget {
  @override
  _Question11State createState() => _Question11State();
}

class _Question11State extends State<Question11> {
  int? index;

  final text2 =
      'Choosing a legal structure to build your company foundation is a tough decision, we would suggest you reach out to a tax attorney or lawyer to discuss your options for correctly starting a business.';

  final text1 = 'We suggest that you choose a legal entity.';

  final text3 =
      'At the time you speak with your legal counselor, they will let you know about your local state options for incorporating.';

  final text4 =
      'Business banking allow you to separate your personal and business finances.';
  final message = '''Some company structures would be

Sole Proprietorship
S- Corporation
C - Corp
LLC - Limited Liability Company ''';

  final chaseURL = 'https://www.chase.com/business';
  final fiveThirdURL =
      'https://www.53.com/content/fifth-third/en/business-banking.html';
  final bmoURL = 'https://www.bmoharris.com/main/business-banking';
  final bofaURL = 'https://www.bankofamerica.com/smallbusiness';

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        SizedBox(height: 24.0),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: [
              TextSpan(
                text: text2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "phenomena-bold",
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: Container(
                  padding: EdgeInsets.only(left: 3.0),
                  child: InkWell(
                    child: Icon(
                      Icons.help,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    onTap: () => CustomDialogs.dialog(
                        context: context, content: message),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          "(GroomLyfe Academy does not offer legal advice)",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 30.0),
        Text(
          'Legal Structure & Business Banking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 24.0),
        Text(
          'Legal Structure',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
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
        SizedBox(height: 24.0),
        Text(
          'Business Banking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          text4,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 24.0),
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/bank1.png',
                    height: 130.0,
                    width: 150.0,
                  ),
                ),
                onTap: () async => await searchURL(chaseURL),
              ),
              SizedBox(width: 16.0),
              InkWell(
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/bank2.png',
                    height: 130.0,
                    width: 150.0,
                  ),
                ),
                onTap: () async => await searchURL(bofaURL),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/bank3.png',
                    height: 130.0,
                    width: 150.0,
                  ),
                ),
                onTap: () async => await searchURL(bmoURL),
              ),
              SizedBox(width: 16.0),
              InkWell(
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/bank4.png',
                    height: 130.0,
                    width: 150.0,
                  ),
                ),
                onTap: () async => await searchURL(fiveThirdURL),
              ),
            ],
          ),
        ),
        Question14(),
      ],
    );
  }

  Future<bool> searchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    glAcademyProvider.isSubmitted = true;
    return true;
  }
}
