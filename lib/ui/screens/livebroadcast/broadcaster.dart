import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:groomlyfe/util/agora_utils.dart';
import 'package:wakelock/wakelock.dart';

import '../../../controllers/agora_controllers.dart';
import '../../../controllers/firestore_service.dart';
import '../../../global/data.dart';
import 'components/buttons.dart';

class BroadcasterPage extends StatefulWidget {
  final String? channelName;
  final bool isBroadcaster;

  const BroadcasterPage(
      {Key? key, required this.channelName, required this.isBroadcaster})
      : super(key: key);

  @override
  _BroadcasterPageState createState() => _BroadcasterPageState();
}

class _BroadcasterPageState extends State<BroadcasterPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  RtcEngine? _engine;
  bool muted = false;
  int? streamId;
  late StreamSubscription<FGBGType> subscription;

  @override
  void dispose() {
    // clear user
    _users.clear();
    // destroy sdk
    if (_engine != null) {
      _engine!.leaveChannel();
      _engine!.destroy();
    }
    Wakelock.disable();
    // AgoraRtcEngine.leaveChannel();
    // AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        clearFirebaseData();
        // clear user
        _users.clear();
        // destroy sdk
        if (_engine != null) {
          _engine!.leaveChannel();
          _engine!.destroy();
        }
        // AgoraRtcEngine.leaveChannel();
        // AgoraRtcEngine.destroy();
        super.dispose();
      } else {}
    });
    // initialize agora sdk
    initializeAgora();
  }

  clearFirebaseData() async {
    final user = FirebaseAuth.instance.currentUser!;
    print('user id ${user.uid}');

    await FirebaseFirestore.instance
        .collection("livebroadcast")
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].get("userId") == user.uid) {
          print(user.uid);
          final val = await FirebaseFirestore.instance
              .runTransaction((Transaction myTransaction) async {
            myTransaction.delete(value.docs[i].reference);
          });
          // print('heye ${val}');
        }
      }
      value.docs.forEach((element) async {});
    });
    Navigator.pop(context);
  }

  Future<void> initializeAgora() async {
    print("fgfg ->${widget.channelName}");
    await _initAgoraRtcEngine();

    if (widget.isBroadcaster)
      streamId = await _engine?.createDataStream(false, false);

    _engine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          print('onJoinChannel: $channel, uid: $uid');
        });
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          print('userJoined: $uid');

          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          print('userOffline: $uid');
          _users.remove(uid);
        });
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
        print(info);
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        print(info);
      },
      connectionStateChanged: (t, r) {
        print(t);
        print(r);
      },
      clientRoleChangeFailed: (r, role) {
        print(r);
        print(role);
      },
      error: (e) {
        print(e);
      },
      warning: (c) {
        print(c);
      },
      remoteVideoStateChanged: (i, s, vs, inte) {
        print(s);
        print(vs);
      },
    ));

    await _engine!.joinChannel(
        null, widget.channelName ?? "", null, Random().nextInt(232));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(AgoraUtils.APP_ID);
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.enableVideo();
    if (widget.isBroadcaster) {
      await _engine!.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine!.setClientRole(ClientRole.Audience);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onCallEnd();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          leading: Offstage(),
          title: Text(
            'Shining',
            style: TextStyle(color: Colors.red),
          ),
          actions: _showButtons(),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              // _viewRows(),
              buildChatBox(user_id),
              _broadcastView(),
              _panel(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }

  buildChatBox(String? channelId) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 3,
          ),
          Container(
            height: height / 3,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirestoreService.getShiningChatHistory(channelId),
              builder: (context, snapshot) {
                if (snapshot == null || !snapshot.hasData) {
                  return Container();
                }
                try {
                  List<String> chatList = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    var tmp = snapshot.data!.docs[i].data();
                    String chat = "${tmp['senderName']} : ${tmp['text']}";
                    chatList.add(chat);
                  }
                  return ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (contxt, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                            .3,
                          ),
                        ),
                        child: Text(
                          chatList[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  );
                } catch (_) {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      default:
    }
    return Container();
  }

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    return QuitButton(
      onPressed: () async {
        final result = await _onCallEnd();
        if (result) {
          Navigator.pop(context);
        }
      },
    );
  }

  Future<bool> _onCallEnd() async {
    bool result = await showPermissionRationale(
      context: context,
      content: "Are you sure you want to end the broadcast?",
      title: "Shine",
      startBroadcast: false,
    );
    if (result) {
      _engine?.leaveChannel();
      final user = FirebaseAuth.instance.currentUser!;
      print('user id ${user.uid}');

      await FirebaseFirestore.instance
          .collection("livebroadcast")
          .get()
          .then((value) async {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i].get("userId") == user.uid) {
            print(user.uid);
            final val = await FirebaseFirestore.instance
                .runTransaction((Transaction myTransaction) async {
              myTransaction.delete(value.docs[i].reference);
            });
            // print('heye ${val}');
          }
        }
        value.docs.forEach((element) async {});
      });
      //old delete code
      // await FirebaseFirestore.instance
      //     .collection("livebroadcast")
      //     .doc(user.uid)
      //     .collection("chatHistory")
      //     .get()
      //     .then((snapshot) async {
      //   print('hhjh ${snapshot.size}');
      //   for (DocumentSnapshot ds in snapshot.docs) {
      //     ds.reference.delete();
      //   }
      //   await FirebaseFirestore.instance
      //       .collection("livebroadcast")
      //       .doc(user.uid)
      //       .delete();
      // });
      return true;
    } else {
      return false;
    }
  }

  // Widget _toolbar() {
  //   return widget.isBroadcasterrec
  //       ? Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           child: Icon(
  //             muted ? Icons.mic_off : Icons.mic,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => _onCallEnd(context),
  //           child: Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           child: Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //       ],
  //     ),
  //   )
  //       : Container();
  // }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
          uid: uid,
          channelId: widget.channelName ?? "",
        )));
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views
        .map<Widget>((view) => Expanded(child: Container(child: view)))
        .toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView([views[0]])
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView([views[0]]),
            _expandedVideoView([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(0, 2)),
            _expandedVideoView(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoView(views.sublist(0, 2)),
            _expandedVideoView(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  // void _onCallEnd(BuildContext context) {
  //   Navigator.pop(context);
  // }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() async {
    if (streamId != null) _engine?.switchCamera();
    //_engine.switchCamera();
  }

  _showButtons() {
    return <Widget>[
      IconButton(
        onPressed: _onToggleMute,
        icon: Icon(
          muted ? Icons.mic : Icons.mic_off,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      IconButton(
        onPressed: _onSwitchCamera,
        icon: Icon(
          Icons.switch_camera,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    ];
  }
}
// import 'dart:async';
//
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_channel.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:groomlyfe/controllers/agora_controllers.dart';
// import 'package:groomlyfe/controllers/firestore_service.dart';
// import 'package:groomlyfe/global/data.dart';
// import 'package:groomlyfe/util/agora_utils.dart';
// import 'components/buttons.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class BroadCasterPage extends StatefulWidget {
//   final String? channelName;
//   final bool isBroadcaster;
//
//   /// Creates a call page with given channel name.
//   const BroadCasterPage({Key? key, this.channelName, required this.isBroadcaster})
//       : super(key: key);
//
//   @override
//   _BroadCasterState createState() => _BroadCasterState();
// }
//
// class _BroadCasterState extends State<BroadCasterPage> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool initialized = false;
//   RtcEngine? agoraEngine;
//
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     if (agoraEngine != null) {
//       agoraEngine!.leaveChannel();
//       agoraEngine!.destroy();
//     }
//     // AgoraRtcEngine.leaveChannel();
//     // AgoraRtcEngine.destroy();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }
//
//   Future<void> initialize() async {
//     // String date = DateTime.now().toString();
//     // await FlutterScreenRecording.startRecordScreenAndAudio(date);
//
//     if (AgoraUtils.APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//
//     await _initAgoraRtcEngine();
//     // _addAgoraEventHandlers();
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await [Permission.camera, Permission.microphone, Permission.storage]
//         .request();
//
//     agoraEngine = await RtcEngine.create(AgoraUtils.APP_ID);
//     _addAgoraEventHandlers();
//     await agoraEngine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     // await agoraEngine!.setClientRole(ClientRole.Broadcaster);
//     await agoraEngine!.enableVideo();
//     // if (widget.broadCast) {
//     //   await agoraEngine!.setClientRole(ClientRole.Broadcaster);
//     // } else {
//     //   await agoraEngine!.setClientRole(ClientRole.Audience);
//     // }
//
//     await agoraEngine!.enableWebSdkInteroperability(true);
//     await agoraEngine!.setParameters(
//         '''{\"che.video.highBitRateStreamParameter\":{\"width\":640,\"height\":480,\"frameRate\":30,\"bitRate\":1500}}''');
//     await agoraEngine!.joinChannel(null, widget.channelName!, 'Groomlyfe', 0);
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     agoraEngine!.setEventHandler(RtcEngineEventHandler(
//       lastmileProbeResult: (result) {
//         print("test");
//       },
//       error: (code) {
//         setState(() {
//           final info = 'onError: $code';
//           _infoStrings.add(info);
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         setState(() {
//           _users.remove(uid);
//         });
//       },
//       firstLocalVideoFrame: (width, height, elapsed) {
//         setState(() {});
//       },
//     ));
//     setState(() {
//       initialized = true;
//     });
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     List<RtcLocalView.SurfaceView> list = [];
//     if (initialized == true) {
//       list.add(RtcLocalView.SurfaceView(
//         channelId: widget.channelName,
//       ));
//     }
//     return list;
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       default:
//     }
//     return Container();
//   }
//
//   Widget _toolbar() {
//     return QuitButton(
//       onPressed: () async {
//         final result = await _onCallEnd();
//         if (result) {
//           Navigator.pop(context);
//         }
//       },
//     );
//   }
//
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onCallEnd() async {
//     bool result = await showPermissionRationale(
//       context: context,
//       content: "Are you sure you want to end the broadcast?",
//       title: "Shine",
//       startBroadcast: false,
//     );
//     if (result) {
//       final user = await FirebaseAuth.instance.currentUser!;
//       FirebaseFirestore.instance
//           .collection("livebroadcast")
//           .doc(user.uid)
//           .collection("chatHistory")
//           .get()
//           .then((snapshot) {
//         for (DocumentSnapshot ds in snapshot.docs) {
//           ds.reference.delete();
//         }
//         FirebaseFirestore.instance
//             .collection("livebroadcast")
//             .doc(user.uid)
//             .delete();
//       });
//
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     agoraEngine!.muteLocalAudioStream(muted);
//   }
//
//   void _onSwitchCamera() {
//     agoraEngine!.switchCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
//     return WillPopScope(
//       onWillPop: () async => await _onCallEnd(),
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: Colors.black,
//           leading: Offstage(),
//           title: Text(
//             'Shining',
//             style: TextStyle(color: Colors.red),
//           ),
//           actions: _showButtons(),
//         ),
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Stack(
//             children: <Widget>[
//               _viewRows(),
//               buildChatBox(user_id),
//               _panel(),
//               _toolbar(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   buildChatBox(String? channelId) {
//     double height = MediaQuery.of(context).size.height;
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: height / 3,
//           ),
//           Container(
//             height: height / 3,
//             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: FirestoreService.getShiningChatHistory(channelId),
//               builder: (context, snapshot) {
//                 if (snapshot == null || !snapshot.hasData) {
//                   return Container();
//                 }
//                 try {
//                   List<String> chatList = [];
//                   for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                     var tmp = snapshot.data!.docs[i].data();
//                     String chat = "${tmp['senderName']} : ${tmp['text']}";
//                     chatList.add(chat);
//                   }
//                   return ListView.builder(
//                     itemCount: chatList.length,
//                     itemBuilder: (contxt, index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(
//                             .3,
//                           ),
//                         ),
//                         child: Text(
//                           chatList[index],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } catch (_) {
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _showButtons() {
//     return <Widget>[
//       IconButton(
//         onPressed: _onToggleMute,
//         icon: Icon(
//           muted ? Icons.mic : Icons.mic_off,
//           color: Colors.white,
//           size: 20.0,
//         ),
//       ),
//       IconButton(
//         onPressed: _onSwitchCamera,
//         icon: Icon(
//           Icons.switch_camera,
//           color: Colors.white,
//           size: 20.0,
//         ),
//       ),
//     ];
//   }
// }
