import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/screens/help/components/profile.dart';
import 'package:groomlyfe/ui/screens/help/help_detailed_screen.dart';

// this code displays the help page in the app
class HelpScreen extends StatefulWidget {
  final String? imageUrl;
  final String? userId;
  const HelpScreen({this.imageUrl, this.userId});
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> list = [
    "About GroomLyfe",
    "Terms and conditions",
    "Privacy policy",
    "How we use your data?",
    "FAQ"
  ];

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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            // The profile image
            HelpProfile(
              userId: widget.userId,
              imageUrl: widget.imageUrl,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.all(0.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list
                        .map(
                          (f) => InkWell(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    f,
                                    style: TextStyle(
                                      fontFamily: "phenomena-bold",
                                      fontSize: 26,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Icon(Icons.navigate_next, size: 26.0)
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpDetailScreen(
                                  userId: widget.userId,
                                  imageUrl: widget.imageUrl,
                                  type: f,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
