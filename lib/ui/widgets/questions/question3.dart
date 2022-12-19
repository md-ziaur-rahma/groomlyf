import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/screens/settings/components/custom_dialogs.dart';
import 'package:groomlyfe/ui/widgets/questions/dropdown/submit_button.dart';
import 'package:groomlyfe/ui/widgets/questions/question4.dart';
import 'package:groomlyfe/util/validator.dart';
import 'package:provider/provider.dart';

class Question3 extends StatefulWidget {
  @override
  _Question3State createState() => _Question3State();
}

class _Question3State extends State<Question3> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();

  final _focus1 = FocusNode();
  final _focus2 = FocusNode();
  final _focus3 = FocusNode();
  final _focus4 = FocusNode();
  final _focus5 = FocusNode();

  String text = '''	

That’s totally ﬁne, we can come up with one later. For some companies it can take over 3 months to ﬁnd the perfect name, but don’t worry…we got you.

No problem, we understand how tough it can be when you want to get your idea oﬀ the ground. 

Don’t worry, we will have a GL counselor to reach out to the and we will work through these issues with you to make sure you are a BOSS !!!
''';

  final text2 = 'Great, see it wasn’t that hard was it? ';

  final text3 = 'Were you able to find the perfect name for your brand yet?';
  final text0 =
      'Ok that sucks but lets see if we can come up with a few names  ';
  final message =
      'Most companies have a brand name, we are looking for you to enter a name that you feel would best represent your brand idea';

  int? clicked;

  bool isSubmitted = false;

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question3 != null) {
      List list = glAcademyProvider.question3;
      for (int i = 0; i < list.length; i++) {
        addData(list[i], i);
      }
      isSubmitted = true;
    }
  }

  void addData(String value, int index) {
    switch (index) {
      case 0:
        _controller1.text = value;
        break;
      case 1:
        _controller2.text = value;
        break;
      case 2:
        _controller3.text = value;
        break;
      case 3:
        _controller4.text = value;
        break;
      case 4:
        _controller5.text = value;
        break;
      default:
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 50.0),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text0,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "phenomena-bold",
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: Container(
                  padding: EdgeInsets.only(left: 3.0),
                  child: InkWell(
                    child: Icon(
                      Icons.help,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    onTap: () => CustomDialogs.dialog(
                        context: context, content: message),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 24.0),
        Text(
          'Enter 5 words that best describe your brand',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.0),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller1,
                focusNode: _focus1,
                textInputAction: TextInputAction.next,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: 'Description 1',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_focus2),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controller2,
                focusNode: _focus2,
                textInputAction: TextInputAction.next,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  hintText: 'Description 2',
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_focus3),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controller3,
                focusNode: _focus3,
                textInputAction: TextInputAction.next,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(),
                  hintText: 'Description 3',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_focus4),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controller4,
                focusNode: _focus4,
                textInputAction: TextInputAction.next,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(),
                  hintText: 'Description 4',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_focus5),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controller5,
                focusNode: _focus5,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(),
                  hintText: 'Description 5',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                minWidth: double.maxFinite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black, width: 3.0),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: "phenomena-bold",
                  ),
                ),
                onPressed: onSubmit,
              )
            ],
          ),
        ),
        SizedBox(height: 32.0),
        if (isSubmitted)
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    text2,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    text3,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: clicked == 1 ? Colors.black : Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.black, width: 3.0),
                            ),
                          ),
                          child: Text(
                            "YES",
                            style: TextStyle(
                              color: clicked == 1 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: "phenomena-bold",
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              clicked = 1;
                            });
                            glAcademyProvider.moveToLastPage();
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: clicked == 0 ? Colors.black : Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.black, width: 3.0),
                              ),
                            ),
                            child: Text(
                              "NO",
                              style: TextStyle(
                                color:
                                    clicked == 0 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: "phenomena-bold",
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                clicked = 0;
                              });
                              glAcademyProvider.moveToLastPage();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              if (clicked == 0)
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: "phenomena-bold",
                  ),
                ),
              if (clicked == 0) SubmitQuestion(),
            ],
          ),
        SizedBox(height: 32.0),
        if (clicked == 1) Question4()
      ],
    );
  }

  // submit the name of the brand
  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      isSubmitted = true;
      List<String> list = [];
      list.add(_controller1.text);
      list.add(_controller2.text);
      list.add(_controller3.text);
      list.add(_controller4.text);
      list.add(_controller5.text);
      glAcademyProvider.setQuestion3 = list;
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context)..unfocus();
      setState(() {});
      glAcademyProvider.moveToLastPage();
    }
  }
}
