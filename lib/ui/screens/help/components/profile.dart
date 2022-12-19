import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';

class HelpProfile extends StatefulWidget {
  final String? imageUrl;
  final String? userId;
  final bool isHelp;
  const HelpProfile({this.imageUrl, this.userId, this.isHelp = true});
  @override
  _HelpProfileState createState() => _HelpProfileState();
}

class _HelpProfileState extends State<HelpProfile> {
  String? imageurl;
  String? userid;
  int favNumber = 0;
  int faceNumber = 0;
  int starNumber = 0;
  String? userName;
  String? userCreateAt;

  @override
  void initState() {
    super.initState();
    userid = widget.userId;
    imageurl = widget.imageUrl;
    _getUserInfo();
  }

  _getUserInfo() {
    if (user_id == userid) {
      imageurl = user_image_url;
      userName = user_firstname! + " " + user_lastname!;
      userCreateAt = user_create_at;
    }
    if (user_videos.isNotEmpty) {
      for (var item in user_videos) {
        if (item.user_id == userid) {
          favNumber += item.video_like_count!;
          faceNumber += item.video_view_count!;
          starNumber += item.video_groomlyfe_count!;
          if (user_id != userid) {
            userName = item.user_name;
            userCreateAt = item.user_create_at;
            imageurl = item.user_image_url;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isHelp
        ? Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              profileImage(),
              //check_numbers
              profileDetails()
            ],
          )
        : FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                profileImage(),
                SizedBox(width: 8.0),
                //check_numbers
                profileDetails()
              ],
            ),
          );
  }

  Widget profileImage() {
    return Stack(
      alignment: Alignment(1, 1),
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: new Border.all(
              color: Colors.black,
              width: 3,
            ),
            image: DecorationImage(
              image: (imageurl == ""
                  ? AssetImage("assets/images/user.png")
                  : CachedNetworkImageProvider(
                      imageurl!,
                    )) as ImageProvider<Object>,
            ),
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget profileDetails() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          userName == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "$userName",
                        style: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "member since $userCreateAt",
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(width: 8.0),
          //name&member
          myIcons("assets/images/glow_white_icon.png", favNumber),
          myIcons("assets/images/glasses.png", faceNumber),
          myIcons('assets/images/glean_icon_replace_face.png', starNumber),
        ],
      ),
    );
  }

  Widget myIcons(String icon, int number) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            color: Colors.black,
            width: 27,
            height: 27,
          ),
          Text(
            "$number",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
