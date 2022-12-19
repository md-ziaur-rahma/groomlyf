import 'package:flutter/material.dart';
import 'package:groomlyfe/models/settings.dart';
import 'package:groomlyfe/util/auth.dart';

class InnerPrivacy extends StatefulWidget {
  final Settings? settings;
  final bool? innercirclePrivacy;
  const InnerPrivacy({Key? key, this.settings, this.innercirclePrivacy})
      : super(key: key);
  @override
  _InnerPrivacyState createState() => _InnerPrivacyState();
}

class _InnerPrivacyState extends State<InnerPrivacy> {
  bool? isPrivacyOn = true;
  final String content =
      "This allows residents to friend residents from your audience";

  @override
  void initState() {
    super.initState();
    isPrivacyOn = widget.innercirclePrivacy;
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
                    "Audience Privacy",
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
                          innerCirclePrivacy: isPrivacyOn,
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
