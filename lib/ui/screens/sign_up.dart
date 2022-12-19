import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/notification/notification_service.dart';
import 'package:groomlyfe/ui/screens/terms_screen.dart';
import 'package:groomlyfe/ui/widgets/loading.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:groomlyfe/util/auth.dart';
import 'package:groomlyfe/util/image_picker_handler.dart';
import 'package:groomlyfe/util/storage.dart';
import 'package:groomlyfe/util/validator.dart';

//sign up screen...........................................
class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  File? _image;
  AnimationController? _animationController;
  late ImagePickerHandler imagePicker;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool? _terms = false;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _animationController);
    imagePicker.init();
    super.initState();
  }

  Widget build(BuildContext context) {
    //logo avatar........image picker..............
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black, width: 3.0),
                  ),
                ),
            onPressed: () {
              //image picker......................................
              imagePicker.showDialog(context);
            },
            child: _image == null
                ? Container(
                    child: Icon(
                      Icons.photo_camera,
                      size: 80,
                      color: Colors.blueGrey,
                    ),
                    padding: EdgeInsets.all(20),
                  )
                : new Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                    ),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                  ),
          ))),
    );

    //firstName field......................
    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //lastName field......................................
    final lastName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //email field.........................................
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //password field......................................
    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    //signup button........................................
    final signUpButton = Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black, width: 3.0),
          ),
        ),
        onPressed: () {
          String _create_at =
              formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
          _emailSignUp(
              firstName: _firstName.text,
              lastName: _lastName.text,
              email: _email.text,
              password: _password.text,
              create_at: _create_at,
              context: context);
        },
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
      ),
    );

    final signInLabel = ElevatedButton(
      child: Text(
        'Already have an Account? Sign In.',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.0,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signin');
      },
    );

    final terms = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: _terms,
          onChanged: (value) {
            setState(() {
              _terms = value;
            });
          },
        ),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14.0,
            ),
            children: [
              TextSpan(
                text: 'I accept the ',
              ),
              WidgetSpan(
                  child: InkWell(
                child: Text(
                  'Terms and Conditions and Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 14.0,
                  ),
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsScreen())),
              ))
            ],
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/back-login.png',
              fit: BoxFit.fill,
            ),
          ),
          LoadingScreen(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                logo,
                                SizedBox(height: 40.0),
                                firstName,
                                SizedBox(height: 16.0),
                                lastName,
                                SizedBox(height: 16.0),
                                email,
                                SizedBox(height: 16.0),
                                password,
                                signInLabel,
                              ],
                            ),
                          ),
                          terms,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: signUpButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              inAsyncCall: _loadingVisible),
        ],
      ),
    );
  }

  //loading action
  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  //sing up function...............................
  void _emailSignUp(
      {String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? create_at,
      BuildContext? context}) async {
    if (_formKey.currentState!.validate()) {
      if (_terms!) {
        try {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          await _changeLoadingVisible();
          //need await so it has chance to go through error if found.
          await Auth.signUp(email!, password!).then((uID) {
            Storage().uploadFile(_image, uID).then((photourl) async {
              NotificationService service = NotificationService();
              final notId = await service.getPlayerId();
              // add user to firebase
              Auth.addUserSettingsDB(new User(
                userId: uID,
                photoUrl: photourl,
                email: email,
                firstName: firstName,
                lastName: lastName,
                create_at: create_at,
                notificationId: notId,
              ));
            });
          });
          //now automatically login user too
          //await StateWidget.of(context).logInUser(email, password);
          _changeLoadingVisible();
          Flushbar(
            title: "Sign Up Feedback",
            message: "Successfully Created User. Please login..",
            duration: Duration(seconds: 3),
          )..show(context!);
          Future.delayed(const Duration(seconds: 3)).then((value) async {
            await Navigator.pushNamed(context, '/signin');
          });
        } on Exception catch (e) {
          _changeLoadingVisible();
          print("Sign Up Error: $e");
          String exception = Auth.getExceptionText(e);
          Flushbar(
            title: "Sign Up Error",
            message: exception,
            duration: Duration(seconds: 5),
          )..show(context!);
        }
      } else {
        ToastShow("Please accept the Terms and Conditions and Privacy Policy",
                context, Colors.red)
            .init();
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
