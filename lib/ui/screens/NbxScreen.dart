import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/ui/screens/NbxWidget.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';

class NbxScreen extends StatefulWidget {
  final String? init_selected_user_id;

  const NbxScreen({Key? key, this.init_selected_user_id}) : super(key: key);

  @override
  _NbxScreenState createState() => _NbxScreenState();
}

class _NbxScreenState extends State<NbxScreen> {
  TextEditingController _search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(),
            NbxWidget(
              init_selected_user_id: widget.init_selected_user_id,
            ),
          ],
        ),
      ),
    );
  }

  buildAppBar() {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
          ),
          Image.asset(
            "assets/images/nbx.png",
            width: 30,
          ),
          Text(
            "nbx",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'phenomena-bold',
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: deviceWidth * 0.5,
              height: 30,
              child: SimpleAutoCompleteTextField(
                key: GlobalKey<AutoCompleteTextFieldState<String>>(),
                controller: _search_controller,
                suggestions: searchData,
                clearOnSubmit: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "mantserrat-bold"),
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  hintText: "*diy, *hair, ...",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                ),
                submitOnSuggestionTap: true,
                textSubmitted: (text) async {},
              ),
            ),
          ),
          Avatar(user_image_url, user_id, null, context).smallLogoHome(),
        ],
      ),
    );
  }
}
