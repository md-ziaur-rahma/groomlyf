import 'package:flutter/material.dart';

class CustomDialogs {
  static void dialog({required BuildContext context, String? content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            content!,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "phenomena-bold",
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: "phenomena-bold",
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static void showSnackBar(final globalKey, final content) {
    globalKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

  static displayProgressDialog(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            _,
            __,
          ) {
            return ProgressDialog();
          }),
    );
  }

  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
