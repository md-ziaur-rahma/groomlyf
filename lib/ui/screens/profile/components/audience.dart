import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/ui/screens/profile/components/dialog.dart';
import 'package:groomlyfe/ui/screens/profile/profile.dart';

class AudienceProfile extends StatelessWidget {
  final String? userId;
  final Glean? glean;
  final bool? isDivider;
  const AudienceProfile({this.userId, this.glean, this.isDivider});
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
                  // you have sent a glean request
                  if (glean!.status == 0)
                    MaterialButton(
                      height: 35.0,
                      minWidth: 70.0,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'pending',
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async => cancelRequest(context, audience),
                    ),
                  // you have gleaned to the user
                  if (glean!.status == 1)
                    MaterialButton(
                      height: 35.0,
                      minWidth: 70.0,
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'remove',
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async => remove(context, audience),
                    ),
                  // you have ungleaned the user
                  if (glean!.status == 2)
                    MaterialButton(
                      height: 35.0,
                      minWidth: 70.0,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'ungleaned',
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async => gleanAgain(context, audience),
                    ),

                  if (glean!.status == 3)
                    MaterialButton(
                      height: 35.0,
                      minWidth: 70.0,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'blocked',
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async => unblock(context, audience),
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

  void remove(BuildContext context, Audience audience) async {
    await audienceDialog(
      context,
      audience,
      Column(
        children: [
          Text(
            'how do you want to remove?',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                height: 35.0,
                minWidth: 80.0,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'block',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirestoreService.block(user_id, userId);
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                height: 35.0,
                minWidth: 80.0,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'unglean',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirestoreService.unglean(user_id, userId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void cancelRequest(BuildContext context, Audience audience) async {
    await audienceDialog(
      context,
      audience,
      Column(
        children: [
          Text(
            'Are you sure you want to cancel your glean pending request?',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                height: 35.0,
                minWidth: 80.0,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirestoreService.cancelGlean(user_id, userId);
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 20.0),
            ],
          )
        ],
      ),
    );
  }

  void gleanAgain(BuildContext context, Audience audience) async {
    await audienceDialog(
      context,
      audience,
      Column(
        children: [
          Text(
            'Are you sure you want to glean?',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                height: 35.0,
                minWidth: 80.0,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirestoreService.gleanAgain(user_id, userId);
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 20.0),
            ],
          )
        ],
      ),
    );
  }

  void unblock(BuildContext context, Audience audience) async {
    await audienceDialog(
      context,
      audience,
      Column(
        children: [
          Text(
            'Are you sure you want to unlock?',
            style: TextStyle(
              fontFamily: "phenomena-bold",
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                height: 35.0,
                minWidth: 80.0,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirestoreService.unblock(user_id, userId);
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 20.0),
            ],
          )
        ],
      ),
    );
  }
}
