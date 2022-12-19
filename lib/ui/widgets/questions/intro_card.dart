import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Stack(children: [
            Image.asset(
              'assets/images/back-login.png',
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Image.asset(
                "assets/images/glacad.png",
              ),
            ),
          ]),
          SizedBox(height: 12.0),
          Text(
            'Groomlyfe academy questionaire',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              fontFamily: "phenomena-bold",
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
