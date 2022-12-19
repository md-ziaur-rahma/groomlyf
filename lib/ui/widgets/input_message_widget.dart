import 'package:flutter/material.dart';

Future openInputMessageWidget(BuildContext context, String initText) {
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = new FocusNode();
  editingController.text = initText;
  Widget cancelButton = ElevatedButton(
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // padding: EdgeInsets.zero,
    child: Text(
      "Cancel",
      style: TextStyle(
        color: Colors.grey,
        fontFamily: "phenomena-bold",
        fontSize: 20,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = ElevatedButton(
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // padding: EdgeInsets.zero,
    style: ElevatedButton.styleFrom(),
    child: Text(
      "OK",
      style: TextStyle(
        color: Colors.blue,
        fontFamily: "phenomena-bold",
        fontSize: 20,
      ),
    ),
    // splashColor: Colors.blue.withOpacity(.5),
    onPressed: () {
      Navigator.pop(context, editingController.text);
    },
  );

  SimpleDialog alert = SimpleDialog(
    contentPadding: EdgeInsets.all(10),
    children: <Widget>[
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Write the message here.",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "phenomena-bold",
                fontSize: 20,
              ),
            ),
            TextFormField(
              focusNode: focusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              controller: editingController,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "phenomena-bold",
                fontSize: 20,
              ),
              decoration: InputDecoration(
                isDense: true,
                focusColor: Colors.white,
              ),
              onFieldSubmitted: (term) {},
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            cancelButton,
            continueButton,
          ],
        ),
      ),
    ],
  );
  focusNode.requestFocus();
  // show the dialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
