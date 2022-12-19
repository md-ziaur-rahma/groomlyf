// import 'dart:async';
//
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:flutter/material.dart';
// import 'package:groomlyfe/util/agora_utils.dart';
// import 'package:uuid/uuid.dart';
//
// class AgoraPreview extends StatefulWidget {
//   final String? shinnerId;
//   final String? notificationId;
//   final String? channelName;
//   final String? name;
//   final String? image;
//
//   const AgoraPreview(
//       {Key? key,
//       this.channelName,
//       this.name,
//       this.image,
//       this.shinnerId,
//       this.notificationId})
//       : super(key: key);
//
//   @override
//   _AgoraPreviewState createState() => _AgoraPreviewState();
// }
//
// class _AgoraPreviewState extends State<AgoraPreview>
//     with AutomaticKeepAliveClientMixin {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool isTorchOn = false;
//   bool isBroadcastNotInSession = false;
//
//   // new update
//   RtcEngine? _agoraEngine;
//
//   @override
//   void dispose() {
//     // clear users
//     try {
//       _users.clear();
//       // destroy sdk
//
//       // AgoraRtcEngine.leaveChannel();
//       // AgoraRtcEngine.destroy();
//       if (_agoraEngine != null) {
//         _agoraEngine!.leaveChannel();
//         _agoraEngine!.destroy();
//       }
//     } catch (_) {}
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//     Future.delayed(Duration(seconds: 5)).then((_) {
//       if (mounted) {
//         setState(() {
//           isBroadcastNotInSession = true;
//         });
//       }
//     });
//   }
//
//   Future<void> initialize() async {
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
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _agoraEngine = await RtcEngine.create(AgoraUtils.APP_ID);
//     // agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _agoraEngine!.enableVideo();
//     await _agoraEngine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     _agoraEngine!.setClientRole(ClientRole.Audience);
//     // _agoraEngine!.enableWebSdkInteroperability(true);
//     // _agoraEngine!.setParameters(
//     //     '''{\"che.video.highBitRateStreamParameter\":{\"width\":640,\"height\":480,\"frameRate\":30,\"bitRate\":1500}}''');
//
//     _agoraEngine!.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (value, _, __) {
//         print("jejej $value");
//         print("jejej $_");
//         print("jejej $__");
//       },
//       streamMessageError: (_, __, error, ___, ____) {
//         final String info = "here is the error $error";
//         print(info);
//       },
//       videoStopped: () {
//         setState(() {
//           isBroadcastNotInSession = true;
//         });
//       },
//       userJoined: (uid, ellapsed) {
//         setState(() {
//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         setState(() {
//           _users.remove(uid);
//         });
//       },
//       error: (err) {
//         setState(() {
//           final info = 'onError: $err';
//           _infoStrings.add(info);
//         });
//       },
//     ));
//     _agoraEngine!.joinChannel(null, widget.channelName!, null, 22);
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<RtcRemoteView.SurfaceView> list = [];
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
//           uid: uid,
//           channelId: widget.channelName!,
//         )));
//     return list;
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: view);
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return _expandedVideoRow([views[0]]);
//       default:
//     }
//     return Builder(
//       builder: (context) {
//         if (isBroadcastNotInSession) {
//           return Container(
//             color: Colors.black26,
//             child: Center(
//               child: Text(
//                 "Livebroadcast has ended",
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           );
//         }
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     print("ChannelID: ${widget.channelName}");
//     return Scaffold(
//       backgroundColor: Colors.black,
//       key: scaffoldKey,
//       body: Center(
//         child: _viewRows(),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => false;
// }
