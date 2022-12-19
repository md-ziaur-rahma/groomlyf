import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/ui/screens/profile/components/profile_header.dart';
import 'package:groomlyfe/ui/screens/profile/components/tab1.dart';
import 'package:groomlyfe/ui/screens/profile/components/tab2.dart';
import 'package:groomlyfe/ui/screens/profile/components/tab2_others.dart';
import 'package:groomlyfe/ui/screens/profile/components/tab3.dart';
import 'package:groomlyfe/ui/screens/profile/components/tab4.dart';

//profile screen
class Profile extends StatefulWidget {
  final String? imageurl;
  final String? userid;
  final String? notificationId;
  final bool notification;
  final senderData;
  const Profile(this.imageurl, this.userid, this.notificationId,
      {this.notification = false, this.senderData});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    print('my notificationId ${widget.notificationId}');
    if (widget.notification == true) {
      userid = user_id;
    } else {
      imageurl = widget.imageurl;
      userid = widget.userid;
    }
    print('myUserId: $userid');

    _getUserInfo();
  }

  //get image info with global user info variables
  _getUserInfo() {
    if (user_id == userid) {
      imageurl = user_image_url;
      userName = user_firstname! + " " + user_lastname!;
      userCreateAt = user_create_at;
    }
    // if (widget.senderData != null) {
    //   favNumber = widget.senderData['fav'];
    //   faceNumber = widget.senderData["face"];
    //   starNumber = widget.senderData["star"];
    //   userCreateAt = widget.senderData["createdAt"];
    //   userName = widget.senderData["name"];
    // }
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userid == user_id
        ? StreamBuilder<Counts>(
            stream: FirestoreService.counts(user_id),
            builder: (context, snapshot) {
              int? audience = 0;
              int? request = 0;
              if (snapshot.hasData) {
                audience = snapshot.data!.audience;
                request = snapshot.data!.requests;
              }
              return DefaultTabController(
                length: 4,
                initialIndex: widget.notification == true ? 2 : 0,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size(double.maxFinite, 290.0),
                    child: Column(
                      children: [
                        ProfileHeader(
                          imageurl: imageurl,
                          userName: userName,
                          userCreateAt: userCreateAt,
                          starNumber: starNumber,
                          faceNumber: faceNumber,
                          favNumber: favNumber,
                          userId: userid,
                          // notification: widget.notification,
                          notification: false,
                          notificationId: widget.notificationId,
                        ),
                        TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          indicatorWeight: 3.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          isScrollable: true,
                          labelStyle: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(text: 'shines'),
                            Tab(
                              text: audience! < 1
                                  ? 'audience'
                                  : 'audience ($audience)',
                            ),
                            Tab(
                              text: request! < 1
                                  ? 'requests'
                                  : 'requests ($request)',
                            ),
                            Tab(text: 'settings'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(),
                        )
                      ],
                    ),
                  ),
                  body: SizedBox.expand(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16.0,
                      ),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Tab1(userId: userid),
                          Tab2(userId: userid),
                          Tab3(userId: userid),
                          Tab4(imageurl, userCreateAt, userid)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(double.maxFinite, 290.0),
                child: Column(
                  children: [
                    ProfileHeader(
                      imageurl: imageurl,
                      userName: userName,
                      userCreateAt: userCreateAt,
                      starNumber: starNumber,
                      faceNumber: faceNumber,
                      favNumber: favNumber,
                      userId: userid,
                      notification: widget.notification,
                      notificationId: widget.notificationId,
                    ),
                    TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(
                        fontFamily: "phenomena-bold",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: 'shines'),
                        Tab(text: 'audience'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Divider(),
                    )
                  ],
                ),
              ),
              body: SizedBox.expand(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16.0,
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirestoreService.getSetting(userid),
                    builder: (context, snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        var data = snapshot.data!;
                        bool? circlePrivacy = data['innercircleprivacy'];
                        bool? residentialPrivacy = data['residentialprivacy'];
                        return TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Tab1(userId: userid, protect: residentialPrivacy),
                            Tab2Others(userId: userid, protect: circlePrivacy),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          );
  }
}
