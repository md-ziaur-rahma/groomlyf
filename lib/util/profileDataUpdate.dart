import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/util/auth.dart';

//profile update(update user table of firestore and firebase database)
class ProfileUpdate {
  User user;

  ProfileUpdate(this.user);

  Future<bool> update() async {
    print(user.toJson());
    updateVideoDB();
    updateMessageDB();
    updateUserDB();
    Auth.storeUserLocal(user);
    return true;
  }

  Future<void> updateVideoDB() async {
    FirebaseDatabase.instance
        .ref()
        .child('video')
        .orderByChild("user_id")
        .equalTo("${user.userId}")
        .once()
        .then((data) {
      print("What happened?");
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) {
            FirebaseDatabase.instance
                .reference()
                .child('video')
                .child('${key.toString()}')
                .update({
              'user_name': '${user.firstName} ${user.lastName}',
              'user_image_url': "${user.photoUrl}"
            });
          });
        }
      }
    });
  }

  Future<void> updateMessageDB() async {
    FirebaseDatabase.instance
        .ref()
        .child('message')
        .orderByChild("userid")
        .equalTo("${user.userId}")
        .once()
        .then((data) {
      print("What happened?");
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) async {
            FirebaseDatabase.instance
                .reference()
                .child('message')
                .child('${key.toString()}')
                .update({
              'username': '${user.firstName} ${user.lastName}',
              'photoUrl': "${user.photoUrl}"
            });
            i++;
          });
        }
      }
      return null;
    });
  }

  Future<void> updateUserDB() async {
    print(user.userId);
    print(user.photoUrl);
    FirebaseFirestore.instance
        .collection('users')
        .doc('${user.userId}')
        .update({
      'firstName': '${user.firstName}',
      'lastName': '${user.lastName}',
      'photoUrl': "${user.photoUrl}"
    });

    FirebaseDatabase.instance
        .reference()
        .child('user')
        .orderByChild("userId")
        .equalTo("${user.userId}")
        .once()
        .then((data) {
      print("What happened?");
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) {
            FirebaseDatabase.instance
                .reference()
                .child('user')
                .child('${key.toString()}')
                .update(user.toJson());
          });
        }
      }
    });
  }
}
