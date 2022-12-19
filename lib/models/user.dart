import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

//user info class
User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String? userId;
  String? photoUrl;
  String? firstName;
  String? lastName;
  String? email;
  String? create_at;
  String? notificationId;
  int? timeStamp;

  User({
    this.userId,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.email,
    this.notificationId,
    this.create_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
      userId: json["userId"],
      photoUrl: json["photoUrl"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      notificationId: json['notificationId'] ?? '',
      create_at: json["create_at"]);

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "photoUrl": photoUrl,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "create_at": create_at,
      'notificationId': notificationId,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return User.fromJson(data!);
  }
}
