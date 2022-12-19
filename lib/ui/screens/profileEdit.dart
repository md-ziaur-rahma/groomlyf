import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/ui/widgets/loading.dart';
import 'package:groomlyfe/util/auth.dart';
import 'package:groomlyfe/util/image_picker_handler.dart';
import 'package:groomlyfe/util/profileDataUpdate.dart';
import 'package:groomlyfe/util/storage.dart';
import 'package:groomlyfe/util/validator.dart';

//profile edit screen
class ProfileEdit extends StatefulWidget {
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit>
    with TickerProviderStateMixin, ImagePickerListener {
  File? _image;
  AnimationController? _animationController;
  late ImagePickerHandler imagePicker;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName =
      new TextEditingController(text: "$user_firstname");
  final TextEditingController _lastName =
      new TextEditingController(text: "$user_lastname");
  final TextEditingController _email =
      new TextEditingController(text: "$user_email");

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
    //profile logo update..............
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: ClipOval(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onPressed: () {
              imagePicker.showDialog(context);
            },
            child: Container(
              height: 140.0,
              width: 140.0,
              child: Stack(
                children: <Widget>[
                  _image == null
                      ? new Container(
                          height: 140.0,
                          width: 140.0,
                          decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                          ),
                          child: user_image_url == ""
                              ? Image.asset(
                                  "assets/images/user.png",
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: user_image_url!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : new Container(
                          height: 140.0,
                          width: 140.0,
                          decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                          ),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            height: 140,
                          ),
                        ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: Icon(
                      Icons.camera_alt,
                      size: 25.0,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //first name field..............................
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

    //last name field....................................
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

    //email field ....................................
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      enabled: false,
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

    //sign up button ..........................................................
    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        onPressed: () {
          //profile update
          _profileupdate(
              firstName: _firstName.text,
              lastName: _lastName.text,
              email: _email.text,
              context: context);
        },
        child: Text('UPDATE', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Edit photo",
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      'assets/images/back-login.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  LoadingScreen(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                logo,
                                SizedBox(height: 48.0),
                                firstName,
                                SizedBox(height: 24.0),
                                lastName,
                                SizedBox(height: 24.0),
                                email,
                                SizedBox(height: 24.0),
                                SizedBox(height: 12.0),
                                signUpButton,
                              ],
                            ),
                          ),
                        ),
                      ),
                      inAsyncCall: _loadingVisible),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  //profile upadte............................
  void _profileupdate(
      {String? firstName,
      String? lastName,
      String? email,
      BuildContext? context}) async {
    if (_formKey.currentState!.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        await Storage().uploadFile(_image, user_id).then((photourl) async {
          print(photourl);
          await ProfileUpdate(new User(
            userId: user_id,
            photoUrl: photourl == "" ? user_image_url : photourl,
            firstName: firstName,
            lastName: lastName,
            create_at: user_create_at,
            email: user_email,
          )).update().then((check) {
            if (check) {
              user_image_url = photourl == "" ? user_image_url : photourl;
              print('image');
              print(user_image_url);
              user_firstname = firstName;
              print(user_firstname);
              user_lastname = lastName;
              print(user_lastname);
              Navigator.pop(context!, true);
            }
          });
        });
        //need await so it has chance to go through error if found.
        //now automatically login user too
        //await StateWidget.of(context).logInUser(email, password);
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
