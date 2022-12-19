import 'package:flutter/material.dart';

class GlAcademyProvider {
  bool showGLAcademyQuestions = false;
  ScrollController controller = ScrollController();
  void moveToLastPage({double? number}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.animateTo(
          controller.position.maxScrollExtent - (number ?? 20.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      },
    );
  }

  Map? _question1;
  String? answer1;
  int selectTempFirstLevelIndex = 0;
  int selectFirstLevelIndex = 0;
  int selectSecondLevelIndex = -1;

  setQuestion1(Map? value, String ans) {
    _question1 = value;
    answer1 = ans;
  }

  get question1 => _question1;

  // Do you have name for your brand?
  String? _question2;
  int? index2;

  setQuestion2(String value, int index) {
    _question2 = value;
    index2 = index;
    _question3 = null;
    _question4 = null;
    _question5 = null;
  }

  get question2 => _question2;

  // Enter 5 words that describe the brand
  List<String>? _question3;

  set setQuestion3(List<String> value) {
    _question3 = value;
  }

  get question3 => _question3;

// Enter the name of the brand?
  String? _question4;

  set setQuestion4(String value) {
    _question4 = value;
  }

  get question4 => _question4;

  // Do you have url for this brand?
  String? _question5;
  int? index5;

  setQuestion5(String value, int index) {
    _question5 = value;
    index5 = index;
    _question6 = null;
    _question7 = null;
    _question8 = null;
  }

  get question5 => _question5;

  bool? _question6 = false;

  set setQuestion6(bool value) {
    _question6 = value;
  }

  get question6 => _question6;

  // Enter the url?
  String? _question7;

  set setQuestion7(String value) {
    _question7 = value;
  }

  get question7 => _question7;

  //Are you ready to create your brand
  String? _question8;
  int? index8;

  setQuestion8(String value, int index) {
    _question8 = value;
    index8 = index;
    _question9 = null;
  }

  get question8 => _question8;

  // Do you have E.I.N?
  String? _question9;
  int? index9;
  bool? isSubmitted;

  setQuestion9(String value, int index) {
    _question9 = value;
    index9 = index;
  }

  get question9 => _question9;

  void restartQuestion() {
    _question1 = null;
    answer1 = null;
    _question2 = null;
    index2 = null;
    _question3 = null;
    _question4 = null;
    _question5 = null;
    index5 = null;
    _question6 = false;
    _question7 = null;
    _question8 = null;
    index8 = null;
    index9 = null;
    _question9 = null;
  }
}
