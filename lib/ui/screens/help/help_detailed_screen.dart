import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:groomlyfe/ui/screens/help/components/card_content.dart';
import 'package:groomlyfe/ui/screens/help/components/profile.dart';
import 'package:groomlyfe/ui/screens/help/privacy.dart';
import 'package:groomlyfe/ui/screens/help/terms.dart';

// this code displays the help page in the app
class HelpDetailScreen extends StatefulWidget {
  final String? imageUrl;
  final String? userId;
  final String? type;
  const HelpDetailScreen({this.imageUrl, this.userId, this.type});
  @override
  _HelpDetailScreenState createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  TextEditingController _searchController = TextEditingController();

  Widget content = Container();

  @override
  void initState() {
    super.initState();

    selectType();
  }

  void selectType() {
    setState(() {
      switch (widget.type) {
        case 'About GroomLyfe':
          content = CardContent("YOU ARE NOW A RESIDENT!");
          break;
        case 'Terms and conditions':
          content = Container(
            child: HtmlWidget(
              terms,
            ),
          );
          break;
        case 'Privacy policy':
          content = Container(
            child: HtmlWidget(
              privacy,
            ),
          );
          break;
        case 'How we use your data?':
          content = CardContent(
              "None of your data is used besides feedback for our launch!");

          break;
        case 'FAQ':
          content = CardContent("Check back later");
          break;
        default:
          content = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.navigate_before, size: 35.0),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: <Widget>[
                  // The profile image
                  HelpProfile(
                    userId: widget.userId,
                    imageUrl: widget.imageUrl,
                  ),
                  SizedBox(height: 16.0),
                  // The card
                  Expanded(
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.all(0.0),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Help type title e.g FAQ
                              Text(
                                widget.type!,
                                style: TextStyle(
                                  fontFamily: "phenomena-bold",
                                  fontSize: 26,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              content
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
