import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// To parse this JSON data, do
//
//     final settings = settingsFromJson(jsonString);

//login authorization
Settings settingsFromJson(String str) {
  final jsonData = json.decode(str);
  return Settings.fromJson(jsonData);
}

String settingsToJson(Settings data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Settings {
  String? settingsId;
  bool? residentialPrivacy;
  bool? innerCirclePrivacy;

  Settings({
    this.settingsId,
    this.residentialPrivacy,
    this.innerCirclePrivacy,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => new Settings(
        settingsId: json["settingsId"],
        residentialPrivacy: json["residentialprivacy"] ?? true,
        innerCirclePrivacy: json["innercircleprivacy"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "settingsId": settingsId,
        "residentialprivacy": residentialPrivacy ?? true,
        "innercircleprivacy": innerCirclePrivacy ?? true,
      };

  factory Settings.fromDocument(DocumentSnapshot doc) {
    return Settings.fromJson((doc.data() as Map<String, dynamic>?)!);
  }
}
