import 'package:flutter/material.dart';
import 'package:groomlyfe/models/settings.dart';
import 'package:groomlyfe/util/auth.dart';

class ResidentialPrivacy extends StatefulWidget {
  final Settings? settings;
  final bool? residentialPrivacy;
  const ResidentialPrivacy({Key? key, this.settings, this.residentialPrivacy})
      : super(key: key);
  @override
  _ResidentialPrivacyState createState() => _ResidentialPrivacyState();
}

class _ResidentialPrivacyState extends State<ResidentialPrivacy> {
  bool? isPrivacyOn;
  final String content =
      "Determine what residents see. Disabling this allows residents to see your posted contents.";

  @override
  void initState() {
    super.initState();
    isPrivacyOn = widget.residentialPrivacy;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Residential Privacy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      fontFamily: "phenomena-bold",
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      isPrivacyOn! ? "On" : "Off",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "phenomena-bold",
                        color: Colors.black,
                      ),
                    ),
                    Switch(
                      value: isPrivacyOn!,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          isPrivacyOn = value;
                        });
                        Auth.addSettingsToServer(
                          currentSettings: widget.settings!,
                          residentialPrivacy: isPrivacyOn,
                        );
                      },
                    )
                  ],
                )
              ],
            ),
            Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "phenomena-bold",
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            if (isPrivacyOn!)
              Text(
                "Profile Privacy On",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "phenomena-bold",
                  color: Colors.green,
                ),
              ),
            SizedBox(height: 8.0)
          ],
        ),
      ),
    );
  }
}
