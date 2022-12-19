import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';

class ShinnerInfoWidget extends StatelessWidget {
  // audienceCount: _users.length, shinnerId: widget.shinnerId
  final int? audienceCount;
  final String? shinnerId;

  const ShinnerInfoWidget({Key? key, this.audienceCount, this.shinnerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      width: 35.0,
      child: Column(
        children: [
          // show like count, like = praise
          Column(
            children: <Widget>[
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/glow_white_icon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Container(),
              ),
              Text(
                "live",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          // show glean count
          StreamBuilder<List<Glean>>(
            stream: FirestoreService.followings(shinnerId),
            builder: (context, snap) {
              int gleanCount = 0;

              bool checkMyGlean = false;

              if (snap.hasData && !snap.hasError) {
                List<Glean> gleanList = snap.data!;

                gleanCount = gleanList.length;

                checkMyGlean = gleanList
                        .where((element) =>
                            element.userId == user_id && element.status != 2)
                        .length >
                    0;
              }

              return Column(
                children: <Widget>[
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/glean_icon_replace_face.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: checkMyGlean
                        ? Icon(FontAwesomeIcons.check, color: Colors.green)
                        : Container(),
                  ),
                  Text(
                    "$gleanCount",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              );
            },
          ),

          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          Image.asset(
            "assets/images/glasses.png",
            width: 27,
            height: 27,
          ),

          Text(
            "$audienceCount",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ShinnerAvatarWidget extends StatelessWidget {
  final String? userId;
  final String? imageUrl;
  final scaffoldKey;
  final String? name;
  const ShinnerAvatarWidget(
      {this.userId, this.imageUrl, this.scaffoldKey, this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        InkWell(
          child:
              Avatar(imageUrl, userId, scaffoldKey, context).whiteBorderLogo(),
          onTap: () {},
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Nova Round"),
            ),
          ],
        ),
      ],
    );
  }
}

class MyProfileWidget extends StatelessWidget {
  final scaffoldKey;
  const MyProfileWidget({this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildMyinfoWidget(),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            padding: EdgeInsets.all(0),
            child: Avatar(user_image_url, user_id, scaffoldKey, context)
                .smallLogoHome(),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          )
        ],
      ),
    );
  }

  buildMyinfoWidget() {
    return Container(
      color: Colors.black26,
      width: 35.0,
      child: Column(
        children: [
          // show like count, like = praise

          StreamBuilder<int>(
            stream: FirestoreService.getTotalPraise(user_id),
            builder: (context, snap) {
              int? praiseCount = 0;

              if (snap.hasData && !snap.hasError) {
                praiseCount = snap.data;
              }

              return Column(
                children: <Widget>[
                  Container(
                    width: 27,

                    height: 27,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/glow_white_icon.png"),
                        fit: BoxFit.contain,
                      ),
                    ),

                    // child: check_you_praising

                    //     ? Icon(Icons.check, color: Colors.red)

                    //     : Container(),
                  ),
                  Text(
                    "$praiseCount",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              );
            },
          ),

          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          // show glean count

          StreamBuilder<List<Glean>>(
            stream: FirestoreService.followings(user_id),
            builder: (context, snap) {
              int gleanCount = 0;

              if (snap.hasData && !snap.hasError) {
                List<Glean> gleanList = snap.data!;

                gleanCount = gleanList.length;
              }

              return Column(
                children: <Widget>[
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/glean_icon_replace_face.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    "$gleanCount",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              );
            },
          ),

          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          // Show my total video views

          StreamBuilder<List<Video>>(
            stream: FirestoreService.myVideosStream(user_id),
            builder: (context, snap) {
              int viewCount = 0;

              if (snap.hasData && !snap.hasError) {
                List<Video> videoList = snap.data!;

                videoList.forEach((element) {
                  viewCount += element.video_view_count!;
                });
              }

              return Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/glasses.png",
                    width: 27,
                    height: 27,
                  ),
                  Text(
                    "$viewCount",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShiningMenuItems extends StatelessWidget {
  final String? notificationId;
  final String? shinnerId;

  const ShiningMenuItems({Key? key, this.notificationId, this.shinnerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(19),
        ),
        Container(
          width: 50,
          height: device_height,
          child: StreamBuilder<List<Glean>>(
              stream: FirestoreService.followings(shinnerId),
              builder: (context, snap) {
// child: buildSpeedDial(context, isGleaned),
                int gleanCount = 0;
                bool checkMyGlean = false;
                if (snap.hasData && !snap.hasError) {
                  List<Glean> gleanList = snap.data!;
                  gleanCount = gleanList.length;
                  checkMyGlean = gleanList
                          .where((element) =>
                              element.userId == user_id && element.status != 2)
                          .length >
                      0;
                }
                return buildSpeedDials(context, checkMyGlean);
              }),
        )
      ],
    );
  }

  SpeedDial buildSpeedDials(BuildContext context, bool isGleaned) {
    return SpeedDial(
      visible: true,
      curve: Curves.bounceIn,
      closeManually: false,
      overlayOpacity: 0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white.withOpacity(0.0),
      foregroundColor: Colors.transparent.withOpacity(0.0),
      elevation: 8.0,
      children: [
        SpeedDialChild(
          //child: Icon(Icons.thumb_up),

          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/glean_icon_replace_face.png",
                ),
                fit: BoxFit.contain,
              ),
            ),
            child: isGleaned
                ? Icon(FontAwesomeIcons.check, color: Colors.green)
                : Container(),
          ),

          backgroundColor: Colors.black.withOpacity(0.5),

          onTap: () {
            if (isGleaned == false) {
              FirestoreService.glean(
                user_id,
                shinnerId,
                notificationId,
                null,
              );
            } else {
              ToastShow("You have already gleaned this Shinner.", context,
                      Colors.black)
                  .init();
            }
          },
        ),
        SpeedDialChild(
          child: Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/glow_white_icon.png",
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          onTap: () {
            ToastShow("Please like after the Shinner submit this video.",
                    context, Colors.black)
                .init();
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.share),
          backgroundColor: Colors.black.withOpacity(0.5),
          onTap: () {
            ToastShow("Please share after the Shinner submit this video.",
                    context, Colors.black)
                .init();
          },
        ),
      ],
    );
  }
}

class ShinningChatWidget extends StatefulWidget {
  final scaffoldKey;
  final String? channelId;
  const ShinningChatWidget({this.scaffoldKey, this.channelId});
  @override
  _ShinningChatWidgetState createState() => _ShinningChatWidgetState();
}

class _ShinningChatWidgetState extends State<ShinningChatWidget> {
  final _messageController = new TextEditingController();
  final FocusNode focusNode = new FocusNode();
  @override
  void dispose() {
    _messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset(
        "assets/images/chat_icon.png",
        width: 70,
        height: 70,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: device_height * 0.7,
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      TextField(
                        controller: _messageController,
                        focusNode: focusNode,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: Avatar(
                            user_image_url,
                            user_id,
                            widget.scaffoldKey,
                            context,
                          ).smallLogoMessage(),
                          hintText: "Insert message.",
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (_messageController.text != "") {
                                // submitChatMessage
                                FirestoreService.submitChatMessage(
                                    widget.channelId,
                                    user_firstname! + " " + user_lastname!,
                                    _messageController.text,
                                    user_id);
                                focusNode.unfocus();
                                _messageController.text = "";
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                        // onSubmitted: (value) {
                        //   _messageController.text = "";
                        //   focusNode.unfocus();
                        //   Navigator.of(context).pop();
                        // },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
