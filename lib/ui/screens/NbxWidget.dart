import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/global/data.dart' as dInfo;
import 'package:groomlyfe/models/messages.dart';
import 'package:groomlyfe/models/user.dart';
import 'package:groomlyfe/ui/widgets/nbx_chat_item_widget.dart';
import 'package:groomlyfe/util/database.dart';

String getChatId(String first, String second) {
  String res = first + second;
  if (first.compareTo(second) > 0) {
    res = second + first;
  }
  return "ghost_chat_$res";
}

class NbxWidget extends StatefulWidget {
  final String? init_selected_user_id;

  const NbxWidget({Key? key, this.init_selected_user_id}) : super(key: key);

  @override
  _NbxWidgetState createState() => _NbxWidgetState();
}

class _NbxWidgetState extends State<NbxWidget> {
  TextEditingController _search_members_controller = TextEditingController();
  TextEditingController _send_message_controller = new TextEditingController();
  List<User?> chatSearchUsers = [];
  List<bool> selectedUserCheck = [];
  User? selected_user;
  bool? is_readed = true;
  //users in '''NBX'''''''''''''''''''''''
  List<User> chatUsers = [];
  bool isLoaded = false;

  // ghost chat and regular chat selection index
  bool check_ghost_chat = false;

  StreamSubscription? subscription;

  int getUserId(String? sender_id) {
    // chatSearchUsers[index].userId
    try {
      int j = -1;
      int len = chatSearchUsers.length;

      for (int i = 0; i < len; i++) {
        if (chatSearchUsers[i]!.userId == sender_id) {
          j = i;
          break;
        }
      }

      return j;
    } catch (e, t) {
      return -1;
    }
  }

  void getChatUserDataInitial() async {
    print("getChatUserDataInitial   ---");
    FirebaseDatabase.instance
        .ref()
        .child("chat")
        .orderByChild("receiver_id")
        // .orderByChild("sender_id")
        .equalTo("$user_id")
        // .orderByChild("create_at")
        // .equalTo(false, key: "is_ghost")
        // .limitToLast(60)
        .once()
        .then((data) {
      print("get CHats Once:----");
      print(data.snapshot.key);
      print("--------------------");
      print(data.snapshot.key!.length);
      Map<dynamic, dynamic> map = data.snapshot.value as Map<dynamic, dynamic>;
      map.forEach((key, value) {
        Chat chat = Chat(
            key: "$key",
            sender_id: "${value['sender_id']}",
            receiver_id: "${value['receive_id']}",
            is_readed: value['is_readed'],
            create_at: "${value['create_at']}",
            message: "${value['message']}",
            fcm_token: "${value['fcm_token']}");

        String? searchID = chat.sender_id;
        if (chat.sender_id == dInfo.user_id) {
          searchID = chat.receiver_id;
          print(searchID);
        } else {
          searchID = chat.sender_id;
        }

        int ind = getUserId(searchID);
        if (ind == -1) {
          return;
        }

        if (searchID == chatSearchUsers[ind]!.userId) {
          print("--------------------------------------------------");

          User? temp = chatSearchUsers[ind];
          chatSearchUsers.remove(temp);
          chatSearchUsers.insert(0, temp);
          setState(() {});
        }
      });
      print("--------------------");
    },onError: (e){
          print("EX $e");
    });
  }

  void chatUserListener() {
    Stream a = FirebaseDatabase.instance
        .ref()
        .child("chat")
        // .orderByChild("receiver_id")
        .orderByChild("create_at")
        .equalTo("$user_id")
        // .orderByChild("create_at")
        // .equalTo(false, key: "is_ghost")
        // .limitToLast(60)
        .onValue;
    a.listen((event) {}).onData((data) {
      print("listen CHats onData:----");
      print(data?.snapshot?.key);
      print("--------------------");
      print(data?.snapshot?.value?.length);
      Map<dynamic, dynamic> map = data?.snapshot?.value;
      map.forEach((key, value) {
        Chat chat = Chat(
            key: "$key",
            sender_id: "${value['sender_id']}",
            receiver_id: "${value['receive_id']}",
            is_readed: value['is_readed'],
            create_at: "${value['create_at']}",
            message: "${value['message']}",
            fcm_token: "${value['fcm_token']}");

        String? searchID = chat.sender_id;
        is_readed = chat.is_readed;
        print("user id :_ $user_id");
        if (chat.sender_id == user_id) {
          searchID = chat.receiver_id;
          print(searchID);
        } else {
          searchID = chat.sender_id;
        }

        int ind = getUserId(searchID);
        if (ind == -1) {
          return;
        }

        if (searchID == chatSearchUsers[ind]!.userId) {
          print("--------------------------------------------------");

          User? temp = chatSearchUsers[ind];
          chatSearchUsers.remove(temp);
          chatSearchUsers.insert(0, temp);
          setState(() {});
        }
      });




/*      chatSearchUsers.forEach((key, value) {
        Chat chat = Chat(
            key: "$key",
            sender_id: "${value['sender_id']}",
            receiver_id: "${value['receive_id']}",
            is_readed: value['is_readed'],
            create_at: "${value['create_at']}",
            message: "${value['message']}",
            fcm_token: "${value['fcm_token']}");
        if (chat.sender_id == chatSearchUsers[index].userId) {
          print(
              "--------------------------------------------------");
          is_readed = chat.is_readed;

          User temp = chatSearchUsers[index];
          chatSearchUsers?.remove(temp);
          chatSearchUsers.insert(0, temp);
          //  setState(() {});
        }
      }*/
      print("--------------------");
    });
  }

  Future _get_chat_users({bool isFirst = false}) async {
    chatUsers = await TotalUserData().getVideoFirestore();
    selectedUserCheck = [];
    chatSearchUsers = [];
    chatSearchUsers.clear();

    if (isFirst == true && widget.init_selected_user_id != null) {
      setState(() {
        var query = chatUsers
            .where((element) => element.userId == widget.init_selected_user_id);
        if (query.length > 0) {
          selected_user = query.first;
          chatSearchUsers.add(selected_user);
          selectedUserCheck.add(true);
          for (var item
              in chatUsers.where((element) => element != selected_user)) {
            chatSearchUsers.add(item);
            print(item.userId);
            selectedUserCheck.add(false);
          }
        }
      });
    } else {
      for (var item in chatUsers) {
        chatSearchUsers.add(item);
        print(item.userId);
        selectedUserCheck.add(false);
      }
    }
  }

  // getting chat users in NBX'''''''''''''''''''''''''''
  _init_venue() async {
    await _get_chat_users(isFirst: true);
    getChatUserDataInitial();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init_venue();
    chatUserListener();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded == false) return Container();
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //nbx search
              buildSearchWidget(),
              //nbx body
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          buildUserList(),
          Container(
            height: 0.8,
            color: Colors.grey[400],
          ),
          new Builder(builder: (context) {
            for (int i = 0; i < chatSearchUsers.length; i++) {
              if (selectedUserCheck[i]) {
                selected_user = chatSearchUsers[i];
              }
            }
            return Column(
              children: <Widget>[
                selected_user == null
                    ? Container()
                    : (check_ghost_chat
                        ? buildGhostChat(selected_user)
                        : buildRegularChat(selected_user)),
                buildSendMsgWidget(selected_user),
              ],
            );
          }),
          buildGhostSwitch(),
        ],
      ),
    );
  }

  Row buildGhostSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Opacity(
          opacity: check_ghost_chat ? 1 : 0.6,
          child: InkWell(
            onTap: () {
              check_ghost_chat = !check_ghost_chat;
              _send_message_controller.text = "";
              setState(() {});
            },
            child: Image.asset(
              "assets/images/gl_dectective.png",
              width: 50,
            ),
          ),
        ),
      ],
    );
  }

  Container buildSendMsgWidget(User? selected_user) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: user_image_url == ""
                      ? Image.asset("assets/images/user.png")
                      : CachedNetworkImage(
                          imageUrl: user_image_url!,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "You",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: device_width - 130,
            child: TextField(
              onTap: () {
                print("DDD ${selected_user==null }");
                if(selected_user!=null){
                  FirebaseDatabase.instance
                      .ref()
                      .child("chat")
                      .orderByChild("id")
                      .equalTo(selected_user.userId! + user_id!)
                      .once()
                      .then((DatabaseEvent snap) {
                    if (snap.snapshot.value != null) {
                      Map data = snap.snapshot.value as Map<dynamic, dynamic>;
                      data.forEach((key, value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("chat")
                            .child(key)
                            .update({"is_readed": true});
                      });
                    }
                  });
                }

              },
              controller: _send_message_controller,
              maxLines: 3,
              decoration: InputDecoration(
                fillColor: Colors.grey,
                suffix: InkWell(
                  onTap: () async {
                    print("TAP CHAT DATA 1 ${selected_user==null}");
                    String message = _send_message_controller.text;
                    String now =
                        ((DateTime.now().millisecondsSinceEpoch / 1000).round())
                            .toString();
                    if (_send_message_controller.text != "" &&
                        selected_user != null){
                      print("TAP CHAT DATA");
                      ChatData().addMessageDB(
                        Chat(
                          notificationId: selected_user.notificationId,
                          id: user_id! + selected_user.userId!,
                          message: message,
                          sender_id: user_id,
                          receiver_id: selected_user.userId,
                          create_at: now,
                          is_readed: false,
                          is_ghost: check_ghost_chat,
                        ),
                      );
                    }



                    /* int tmpIndex = chatSearchUsers?.indexWhere((element) =>
                            element.userId == selected_user.userId) ??
                        -1;
                    if (tmpIndex > -1) {
                      User tmpUser = chatSearchUsers[tmpIndex];
                      chatSearchUsers.removeAt(tmpIndex);
                      chatSearchUsers.insert(0, tmpUser);
                      selectedUserCheck[0] = true;
                      selectedUserCheck[tmpIndex] = false;
                      this.selected_user = tmpUser;
                     //  setState(() {});
                    }*/

                    _send_message_controller.text = "";
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                      style: BorderStyle.solid),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder buildRegularChat(User? selected_user) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child("chat")
          // .orderByChild("create_at")
          // .equalTo(false, key: "is_ghost")
          .limitToLast(60)
          .onValue,
      builder: (context, snap) {
        List<Chat> chat_list = [];
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          Map data = snap.data.snapshot.value;

          data.forEach((key, value) {
            String chat_id = "${value["id"]}";
            if ((chat_id == selected_user!.userId! + user_id! ||
                    chat_id == user_id! + selected_user.userId!) &&
                value['is_ghost'] == false) {
              chat_list.add(
                Chat(
                  key: "$key",
                  create_at: "${value['create_at']}",
                  id: "${value['id']}",
                  is_readed: value['is_readed'],
                  message: "${value['message']}",
                  receiver_id: "${value['receiver_id']}",
                  sender_id: "${value['sender_id']}",
                ),
              );
            }
          });
        } else {}

        chat_list.sort((a, b) {
          return a.key.toString().compareTo(b.key.toString());
        });
        return Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            chat_list.isEmpty
                ? Container()
                : Column(
                    children: chat_list.map((data) {
                      return NbxChatItemWidget(
                        chatInfo: data,
                        selected_user: selected_user,
                      );
                    }).toList(),
                  ),
          ],
        );
      },
    );
  }

  Container buildGhostChat(User? selected_user) {
    return Container(
      padding: EdgeInsets.all(15),
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child("chat")
            // .equalTo(true)
            // .orderByChild("id")
            // .equalTo(
            //     selected_user.userId + user_id)
            .onValue,
        builder: (context, snap) {
          List<Chat> chat_list = [];
          if (snap.hasData &&
              !snap.hasError &&
              snap.data != null) {
            Map<String, dynamic> data = snap.data as Map<String, dynamic>;

            data.forEach((key, value) {
              String chat_id = "${value["id"]}";
              print("value['create_at'] ${value['create_at']}");
              if ((chat_id == selected_user!.userId! + user_id! ||
                      chat_id == user_id! + selected_user.userId!) &&
                  !value['create_at'].toString().contains("-") &&
                  value['is_ghost'] == true) {

                chat_list.add(Chat(
                    key: "$key",
                    create_at: "${value['create_at']}",
                    id: "${value['id']}",
                    is_readed: value['is_readed'],
                    message: "${value['message']}",
                    receiver_id: "${value['receiver_id']}",
                    sender_id: "${value['sender_id']}"));
              }
            });
          }

          if (chat_list.length == 0) {
            // chat_list.add(Chat(message: ""));
            return Container();
          }
          try {
            chat_list.sort((a, b) => b.create_at!.compareTo(a.create_at!));
          } catch (_) {}
          try {
            var senderId = chat_list[0].sender_id;
            return NbxChatItemWidget(
              chatInfo: chat_list[0],
              selected_user: senderId == user_id ? null : selected_user,
            );
          } catch (_) {
            return Container();
          }
        },
      ),
    );
  }

  Container buildUserList() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: device_height * 0.27,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chatSearchUsers.length,
        itemBuilder: (context, index) {

        //  print("IMAGE ${chatSearchUsers[index].photoUrl}");




          return Column(
            children: <Widget>[
           /*   InkWell(
                onTap: () async {
                  if (!selectedUserCheck[index]) {
                    FirebaseDatabase.instance
                        .reference()
                        .child("chat")
                        .orderByChild("id")
                        .equalTo(chatSearchUsers[index].userId + user_id)
                        .once()
                        .then((DataSnapshot snap) {
                      if (snap.value != null) {
                        Map data = snap.value;
                        data.forEach((key, value) {
                          FirebaseDatabase.instance
                              .reference()
                              .child("chat")
                              .child(key)
                              .update({"is_readed": true});
                        });
                      }
                    });
                  }
                  for (int i = 0; i < selectedUserCheck.length; i++) {
                    selectedUserCheck[i] = false;
                  }
                  selectedUserCheck[index] = true;
                  setState(() {});
                },
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child("chat")
                      .orderByChild("receiver_id")
                      .equalTo("$user_id")
                      .limitToLast(1)
                      .onValue,
                  builder: (context, snap) {
                  // print("snap.data.snapshot.value ${snap.data.snapshot.value}}");
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data.snapshot.value != null) {
                      print("-----------+++++++++++++++++++++------");
                      bool is_readed = true;
                      snap.data.snapshot.value.forEach((key, value) {
                        Chat chat = Chat(
                            key: "$key",
                            sender_id: "${value['sender_id']}",
                            receiver_id: "${value['receive_id']}",
                            is_readed: value['is_readed'],
                            create_at: "${value['create_at']}",
                            message: "${value['message']}",
                            fcm_token: "${value['fcm_token']}");
                        if (chat.sender_id == chatSearchUsers[index].userId) {
                          print(
                              "--------------------------------------------------");
                          is_readed = chat.is_readed;

                          User temp = chatSearchUsers[index];
                          chatSearchUsers?.remove(temp);
                          chatSearchUsers.insert(0, temp);
                          //  setState(() {});
                        }
                      });
                      return Stack(
                        alignment: Alignment(1.05, -1.05),
                        children: [
                          Container(
                            height: device_height * 0.24 - 60,
                            margin: EdgeInsets.all(5),
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedUserCheck[index]
                                      ? Colors.green
                                      : is_readed
                                          ? Colors.grey
                                          : Colors.red,
                                  width: selectedUserCheck[index]
                                      ? 3
                                      : is_readed
                                          ? 1
                                          : 3,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (chatSearchUsers[index].photoUrl == "" ||
                                      chatSearchUsers[index].photoUrl == null)
                                  ? Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                     chatSearchUsers[index].photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          is_readed
                              ? Container()
                              : Icon(
                                  Icons.announcement,
                                  color: Colors.red,
                                ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),*/

              InkWell(
                onTap: () async {
                  if (!selectedUserCheck[index]) {
                    FirebaseDatabase.instance
                        .reference()
                        .child("chat")
                        .orderByChild("id")
                        .equalTo(chatSearchUsers[index]!.userId! + user_id!)
                        .once()
                        .then((DatabaseEvent snap) {
                      if (snap.snapshot.value != null) {
                        Map data = snap.snapshot.value as Map<dynamic, dynamic>;
                        data.forEach((key, value) {
                          FirebaseDatabase.instance
                              .reference()
                              .child("chat")
                              .child(key)
                              .update({"is_readed": true});
                        });
                      }
                    });
                  }
                  for (int i = 0; i < selectedUserCheck.length; i++) {
                    selectedUserCheck[i] = false;
                  }
                  selectedUserCheck[index] = true;
                  setState(() {});
                },
                child: Stack(




                  alignment: Alignment(1.05, -1.05),
                  children: [
                    Container(
                      height: device_height * 0.24 - 25,
                      margin: EdgeInsets.all(5),
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedUserCheck[index]
                                ? Colors.green
                                : is_readed!
                                ? Colors.grey
                                : Colors.red,
                            width: selectedUserCheck[index]
                                ? 3
                                : is_readed!
                                ? 1
                                : 3,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (chatSearchUsers[index]!.photoUrl == "" ||
                            chatSearchUsers[index]!.photoUrl == null)
                            ? Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          chatSearchUsers[index]!.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    is_readed!
                        ? Container()
                        : Icon(
                      Icons.announcement,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                child: Text(
                  "${chatSearchUsers[index]!.firstName} ${chatSearchUsers[index]!.lastName}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),


            ],
          );
        },
      ),
    );
  }

  Container buildSearchWidget() {
    return Container(
      height: 50,
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: _search_members_controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "mantserrat-bold"),
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          hintText: "search for members",
          suffixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          print(value);
          chatSearchUsers = [];
          selectedUserCheck = [];
          for (var item in chatUsers) {
            String name = item.firstName! + " " + item.lastName!;
            print("+++++++++++++++++++++++++++++++++++++++++++++++++");
            print(name.toLowerCase().contains(value));
            if (name.toLowerCase().contains(value.toLowerCase())) {
              chatSearchUsers.add(item);
              selectedUserCheck.add(false);
            }
          }
          setState(() {});
        },
      ),
    );
  }
}
