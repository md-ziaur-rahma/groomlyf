import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/notification/notification_service.dart';
import 'package:rxdart/rxdart.dart';

import '../models/glean.dart';

class FirestoreService {
  static Stream<List<Glean>> followings(String? userId) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('audience')
        .where('status', isLessThan: 4)
        .snapshots();
    return stream.map((snapshot) {
      final result = snapshot.docs.map((e) {
        // final data = e.data() as Glean;
        Map<String, dynamic> data = json.decode(json.encode(e.data()));
        return Glean(userId: data["id"], status: data["status"]);
      }).toList();
      return result;
    });
  }

  static Stream<List<Glean>> followingsAudience(
      String? userId, String? checkerId) {
    return Rx.combineLatest2(followings(userId), followings(checkerId),
        (List<Glean> userFollowing, List<Glean> checkerFollowing) {
      List<Glean> result = [];
      userFollowing.removeWhere((user) => user.userId == checkerId);
      for (Glean user in userFollowing) {
        int? statusCode = -1;
        for (Glean checker in checkerFollowing) {
          print('Hello');
          if (user.userId == checker.userId) {
            print(checker.userId);
            statusCode = checker.status;
          }
        }
        result.add(Glean(userId: user.userId, status: statusCode));
      }
      return result;
    });
  }

  static Stream<List<Glean>> requestStream(String? userId) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('audience')
        .where('status', isEqualTo: 4)
        .snapshots();
    return stream.map((snapshot) {
            final result = snapshot.docs
                .map((e) => Glean(userId: e.id))
                .toList();
            return result;
          });
  }

  static Stream<Counts> counts(String? userId) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('audience')
        .snapshots();
    return stream.map((snapshot) {
            int requests = 0;
            int audience = 0;
            snapshot.docs.forEach((e) {
              final data = e.data() as Glean;
              if (data.status == 4) {
                requests = requests + 1;
              } else {
                audience = audience + 1;
              }
            });
            return Counts(
              audience: audience,
              requests: requests,
            );
          });
  }

  static Stream<List<Video>> myVideosStream(String? myUserId) {
    List<Video> result = [];
    Stream stream = FirebaseDatabase.instance
        .ref()
        .child("video")
        .orderByChild("user_id")
        .equalTo(myUserId)
        .onValue;
    return stream.map((event) {
      // result.clear();
      print("iiiiiiiiiiiiiiiiiii inside video stream : ${event.snapshot.value} iiiiiiiiiiiiiiiiii");
      final value = event.snapshot.value;
      if (value != null) {
        value.forEach((key, data) {
          Video video = Video.fromJson(data);
          video.key = key;
          result.add(video);
        });
      }
      return result;
    });
  }

  static Stream<int> getTotalPraise(String? userId) {
    int totalCount = 0;
    return myVideosStream(userId).map((videoList) {
      videoList.forEach((video) {
        Stream stream = FirebaseDatabase.instance
            .ref()
            .child("video_praise")
            .orderByChild("is_parsing")
            .equalTo(true)
            .orderByChild("video_id")
            .equalTo("${video.key}")
            .onValue;
        stream.map((event) {
          totalCount += 1;
        });
      });
      return totalCount;
    });
  }

  static Stream<bool?> isGleaned(String? userId, String? followingId) {
    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('audience')
        .where('id', isEqualTo: followingId)
        .snapshots();
    bool? isGleaned = false;
    return stream.map((event) {
      if (event.docs.length > 0) {
        isGleaned = event.docs[0].data()['glean'];
      }
      return isGleaned;
    });
  }

  // to glean with someone
  static glean(
      String? userId, String? followingId, String? notId, final data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .set({'id': followingId, 'status': 0, 'glean': true});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followingId)
          .collection('audience')
          .doc(userId)
          .set({'id': userId, 'status': 4, 'glean': false});

      NotificationService service = NotificationService();
      await service.sendGleanNotification(playerId: notId, data: data);
      print('__________________________________Notification Sent');
    } catch (e) {
      print('Error ndwjhfhdvfhvjhdvfjvh');
    }
  }

  // to
  static cancelGlean(String? userId, String? followingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followingId)
          .collection('audience')
          .doc(userId)
          .delete();
    } catch (e) {
      print('Error ndwjhfhdvfhvjhdvfjvh');
    }
  }

  static unblock(String? userId, String? followingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .update({'status': 1});
    } catch (e) {
      print('Error ndwjhfhdvfhvjhdvfjvh');
    }
  }

// pending-0,  gleaned-1, ungleaned-2, block-3 request-4
  static add(String? userId, followingId, String? notId, final data) async {
    print('my notificationId $notId');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .update({'status': 1, 'glean': true});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(followingId)
          .collection('audience')
          .doc(userId)
          .update({'status': 1, 'glean': true});

      NotificationService service = NotificationService();
      await service.sendGleanNotification(
          playerId: notId,
          heading: '$user_firstname $user_lastname  gleaned you',
          content: 'You are now connected',
          data: data);
    } catch (e) {}
  }

  // unglean- status = 2
  static unglean(String? userId, followingId) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .update({'status': 2});
    } catch (e) {}
  }

  static gleanAgain(String? userId, followingId) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .update({'status': 1});
    } catch (e) {}
  }

  // block- status = 3
  static block(String? userId, followingId) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('audience')
          .doc(followingId)
          .update({'status': 3});
    } catch (e) {}
  }

  static Stream<Map> profileStream(String? userId) {
    Stream<DocumentSnapshot> stream =
    FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return stream.map(((document) => document.data() as Map<dynamic, dynamic>));
  }

  static Stream<Videoview> videoStream(String? userId) {
    Stream stream =
        FirebaseDatabase.instance.ref().child("video").onValue;
    return stream == null
        ? Videoview() as Stream<Videoview>
        : stream.map((event) {
            final value = event.snapshot.value;
            int favNumber = 0;
            int faceNumber = 0;
            int starNumber = 0;
            value.forEach((key, data) {
              if (data['user_id'] == userId) {
                favNumber += data['video_like_count'] as int;
                faceNumber += data['video_view_count'] as int;
                starNumber += data['video_groomlyfe_count'] as int;
              }
            });
            return Videoview(
              faceNumber: faceNumber,
              favNumber: favNumber,
              starNumber: starNumber,
            );
          });
  }

  static Stream<Audience> audienceStream(String? userId) {
    return Rx.combineLatest2(profileStream(userId), videoStream(userId),
        (Map profile, Videoview videoview) {
      return Audience(
        createdAt: profile['create_at'] ?? '',
        name: '${profile['firstName'] ?? ''}  ${profile['lastName'] ?? ''} ',
        email: profile['email'] ?? '',
        id: profile['userId'] ?? '',
        photoURL: profile['photoUrl'] ?? '',
        notificationId: profile['notificationId'] ?? '',
        videoview: videoview,
      );
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSetting(String? user_id) {
    return FirebaseFirestore.instance
        .collection('settings')
        .doc(user_id)
        .snapshots();
  }

  static submitChatMessage(
      String? channelId, String senderName, String text, String? senderId) {
    FirebaseFirestore.instance
        .collection("livebroadcast")
        .doc(channelId)
        .collection("chatHistory")
        .add({
      "senderName": senderName,
      "text": text,
      "sendereId": senderId,
      "createdAt": DateTime.now().millisecondsSinceEpoch / 1000
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getShiningChatHistory(String? channelId) {
    return FirebaseFirestore.instance
        .collection('livebroadcast')
        .doc(channelId)
        .collection("chatHistory")
        .orderBy('createdAt')
        .snapshots();
  }

  static void shineInvite(String? user_id) async {
    QuerySnapshot gleans = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('audience')
        .where('glean', isEqualTo: true)
        .get();

    List<String> userList = gleans.docs.map((e) => e.id).toList();

    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<String> notificationIdList = userSnapshot.docs
        .where((element) => userList.contains(element.id))
        .where((element) => (element.data() as Map<String, dynamic>)['notificationId'] != null)
        .map((e) => (e.data()  as Map<String, dynamic>)['notificationId'] == null
            ? ""
            : "${(e.data()  as Map<String, dynamic>)['notificationId']}")
        .toList();
    try {
      notificationIdList.forEach((id) {
        NotificationService service = NotificationService();
        if (id != "") {
          service.sendShineInviteNotification(
            notificationId: id,
            channelId: user_id,
          );
        }
      });
    } catch (err) {
      print('Error: ${err.toString()}');
    }
  }
}
