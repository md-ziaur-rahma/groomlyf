import 'package:firebase_database/firebase_database.dart';

//video messages
class ChatMessage {
  String? key;
  String? videoKey;
  String? userid;
  String? username;
  String? user_create_at;
  String? notificationId;
  String? photoUrl;
  String? message;
  String? created_at;

  ChatMessage(
      {this.key,
      this.videoKey,
      this.userid,
      this.username,
      this.user_create_at,
      this.photoUrl,
      this.message,
      this.notificationId,
      this.created_at});

  ChatMessage.fromSnapshot(DataSnapshot snapshot, String username)
      : photoUrl = (snapshot.value as Map<String, dynamic>)['photoUrl'],
        message = (snapshot.value as Map<String, dynamic>)['message'],
        username = (snapshot.value as Map<String, dynamic>)['username'],
        videoKey = (snapshot.value as Map<String, dynamic>)['videoKey'],
        created_at = (snapshot.value as Map<String, dynamic>)['created_at'],
        notificationId = (snapshot.value as Map<String, dynamic>)['notificationId'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'videoKey': videoKey,
      'userid': userid,
      'username': username,
      'photoUrl': photoUrl,
      'message': message,
      'created_at': created_at,
      'notificationId': notificationId,
    };
  }
}

//ghost&regular chat
class Chat {
  String? key;
  String? id;
  String? message;
  String? sender_id;
  String? receiver_id;
  bool? is_readed;
  bool? is_ghost;
  String? create_at;
  String? notificationId;
  String? fcm_token;
  Chat(
      {this.key,
      this.id,
      this.message,
      this.sender_id,
      this.receiver_id,
      this.is_readed,
      this.create_at,
      this.notificationId,
      this.fcm_token,
      this.is_ghost});
  toJson() {
    return {
      'id': id,
      'message': message,
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'is_readed': is_readed,
      'create_at': DateTime.now().millisecondsSinceEpoch,//create_at,
      'fcm_token': fcm_token,
      'is_ghost': is_ghost,
    };
  }
}
