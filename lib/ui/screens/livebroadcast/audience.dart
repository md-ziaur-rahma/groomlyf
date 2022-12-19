import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/ui/screens/livebroadcast/components/features.dart';
import 'package:groomlyfe/util/agora_utils.dart';

class AudiencePage extends StatefulWidget {
  final String? shinnerId;
  final String? notificationId;
  final String? channelName;
  final String? name;
  final String? image;
  final bool isPreview;

  /// Creates a call page with given channel name.
  const AudiencePage(
      {Key? key,
      this.channelName,
      this.name,
      this.image,
      this.shinnerId,
      this.notificationId,
      required this.isPreview})
      : super(key: key);

  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool isTorchOn = false;
  bool isBroadcastNotInSession = false;

  // new update
  RtcEngine? agoraEngine;

  @override
  void dispose() {
    // clear users
    try {
      _users.clear();
      // destroy sdk

      // AgoraRtcEngine.leaveChannel();
      // AgoraRtcEngine.destroy();
      if (agoraEngine != null) {
        agoraEngine!.leaveChannel();
        agoraEngine!.destroy();
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    Future.delayed(Duration(seconds: 5)).then((_) {
      if (mounted) {
        setState(() {
          isBroadcastNotInSession = true;
        });
      }
    });
  }

  Future<void> initialize() async {
    if (AgoraUtils.APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    try {
      agoraEngine = await RtcEngine.create(AgoraUtils.APP_ID);
      // agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await agoraEngine!.enableVideo();
      await agoraEngine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
      agoraEngine!.setClientRole(ClientRole.Audience);

      agoraEngine!.enableWebSdkInteroperability(true);
      agoraEngine!.setParameters(
          '''{\"che.video.highBitRateStreamParameter\":{\"width\":640,\"height\":480,\"frameRate\":30,\"bitRate\":1500}}''');
      agoraEngine!.joinChannel(null, widget.channelName!, null, 156);

      agoraEngine!.setEventHandler(RtcEngineEventHandler(
        videoStopped: () {
          setState(() {
            isBroadcastNotInSession = true;
          });
        },
        userJoined: (uid, ellapsed) {
          setState(() {
            _users.add(uid);
          });
        },
        userOffline: (uid, reason) {
          setState(() {
            _users.remove(uid);
          });
        },
        error: (err) {
          setState(() {
            final info = 'onError: $err';
            _infoStrings.add(info);
          });
        },
      ));
    } catch (e) {
      print("Jkl -> $e");
    }
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<RtcRemoteView.SurfaceView> list = [];
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
          uid: uid,
          channelId: widget.channelName!,
        )));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]])
          ],
        ));
      default:
    }
    return Builder(
      builder: (context) {
        if (isBroadcastNotInSession) {
          return SizedBox.expand(
            child: Container(
              color: Colors.black26,
              child: Center(
                child: Text(
                  "Livebroadcast has ended",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("ChannelID: ${widget.channelName}");
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _viewRows(),
            if (!widget.isPreview) buildChatBox(widget.channelName),
            if (!widget.isPreview)
              Container(
                margin: EdgeInsets.only(left: 10, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShinnerAvatarWidget(
                      userId: widget.channelName,
                      imageUrl: widget.image,
                      scaffoldKey: scaffoldKey,
                      name: widget.name,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: ShinnerInfoWidget(
                            audienceCount: _users.length,
                            shinnerId: widget.shinnerId)),
                  ],
                ),
              ),
            if (!widget.isPreview)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          "assets/images/shine_video.png",
                          width: 70,
                          height: 70,
                        ),
                      ),
                      ShinningChatWidget(
                          scaffoldKey: scaffoldKey,
                          channelId: widget.channelName),
                      MyProfileWidget(scaffoldKey: scaffoldKey)
                    ],
                  ),
                ),
              ),
            if (widget.isPreview) Positioned(top: 0, child: Text("Hello")),
          ],
        ),
      ),
      floatingActionButton: ShiningMenuItems(
        notificationId: widget.notificationId,
        shinnerId: widget.shinnerId,
      ),
    );
  }

  buildChatBox(String? channelId) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    itemBuilder: (context, index) {
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
}
