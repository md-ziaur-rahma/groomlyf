import 'package:flutter/material.dart';

class QuitButton extends StatelessWidget {
  final void Function()? onPressed;
  const QuitButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Text(
          "Quit",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape: StadiumBorder(),
        elevation: 2.0,
        fillColor: Colors.redAccent,
        padding: const EdgeInsets.all(15.0),
      ),
    );
  }
}
