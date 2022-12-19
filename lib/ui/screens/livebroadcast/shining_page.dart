import 'dart:async';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';

// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/notification/notification_service.dart';
import 'package:groomlyfe/ui/screens/livebroadcast/broadcaster.dart';
import 'package:groomlyfe/ui/screens/livebroadcast/components/upload_video.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/ui/widgets/progress_indicator.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

bool isRecStarted = false;

class ShiningPage extends StatefulWidget {
  final User? user;

  ShiningPage({this.user});

  @override
  _ShiningPageState createState() => _ShiningPageState();
}

class _ShiningPageState extends State<ShiningPage> {
  File? file;

  String textBtn = "Start";
  bool recording = true;
  String? path;
  VideoPlayerController? _controller;
  bool status = false;
  bool isInviteSent = false;
  Timer? _timer;
  int _start = 4;
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  void dispose() {
    // stopScreenRecord();
    try {
      _timer!.cancel();
    } catch (_) {}
    super.dispose();
  }

  void findFile() async {
    try {
      file = File(path!);

      if (file != null) {
        bool b = await file!.exists();
        print("file exeist :- $b");
        recordingUpload();
        if (!b) {
          ToastShow("file not found", context, Colors.red).init();
          throw Exception("File Not Found");
        }
        _controller = VideoPlayerController.file(file!)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      } else {
        ToastShow("file not found", context, Colors.red).init();
      }
    } catch (e) {
      ToastShow("file error", context, Colors.red).init();
      print('failed');
    }
  }

  requestPermissions() async {
    await [Permission.storage, Permission.photos].request();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CAppBar(
                  user: widget.user,
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // if (file != null)
                        //   if (_controller?.value.isInitialized ?? false)
                        //     Expanded(
                        //       child: Container(
                        //         padding: EdgeInsets.all(16.0),
                        //         decoration: BoxDecoration(
                        //           color: Colors.black,
                        //           borderRadius: BorderRadius.circular(20.0),
                        //           border:
                        //               Border.all(color: Colors.red, width: 3.0),
                        //         ),
                        //         child: Column(
                        //           children: [
                        //             Expanded(
                        //               child: VideoPlayer(_controller!),
                        //             ),
                        //             SizedBox(height: 16.0),
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: <Widget>[
                        //                 FlatButton(
                        //                   color: Colors.blue,
                        //                   onPressed: () => _controller!.play(),
                        //                   child: Text("Play"),
                        //                 ),
                        //                 SizedBox(width: 20.0),
                        //                 FlatButton(
                        //                   color: Colors.blue,
                        //                   onPressed: () => _controller!.pause(),
                        //                   child: Text("Pause"),
                        //                 )
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),

                        // SizedBox(height: 16.0),
                        // the button to start or stop screen recording
                        /* SizedBox(
                        height: 50.0,
                        width: double.maxFinite,
                        child: RaisedButton(
                          color: Colors.green,
                          shape: StadiumBorder(),
                          child: Text(
                            '$textBtn recording',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (recording) {
                              stopScreenRecord();
                            } else {
                              startScreenRecord();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),*/
                        // button to start broadcast
                        if (recording)
                          SizedBox(
                            height: 50.0,
                            width: double.maxFinite,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.all(12),
                                  shape: StadiumBorder()
                                ),
                                child: Text(
                                  'Start Shining',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  // waitAndRecord();
                                  if (!isInviteSent) {
                                    FirestoreService.shineInvite(
                                      user_id,
                                    );
                                    setState(() {
                                      isInviteSent = true;
                                    });
                                  }
                                  onJoin(context: context, isBroadcaster: true);
                                  // goToBroadcastPage(context: context, isBroadCast: false);
                                }),
                          ),
                        UploadIndicator(),
                        // if (path != null && !status)
                        //   SizedBox(
                        //     height: 50.0,
                        //     width: double.maxFinite,
                        //     child: RaisedButton(
                        //       color: Colors.green,
                        //       shape: StadiumBorder(),
                        //       child: Text(
                        //         'Upload video to Server',
                        //         style: TextStyle(
                        //           fontSize: 17.0,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //       onPressed: () async {},
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (_timer != null && _timer!.isActive)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Text(
                    _start == 0 ? "Recording!" : "$_start",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 80,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  startScreenRecord() async {
    file = null;
    path = null;

    setState(() {
      recording = !recording;
      textBtn = recording ? "Stop" : "Start";
    });
    if (!isInviteSent) {
      FirestoreService.shineInvite(
        user_id,
      );
      setState(() {
        isInviteSent = true;
      });
    }

    // await Future.delayed(Duration(milliseconds: 4200));
    // startRecordScreen();
    return true;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            // startRecordScreen();
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  //............ Need to comment out those method ..........
  // startRecordScreen() async {
  //   var status = await Permission.manageExternalStorage.request();
  //   if (!isRecStarted) {
  //     String date = DateTime.now().toString();
  //     bool? started =
  //         await FlutterScreenRecording.startRecordScreenAndAudio(date).then(
  //             (value) {
  //       print("SS $value");
  //       return value;
  //     }, onError: (e) async {
  //       print("EE $e");
  //       return false;
  //     });
  //     startTimer();
  //     isRecStarted = started!;
  //     // if (isRecStarted == false) {
  //     //   Navigator.of(context).pop();
  //     // }
  //   }
  // }
  //
  // stopScreenRecord() async {
  //   clearEndedBroadcast();
  //   if (isRecStarted == true) {
  //     try {
  //       // clearEndedBroadcast();
  //       path = await FlutterScreenRecording.stopRecordScreen;
  //       print("vedio path :- $path");
  //       print("vedio path :- ${path!.length}");
  //       setState(() {
  //         isRecStarted = false;
  //         recording = !recording;
  //         textBtn = (recording) ? "Stop" : "Start";
  //       });
  //       findFile();
  //     } catch (_) {
  //       print("-=-=-");
  //       print(_);
  //       print("-=-=-");
  //     }
  //   }
  //   // try {
  //   //   var stopResponse = await screenRecorder?.stopRecord();
  //   //   setState(() {
  //   //     _response = stopResponse;
  //   //     path = (_response?['file'] as File?)?.path;
  //   //     print("File: ${(_response?['file'] as File?)?.path}");
  //   //     isRecStarted = false;
  //   //     recording = !recording;
  //   //     textBtn = (recording) ? "Stop" : "Start";
  //   //   });
  //   //   findFile();
  //   // } on PlatformException {
  //   //   print("Error: An error occurred while stopping recording.");
  //   // }
  // }

  void clearEndedBroadcast() async {
    await FirebaseFirestore.instance
        .collection("livebroadcast")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future<void> onJoin(
      {required BuildContext context, required bool isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    try {
      NotificationService service = NotificationService();

      final notId = await service.getPlayerId();
      FirebaseFirestore.instance.collection("livebroadcast").add({
        "name": ('${user_firstname!}  ${user_lastname!}'),
        "photoUrl": user_image_url ?? "https://pngtree.com/so/avatar",
        "userId": user_id,
        "notificationId": notId,
      });
      startScreenRecord();
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => BroadcasterPage(
            channelName: user_id,
            isBroadcaster: isBroadcaster,
          ),
        ),
      )
          .then((value) {
        // stopScreenRecord();
      });
    } catch (e) {}
  }

  // void goToBroadcastPage({required BuildContext context,required bool isBroadCast}) async {
  //   try {
  //     NotificationService service = NotificationService();
  //
  //     final notId = await service.getPlayerId();
  //     FirebaseFirestore.instance.collection("livebroadcast").add({
  //       "name": ('${user_firstname!}  ${user_lastname!}'),
  //       "photoUrl": user_image_url ?? "https://pngtree.com/so/avatar",
  //       "userId": user_id,
  //       "notificationId": notId,
  //     });
  //     startScreenRecord();
  //     // broadcast notification
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => BroadCasterPage(
  //           channelName: user_id,
  //         ),
  //       ),
  //     ).then((value) {
  //       stopScreenRecord();
  //     });
  //   } catch (e) {}
  // }

  recordingUpload() async {
    setState(() {
      status = true;
    });
    if (file != null) {
      bool result = await userVideo(file!, context);
      if (result) {
        file = null;
        path = null;
      }
      setState(() {
        status = false;
      });
    }
  }
}

class CAppBar extends StatelessWidget {
  final User? user;

  const CAppBar({this.user});

  static final TextEditingController _search_controller =
      TextEditingController();
  static GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  static GlobalKey? _globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5, right: 7, left: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
          ),
          SizedBox(width: 16.0),
          Text(
            "Shining",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "phenomena-bold",
                color: Colors.black),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 30,
            child: SimpleAutoCompleteTextField(
              key: _key,
              controller: _search_controller,
              suggestions: searchData,
              clearOnSubmit: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "mantserrat-bold"),
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                hintText: "*diy, *hair, ...",
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                fillColor: Colors.white,
              ),
            ),
          ),
          Avatar(user_image_url, user!.uid,
                  _globalKey as GlobalKey<ScaffoldState>?, context)
              .smallLogoHome(),
        ],
      ),
    );
  }
}
