import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/screens/help/help_screen.dart';
import 'package:groomlyfe/ui/screens/profileEdit.dart';
import 'package:groomlyfe/ui/screens/settings/settings_screen.dart';
import 'package:groomlyfe/util/state_widget.dart';

class Tab4 extends StatelessWidget {
  final String? imageurl;
  final String? userCreateAt;
  final String? userid;
  const Tab4(this.imageurl, this.userCreateAt, this.userid);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //edit profile
        Container(
          padding: EdgeInsets.all(3),
          child: userid == userid
              ? InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEdit(),
                      ),
                    );
                  },
                  child: Text(
                    "edit profile",
                    style: TextStyle(
                        fontFamily: "phenomena-bold",
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Text(
                  "edit profile",
                  style: TextStyle(
                      fontFamily: "phenomena-bold",
                      fontSize: 30,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
        ),

        //Settings
        Container(
          padding: EdgeInsets.all(3),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          userId: userid,
                          imageUrl: imageurl,
                        )),
              );
            },
            child: Text(
              "app Settings",
              style: TextStyle(
                  fontFamily: "phenomena-bold",
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        //Help
        Container(
          padding: EdgeInsets.all(3),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(
                    userId: userid,
                    imageUrl: imageurl,
                  ),
                ),
              );
            },
            child: Text(
              "Help",
              style: TextStyle(
                  fontFamily: "phenomena-bold",
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              //Logout.........
              Expanded(
                child: Center(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: InkWell(
                        onTap: () async {
                          print("Logout");
                          await StateWidget.of(context).logOutUser();
                          await Navigator.pushNamedAndRemoveUntil(
                              context, "/signin", (route) => false);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontFamily: "phenomena-bold",
                              fontSize: 34,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //Close Account
              Expanded(
                child: Center(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: InkWell(
                        onTap: () async {},
                        child: Text(
                          "Close Account",
                          style: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
