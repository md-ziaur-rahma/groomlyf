// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// class FlutterScreenRecording {
//   static const MethodChannel _channel =
//       const MethodChannel('flutter_screen_recording');

//   static Future<bool?> startRecordScreen(String name,
//       {String? titleNotification, String? messageNotification}) async {
//     await FlutterForegroundTask.init(
//         androidNotificationOptions: AndroidNotificationOptions(
//             channelId: "startRecordScreen", channelName: name));
//     await _maybeStartFGS(titleNotification, messageNotification);
//     final bool? start = await _channel
//         .invokeMethod('startRecordScreen', {"name": name, "audio": false});
//     return start;
//   }

//   static Future<bool?> startRecordScreenAndAudio(String name,
//       {String? titleNotification, String? messageNotification}) async {
//     await FlutterForegroundTask.init(
//         androidNotificationOptions: AndroidNotificationOptions(
//             channelId: "startRecordScreen", channelName: name));
//     await _maybeStartFGS(titleNotification, messageNotification);
//     final bool? start = await _channel
//         .invokeMethod('startRecordScreen', {"name": name, "audio": true});
//     return start;
//   }

//   static Future<String?> get stopRecordScreen async {
//     final String? path = await _channel.invokeMethod('stopRecordScreen');
//     if (Platform.isAndroid) {
//       await FlutterForegroundTask.stopService();
//     }
//     return path;
//   }

//   static _maybeStartFGS(
//       String? titleNotification, String? messageNotification) async {
//     if (Platform.isAndroid) {
//       // await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
//       return await FlutterForegroundTask.startService(
//         notificationText:
//             messageNotification != null ? messageNotification : "",
//         notificationTitle: titleNotification != null ? titleNotification : "",

//         // iconName: "org_thebus_foregroundserviceplugin_notificationicon",
//       );
//     }
//   }

//   static void globalForegroundService() {
//     print("current datetime is ${DateTime.now()}");
//   }
// }
