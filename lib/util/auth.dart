import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groomlyfe/models/settings.dart' as gSettings;
import 'package:groomlyfe/models/user.dart' as gUser;
import 'package:shared_preferences/shared_preferences.dart';

//auth
//email login, google login, email sign up, logout, userinfo store firebase&local
enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  //sign up
  static Future<String> signUp(String email, String password) async {
    User user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user!;
    return user.uid;
  }

  //add userinfo to firebase
  static Future addUserSettingsDB(gUser.User user) async {
    var userExist = await checkUserExist(user.userId);

    if (!userExist) {
      print("user ${user.firstName} ${user.email} added");
      await FirebaseFirestore.instance
          .doc("users/${user.userId}")
          .set(user.toJson());

      await FirebaseDatabase.instance
          .ref()
          .child('user')
          .child(user.userId!)
          .set(user.toJson());

      await Auth.storeUserLocal(user);
      _addSettings(gSettings.Settings(
        settingsId: user.userId,
      ));
    } else {
      print("user ${user.firstName} ${user.email} exists");

      await Auth.storeUserLocal(user);
    }
  }

  //user exist check
  static Future<bool> checkUserExist(String? userId) async {
    // var info = await Firestore.instance.document("users/$userId").get();
    try {
      var user = FirebaseFirestore.instance.doc("users").collection("$userId");
      var userExist = (await user.get()).docs.length;
      return userExist > 0;
    } catch (_) {
      return false;
    }
  }

  //add settings to the server
  static void addSettingsToServer(
      {required gSettings.Settings currentSettings,
      bool? residentialPrivacy,
      bool? innerCirclePrivacy}) async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    gSettings.Settings localSettings = currentSettings;
    if (residentialPrivacy != null) {
      localSettings.residentialPrivacy = residentialPrivacy;
    }
    if (innerCirclePrivacy != null) {
      localSettings.innerCirclePrivacy = innerCirclePrivacy;
    }
    String storeSettings = gSettings.settingsToJson(localSettings);
    await prefs1.setString('settings', storeSettings);
    FirebaseFirestore.instance.doc("settings/${localSettings.settingsId}").set(
          localSettings.toJson(),
        );
  }

  //user auth set
  static void _addSettings(gSettings.Settings settings,
      {bool? residentialPrivacy, bool? innerCirclePrivacy}) async {
    FirebaseFirestore.instance.doc("settings/${settings.settingsId}").set(
          settings.toJson(),
        );
  }

  //sign in
  static Future<String> signIn(String email, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return user.user!.uid;
    } catch (e) {
      print("Sign in Error : $e");
    }
    return "xx";
  }

  //get user info from firebase user table
  static Future<gUser.User?> getUserFirestore(String? userId) async {
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then(
              (documentSnapshot) => gUser.User.fromDocument(documentSnapshot));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  //get user auth info from firebase setting table
  static Future<gSettings.Settings?> getSettingsFirestore(
      String? settingsId) async {
    if (settingsId != null) {
      var settingInfo = await FirebaseFirestore.instance
          .collection('settings')
          .doc(settingsId)
          .get();
      return gSettings.Settings.fromDocument(settingInfo);
    } else {
      print('no firestore settings available');
      return null;
    }
  }

  //save userinfo in local
  static Future<String?> storeUserLocal(gUser.User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = gUser.userToJson(user);
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  //save user auth in local
  static Future<String?> storeSettingsLocal(gSettings.Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = gSettings.settingsToJson(settings);
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }

  //getting user from firebase auth
  static Future<User?> getCurrentFirebaseUser() async {
    /*FirebaseUser currentUser = await FirebaseAuth.instance.currentUser().then((value) {
      print('state: vvv ${value==null}');
      return;
    },onError: (e){
      print('state: ee ${e}');
    });*/
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  //getting user info from local
  static Future<gUser.User?> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      gUser.User user = gUser.userFromJson(prefs.getString('user')!);
      //print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  //getting auth info from local
  static Future<gSettings.Settings?> getSettingsLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('settings') != null) {
      gSettings.Settings settings =
          gSettings.settingsFromJson(prefs.getString('settings')!);
      //print('SETTINGS: $settings');
      return settings;
    } else {
      return null;
    }
  }

  //logout
  static Future<void> signOut() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
  }

  //forgot password
  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  /// save FCM token
  //save userinfo in local
  static Future<String> saveFCMNotificationToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeToken = token;
    await prefs.setString('fcmToken', token.isNotEmpty ? token : '');

    /// notification ID
    return storeToken;
  }

  static Future<String?> getFCMNotificationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeToken = prefs.getString('fcmToken');

    /// notification ID
    return storeToken;
  }

  //exception text
  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

/*static Stream<User> getUserFirestore(String userId) {
    print("...getUserFirestore...");
    if (userId != null) {
      //try firestore
      return Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return User.fromDocument(doc);
        }).first;
      });
    } else {
      print('firestore user not found');
      return null;
    }
  }*/

/*static Stream<Settings> getSettingsFirestore(String settingsId) {
    print("...getSettingsFirestore...");
    if (settingsId != null) {
      //try firestore
      return Firestore.instance
          .collection("settings")
          .where("settingsId", isEqualTo: settingsId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return Settings.fromDocument(doc);
        }).first;
      });
    } else {
      print('no firestore settings available');
      return null;
    }
  }*/
}
