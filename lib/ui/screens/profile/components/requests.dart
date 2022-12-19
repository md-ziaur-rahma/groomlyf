import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/ui/screens/profile/profile.dart';

// ignore: must_be_immutable
class RequestProfile extends StatelessWidget {
  final String? userId;
  final Glean? glean;
  final bool? isDivider;
  RequestProfile({this.userId, this.glean, this.isDivider});

  Map userData = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Audience>(
      stream: FirestoreService.audienceStream(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final audience = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Stack(
                      alignment: Alignment(1, 1),
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
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
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          audience.photoURL,
                          audience.id,
                          audience.notificationId,
                        ),
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
                  const SizedBox(width: 20.0),
                  MaterialButton(
                    height: 35.0,
                    minWidth: 70.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2.5,
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: "phenomena-bold",
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => FirestoreService.add(
                      user_id,
                      userId,
                      audience.notificationId,
                      {},
                    ),
                  ),
                ],
              ),
              if (isDivider!) Divider()
            ],
          );
        }
        return Offstage();
      },
    );
  }
}
