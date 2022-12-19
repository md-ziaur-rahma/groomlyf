import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question5.dart';
import 'package:groomlyfe/util/validator.dart';
import 'package:provider/provider.dart';

class Question4 extends StatefulWidget {
  @override
  _Question4State createState() => _Question4State();
}

class _Question4State extends State<Question4> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool isSubmitted = false;
  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question4 != null) {
      _controller.text = glAcademyProvider.question4;
      isSubmitted = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 50.0),
        Text(
          'Question: What is the name of the brand?',
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
                controller: _controller,
                validator: Validator.validateString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: 'Enter brand name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
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
                  "Submit Brand Name",
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
        if (isSubmitted) Question5()
      ],
    );
  }

  // submit the name of the brand
  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      glAcademyProvider.setQuestion4 = _controller.text.toString();
      isSubmitted = true;
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context)..unfocus();
      setState(() {});
      glAcademyProvider.moveToLastPage();
    }
  }
}
