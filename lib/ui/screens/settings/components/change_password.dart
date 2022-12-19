// change password card
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/screens/settings/components/custom_dialogs.dart';
import 'package:groomlyfe/util/auth.dart';

class ChangePassowrd extends StatefulWidget {
  const ChangePassowrd({Key? key}) : super(key: key);
  @override
  _ChangePassowrdState createState() => _ChangePassowrdState();
}

class _ChangePassowrdState extends State<ChangePassowrd> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

// form key
  final _formKey = GlobalKey<FormState>();

  //status of the password visibilty
  bool obscurePasswordText = true;
  bool obscureConfirmPasswordText = true;

// border comes up when the textfield is in focus
  final focusedBorder = OutlineInputBorder(
    borderRadius: new BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.green, width: 1),
  );

// this border comes on when textfild is not in focus
  final enabledBorder = OutlineInputBorder(
    borderRadius: new BorderRadius.circular(25.0),
    borderSide: BorderSide(color: Colors.black, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                  fontFamily: "phenomena-bold",
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.maxFinite,
                height: 40.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    "change password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                  onPressed: () => _changePassword(context: context),
                ),
              ),
              SizedBox(height: 8.0)
            ],
          ),
        ),
      ),
    );
  }

  // change password function
  void _changePassword({required BuildContext context}) async {
    try {
      CustomDialogs.displayProgressDialog(context);
      //change password request
      final user = FirebaseAuth.instance.currentUser!;
      await Auth.forgotPasswordEmail(user.email!);
      CustomDialogs.closeProgressDialog(context);
      Flushbar(
        title: "Password Reset Email Sent",
        message:
            'Check your email and follow the instructions to change your password.',
        duration: Duration(seconds: 20),
      )..show(context);
    } on Exception catch (e) {
      CustomDialogs.closeProgressDialog(context);
      String exception = Auth.getExceptionText(e);
      Flushbar(
        title: "Forgot Password Error",
        message: exception,
        duration: Duration(seconds: 10),
      )..show(context);
    }
  }
}
