import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:provider/provider.dart';

class SubmitQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: MaterialButton(
        height: 50.0,
        minWidth: double.maxFinite,
        color: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "Submit Questions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: "phenomena-bold",
            color: Colors.white,
          ),
        ),
        onPressed: () => submitAnswers(context),
      ),
    );
  }

  submitAnswers(BuildContext context) async {
    final glAcademyProvider =
        Provider.of<GlAcademyProvider>(context, listen: false);
    Map<String, dynamic> myAnswers = {
      'What Grooming Industry would you like to become a boss in?':
          glAcademyProvider.question1,
      'Do you have name for your Brand?': glAcademyProvider.question2,
      'Enter 5 words that describe the brand': glAcademyProvider.question3,
      'Enter the name of the brand?': glAcademyProvider.question4,
      'Do you have url for this brand?': glAcademyProvider.question5,
      'Enter the url': glAcademyProvider.question7,
      'Are you ready to create your brand?': glAcademyProvider.question8,
      'Do you have E.I.N?': glAcademyProvider.question9,
    };
    print(myAnswers);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        glAcademyProvider.showGLAcademyQuestions = false;
        await FirebaseFirestore.instance
            .collection('glAcademy')
            .doc(user.uid)
            .delete();
        await FirebaseFirestore.instance
            .collection('glAcademy')
            .doc(user.uid)
            .set(myAnswers);

        Flushbar flush = Flushbar(
          title: "GL Academy",
          message: "Submission Successful",
          backgroundColor: Colors.green,
          duration: Duration(seconds: 10),
        );
        await flush.show(context);
      } else {
        Flushbar(
          title: "GL Academy",
          message: 'Please Sign in',
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 6),
        )..show(context);
      }
    } catch (e) {
      print(e);
      Flushbar(
        title: "GL Academy",
        message: 'Error Encountered. Please try again',
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 6),
      )..show(context);
    }
  }
}
