import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/models/glean.dart';

audienceDialog(BuildContext context, Audience audience, Widget child) async {
  await showDialog(
    context: (context),
    barrierDismissible: true, builder: (BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 110.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: audience.photoURL == ""
                          ? Image.asset(
                        "assets/images/user.png",
                        fit: BoxFit.cover,
                      )
                          : CachedNetworkImage(
                        imageUrl: audience.photoURL!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 22.0,
                          child: Text(
                            audience.name!,
                            style: TextStyle(
                                fontFamily: "phenomena-bold",
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "member since ${audience.createdAt}",
                          style: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/glow_white_icon.png",
                                    color: Colors.black,
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    '${audience.videoview!.favNumber}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/glean_icon_replace_face.png",
                                    color: Colors.black,
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    '${audience.videoview!.starNumber}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/glasses.png",
                                    color: Colors.black,
                                    width: 27,
                                    height: 27,
                                  ),
                                  Text(
                                    '${audience.videoview!.faceNumber}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            child
          ],
        ),
      ),
    );
  },


  );
}
