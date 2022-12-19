 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/screens/livebroadcast/audience.dart';
import 'package:groomlyfe/ui/screens/livebroadcast/shining_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

Future<void> joinAsBroadcaster(BuildContext context) async {
  // await for camera and mic permissions before pushing video page
  bool result = await showPermissionRationale(
    context: context,
    content:
        "You are about to start shining. Clicking the yes button will notify all users of the broadcast. \nAre you sure you want to start shining?",
  );
  if (result) {
    isRecStarted = false;
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      await _handleCameraAndMic();
      // push video page with given channel name
      if (currentUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShiningPage(
              user: currentUser,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

Future<void> joinAsAudience(BuildContext context, String channel, String name,
    String image, String shinnerId, String notificationId) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AudiencePage(
        channelName: channel,
        name: name,
        image: image,
        shinnerId: shinnerId,
        notificationId: notificationId,
        isPreview: false,
      ),
    ),
  ).then((value) => null);
}

Future<void> _handleCameraAndMic() async {
  await [Permission.camera, Permission.microphone, Permission.storage]
      .request();
}

void showToast(BuildContext context) {
  Toast.show(
    "No internet Connection. Please check your Connection",
    duration: Toast.lengthLong,
    gravity: Toast.bottom,
    backgroundColor: Colors.red,
  );
}

showPermissionRationale(
    {required BuildContext context,
    String title = "Shining",
    String? content,
    bool startBroadcast = true}) {
  final textTheme = Theme.of(context).textTheme;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  content!,
                  textAlign: TextAlign.justify,
                  style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 24.0),
                SizedBox(
                  width: double.maxFinite,
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: SizedBox(
                          width: 60.0,
                          child: Center(
                            child: Text(
                              'NO',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      InkWell(
                        child: SizedBox(
                          width: 60.0,
                          child: Center(
                            child: Text(
                              'YES',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class AgoraProvider with ChangeNotifier {
  String? resourceId;
  String? sId;
  String? uId;

  updateResourceId(String id) {
    resourceId = id;
     notifyListeners();
  }

  updateSId(String id) {
    sId = id;
     notifyListeners();
  }

  updateUId(String id) {
    uId = id;
     notifyListeners();
  }

 
}
