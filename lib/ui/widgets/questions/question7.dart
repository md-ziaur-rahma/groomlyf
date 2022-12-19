import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question8.dart';
import 'package:groomlyfe/util/validator.dart';
import 'package:provider/provider.dart';

class Question7 extends StatefulWidget {
  @override
  _Question7State createState() => _Question7State();
}

class _Question7State extends State<Question7> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool isSubmitted = false;

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question7 != null) {
      _controller.text = glAcademyProvider.question7;
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
          'Enter the URL for that brand',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: "phenomena-bold",
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "phenomena-bold",
                ),
                validator: Validator.validateString(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  hintText: 'Enter brand Url',
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
                  "Submit Brand Url",
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
        if (isSubmitted) Question8()
      ],
    );
  }

  // submit the name of the brand
  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      glAcademyProvider.setQuestion7 = _controller.text.toString();
      isSubmitted = true;
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context)..unfocus();
      setState(() {});
      glAcademyProvider.moveToLastPage();
    }
  }
}
