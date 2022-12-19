import 'package:flutter/material.dart';

Future onOpenEditComment(BuildContext context, String initText) {
  TextEditingController commentTextController = new TextEditingController();
  FocusNode focus = new FocusNode();
  commentTextController.text = initText;
  focus.requestFocus();
  return showDialog(
    context: (context), builder: (BuildContext context) {
    return  AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(
              'Comment Update',
              style: TextStyle(
                fontFamily: "phenomena-bold",
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: TextFormField(
              focusNode: focus,
              controller: commentTextController,
              minLines: 1,
              maxLines: 10,
            ),
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context, "__DELETE__"),
          child: Text(
            'DELETE',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // padding: EdgeInsets.zero,
          onPressed: () async {
            if (commentTextController.text != "") {
              Navigator.pop(context, commentTextController.text);
            }
          },
          child: Text(
            'UPDATE',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  },

  );
}
