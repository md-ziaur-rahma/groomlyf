import 'package:firebase_database/firebase_database.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/ads_video.dart';
import 'package:groomlyfe/models/messages.dart';
import 'package:groomlyfe/models/praise.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/notification/notification_service.dart';

//add and get all video info from firebase videos table
class VideoData {
  //add video to firebase database
  Future<void> addVideoDB(Video video) async {
    await FirebaseDatabase.instance
        .reference()
        .child('video')
        .push()
        .set(video.toJson())
        .then((ref) {
      return;
    });
  }

  Future getAdsVideoList() async {
    DatabaseEvent snapshot = await FirebaseDatabase.instance.ref().child("ads_files").once();
    List<AdsVideo> tmpVideoList = [];
    Map<dynamic, dynamic>? adInfoList = snapshot.snapshot.value as Map?;
    if (adInfoList != null) {
      adInfoList.forEach((key, value) {
        var adVideo = AdsVideo.fromDocument(value);
        adVideo.id = key;
        tmpVideoList.add(adVideo);
      });
    }
    return tmpVideoList;
  }

  //get videos from firebase database
  Future<void> getVideoFirestore() async {
    Video video;
    await FirebaseDatabase.instance
        .reference()
        .child("video")
        .orderByKey()
        .once()
        .then((DatabaseEvent snapshot) {
      user_videos = [];
      print(snapshot.snapshot.value);
      Map values = snapshot.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        video = Video(
            key: key,
            ID: "${values['ID']}",
            image_url: "${values['image_url']}",
            video_url: "${values['video_url']}",
            video_category: "${values['video_category']}",
            user_id: "${values['user_id']}",
            user_email: "${values['user_email']}",
            user_image_url: "${values['user_image_url']}",
            user_name: "${values['user_name']}",
            user_create_at: "${values['user_create_at']}",
            video_description: "${values['video_description']}",
            video_tag: "${values['video_tag']}",
            video_title: "${values['video_title']}",
            video_view_count: values['video_view_count'],
            video_like_count: values['video_like_count'],
            video_groomlyfe_count: values['video_groomlyfe_count'],
            notificationId: "${values['notificationId']}",
            isStreaming:
                values['isStreaming'] == null ? false : values['isStreaming']);
        user_videos.add(video);
      });

      //all videos
      user_videos = user_videos.reversed.toList();
    });
  }

  //video looking count
  Future<void> updateVideoCount(int? count, String? key, String type) async {
    print(key);
    FirebaseDatabase.instance.ref().child('video').child('$key').update({
      '$type': count //yes I know.
    });
  }

  //add video like, favorite, praise
  Future<void> praiseVideo(Praise praise, String check_praise) async {
    print(praise.id);
    FirebaseDatabase.instance
        .ref()
        .child("video_praise")
        .orderByChild("id")
        .equalTo(praise.id)
        .once()
        .then((DatabaseEvent dataSnapshot) {
      Map? data = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;
      print("+_+_+_+_+_+_+_+_+$data");
      if (data == null) {
        FirebaseDatabase.instance
            .reference()
            .child("video_praise")
            .push()
            .set(praise.toJson());
      } else {
        data.forEach((key, value) {
          print("$key jdklsajfkldsajklfjadslfjkl");
          FirebaseDatabase.instance
              .reference()
              .child("video_praise")
              .child("${key}")
              .update({"$check_praise": true});
        });
      }
    });
  }
}

//add video messages(commit)
class MessageData {
  Future<void> addMessageDB(ChatMessage message) async {
    NotificationService service = NotificationService();
    await FirebaseDatabase.instance
        .ref()
        .child('message')
        .push()
        .set(message.toJson())
        .then((ref) {
      return;
    });
    service.videoMessageNotification(
        playerId: message.notificationId, content: message.message);
  }
}

//save chat to database
class ChatData {
  Future<void> addMessageDB(Chat message) async {
    NotificationService service = NotificationService();
    await FirebaseDatabase.instance
        .reference()
        .child('chat')
        .push()
        .set(message.toJson());
    service.messageNotification(
        playerId: message.notificationId, content: message.message);
  }
}

//get user info from firebase realtime database user table
class TotalUserData {
  Future<List<User>> getVideoFirestore() async {
    List<User> users = [];
    try {
      await FirebaseDatabase.instance
          .ref()
          .child("user")
          .once()
          .then((DatabaseEvent snapshot) {
        print(snapshot.snapshot.value);
        Map values = snapshot.snapshot.value as Map<dynamic, dynamic>;
        users.clear();
        values.forEach((key, values) {
          User user;
          user = User(
              userId: "${values['userId']}",
              firstName: "${values['firstName']}",
              lastName: "${values['lastName']}",
              email: "${values['email']}",
              photoUrl: "${values['photoUrl']}",
              notificationId: "${values['notificationId']}",
              create_at: "${values['create_at']}");
          if (user.userId != user_id) {
            users.add(user);
          }
        });
      });
    } catch (e) {}

    return users;
  }
}
