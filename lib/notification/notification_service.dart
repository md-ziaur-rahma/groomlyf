import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:groomlyfe/controllers/agora_controllers.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/ui/screens/home.dart';
import 'package:groomlyfe/ui/screens/profile/profile.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/util/auth.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
class NotificationService {
  static const String appID = 'd44d2a48-486a-4077-b9b1-4e612b081ee0';
  static String serverToken = 'AAAAq_isXDw:APA91bGXhQL4vxT3MqSePN5OeqbLzhEcBLuP5KQ-f7kfVEYfkFDQeGXosmCW8VGrsie1kXtQeu2CbNr5GM8e52sqPebPaxezkTKuyrYDDqYGBvZQyi55v5_9iakCT-Jk2HY0emqSjaMB';

  Future<String?> getPlayerId() async {
    /*final status = await OneSignal.shared.getDeviceState();
    final playerId = status.userId;
    print("PLAYER ID $playerId ${status.emailUserId}");*/
    //final playerId = "status.subscriptionStatus.userId";
    final playerId = await Auth.getFCMNotificationToken();
    return playerId;
  }

  void messageNotification({String? playerId, String? content}) async {
    Map<String, dynamic> additionalData = <String, dynamic>{
      "screen": "/nbxpage",
      "image": "$user_image_url",
      "userId": "$user_id",
    };
    sendAndRetrieveMessage(senderID: playerId,
        contentBody: content,
        title: '$user_firstname $user_lastname',
        payloadAdditionalData: additionalData);

    /* var notification = OSCreateNotification(
      playerIds: [playerId],
      content: '$content',
      heading: '$user_firstname $user_lastname',
      androidSmallIcon: 'ic_stat_one_signal_default',
      additionalData: <String, dynamic>{
        "screen": "/nbxpage",
        'image': user_image_url,
        'userId': user_id,
      },
    );
    print("errr ${notification.jsonRepresentation()}");

    try {
      await OneSignal.shared.postNotification(notification).then((value) {

      },onError: (e){
        print("errr $e");
      });
    } catch (_) {
      print("errr _ $_");
    }*/
  }

  void videoMessageNotification({String? playerId, String? content}) async {
    Map<String, dynamic> additionalData = <String, dynamic>{
      "image": "$user_image_url",
      "userId": "$user_id",
    };
    sendAndRetrieveMessage(senderID: playerId,
        contentBody: content,
        title: '$user_firstname $user_lastname commented on your video',
        payloadAdditionalData: additionalData);

    /*  var notification = OSCreateNotification(
      playerIds: [playerId],
      content: '$content',
      heading: '$user_firstname $user_lastname commented on your video',
      androidSmallIcon: 'ic_stat_one_signal_default',
      additionalData: <String, dynamic>{
        'image': user_image_url,
        'userId': user_id,
      },
    );
    try {
      await OneSignal.shared.postNotification(notification);
    } catch (_) {}*/
  }

  sendGleanNotification(
      {String? playerId, String? heading, content, final data}) async {
    final String? id = await getPlayerId();
    Map<String, dynamic> additionalData = <String, dynamic>{
      "screen": "/profilepage",
      "image": "$user_image_url",
      "userId": "$user_id",
      "notificationId": "$id",
      "title": "$user_firstname $user_lastname  gleaned you",
      "content": "${content ?? 'Tap to follow back'}",
      "data": "$data"
    };
    sendAndRetrieveMessage(senderID: playerId,
        contentBody: content ?? 'Just Tap to follow him back',
        title: heading ?? '$user_firstname $user_lastname  gleaned you',
        payloadAdditionalData: additionalData);

    /* var notification = OSCreateNotification(
      playerIds: [playerId],
      content: content ?? 'Just Tap to follow him back',
      heading: heading ?? '$user_firstname $user_lastname  gleaned you',
      androidSmallIcon: 'ic_stat_one_signal_default',
      androidLargeIcon: user_image_url ?? '',
      additionalData: <String, dynamic>{
        "screen": "/profilepage",
        'image': user_image_url,
        'userId': user_id,
        'notificationId': id,
        'title': '$user_firstname $user_lastname  gleaned you',
        'content': content ?? 'Tap to follow back',
        'data': data
      },
    );
    await OneSignal.shared.postNotification(notification);*/
  }

  sendShineInviteNotification({String? notificationId, String? channelId}) async {
    final String? id = await getPlayerId();


    Map<String, dynamic> additionalData = <String, dynamic>{
      "screen": "/audience",
      "photoUrl": "$user_image_url",
      "userId": "$user_id",
      "channelId": "$channelId",
      "notificationId": "$id",
      "username": "$user_firstname $user_lastname",
      "notificationId": "$id"
    };
    sendAndRetrieveMessage(senderID: notificationId, contentBody: 'Just Tap to follow him back',
        title: '$user_firstname $user_lastname invited you to his shinning',
        payloadAdditionalData: additionalData);
    /*var notification = OSCreateNotification(
      playerIds: [notificationId],
      content: 'Just Tap to follow him back',
      heading: '$user_firstname $user_lastname  invited you to his shinning.',
      androidSmallIcon: 'ic_stat_one_signal_default',
      androidLargeIcon: user_image_url ?? '',
      additionalData: <String, dynamic>{
        'screen': '/audience',
        'channelId': channelId,
        'username': '$user_firstname $user_lastname',
        'photoUrl': user_image_url ?? '',
        'userId': user_id,
        'notificationId': id
      },
    );
    try {
      await OneSignal.shared.postNotification(notification);
    } catch (_) {}*/
  }

  // intializes the function for one signal notification
  static Future<void> initPlatformState() async {
    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    OneSignal.shared.setRequiresUserPrivacyConsent(requiresConsent);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    // initialize one signal in the app
    /*await OneSignal.shared.init(appID, iOSSettings: settings);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);*/
    await OneSignal.shared.setRequiresUserPrivacyConsent(true);
    await OneSignal.shared.setAppId(appID);
  }

  // displays permission dialogs to the user
  static Future permissionDialog({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification Permission'),
          content: Text(
            'To continue, turn on device notification in Settings. This is require to notify you of glean request',
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.3,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'Okay',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }


  /// FCM INITIALIZATION
  static initFirebaseConfig() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.containsKey('data')) {
        // Handle data message
        final dynamic data = message.data['data'];
        print("containsKey ${message.data['data']}");
      }

      if (message.data.containsKey('notification')) {
        // Handle notification message
        final dynamic notification = message.data['notification'];
        flutterLocalNotificationsPlugin.show(
            DateTime
                .now()
                .millisecond, '${message.data['notification']['title']}',
            '${message.data['notification']['body']}', platformChannelSpecifics,
            payload: jsonEncode(
              <String, dynamic>{
                'screen': '${message.data['data']['screen']}',
                'userId': '${message.data['data']['userId']}',
                'image': '${message.data['data']['image']}'
              },
            )).then((value) {
          print("value: ");
        }, onError: (e) {
          print("onError: $e");
        });
      }

    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {

      RemoteNotification? _notification = message?.notification;
      // bool isNext = await checkMessageId(message.data["google.message_id"]);
      // if (!isNext) return;

      if (_notification != null) {
        print("OnLaunch::: $message");

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");

      await flutterLocalNotificationsPlugin.show(
          DateTime
              .now()
              .millisecond, '${message.data['notification']['title']}',
          '${message.data['notification']['body']}', platformChannelSpecifics,
          payload: jsonEncode(
            <String, dynamic>{
              'screen': '${message.data['data']['screen']}',
              'userId': '${message.data['data']['userId']}',
              'image': '${message.data['data']['image']}'
            },
          )).then((value) {
        print("value: ");
      }, onError: (e) {
        print("onError: $e");
      });

    });

    _firebaseMessaging.getToken().then((String? token) async {
      assert(token != null);

      Auth.saveFCMNotificationToken(token!);
      String? token1 = await Auth.getFCMNotificationToken();
      print(" token $token1");
    });
  }



  // Replace with server token from firebase console settings.


  static Future<Map<String, dynamic>> sendAndRetrieveMessage({String? senderID,
    String? title, String? contentBody, Map<String,
        dynamic>? payloadAdditionalData}) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false,
    );

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$contentBody',
            'title': '$title'
          },
          'priority': 'high',
          'data': payloadAdditionalData,
          'to': '$senderID'
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();


    return completer.future;
  }


  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static NotificationDetails? platformChannelSpecifics;

  ///display part notification
  static flutterLocalNotificationInit(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );
    // final MacOSInitializationSettings initializationSettingsMacOS =
    // MacOSInitializationSettings(
    //     requestAlertPermission: false,
    //     requestBadgePermission: false,
    //     requestSoundPermission: false);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsIOS
    );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String? payload) async {
    //       Map<String, dynamic> data = json.decode(payload!);
    //
    //
    //       print("PAYLOAD ${data['screen']}");
    //       redirectOnBackground(data,context);
    //     });

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true);
    platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  static void redirectOnBackground(Map<String, dynamic> data,
      BuildContext context) {
    final link = data["screen"];
    final profileURL = data['image'];
    final id = data['userId'];
    final notId = data['notificationId'];
    final senderData = data['data'];
    if (link == "/profilepage") {
      scheduler.SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                Profile(
                  profileURL,
                  id,
                  notId,
                  notification: true,
                  senderData: senderData,
                ),
          ),
        );
      });
    }
    if (link == "/nbxpage") {
      /* SchedulerBinding.instance.addPostFrameCallback((_) async {
        _showAds = false;
        await _get_chat_users();
        Future.delayed(Duration(milliseconds: 500), () {
          tab_index = 1;
          animation_opacity = 1.0;
          setState(() {
            title = "NBX";
          });
        });
      });*/
      HomePage().createState().funCallbackFromNotification();
    }
    if (link == '/audience') {
      scheduler.SchedulerBinding.instance.addPostFrameCallback((_) async {
        joinAsAudience(
          context,
          data['channelId'] ?? '',
          data['username'] ?? '',
          data['photoUrl'] ?? '',
          data['userId'] ?? '',
          data['notificationId'] ?? '',
        );
      });
    }
  }


  static void redirectOnTap(Map<String, dynamic> data, BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final link = data["screen"];
    final profileURL = data['image'];
    final id = data['userId'];
    final notId = data['notificationId'];
    final title = data['title'];
    final content = data['content'];
    final senderData = data['data'];
    if (link == "/profilepage") {
      scheduler.SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            title: title,
            message: content,
            icon:
            Avatar(profileURL, id, scaffoldKey, context).smallLogoHome(),
            duration: Duration(seconds: 6),
            flushbarPosition: FlushbarPosition.TOP,
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      Profile(
                        profileURL,
                        id,
                        notId,
                        notification: true,
                        senderData: senderData,
                      ),
                ),
              );
            })
          ..show(context);
      });

      if (link == '/audience') {
        scheduler.SchedulerBinding.instance.addPostFrameCallback((_) async {
          joinAsAudience(
            context,
            data['channelId'] ?? '',
            data['username'] ?? '',
            data['photoUrl'] ?? '',
            data['userId'] ?? '',
            data['notificationId'] ?? '',
          );
        });
      }
    }
  }
}
