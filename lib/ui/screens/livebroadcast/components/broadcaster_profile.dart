import 'package:flutter/material.dart';

class BroadcasterProfile extends StatelessWidget {
  final String? image;
  const BroadcasterProfile({this.image});
  @override
  Widget build(BuildContext context) {
    return image == null || image == ""
        ? Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              image: DecorationImage(
                  image: AssetImage(
                "assets/images/user.png",
              )),
            ),
          )
        : Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  image!,
                ),
              ),
            ),
          );
  }
}
