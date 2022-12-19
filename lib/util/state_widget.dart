import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/settings.dart';
import 'package:groomlyfe/models/state.dart';
import 'package:groomlyfe/models/user.dart' as gUser;
import 'package:groomlyfe/util/auth.dart';

//sign in authorization class
class StateWidget extends StatefulWidget {
  final StateModel? state;
  final Widget child;

  StateWidget({
    required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>()!
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel? state;
  bool google_sign_in_check = false;

  //GoogleSignInAccount googleAccount;
  //final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    google_sign_in_check = false;
    if (widget.state != null) {
      state = widget.state;
      print('state: 0 ${state}');

    } else {
      print('state: 1 ${state}');
      state = new StateModel(isLoading: true);

      initUser();
    }
  }

  Future<Null> initUser() async {
    print('...initUser...');
    User? firebaseUserAuth = await Auth.getCurrentFirebaseUser();
    if(firebaseUserAuth==null){
      setState(() {
        state!.isLoading = false;
      });
    }
        /* FirebaseUser firebaseUserAuth = await Auth.getCurrentFirebaseUser().then((value) {
      print('state: v ${value==null} ');

      setState(() {
        state.isLoading = false;
      });


    },onError: (e){
      print('state: e ${e}');
    });*/
    gUser.User? user;
    print('state: firebaseUserAuth ${firebaseUserAuth!.uid}');
    if (google_sign_in_check) {

      String _create_at = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
      user = gUser.User(
          userId: firebaseUserAuth.uid,
          photoUrl: firebaseUserAuth.photoURL,
          email: firebaseUserAuth.email,
          firstName: firebaseUserAuth.displayName!.split(" ")[0],
          lastName: firebaseUserAuth.displayName!.split(" ").length > 1
              ? firebaseUserAuth.displayName!.split(" ")[1]
              : "",
          create_at: _create_at);
    } else {
      user = await Auth.getUserLocal();
    }
    print('state: 2 ${state}');

    Settings? settings = await Auth.getSettingsLocal();
    setState(() {
      state!.isLoading = false;
      state!.firebaseUserAuth = firebaseUserAuth;
      state!.user = user;
      state!.settings = settings;
    });
    google_sign_in_check = false;
    print('state: 3 ${state}');
  }

  Future<void> logOutUser() async {
    await Auth.signOut();
    User? firebaseUserAuth = await Auth.getCurrentFirebaseUser();

    user_id = null;
    user_email = null;
    user_image_url = "";
    user_firstname = null;
    user_lastname = null;
    user_create_at = null;
    state!.user = null;
    state!.settings = null;
    state!.firebaseUserAuth = firebaseUserAuth;
  }

  Future<void> logInUser(email, password) async {
    String userId = await Auth.signIn(email, password);
    if (userId != "xx") {
      gUser.User? user = await Auth.getUserFirestore(userId);
      if (user != null) {
        await Auth.storeUserLocal(user);
        Settings? settings = await Auth.getSettingsFirestore(userId);
        await Auth.storeSettingsLocal(settings!);
        await initUser();
      }
    }
  }

// Sign in with Google
  Future<User?> signInGoogle() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = authResult.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> googleSignIn() async {
    var user = await signInGoogle();
    if (user != null) {
      print(user.displayName);
      var userNew = gUser.User(
        userId: user.uid,
        photoUrl: user.photoURL,
        email: user.email,
        firstName: user.displayName!.split(" ")[0],
        lastName: user.displayName!.split(" ").length > 1
            ? user.displayName!.split(" ")[1]
            : "",
      );

      await Auth.addUserSettingsDB(userNew);

      // Settings settings = await (Auth.getSettingsFirestore(user_new.userId) as FutureOr<Settings>);
      Settings? settings = await Auth.getSettingsFirestore(userNew.userId);
      await Auth.storeSettingsLocal(settings!);
      google_sign_in_check = true;
      await initUser();
    } else {
      print("google singin error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
