

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/models/messages.dart';
import 'package:groomlyfe/models/praise.dart';
//import 'package:custom_chewie/custom_chewie.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/util/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/firestore_service.dart';

//////////////////////////////////////////Video play/ screen 'SAME SHINE PLAY'///////////////////////////////////////////////////////////////
class Video_small_play extends StatefulWidget {
  VideoPlayerController? _controller;
  Video? video;

  Video_small_play(this._controller, this.video);
  String? path;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Video_small_play_state(_controller, video);
  }
}

class Video_small_play_state extends State<Video_small_play> {
  Video_small_play_state(this._controller, this.video);

  TextEditingController? _messageController;
  VideoPlayerController? _controller;
  Video? video;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
//    SystemChrome.setEnabledSystemUIOverlays([]);
    //_controller = VideoPlayerController.asset("videos/sample_video.mp4");
    _messageController = new TextEditingController();
    _controller ??= VideoPlayerController.network(video!.video_url!)
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }
//  _refresh()async{
//    await SystemChrome.setPreferredOrientations(
//        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//    setState(() {
//
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    _refresh();
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            buildVideoWidget(),
            buildInfoWidget(context),
          ],
        ),
      ),
      // floatingActionButton: buildMenuWidget(),
    );
  }

  Widget buildMenuWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(19),
        ),
        StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("video")
              .child("${video!.key}")
              .onValue,
          builder: (context, snap) {
            DataSnapshot? snapshot;
            if (snap.hasData || snap.data != null) {
              snapshot = snap.data!.snapshot;
            }

            if (snapshot == null) {
              return Container();
            } else {
              bool? isStreaming = false;
              isStreaming = (snapshot.value as Map<dynamic, dynamic>?)!["isStreaming"] == null
                  ? false
                  : (snapshot.value as Map<dynamic, dynamic>?)!["isStreaming"];
              print("${(snapshot.value as Map<dynamic, dynamic>?)!["isStreaming"]}");
              return Container(
                width: 50,
                height: device_height,
                child: SpeedDial(
                  // both default to 16
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: true,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
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
                      ),
                      backgroundColor: Colors.black.withOpacity(0.5),
                      onTap: () {
                        // print(video.key);
                        FirestoreService.glean(
                          user_id,
                          video!.user_id,
                          video!.notificationId,
                          null,
                        );
                      },
                    ),
                    SpeedDialChild(
                      //  child: Icon(Icons.check),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 15),
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
                        Praise praise = Praise(
                            id: "${video!.key}$user_id",
                            video_id: video!.key,
                            user_id: user_id,
                            is_praising: true);
                        if (video!.user_id != user_id)
                          VideoData().praiseVideo(praise, 'is_praising');
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.share),
                      backgroundColor: Colors.black.withOpacity(0.5),
                      onTap: () async {
                        print("${video!.video_view_count}");
                        if (await canLaunchUrl(Uri.parse('mailto:${video!.user_email}'))) {
                          await launchUrl(Uri.parse('mailto:${video!.user_email}'));
                        } else {
                          throw "Could not launch";
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Container buildInfoWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildTopWidget(context),
            buildBottomWidget(context)
          ],
        ));
  }

  Row buildBottomWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        buildShowingMenuButton(),
        buildChatWidget(context),
        buildTotalProfileInfoWidget(context),
      ],
    );
  }

  ///................... Like Share ..................
  Stack buildShowingMenuButton() {
    return Stack(
      alignment: Alignment(-0.1, -0.3),
      children: <Widget>[
        Container(
          child: Image.asset(
            "assets/images/shine_video.png",
            width: 70,
            height: 70,
          ),
        ),
        StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("video")
              .child("${video!.key}")
              .onValue,
          builder: (context, snap) {
            DataSnapshot? snapshot;
            if (snap.hasData || snap.data != null) {
              snapshot = snap.data!.snapshot;
            }

            if (snapshot == null) {
              return Container();
            } else {
              bool? isStreaming = false;
              isStreaming = (snapshot.value as Map)["isStreaming"] == null
                  ? false
                  : (snapshot.value as Map)["isStreaming"];
              print("${(snapshot.value as Map)["isStreaming"]}");
              return Container(
                width: 50,
                // height: device_height,
                child: SpeedDial(
                  // both default to 16
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: true,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
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
                    //gleen
                    SpeedDialChild(
                      child: Image(image: AssetImage("assets/images/glean_icon_replace_face.png"),height: 24,width: 24,),
                      backgroundColor: Colors.black.withOpacity(0.5),
                      onTap: () {
                        print("user id : $user_id, video id : ${video!.user_id}, notification id : ${video!.notificationId}");

                        FirestoreService.glean(
                          user_id,
                          video!.user_id,
                          video!.notificationId,
                          null,
                        );
                      },
                    ),
                    //glow
                    SpeedDialChild(
                      // child: Icon(Icons.thumb_up_alt,color: Colors.white,),
                      child: Image(image: AssetImage("assets/images/glow_white_icon.png"),height: 24,width: 24,),
                      backgroundColor: Colors.black.withOpacity(0.5),
                      onTap: () {
                        Praise praise = Praise(
                            id: "${video!.key}$user_id",
                            video_id: video!.key,
                            user_id: user_id,
                            is_praising: true);
                        if (video!.user_id != user_id)
                          VideoData().praiseVideo(praise, 'is_praising');
                      },
                    ),
                    //share
                    SpeedDialChild(
                      child: Icon(Icons.share,color: Colors.white,),
                      backgroundColor: Colors.black.withOpacity(0.5),
                      onTap: () async {
                        print("${video!.video_view_count}");
                        if (await canLaunchUrl(Uri.parse('mailto:${video!.user_email}'))) {
                          // await launchUrl(Uri.parse('mailto:${video!.user_email}?subject=${video!.video_title}&body=${video!.video_url}'));
                          await launchUrl(Uri.parse('mailto:${video!.user_email}?subject=&body='));
                        } else {
                          throw "Could not launch";
                        }
                      },
                    ),
                  ],
                ),
              );
              // : Container();
            }
          },
        ),
      ],
    );
  }

  Padding buildTotalProfileInfoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildMyInfoWidget(),
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

  InkWell buildChatWidget(BuildContext context) {
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
                      Container(
                        child: StreamBuilder<DatabaseEvent>(
                          stream: FirebaseDatabase.instance
                              .ref()
                              .child('message')
                              .orderByChild('videoKey')
                              .equalTo(video!.key) //order by creation time.
                              .onValue,
                          builder: (context, snap) {
                            if (snap.hasData &&
                                !snap.hasError &&
                                snap.data!.snapshot.value != null) {
                              DataSnapshot snapshot = snap.data!.snapshot;
                              List<ChatMessage> messages = [];

                              (jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>).forEach((key, value) {

                                if (value != null) {
                                  print(value);
                                  ChatMessage messageItem = ChatMessage(
                                      key: "$key",
                                      videoKey: "${value['videoKey']}",
                                      userid: "${value['userid']}",
                                      username: "${value['username']}",
                                      user_create_at:
                                      "${value['user_create_at']}",
                                      photoUrl: "${value['photoUrl']}",
                                      message: "${value['message']}");
                                  print(messageItem.message);
                                  messages.add(messageItem);
                                }
                              });
                              messages.sort((a, b) {
                                return a.key
                                    .toString()
                                    .compareTo(b.key.toString());
                              });
                              return snap.data!.snapshot.value == null
                                  ? SizedBox()
                                  : Column(
                                      children: messages.map((item) {
                                      return Container(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: item.photoUrl == ""
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 22,
                                                      color: Colors.blueGrey,
                                                    )
                                                  : Image.network(
                                                      "${item.photoUrl}",
                                                      fit: BoxFit.cover,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                            ),
                                            Container(
                                              width: device_width - 160,
                                              child: Text(
                                                "${item.message}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList());
                            } else {
                              return Center(child: Container());
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: Avatar(
                                  user_image_url, user_id, scaffoldKey, context)
                              .smallLogoMessage(),
                          hintText: "Insert message.",
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onTap: () {
                              var now = DateTime.now().toString();
                              if (_messageController!.text != "") {
                                MessageData().addMessageDB(ChatMessage(
                                    videoKey: video!.key,
                                    userid: user_id,
                                    username:
                                        "${user_firstname} ${user_lastname}",
                                    user_create_at: user_create_at,
                                    photoUrl: user_image_url,
                                    notificationId: video!.notificationId,
                                    message: _messageController!.text,
                                    created_at: now));
                                setState(
                                  () {
                                    _messageController!.text = "";
                                  },
                                );
                              }
                            },
                          ),
                        ),
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

  Column buildTopWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTopProfileWidget(context),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: buildVideoInfoWidget(true),
        ),
      ],
    );
  }

  Row buildTopProfileWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        InkWell(
          child: Avatar(
            video!.user_id == user_id ? user_image_url : video!.user_image_url,
            video!.user_id,
            scaffoldKey,
            context,
            notificationId: video!.notificationId,
          ).whiteBorderLogo(),
          //.smallLogoHome(),
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
              video!.user_id == user_id
                  ? "$user_firstname $user_lastname"
                  : video!.user_name!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Nova Round"),
            ),
            Container(
              width: device_width * 0.6,
              child: Text(
                "${video!.video_title}",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "Nova Round"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Builder buildVideoWidget() {
    return new Builder(builder: (context) {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new VideoPlayer(
            _controller!,
          ));
    });
  }

  buildVideoInfoWidget(isShow) {
    return Container(
      color: Colors.black26,
      width: 35.0,
      child: Column(
        children: [
          // show like count, like = praise
          StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref()
                .child("video_praise")
                .orderByChild("video_id")
                .equalTo("${video!.key}")
                .onValue,
            builder: (context, snap) {
              int praising_count = 0;
              bool check_you_praising = false;
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data!.snapshot.value != null) {
                // Map data = snap.data!.snapshot.value as Map<String, dynamic>;
                Map<String, dynamic> data = json.decode(json.encode(snap.data!.snapshot.value));
                print(data.toString() + "dakfsakflk");
                data.forEach((key, value) {
                  Praise praise = new Praise(
                    user_id: "${value['user_id']}",
                    is_praising: value['is_praising'] ?? true,
                  );
                  if (praise.is_praising!) {
                    praising_count++;
                    if (praise.user_id == user_id) {
                      check_you_praising = true;
                    }
                  }
                });
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
                    child: check_you_praising && isShow
                        ? Icon(FontAwesomeIcons.check, color: Colors.green)
                        : Container(),
                  ),
                  Text(
                    "$praising_count",
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
            stream: FirestoreService.followingsAudience(video!.user_id,user_id),
            builder: (context, snap) {
              int gleanCount = 0;
              bool checkMyGlean = false;

              if (snap.hasData && !snap.hasError) {
                print("ddddddddddddddddddddddddd");
                List<Glean> gleanList = snap.data!;
                gleanCount = gleanList.length;
                checkMyGlean = gleanList
                    .where((element) =>
                element.userId == user_id && element.status != 2)
                    .length >
                    0;
              } else {
                print('xxxxxxxxxxxxxx Error found in gleen : ${snap.error.toString()} xxxxxxxxxxxxxxxx');
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
                    child: checkMyGlean && isShow
                        ? Icon(Icons.check, color: Colors.red)
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
            "${video!.video_view_count}",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  buildMyInfoWidget() {
    return Container(
      color: Colors.black26,
      width: 35.0,
      child: Column(
        children: [
          StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref()
                .child("video_praise")
                .onValue,
            builder: (context, snap) {
              int praising_count = 0;
              bool check_you_praising = false;
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data!.snapshot.value != null) {
                // Map data = snap.data!.snapshot.value as Map<String, dynamic>;
                Map<String, dynamic> data = json.decode(json.encode(snap.data!.snapshot.value));
                print(data.toString() + "dakfsakflk");
                data.forEach((key, value) {
                  Praise praise = new Praise(
                    user_id: "${value['user_id']}",
                    is_praising: value['is_praising'] ?? true,
                  );
                  if (praise.is_praising!) {
                    if (praise.user_id == user_id) {
                      praising_count++;
                    }
                  }
                });
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
                    child: check_you_praising
                        ? Icon(FontAwesomeIcons.check, color: Colors.green)
                        : Container(),
                  ),
                  Text(
                    "$praising_count",
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
              }else {
                print("ffffffffffffff view error in bottom : ${snap.error} ffffffffffffffff");
              }

              return Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/glasses.png",
                    width: 27,
                    height: 27,
                  ),
                  Text(
                    // "${video!.video_view_count}",
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
