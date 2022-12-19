import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/messages.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/ui/screens/profile/profile.dart';
import 'package:intl/intl.dart';

class NbxChatItemWidget extends StatelessWidget {
  final Chat? chatInfo;
  final User? selected_user;

  NbxChatItemWidget({Key? key, this.chatInfo, this.selected_user})
      : super(key: key);
  final DateFormat dateFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    late DateTime time;
    if (chatInfo!.create_at != null) {
      if (chatInfo!.create_at.toString().contains("-") &&
          chatInfo!.create_at.toString().contains(":")) {
        time = DateFormat("yyyy-MM-dd HH:mm:ss").parse(chatInfo!.create_at!);
      } else {
        if(chatInfo!.create_at!.length>10){
          time = new DateTime.fromMillisecondsSinceEpoch(int.parse(chatInfo!.create_at!));
        }else{
          int epoch = int.parse(chatInfo!.create_at!) * 1000;
          time = new DateTime.fromMillisecondsSinceEpoch(epoch);
        }

      }
     // print("time $time  ${chatInfo.create_at}");
    }
    double device_width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    chatInfo!.sender_id == user_id
                        ? user_image_url
                        : selected_user!.photoUrl,
                    chatInfo!.sender_id == user_id
                        ? user_id
                        : selected_user!.userId,
                    chatInfo!.sender_id == user_id
                        ? ""
                        : selected_user!.notificationId,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: chatInfo!.sender_id == user_id
                        ? user_image_url == ""
                            ? Image.asset("assets/images/user.png")
                            : CachedNetworkImage(
                                imageUrl: user_image_url!,
                              )
                        : (selected_user!.photoUrl == "" ||
                                selected_user!.photoUrl == null)
                            ? Image.asset("assets/images/user.png")
                            : CachedNetworkImage(
                                imageUrl: selected_user!.photoUrl!,
                              ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  chatInfo!.sender_id == user_id
                      ? "You"
                      : selected_user!.firstName!.substring(0, 1).toUpperCase() +
                          "." +
                          selected_user!.lastName!.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chatInfo!.create_at != null)
                Container(
                  child: Text(
                    DateFormat("EEEE, MMMM dd yyyy hh:mm aaa").format(time),
                    style: TextStyle(
                      fontFamily: 'phenomena-regular',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              Container(
                width: device_width - 130,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey[300],
                ),
                child: Text(
                  chatInfo!.message!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'phenomena-regular',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
