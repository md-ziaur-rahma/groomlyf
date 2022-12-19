import 'package:flutter/material.dart';
import 'package:groomlyfe/models/settings.dart';
import 'package:groomlyfe/ui/screens/help/components/profile.dart';
import 'package:groomlyfe/ui/screens/settings/components/change_password.dart';
import 'package:groomlyfe/ui/screens/settings/components/inner_privacy.dart';
import 'package:groomlyfe/ui/screens/settings/components/residential_privacy.dart';
import 'package:groomlyfe/util/auth.dart';

// this code is the setting screen in the app
class SettingsScreen extends StatefulWidget {
  final String? imageUrl;
  final String? userId;
  const SettingsScreen({this.imageUrl, this.userId});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _searchController = TextEditingController();
  Settings? settings;

  @override
  void initState() {
    super.initState();
    getSettingsFromLocal();
  }

// this gets the user settings from the local storage
  void getSettingsFromLocal() async {
    settings = await Auth.getSettingsLocal();
    print(settings!.residentialPrivacy);
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.navigate_before, size: 35.0),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: <Widget>[
              // The profile image
              HelpProfile(
                userId: widget.userId,
                imageUrl: widget.imageUrl,
                isHelp: false,
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // residential privacy
                  ResidentialPrivacy(
                    settings: settings,
                    residentialPrivacy: settings!.residentialPrivacy,
                  ),
                  SizedBox(height: 8.0),
                  // inner circle privacy
                  InnerPrivacy(
                    settings: settings,
                    innercirclePrivacy: settings!.innerCirclePrivacy,
                  ),
                  SizedBox(height: 8.0),
                  // change password button
                  ChangePassowrd(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
