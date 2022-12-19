import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:groomlyfe/models/settings.dart';
import 'package:groomlyfe/models/user.dart';

//login authorization

class StateModel {
  bool isLoading;
  firebase.User? firebaseUserAuth;
  User? user;
  Settings? settings;
  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
