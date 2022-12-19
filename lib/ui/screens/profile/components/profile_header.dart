import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/models/messages.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/ui/screens/profileEdit.dart';
import 'package:groomlyfe/ui/screens/sign_in.dart';
import 'package:groomlyfe/ui/widgets/input_message_widget.dart';
import 'package:groomlyfe/util/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeader extends StatefulWidget {
  final String? imageurl;
  final String? userName;
  final String? userCreateAt;
  final int? faceNumber;
  final int? favNumber;
  final int? starNumber;
  final String? userId;
  final bool? notification;
  final String? notificationId;
  ProfileHeader(
      {this.imageurl,
      this.userCreateAt,
      this.userName,
      this.faceNumber,
      this.favNumber,
      this.userId,
      this.notificationId,
      this.notification,
      this.starNumber});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Map userData = {};

  @override
  void initState() {
    super.initState();
    userData = {
      "image_url": widget.imageurl,
      "face": widget.faceNumber,
      "fav": widget.favNumber,
      "star": widget.starNumber,
      "name": user_firstname ?? "" + " " + user_lastname!,
      "createdAt": widget.userCreateAt,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Profiles",
                style: TextStyle(
                  fontFamily: "phenomena-bold",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 35.0,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.logout,
              //     size: 35.0,
              //     color: Colors.black54,
              //   ),
              //   onPressed: () async {
              //     SharedPreferences localStorage = await SharedPreferences.getInstance();
              //     Future.delayed(const Duration(seconds: 1)).then((value) async {
              //       await FirebaseAuth.instance.signOut();
              //       localStorage.clear();
              //       Navigator.pushAndRemoveUntil<void>(
              //         context,
              //         MaterialPageRoute<void>(builder: (BuildContext context) => SignInScreen()),
              //         ModalRoute.withName('/'),
              //       );
              //     });
              //   },
              // ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: Stack(
                  alignment: Alignment(1, 1),
                  children: <Widget>[
                    Container(
                      width: 110,
                      height: 110,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.circular(65),
                        child: widget.imageurl == ""
                            ? Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.userId == user_id
                                    ? user_image_url!
                                    : widget.imageurl!,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  if (widget.userId == user_id) {
                    bool? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEdit(),
                      ),
                    );
                    if (value != null) {
                      setState(() {});
                    }
                  }
                },
              ),
              SizedBox(width: 6.0),
              widget.userName == null
                  ? Offstage()
                  : Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${widget.userName}",
                            style: TextStyle(
                                fontFamily: "phenomena-bold",
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "member since ${widget.userCreateAt}",
                            style: TextStyle(
                              fontFamily: "phenomena-bold",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                StreamBuilder<int>(
                                  stream: FirestoreService.getTotalPraise(
                                      widget.userId),
                                  builder: (context, snap) {
                                    int? praiseCount = 0;

                                    if (snap.hasData && !snap.hasError) {
                                      praiseCount = snap.data;
                                    }

                                    return Container(
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
                                            "$praiseCount",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                // show glean count
                                StreamBuilder<List<Glean>>(
                                  stream: FirestoreService.followings(
                                      widget.userId),
                                  builder: (context, snap) {
                                    int gleanCount = 0;

                                    if (snap.hasData && !snap.hasError) {
                                      List<Glean> gleanList = snap.data!;
                                      gleanCount = gleanList.length;
                                    }

                                    return Container(
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
                                            "$gleanCount",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                StreamBuilder<List<Video>>(
                                  stream: FirestoreService.myVideosStream(
                                      widget.userId),
                                  builder: (context, snap) {
                                    int viewCount = 0;

                                    if (snap.hasData && !snap.hasError) {
                                      List<Video> videoList = snap.data!;
                                      videoList.forEach((element) {
                                        viewCount += element.video_view_count!;
                                      });
                                    }

                                    return Container(
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
                                            "$viewCount",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (widget.userId != user_id)
                            Row(
                              children: [
                                StreamBuilder<bool?>(
                                  stream: FirestoreService.isGleaned(
                                      user_id, widget.userId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return MaterialButton(
                                        height: 35.0,
                                        color: snapshot.data!
                                            ? Colors.white
                                            : Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: snapshot.data!
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                width: 3.0)),
                                        child: Text(
                                          snapshot.data!
                                              ? 'Glean sent'
                                              : 'Glean',
                                          style: TextStyle(
                                            fontFamily: "phenomena-bold",
                                            fontSize: 20,
                                            color: snapshot.data!
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (widget.notification! &&
                                              snapshot.data == false) {
                                            FirestoreService.add(
                                              user_id,
                                              widget.userId,
                                              widget.notificationId,
                                              userData,
                                            );
                                            return;
                                          }
                                          if (snapshot.data == false &&
                                              widget.notification == false) {
                                            FirestoreService.glean(
                                              user_id,
                                              widget.userId,
                                              widget.notificationId,
                                              userData,
                                            );
                                          }
                                        },
                                      );
                                    }
                                    return Offstage();
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                MaterialButton(
                                  height: 35.0,
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                      color: Colors.transparent,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Text(
                                    'msg',
                                    style: TextStyle(
                                      fontFamily: "phenomena-bold",
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {

                                    // openInputMessageWidget(context, )
                                    openInputMessageWidget(context, "")
                                        .then((value) {
                                      if (value == null) return;
                                      String now = ((DateTime.now()
                                                      .millisecondsSinceEpoch /
                                                  1000)
                                              .round())
                                          .toString();
                                      ChatData().addMessageDB(
                                        Chat(
                                          notificationId: widget.notificationId,
                                          id: user_id! + widget.userId!,
                                          message: value,
                                          sender_id: user_id,
                                          receiver_id: widget.userId,
                                          create_at: now,
                                          is_readed: false,
                                          is_ghost: false,
                                        ),
                                      );
                                    });
                                  },
                                )
                              ],
                            )
                        ],
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
