import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/agora_controllers.dart';
import '../../global/data.dart';
import '../../models/ads_video.dart';
import '../../models/categories.dart';
import '../../models/messages.dart';
import '../../models/state.dart';
import '../../models/user.dart';
import '../../models/video.dart';
import '../../notification/notification_service.dart';
import '../../providers/gl_academy_provider.dart';
import '../../providers/shop_registration.dart';
import '../../util/database.dart';
import '../../util/get_thumbnails.dart';
import '../../util/state_widget.dart';
import '../../util/storage.dart';
import '../../util/video_picker_handler.dart';
import '../widgets/acad.dart';
import '../widgets/ads.dart';
import '../widgets/avatar.dart';
import '../widgets/input_text_widget.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/shine_list.dart';
import '../widgets/shining.dart';
import '../widgets/shop.dart';
import '../widgets/toast.dart';
import '../widgets/video_upload_detail.dart';
import '../widgets/youtube_play.dart';
import 'NbxWidget.dart';
import 'livebroadcast/audience.dart';
import 'livebroadcast/components/broadcaster_profile.dart';
import 'sign_in.dart';
import 'video_play.dart';

class HomeScreen extends StatelessWidget {
  StateModel? appState;
  bool value = false;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('weight: ${size.width}, height: ${size.height}');
    appState = StateWidget.of(context).state;
    print(!appState!.isLoading);
    print(appState!.firebaseUserAuth);
    print(appState!.settings);
    print(appState!.user);

    /* ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:Text(
                '${appState.user}---${appState.user}---${appState.user}-${appState.firebaseUserAuth}-----${appState.settings}'
            )));*/
    if (!appState!.isLoading &&
        (appState!.firebaseUserAuth == null ||
            appState!.user == null ||
            appState!.settings == null)) {
      /*   print(appState.isLoading);
      print(appState.firebaseUserAuth);
      print(appState.settings);
      print(appState.user);*/
      value = true;
    }
    /* return value
        ? SignInScreen()
        : MultiProvider(
      providers: [
        FutureProvider<DataSnapshot>(
            create: (_) => FirebaseDatabase.instance
                .reference()
                .child("video")
                .once()),
        StreamProvider<QuerySnapshot>(
            create: (context) => Firestore.instance
                .collection("livebroadcast")
                .snapshots()),
        Provider(create: (context) => GlAcademyProvider()),
      ],
      child: HomePage(),
    );*/

    return Stack(
      children: [
        value
            ? SignInScreen()
            : MultiProvider(
                providers: [
                  FutureProvider<DatabaseEvent?>(
                      initialData: null,
                      create: (_) => FirebaseDatabase.instance
                          .ref()
                          .child("video")
                          .once()),
                  StreamProvider<QuerySnapshot?>(
                      initialData: null,
                      create: (context) => FirebaseFirestore.instance
                          .collection("livebroadcast")
                          .snapshots()),
                  Provider(create: (context) => GlAcademyProvider()),
                ],
                child: HomePage(),
              ),

        /*   Center(
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text("'${!appState.isLoading}---${appState.user}---${appState.firebaseUserAuth}-----${appState.settings}'",style: TextStyle(
               fontSize: 24,color: Colors.red
             ),),
           ),
         )*/
      ],
    );
  }

/*  @override
  State<HomeScreen> createState() => _HomeScreenState();*/
}

/*class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool value = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showToast(context);

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('weight: ${size.width}, height: ${size.height}');
    appState = StateWidget.of(context).state;


    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {


      print(appState.isLoading);
      print(appState.firebaseUserAuth);
      print(appState.settings);
      print(appState.user);
      value = true;
    }
    return value
        ? SignInScreen()
        : MultiProvider(
      providers: [
        FutureProvider<DataSnapshot>(
            create: (_) => FirebaseDatabase.instance
                .reference()
                .child("video")
                .once()),
        StreamProvider<QuerySnapshot>(
            create: (context) => Firestore.instance
                .collection("livebroadcast")
                .snapshots()),
        Provider(create: (context) => GlAcademyProvider()),
      ],
      child: HomePage(),
    );
  }


  showToast(BuildContext context){
    appState = StateWidget.of(context).state;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(
            '${appState.user}---${appState.user.userId}---${appState.user.email}-${appState.firebaseUserAuth.email}--${appState.firebaseUserAuth}----${appState.settings}'
        )));
  }
}*/

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, VideoPickerListner {
  //double click app close time//////////////////////////////////////
  DateTime? currentBackPressTime;

  //video search field key.................................................
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  //video search field controller.......................................
  TextEditingController _search_controller = TextEditingController();

  //search member controller in NBX tab .................................
  TextEditingController _search_members_controller = TextEditingController();

  //send message controller of videos  ...........................
  TextEditingController _messageController = TextEditingController();

  TextEditingController _send_message_controller = new TextEditingController();
  TextEditingController _receive_message_controller =
      new TextEditingController();

  //search query...............................
  String query = "";

  //search category data..........................
  List<Map<String, dynamic>> categories_data = [
    {"name": "Groomlyfe", "select_check": false},
    {"name": "Live", "select_check": false},
    {"name": "Cook", "select_check": false},
    {"name": "Art", "select_check": false},
    {"name": "History", "select_check": false},
    {"name": "Fashion", "select_check": false},
    {"name": "Social", "select_check": false},
    {"name": "Sport", "select_check": false},
  ];

  //home screen widget globla key...........using for avatar of users
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //auth
  StateModel? appState;

  //video uplaoding check index
  bool isUploading = false;

  //video list and video unfull screen selection index
  bool check_video_play = false;

  // ghost chat and regular chat selection index
  bool check_ghost_chat = false;

  //opacity for video click animation..........
  double video_click_opacity = 1;
  int i = 0;

  //animation controller///// for video picker
  AnimationController? _animationController;

  //video picker handler for uploading video.............
  late VideoPickerHandler videoPicker;

  //video controller in home page
  VideoPlayerController? _controller;

  //video's messages
  List<String> messages = [];

  //video variables with tag/........
  late List<Video> searchVideos;
  late List<Video> diy_videos;
  List<Video>? hair_videos;
  late List<Video> random_videos;
  List<Video> random_videos1 = [];
  List<Video> random_videos2 = [];

  //ad videos...........
  List<Video> ads_videos = [];

  List<AdsVideo> myAdsVideos = [];

  //current play video..........
  Video? current_video;

  //users in '''NBX'''''''''''''''''''''''
  List<User> chatUsers = [];
  List<User> chatSearchUsers = [];
  List<bool> selectedUserCheck = [];

  bool _venue_visible = false;

  bool _showAds = true;
  String uid = '';
  VoidCallback? _onTap;

  int? currentVideoIndex;

  @override
  void initState() {
    super.initState();
    NotificationService.flutterLocalNotificationInit(context);
    // Provider.of<DataSnapshot>(context, listen: false);
    //video categories  init///
    categories = [];
    for (var item in categories_data) {
      categories.add(Categories.fromJson(item));
    }

    //video's messages init...
    messages = [];

    //total videos init.........
    user_videos = [];

    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    //video picker init/........
    videoPicker =
        VideoPickerHandler(listener: this, controller: _animationController);
    videoPicker.init();

    //for getting chat user .....
    if (title == "NBX") {
      _init_venue();
    }
    _initVideoData();
    // on notification click ---------------------------
    //---------------------------------
    // executes the function when the notification tray is click
    // for app in background or foreground
    /*  OneSignal.shared.setNotificationOpenedHandler((handler) {
      final data = handler.notification.payload.additionalData;
      final link = data["screen"];
      final profileURL = data['image'];
      final id = data['userId'];
      final notId = data['notificationId'];
      final senderData = data['data'];
      if (link == "/profilepage") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Profile(
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
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          _showAds = false;
          await _get_chat_users();
          Future.delayed(Duration(milliseconds: 500), () {
            tab_index = 1;
            animation_opacity = 1.0;
            setState(() {
              title = "NBX";
            });
          });
        });
      }
      if (link == '/audience') {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
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
    });

    // executes the function when the app is open
    OneSignal.shared.setNotificationReceivedHandler((handler) {
      final data = handler.payload.additionalData;
      final link = data["screen"];
      final profileURL = data['image'];
      final id = data['userId'];
      final notId = data['notificationId'];
      final title = data['title'];
      final content = data['content'];
      final senderData = data['data'];
      if (link == "/profilepage") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
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
                    builder: (context) => Profile(
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
          */ /*  , */ /*
        });
      }
      if (link == '/audience') {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
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
    });*/

    updateNotificationId();
  }

  void funCallbackFromNotification() {
    print("funCallbackFromNotification");
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _showAds = false;
      await _get_chat_users();
      Future.delayed(Duration(milliseconds: 500), () {
        tab_index = 1;
        animation_opacity = 1.0;
        title = "NBX";

        /*   setState(() {

          });*/
      });
    });
    setState(() {});
  }

  // checks if notification permission is allowed on the user device
  checkNotificationPermissionStatus() async {
    // If you want to know if the user allowed/denied permission,
    /*  OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);*/

    // checks if notification permission is granted
    final result = await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    print("result $result");
    if (result == false) {
      // opens permission dialog
      await NotificationService.permissionDialog(context: context);
      // opens app settings for user to enable notification permission
      AppSettings.openAppSettings();
    }
  }

  updateNotificationId() async {
    NotificationService service = NotificationService();
    final String? notificationId = await service.getPlayerId();
    print("notificationId $notificationId");
    await FirebaseFirestore.instance.collection('users').doc(user_id).update({
      'notificationId': notificationId,
    });
    await FirebaseDatabase.instance
        .ref()
        .child('video')
        .orderByChild("user_id")
        .equalTo(user_id)
        .once()
        .then((data) {
      print("What happened?");
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) {
            FirebaseDatabase.instance
                .ref()
                .child('video')
                .child('${key.toString()}')
                .update({
              'notificationId': notificationId,
            });
          });
        }
      }
    });

    await FirebaseDatabase.instance
        .ref()
        .child('message')
        .orderByChild("userid")
        .equalTo(user_id)
        .once()
        .then((data) {
      print("What happened?");
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) async {
            FirebaseDatabase.instance
                .ref()
                .child('message')
                .child('${key.toString()}')
                .update({
              'notificationId': notificationId,
            });
            i++;
          });
        }
      }
    });

    FirebaseDatabase.instance
        .ref()
        .child('user')
        .orderByChild("userId")
        .equalTo(user_id)
        .once()
        .then((data) {
      Map? getData = data.snapshot.value as Map<dynamic, dynamic>?;
      if (getData != null) {
        int i = 0;
        if (i == 0) {
          getData.forEach((key, value) {
            FirebaseDatabase.instance
                .reference()
                .child('user')
                .child('${key.toString()}')
                .update({
              'notificationId': notificationId,
            });
          });
        }
      }
    });
  }

  //home dispose calling...
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
  }

  //init total videos ...................
  Future<void> _initVideoData() async {
    List<Video> check_video = user_videos;
    print("+++============+++++++++++++++++++++++++++++$check_video");

    myAdsVideos = await VideoData().getAdsVideoList();

    await VideoData().getVideoFirestore().then((_) {
//      List<Video> videos_items = [];
//      videos_splite = [];
      diy_videos = [];
      hair_videos = [];
      random_videos = [];
      searchVideos = [];
      random_videos1 = [];
      random_videos2 = [];

      for (Video item in user_videos) {
        if (item.video_category == query) {
          searchVideos.add(item);
        }
        if (query == "") {
          searchVideos.add(item);
        }
      }
      if (searchVideos.isEmpty) {
        query = "";
        setState(() {});
      }

      for (Video item in searchVideos) {
        if (item.video_category!.toUpperCase() != "*ADS" &&
                item.video_tag!.toUpperCase() == "DIY" ||
            item.video_tag!.toUpperCase() == "*DIY") {
          diy_videos.add(item);
        } else if (item.video_category!.toUpperCase() == "*ADS") {
          ads_videos.add(item);
        } else {
          random_videos.add(item);
        }
      }
      //todo
      for (int i = 0; i < (random_videos.length / 2).floor(); i++) {
        print("CAT ${random_videos[i].video_category}");
        if (random_videos[i].video_category!.contains(query)) {
          random_videos1.add(random_videos[i]);
          setState(() {});
        }
      }
      for (int i = (random_videos.length / 2).floor();
          i < random_videos.length;
          i++) {
        if (random_videos[i].video_category!.contains(query)) {
          random_videos2.add(random_videos[i]);
          setState(() {});
        }
      }
    });
    print(
        "RANDOM ${random_videos.length}  ${(random_videos.length / 2).floor()}");
  }

/*  searchDataFun(String query){

    diy_videos.clear();
    ads_videos.clear();
    random_videos.clear();
    searchVideos.forEach((searchItem) {
      if (searchItem.video_tag.contains(query) || searchItem.video_category.contains(query)){
        if (searchItem.video_category.toUpperCase() != "*ADS" &&
            searchItem.video_tag.toUpperCase() == "DIY" ||
            searchItem.video_tag.toUpperCase() == "*DIY") {
          diy_videos.add(searchItem);
        } else if (searchItem.video_category.toUpperCase() == "*ADS") {
          ads_videos.add(searchItem);
        } else {
          random_videos.add(searchItem);
        }
      }

    });
    for (int i = 0; i < (random_videos.length / 2).floor(); i++) {
      random_videos1.add(random_videos[i]);
    }
    for (int i = (random_videos.length / 2).floor();
    i < random_videos.length;
    i++) {
      random_videos2.add(random_videos[i]);
    }
    setState(() {

    });
  }*/

  @override
  // current video play init ........................
  _video_init(String video_url) async {
    _controller = VideoPlayerController.network(video_url)
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
  }

  // getting chat users in NBX'''''''''''''''''''''''''''
  _init_venue() async {
    await _get_chat_users();
  }

  Future _get_chat_users() async {
    chatUsers = await TotalUserData().getVideoFirestore();
    selectedUserCheck = [];
    chatSearchUsers = [];
    for (var item in chatUsers) {
      chatSearchUsers.add(item);
      print(item.userId);
      selectedUserCheck.add(false);
    }
    setState(() {});
  }

  //calling tabs 'venue', 'acad', 'shop', ....
  Widget _tabView(int index) {
    switch (index) {
      case 0:
        return _HomeView();
        break;
      case 1:
        return SingleChildScrollView(child: NbxWidget());
        break;
      case 3:
        return SingleChildScrollView(child: _ShopView());
        break;
      case 4:
        return _TVView(
          uid,
        );
        break;
      case 5:
        return SingleChildScrollView(child: _AcadView());
        break;
      default:
        return Offstage();
    }
  }

  //screen
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      //   await checkNotificationPermissionStatus();
      // });
    }
    //init device width and height .....
    device_width = MediaQuery.of(context).size.width;
    device_height = MediaQuery.of(context).size.height;
    print(device_height);

    //auth.... and get user info from auth............
    appState = StateWidget.of(context).state;
    if (!appState!.isLoading &&
        (appState!.firebaseUserAuth == null ||
            appState!.user == null ||
            appState!.settings == null)) {
      print(appState!.isLoading);
      print(appState!.firebaseUserAuth);
      print(appState!.settings);
      print(appState!.user);
      return SignInScreen();
    } else {
      // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ));
      //check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final photoUrl =
          appState?.user?.photoUrl ?? "https://pngtree.com/so/avatar";
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final creat_at = appState?.user?.create_at ?? '';
      uid = userId;
      if (user_id == null) {
        animation_opacity = 1.0;
        user_id = userId;
        user_email = email;
        user_image_url = "";
        user_image_url = photoUrl;
        user_firstname = firstName;
        user_lastname = lastName;
        user_create_at = creat_at;
      }

      //screen...........................
      return WillPopScope(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                brightness: Brightness.light,
                elevation: 0,
              ),
            ),
            // backgroundColor: Colors.grey,
            key: scaffoldKey,
            body: SafeArea(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      height: device_height,
                      child: SingleChildScrollView(
                        controller:
                            Provider.of<GlAcademyProvider>(context).controller,
                        // physics: NeverScrollableScrollPhysics(),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                //top search bar..................................
                                tab_index == 4
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 5,
                                          right: 7,
                                          left: 7,
                                          top: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: tab_index == 5 ||
                                                  tab_index == 3 ||
                                                  tab_index == 1
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            title.toLowerCase() == "venue"
                                                ? InkWell(
                                                    onTap: () {
                                                      if (_controller!
                                                          .value.isPlaying) {
                                                        _controller!.pause();
                                                      }
                                                      animation_opacity = 0.0;
                                                      setState(() {});
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        animation_opacity = 1.0;

                                                        setState(() {
                                                          title = "VENUE";
                                                          check_video_play =
                                                              false;
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Stack(
                                                            alignment:
                                                                Alignment(
                                                                    1.5, -1),
                                                            children: <Widget>[
                                                              Text(
                                                                "Venue",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        30,
                                                                    fontFamily:
                                                                        "phenomena-bold",
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Text(
                                                                "GL",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'phenomena-regular',
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Row(
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          Provider.of<AdsProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .cancelAds(
                                                                  value: true);
                                                          if (tab_index != 0) {
                                                            animation_opacity =
                                                                0.0;
                                                            setState(() {});
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                                () {
                                                              tab_index = 0;
                                                              animation_opacity =
                                                                  1.0;
                                                              if (_venue_visible) {
                                                                _venue_visible =
                                                                    false;
                                                              }
                                                              setState(() {
                                                                _showAds = true;
                                                                title = "VENUE";
                                                              });
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        "assets/images/${title.toLowerCase()}.png",
                                                        width:
                                                            title.toLowerCase() ==
                                                                    "glacad"
                                                                ? 50
                                                                : 30,
                                                      ),
                                                    ],
                                                  ),
                                            title.toLowerCase() == "venue" ||
                                                    title.toLowerCase() ==
                                                        "glacad"
                                                ? Container()
                                                : tab_index == 4
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            left: 0.0),
                                                        child: Text(
                                                          "${title.toLowerCase()}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 25,
                                                              fontFamily:
                                                                  'phenomena-bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8.0),
                                                          child: Text(
                                                            "${title.toLowerCase()}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25,
                                                                fontFamily:
                                                                    'phenomena-bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                            tab_index == 5 ||
                                                    tab_index == 3 ||
                                                    tab_index == 1
                                                ? Offstage(
                                                    child: Container(
                                                      width: device_width * 0.5,
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      if (check_video_play ||
                                                          title != "VENUE") {
                                                        if (check_video_play) {
                                                          _controller!.pause();
                                                        }

                                                        animation_opacity = 0.0;
                                                        setState(() {});
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          tab_index = 0;
                                                          animation_opacity =
                                                              1.0;
                                                          setState(() {
                                                            title = "VENUE";
                                                          });
                                                        });

                                                        query = "";
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      width: device_width * 0.6,
                                                      height: 30,
                                                      child:
                                                          SimpleAutoCompleteTextField(
                                                        key: key,
                                                        controller:
                                                            _search_controller,
                                                        suggestions: searchData,
                                                        clearOnSubmit: false,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "mantserrat-bold"),
                                                          border: new OutlineInputBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      25.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1)),
                                                          enabledBorder: new OutlineInputBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      25.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1)),
                                                          hintText:
                                                              "*diy, *hair, ...",
                                                          suffixIcon: Icon(
                                                            Icons.search,
                                                            color: Colors.black,
                                                          ),
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        submitOnSuggestionTap:
                                                            true,
                                                        textChanged: (s) async {
                                                          if (s.isEmpty) {
                                                            _search_controller
                                                                .text = "";
                                                            query = "";
                                                            await _initVideoData();
                                                          }
                                                        },
                                                        textSubmitted:
                                                            (text) async {
                                                          print("onSubmit");
                                                          bool check = false;

                                                          /* if(_search_controller.text.isNotEmpty){
                                                   //   searchDataFun(_search_controller.text);
                                                    }else{
                                                      await _initVideoData();
                                                    }*/

                                                          for (String search_item
                                                              in searchData) {
                                                            if (text ==
                                                                search_item) {
                                                              check = true;
                                                            }
                                                          }
                                                          if (text == "") {
                                                            query = "";
                                                          } else {
                                                            if (check) {
                                                              query = text;
                                                            } else {
                                                              _search_controller
                                                                  .text = "";
                                                              query = "";
                                                            }
                                                          }
                                                          await _initVideoData();
                                                          print("query $query");
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                            Avatar(user_image_url, userId,
                                                    scaffoldKey, context)
                                                .smallLogoHome(),
                                          ],
                                        ),
                                      ),

                                //animation tab screens///////////////////////
                                AnimatedOpacity(
                                    opacity: animation_opacity,
                                    duration: Duration(milliseconds: 500),
                                    child:
                                        SafeArea(child: _tabView(tab_index))),
                              ],
                            ),

                            //animation gradient grey to black effect////////////////
                            AnimatedOpacity(
                              opacity: animation_opacity == 1 ? 0 : 1,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                height: animation_opacity == 1
                                    ? 0
                                    : device_height - 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    // Where the linear gradient begins and ends
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    // Add one stop for each color. Stops should increase from 0 to 1
                                    stops: [0.1, 0.5, 0.7, 0.9],
                                    colors: [
                                      // Colors are easy thanks to Flutter's Colors class.
                                      Colors.grey.withOpacity(0.0),
                                      Colors.grey.withOpacity(0.2),
                                      Colors.black26,
                                      Colors.black54,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            UploadIndicator(),
                          ],
                        ),
                      ),
                    ),
                    if (_showAds)
                      Consumer<AdsProvider>(
                        builder: (context, result, child) {
                          if (result.showAds && myAdsVideos.isNotEmpty) {
                            result.cancelAds();
                            final adInfo = myAdsVideos[
                                Random().nextInt(myAdsVideos.length)];

                            CachedVideoPlayerController? _videoAdController;
                            CachedNetworkImage? _imageAdController;
                            if (adInfo.is_image!)
                              _imageAdController = CachedNetworkImage(
                                imageUrl: adInfo.ad_url!,
                                // placeholder: (context, url) => Container(
                                //   color: Colors.transparent,
                                //   child: Center(
                                //     child: CircularProgressIndicator(),
                                //   ),
                                // ),
                                errorWidget: (context, url, err) =>
                                    Icon(Icons.error),
                              );
                            else
                              _videoAdController =
                                  CachedVideoPlayerController.network(
                                      adInfo.ad_url!);
                            return Builder(
                              builder: (context) {
                                Future.delayed(
                                  Duration(minutes: 5, seconds: 5),
                                  () async {
                                    if (adInfo.is_image == false)
                                      await _videoAdController!.initialize();
                                    if ((adInfo.is_image == false &&
                                            _videoAdController!
                                                .value.isInitialized) ||
                                        adInfo.is_image == true) {
                                      try {
                                        await showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AdsDialog(
                                              isImage: adInfo.is_image,
                                              videoController:
                                                  _videoAdController,
                                              imageController:
                                                  _imageAdController,
                                            );
                                          },
                                        );
                                      } catch (_) {}
                                    }
                                  },
                                );
                                return Offstage();
                              },
                            );
                          }
                          return Offstage();
                        },
                      )
                  ],
                ),
              ),
            ),

            // bottom tab bar.....................................................................
            bottomNavigationBar: Container(
              alignment: Alignment.center,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 30.0, // has the effect of softening the shadow
                    spreadRadius: 2.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   height: 4,
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //glTV tab///////////////////////////////////////
                        InkWell(
                          onTap: () {
                            // NotificationService.sendAndRetrieveMessage('ccpnaWyiSJiMDayoHy7ZtQ:APA91bEu8Y2CJYxiuaotUqUa6cs99Hn4E0fZQ52Bv_HabMYxIT6v2DFdhksiZb3JeQhOkXRRm2hMC3BRcpgOwZS84GpXU1kdoksA6f4mLfy--hFlG1fp75bqpTjrZDsBcqcuN08Sh3uL');
                            //  _launchURL();
                            if (check_video_play) {
                              _controller!.pause();
                            }
                            if (tab_index != 4) {
                              _showAds = false;

                              animation_opacity = 0.0;

                              setState(() {});
                              Future.delayed(Duration(milliseconds: 500), () {
                                tab_index = 4;
                                animation_opacity = 1.0;
                                setState(() {
                                  title = "TV";
                                });
                                check_video_play = false;
                              });
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                child: new Image.asset(
                                  "assets/images/tv.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                "TV",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nova Round",
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        //nbx tab////////////////////////////////////////
                        InkWell(
                          onTap: () async {
                            if (check_video_play) {
                              _controller!.pause();
                            }
                            if (tab_index != 1) {
                              _showAds = false;
                              animation_opacity = 0.0;
                              setState(() {});
                              await _get_chat_users();
                              Future.delayed(Duration(milliseconds: 500), () {
                                tab_index = 1;
                                animation_opacity = 1.0;
                                setState(() {
                                  title = "NBX";
                                });
                                check_video_play = false;
                              });
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: new Image.asset(
                                      "assets/images/nbx.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: StreamBuilder<DatabaseEvent>(
                                      stream: FirebaseDatabase.instance
                                          .ref()
                                          .child("chat")
                                          .orderByChild("receiver_id")
                                          .equalTo(user_id)
                                          .onValue,
                                      builder: (context, snap) {
                                        if (snap.hasData &&
                                            !snap.hasError &&
                                            snap.data != null) {
                                          int i = 0;
                                          Map<String, dynamic>? data = snap
                                              .data!
                                              .snapshot
                                              .value as Map<String, dynamic>?;

                                          if (data != null) {
                                            data.forEach((key, value) {
                                              print(value['is_readed']);
                                              if (!value['is_readed']) i++;
                                            });
                                          }

                                          return i == 0
                                              ? Container()
                                              : Container(
                                                  padding: EdgeInsets.only(
                                                      left: 3, right: 3),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red),
                                                  child: Text(
                                                    "$i",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "nbx",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Nova Round",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //red shine button/////////////////////////////
                        InkWell(
                          onTap: () {
                            uploaded_video_category = "Other";
                            uploaded_video_tag = "RANDOM";
                            setState(() {
//
                              if (check_video_play) {
                                _controller!.pause();
                                check_video_play = false;
                              } else {
                                if (isUploading) {
                                } else {
                                  _go_shining().then((val) {
                                    print("VAL $val");
                                    if (val == "upload") {
                                      videoPicker.showDialog(context);
                                    }
                                    if (val == "broadcast") {
                                      joinAsBroadcaster(context);
                                    }
                                    if (val == "shine") {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              MyShiningList());
                                    }
                                  });
                                }
                              }
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 55,
                                width: 55,
                                child: new Image.asset(
                                  "assets/images/shine.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "shine",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nova Round",
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //shop tab /////////////////////////////////////////////////
                        InkWell(
                          onTap: () {
                            if (tab_index != 3) {
                              _showAds = false;
                              if (check_video_play) {
                                _controller!.pause();
                              }
                              animation_opacity = 0.0;

                              setState(() {});
                              Future.delayed(Duration(milliseconds: 500), () {
                                tab_index = 3;
                                animation_opacity = 1.0;
                                setState(() {
                                  title = "SHOP";
                                });
                                check_video_play = false;
                              });
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                child: new Image.asset(
                                  "assets/images/shop.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                "shop",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nova Round",
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        //glacad tab ////////////////////////////////////
                        InkWell(
                          onTap: () {
                            if (tab_index != 5) {
                              _showAds = false;
                              if (check_video_play) {
                                _controller!.pause();
                              }
                              animation_opacity = 0.0;
                              setState(() {});
                              Future.delayed(Duration(milliseconds: 500), () {
                                tab_index = 5;
                                animation_opacity = 1.0;
                                setState(() {
                                  title = "glacad";
                                });
                                check_video_play = false;
                              });
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                child: new Image.asset(
                                  "assets/images/glacad.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text("Acad",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Nova Round",
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //double click close app............................................
          onWillPop: () {
            if (title == "VENUE" && !check_video_play) {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      Duration(seconds: 2)) {
                currentBackPressTime = now;
                print("exit");
                ToastShow("Tap back again to leave", context, Colors.black)
                    .init();
                return Future.value(false);
              } else {
                print("+++++++++++++++++++++++++++++++++++++++++++++++++++");
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                return Future.value(false);
              }
            } else {
              if (check_video_play) {
                _controller!.pause();
              }
              animation_opacity = 0.0;
              setState(() {});
              Future.delayed(Duration(milliseconds: 500), () {
                tab_index = 0;
                animation_opacity = 1.0;
                if (_venue_visible) {
                  _venue_visible = false;
                }
                setState(() {
                  check_video_play = false;
                  title = "VENUE";
                });
              });
            }
            return Future.value(false);
          });
    }
  }

  //GLTV view\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Widget _TVView(
    String user_id,
  ) =>
      Container(
        height: device_height,
        child: YouTubeView(user_id, () {
          if (title == "VENUE" && !check_video_play) {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
              currentBackPressTime = now;
              print("exit");
              ToastShow("Tap back again to leave", context, Colors.black)
                  .init();
              return null;
            } else {
              print("+++++++++++++++++++++++++++++++++++++++++++++++++++");
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return null;
            }
          } else {
            if (check_video_play) {
              _controller!.pause();
            }
            animation_opacity = 0.0;
            setState(() {});
            Future.delayed(Duration(milliseconds: 500), () {
              tab_index = 0;
              animation_opacity = 1.0;
              if (_venue_visible) {
                _venue_visible = false;
              }
              setState(() {
                check_video_play = false;
                title = "VENUE";
              });
            });
          }
        }),
      );

  //NBX view\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  //venue view\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Widget _HomeView() {
    return Container(
        //height: device_height,
        //  color:Colors.red,
        child: Column(
      children: <Widget>[
        check_video_play
            ? _videoPlay()
            : Container(
                // margin: EdgeInsets.only(bottom: 160),

                child:
                    //  StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection("livebroadcast")
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (!snapshot.hasData) return LinearProgressIndicator();

                    //       return Text(snapshot.data!.docs[0].toString());
                    //     }),
                    _videoList(),
              )
      ],
    ));
  }

  //video play view.............
  Widget _videoPlay() {
    FocusNode focusNode = new FocusNode();
    return Column(
      children: <Widget>[
        Container(
          // height: MediaQuery.of(context).size.width*0.9,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(10),
          child: GestureDetector(
              onDoubleTap: () {
                check_video_play = false;
                if (_controller == null || user_id == current_video!.user_id) {
                  _video_full_screen_go();
                } else {
                  current_video!.video_view_count =
                      current_video!.video_view_count == null
                          ? 0
                          : current_video!.video_view_count;
                  current_video!.video_view_count! + 1;
                  VideoData().updateVideoCount(current_video!.video_view_count,
                      current_video!.key, "video_view_count");
                  _video_full_screen_go();
                }
              },
              onTap: () {},
              onTapDown: (_) {
                setState(() {
                  video_click_opacity = 0.4;
                });
              },
              onTapUp: (_) {
                setState(() {
                  video_click_opacity = 1;
                });
              },
              onTapCancel: () {
                setState(() {
                  video_click_opacity = 1;
                });
              },
              child: Opacity(
                opacity: video_click_opacity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: device_height - 250,
                          child: _controller!.value.isInitialized
                              ? new VideoPlayer(
                                  _controller!,
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                        Positioned(
                          child: new Builder(
                            builder: (context) {
                              String? cat_icon_name;
                              try {
                                cat_icon_name =
                                    current_video!.video_description;
                              } catch (e) {}
                              print(cat_icon_name);
                              return cat_icon_name == "null"
                                  ? Image.asset(
                                      "assets/category/${current_video!.video_category}.png",
                                    )
                                  : Image.asset(
                                      "assets/category/$cat_icon_name.png",
                                    );
                            },
                          ),
                          top: -7,
                          right: -11,
                        ),
                        Positioned(
                          top: 3,
                          left: 3,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Avatar(
                                  current_video!.user_id == user_id
                                      ? user_image_url
                                      : current_video!.user_image_url,
                                  current_video!.user_id,
                                  scaffoldKey,
                                  context,
                                  notificationId: current_video!.notificationId,
                                ).smallLogoHome(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, right: 20, left: 10),
                                ),
                                Text(
                                  current_video!.user_id == user_id
                                      ? "$user_firstname $user_lastname"
                                      : current_video!.user_name!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'NovaRound-Regular'),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            left: 15,
                            child: Container(
                              width: device_width / 2 + 10,
                              child: Text(
                                current_video!.video_title!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "phenomena-bold",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )),
        ),
        Container(
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref()
                .child('message')
                .orderByChild('videoKey')
                .equalTo(current_video!.key) //order by creation time.
                .onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data != null) {
                DatabaseEvent snapshot = snap.data!;
                List<ChatMessage> messages = [];
                (snapshot.snapshot.value as Map?)!.forEach((key, value) {
                  if (value != null) {
                    print(value);
                    ChatMessage messageItem = ChatMessage(
                        key: "$key",
                        videoKey: "${value['videoKey']}",
                        userid: "${value['userid']}",
                        username: "${value['username']}",
                        user_create_at: "${value['user_create_at']}",
                        notificationId: "${value['notificationId']}",
                        photoUrl: "${value['photoUrl']}",
                        message: "${value['message']}");
                    print(messageItem.message);
                    messages.add(messageItem);
                  }
                });

                messages.sort((a, b) {
                  return a.key.toString().compareTo(b.key.toString());
                });

                return snap.data?.snapshot.value == null
                    ? SizedBox()
                    //otherwise return a list of widgets.
                    : Column(
                        children: messages.map((item) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Avatar(
                                item.photoUrl,
                                item.userid,
                                scaffoldKey,
                                context,
                                notificationId: item.notificationId,
                              ).smallLogoMessage(),
                              GestureDetector(
                                child: Container(
                                  width: device_width - 60,
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(item.message!),
                                    ),
                                  ),
                                ),
                                onDoubleTap: () async {
                                  if (item.userid != user_id) return;
                                  var result = await onOpenEditComment(
                                      context, item.message!);
                                  if (result == null) {
                                    return;
                                  }
                                  if (result == "__DELETE__") {
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child("message")
                                        .child(item.key!)
                                        .remove();
                                    return;
                                  }
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child("message")
                                      .child(item.key!)
                                      .update({"message": result});
                                  return;
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList());
              } else {
                return Center(child: Container());
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _messageController,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: Avatar(user_image_url, user_id, scaffoldKey, context)
                  .smallLogoMessage(),
              hintText: "Insert message.",
              suffixIcon: InkWell(
                child: Icon(Icons.send),
                onTap: () {
                  var now = DateTime.now().toString();
                  if (_messageController.text != "") {
                    MessageData().addMessageDB(ChatMessage(
                        videoKey: current_video!.key,
                        userid: user_id,
                        username: "${user_firstname} ${user_lastname}",
                        user_create_at: user_create_at,
                        photoUrl: user_image_url,
                        message: _messageController.text,
                        notificationId: current_video!.notificationId,
                        created_at: now));
                    setState(() {
                      _messageController.text = "";
                      focusNode.unfocus();
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //video list view........
  Widget _videoList() => Column(
        children: <Widget>[
          user_videos.isEmpty
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : new Container(
                  height: device_height - 200,
                  child: Column(
                    children: <Widget>[
                      diy_videos.isEmpty
                          ? Container(
                              height: (device_height - 200) * 0.35,
                              child: Center(
                                child: Text(
                                  "DIY",
                                  style: TextStyle(
                                      color: Colors.grey[300], fontSize: 20),
                                ),
                              ),
                            )
                          : CarouselSlider(
                              options: CarouselOptions(
                                height: (device_height - 200) * 0.35,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                pauseAutoPlayInFiniteScroll: true,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: Duration(milliseconds: 5000),
                                autoPlayCurve: Curves.linear,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 5000),
                                /* pauseAutoPlayOnTouch: Duration(seconds: 2),
                               onPageChanged: (c) {},*/
                                scrollDirection: Axis.horizontal,
                              ),
                              items: [
                                for (int i = 0; i < diy_videos.length; i++)
                                  InkWell(
                                    onTap: () {
                                      if (diy_videos[i]
                                              .video_category!
                                              .toUpperCase() !=
                                          "*ADS") {
                                        _video_init(diy_videos[i].video_url!);
                                        setState(() {
                                          check_video_play = true;
                                          current_video = diy_videos[i];
                                        });
                                      }
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          height: (device_height - 150) * 0.35,
                                          width: device_width,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 4, right: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            23),
                                                    boxShadow: [
                                                      new BoxShadow(
                                                          color: Colors.grey,
                                                          offset:
                                                              new Offset(0, 4),
                                                          blurRadius: 4)
                                                    ]),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: device_width,
                                                      height: device_height,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              diy_videos[i]
                                                                  .image_url!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        gradient:
                                                            LinearGradient(
                                                          // Where the linear gradient begins and ends
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          // Add one stop for each color. Stops should increase from 0 to 1
                                                          stops: [
                                                            0.1,
                                                            0.5,
                                                            0.7,
                                                            0.9
                                                          ],
                                                          colors: [
                                                            // Colors are easy thanks to Flutter's Colors class.
                                                            Colors.grey
                                                                .withOpacity(
                                                                    0.0),
                                                            Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            Colors.black26,
                                                            Colors.black54,
                                                          ],
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: 40,
                                                            height: 40,
                                                            child: Avatar(
                                                              diy_videos[i]
                                                                          .user_id ==
                                                                      user_id
                                                                  ? user_image_url
                                                                  : diy_videos[
                                                                          i]
                                                                      .user_image_url,
                                                              diy_videos[i]
                                                                  .user_id,
                                                              scaffoldKey,
                                                              context,
                                                              notificationId:
                                                                  diy_videos[i]
                                                                      .notificationId,
                                                            ).smallLogoHome(),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            width: device_width,
                                                            child: Text(
                                                              diy_videos[i]
                                                                  .video_title!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 22,
                                                                  fontFamily:
                                                                      "phenomena-bold"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                child: new Builder(
                                                  builder: (context) {
                                                    String? cat_icon_name;
                                                    try {
                                                      cat_icon_name =
                                                          diy_videos[i]
                                                              .video_description;
                                                    } catch (e) {}
                                                    print(cat_icon_name);
                                                    return cat_icon_name ==
                                                            "null"
                                                        ? Image.asset(
                                                            "assets/category/${diy_videos[i].video_category}.png",
                                                          )
                                                        : Image.asset(
                                                            "assets/category/$cat_icon_name.png",
                                                          );
                                                  },
                                                ),
                                                top: -7,
                                                right: -11,
                                              ),
                                              diy_videos[i].isStreaming!
                                                  ? Container(
                                                      height: (device_height -
                                                              150) *
                                                          0.32,
                                                      width: device_width,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.red,
                                                                width: 5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 0,
                                                          right: 0,
                                                          left: 0),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              right: 30,
                                              left: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Button for audience to view livestream
                                Consumer<QuerySnapshot?>(
                                  builder: (context, querySnapshot, child) {
                                    if (querySnapshot == null ||
                                        querySnapshot.docs.isEmpty) {
                                      return InkWell(
                                        onTap: () {
                                          if (diy_videos[i]
                                                  .video_category!
                                                  .toUpperCase() !=
                                              "*ADS") {
                                            _video_init(
                                                diy_videos[i].video_url!);
                                            setState(() {
                                              check_video_play = true;
                                              current_video = diy_videos[i];
                                            });
                                          }
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height:
                                                  (device_height - 150) * 0.35,
                                              width: device_width,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 4, right: 4),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(23),
                                                        boxShadow: [
                                                          new BoxShadow(
                                                              color:
                                                                  Colors.yellow,
                                                              offset:
                                                                  new Offset(
                                                                      0, 4),
                                                              blurRadius: 4)
                                                        ]),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          width: device_width,
                                                          height: device_height,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  diy_videos[i]
                                                                      .image_url!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            gradient:
                                                                LinearGradient(
                                                              // Where the linear gradient begins and ends
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              // Add one stop for each color. Stops should increase from 0 to 1
                                                              stops: [
                                                                0.1,
                                                                0.5,
                                                                0.7,
                                                                0.9
                                                              ],
                                                              colors: [
                                                                // Colors are easy thanks to Flutter's Colors class.
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.0),
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.2),
                                                                Colors.black26,
                                                                Colors.black54,
                                                              ],
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                width: 40,
                                                                height: 40,
                                                                child: Avatar(
                                                                  diy_videos[i]
                                                                              .user_id ==
                                                                          user_id
                                                                      ? user_image_url
                                                                      : diy_videos[
                                                                              i]
                                                                          .user_image_url,
                                                                  diy_videos[i]
                                                                      .user_id,
                                                                  scaffoldKey,
                                                                  context,
                                                                  notificationId:
                                                                      diy_videos[
                                                                              i]
                                                                          .notificationId,
                                                                ).smallLogoHome(),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                width:
                                                                    device_width,
                                                                child: Text(
                                                                  diy_videos[i]
                                                                      .video_title!,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          22,
                                                                      fontFamily:
                                                                          "phenomena-bold"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: new Builder(
                                                      builder: (context) {
                                                        String? cat_icon_name;
                                                        try {
                                                          cat_icon_name =
                                                              diy_videos[i]
                                                                  .video_description;
                                                        } catch (e) {}
                                                        print(cat_icon_name);
                                                        return cat_icon_name ==
                                                                "null"
                                                            ? Image.asset(
                                                                "assets/category/${diy_videos[i].video_category}.png",
                                                              )
                                                            : Image.asset(
                                                                "assets/category/$cat_icon_name.png",
                                                              );
                                                      },
                                                    ),
                                                    top: -7,
                                                    right: -11,
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 30,
                                                  left: 30),
                                            ),
                                            // diy_videos[i].isStreaming!
                                            //     ?
                                            Container(
                                              height:
                                                  (device_height - 150) * 0.32,
                                              width: device_width,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        width: 5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 20,
                                                  left: 0),
                                            )
                                            // : Container()
                                          ],
                                        ),
                                      );
                                    }
                                    final list = querySnapshot.docs;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          list.length,
                                          (index) =>
                                              list[index].id.toString() ==
                                                      user_id
                                                  ? Offstage()
                                                  : VisibilityDetector(
                                                      key: UniqueKey(),
                                                      onVisibilityChanged:
                                                          (VisibilityInfo
                                                              info) {
                                                        if (info.visibleFraction ==
                                                                1 &&
                                                            currentVideoIndex !=
                                                                index) {
                                                          setState(() {
                                                            currentVideoIndex =
                                                                index;
                                                          });
                                                        }
                                                      },
                                                      child: InkWell(
                                                        onTap: () {
                                                          // querySnapshot.docs
                                                          //     .forEach((element) {
                                                          //   element.reference
                                                          //       .delete();
                                                          // });
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AudiencePage(
                                                                channelName: (list[
                                                                            index]
                                                                        .data()
                                                                    as Map<
                                                                        dynamic,
                                                                        dynamic>)['userId'],
                                                                name: (list[index]
                                                                            .data()
                                                                        as Map<
                                                                            dynamic,
                                                                            dynamic>)['name'] ??
                                                                    "",
                                                                image: (list[index]
                                                                            .data()
                                                                        as Map<
                                                                            dynamic,
                                                                            dynamic>)['photoUrl'] ??
                                                                    "",
                                                                shinnerId: (list[index]
                                                                            .data()
                                                                        as Map<
                                                                            dynamic,
                                                                            dynamic>)['userId'] ??
                                                                    "",
                                                                notificationId:
                                                                    (list[index].data() as Map<
                                                                            dynamic,
                                                                            dynamic>)['notificationId'] ??
                                                                        "",
                                                                isPreview:
                                                                    false,
                                                              ),
                                                            ),
                                                          ).then((value) =>
                                                              setState(() {
                                                                currentVideoIndex =
                                                                    null;
                                                              }));
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      30.0),
                                                          width: device_width,
                                                          height: device_height,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    color: Colors
                                                                        .green),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    child: currentVideoIndex ==
                                                                            index
                                                                        ? AudiencePage(
                                                                            channelName:
                                                                                (list[index].data() as Map<dynamic, dynamic>)['userId'],
                                                                            name:
                                                                                (list[index].data() as Map<dynamic, dynamic>)['name'] ?? "",
                                                                            image:
                                                                                (list[index].data() as Map<dynamic, dynamic>)['photoUrl'] ?? "",
                                                                            shinnerId:
                                                                                (list[index].data() as Map<dynamic, dynamic>)['userId'],
                                                                            notificationId:
                                                                                (list[index].data() as Map<dynamic, dynamic>)['notificationId'] ?? "",
                                                                            isPreview:
                                                                                true,
                                                                          )
                                                                        : (list[index].data() as Map<dynamic, dynamic>)['photoUrl'] ==
                                                                                ""
                                                                            ? Image.asset(
                                                                                "assets/images/user.png",
                                                                                fit: BoxFit.cover,
                                                                              )
                                                                            : CachedNetworkImage(
                                                                                imageUrl: (list[index].data() as Map<dynamic, dynamic>)['photoUrl'],
                                                                                width: 140,
                                                                                height: 140,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  left: 8.0,
                                                                  top: 8.0,
                                                                  child:
                                                                      BroadcasterProfile(
                                                                    image: (list[index].data() as Map<
                                                                            String,
                                                                            dynamic>)['photoUrl'] ??
                                                                        "",
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    right: 12.0,
                                                                    top: 8.0,
                                                                    child: Text(
                                                                      "• Live",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.green),
                                                                    )),
                                                                Positioned(
                                                                  bottom: 20,
                                                                  left: 15,
                                                                  child:
                                                                      Container(
                                                                    width: device_width /
                                                                            2 +
                                                                        10,
                                                                    child: Text(
                                                                      (list[index]
                                                                              .data()
                                                                          as Map<
                                                                              dynamic,
                                                                              dynamic>)['name'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              "phenomena-bold",
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                      random_videos.isEmpty
                          ? Container(
                              height: (device_height - 180) * 0.62,
                              child: Center(
                                child: Text(
                                  "RANDOM",
                                  style: TextStyle(
                                      color: Colors.grey[300], fontSize: 20),
                                ),
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: (device_height - 180) * 0.60 / 2,
                                    viewportFraction: 0.7,
                                    //    aspectRatio:16/9,
                                    initialPage: 0,
                                    //  viewportFraction: 0.8,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    pauseAutoPlayInFiniteScroll: true,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        Duration(milliseconds: 3000),
                                    autoPlayCurve: Curves.linear,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 3000),
                                    /* pauseAutoPlayOnTouch: Duration(seconds: 2),*/
                                    //  enlargeCenterPage: true,
                                    /*onPageChanged: (c) {},*/
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: [
                                    for (int i = 0;
                                        i < random_videos1.length;
                                        i++)
                                      buildOneVenueItemWidget(
                                          random_videos1, i),
                                    buildOneVenueADWidget(),
                                  ],
                                ),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: (device_height - 160) * 0.60 / 2,
                                    viewportFraction: 0.7,
//        aspectRatio:16/9,
                                    initialPage: 0,
//        viewportFraction: 0.8,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    pauseAutoPlayInFiniteScroll: true,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        Duration(milliseconds: 4000),
                                    autoPlayCurve: Curves.linear,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 4000),
                                    /* pauseAutoPlayOnTouch: Duration(seconds: 2),
//        enlargeCenterPage: true,
                                    onPageChanged: (c) {},*/
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: [
                                    for (int i = 0;
                                        i < random_videos2.length;
                                        i++)
                                      buildOneVenueItemWidget(
                                          random_videos2, i),
                                    buildOneVenueADWidget(),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                    ],
                  ),
                )
        ],
      );

  Widget buildOneVenueADWidget() {
    if (myAdsVideos.length == 0) return Container();
    int randomIndex = Random().nextInt(myAdsVideos.length);
    AdsVideo adsVideo = myAdsVideos[randomIndex];
    return Column(
      children: <Widget>[
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.vertical,
          onDismissed: (direction) {
            setState(() {});
          },
          child: InkWell(
            onTap: () async {
              setState(() {
                _showAds = false;
              });

              CachedVideoPlayerController? _videoAdController;
              CachedNetworkImage? _imageAdController;
              if (adsVideo.is_image!)
                _imageAdController = CachedNetworkImage(
                  imageUrl: adsVideo.ad_url!,
                  errorWidget: (context, url, err) => Icon(Icons.error),
                );
              else {
                _videoAdController =
                    CachedVideoPlayerController.network(adsVideo.ad_url!);
              }

              if (adsVideo.is_image == false)
                await _videoAdController!.initialize();
              if ((adsVideo.is_image == false &&
                      _videoAdController!.value.isInitialized) ||
                  adsVideo.is_image == true) {
                try {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AdsDialog(
                        isImage: adsVideo.is_image,
                        videoController: _videoAdController,
                        imageController: _imageAdController,
                      );
                    },
                  ).then((value) {
                    setState(() {
                      _showAds = true;
                    });
                  });
                } catch (_) {}
              }
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: (device_height - 160) * 0.28,
                  width: device_width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        23,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: device_width,
                          height: device_height,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: adsVideo.thumb_url!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                Colors.grey.withOpacity(0.0),
                                Colors.grey.withOpacity(0.2),
                                Colors.black26,
                                Colors.black54,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildOneVenueItemWidget(List<Video> individual_video, int i) {
    return Column(
      children: <Widget>[
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.vertical,
          onDismissed: (direction) {
            setState(() {
              individual_video.removeAt(i);
            });
          },
          child: InkWell(
            onTap: () {
              if (individual_video[i].video_category!.toUpperCase() != "*ADS") {
                _video_init(individual_video[i].video_url!);
                setState(() {
                  check_video_play = true;
                  current_video = individual_video[i];
                });
              }
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: (device_height - 160) * 0.28,
                  width: device_width,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          23,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: device_width,
                            height: device_height,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: individual_video[i].image_url!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                // Where the linear gradient begins and ends
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                stops: [0.1, 0.5, 0.7, 0.9],
                                colors: [
                                  // Colors are easy thanks to Flutter's Colors class.
                                  Colors.grey.withOpacity(0.0),
                                  Colors.grey.withOpacity(0.2),
                                  Colors.black26,
                                  Colors.black54,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 40,
                                  height: 40,
                                  child: Avatar(
                                    individual_video[i].user_id == user_id
                                        ? user_image_url
                                        : individual_video[i].user_image_url,
                                    individual_video[i].user_id,
                                    scaffoldKey,
                                    context,
                                    notificationId:
                                        individual_video[i].notificationId,
                                  ).smallLogoHome(),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(bottom: 10, left: 10),
                                  width: device_width,
                                  child: Text(
                                    individual_video[i].video_title!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontFamily: "phenomena-bold"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 0),
                ),
                Positioned(
                  child: new Builder(
                    builder: (context) {
                      String? cat_icon_name;
                      try {
                        cat_icon_name = individual_video[i].video_description;
                      } catch (e) {}
                      print(cat_icon_name);
                      return cat_icon_name == "null"
                          ? Image.asset(
                              "assets/category/${individual_video[i].video_category}.png",
                              width: 50,
                            )
                          : Image.asset(
                              "assets/category/$cat_icon_name.png",
                              width: 50,
                            );
                    },
                  ),
                  top: 1,
                  right: 11,
                ),
                individual_video[i].isStreaming!
                    ? Container(
                        height: (device_height - 160) * 0.28,
                        width: device_width,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 5),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, right: 20, left: 0),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }

  //shop view\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Widget _ShopView() => Container(child: Shop());

  //acad view\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Widget _AcadView() => Container(
        child: AcadWidget(),
      );

  //go video full screen....................................
  Future<void> _video_full_screen_go() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (content) => Video_small_play(_controller, current_video),
      ),
    );

    setState(() {});
  }

  //go shining "click red shinning button"
  Future<String?> _go_shining() async {
    String? result =
        await showDialog(context: context, builder: (_) => MyShining());
    print(result);
    return result;
  }

  //go video upload details settings screen modal.............................
  Future<String?> _video_upload_detail_go(_image) async {
    String? returnVal =
        await showDialog(context: context, builder: (_) => MyDialog(_image));
    print(returnVal);
    return returnVal;
  }

  //upload and save videos////////////////////////////////////////////////////
  @override
  userVideo(XFile? _video) async {
    final DateTime now = DateTime.now();
    final String millSeconds = now.millisecond.toString();
    final String year = now.year.toString();
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String today = ('$year-$month-$date');
    print(_video!.path.split(".").last);

    if (_video != null) {
      try {
        Uint8List? _image = await GetThumbnails().getThumbnailsImage(_video);
        if (_image != null) {
          String? checkSuccess = await _video_upload_detail_go(_image);
          if (checkSuccess == "success") {
            ToastShow("Video is uploading ...", context, Colors.black).init();
            String imageUrl = await Storage()
                .uploadImageFile(_image, "$user_id/$today/$millSeconds");
            String videoUrl = await Storage().uploadVideoFile(
                context, File(_video.path), "$user_id/$today/$millSeconds");
            print("VideoUrl::: $videoUrl");
            print("ImageUrl::: $imageUrl");
            if (videoUrl != "Failed") {
              NotificationService service = NotificationService();
              final notId = await service.getPlayerId();
              int random = Random().nextInt(1000000000);
              String videoId = "$random-$millSeconds";
              Video video = Video(
                  ID: videoId,
                  video_url: videoUrl,
                  video_category: uploaded_video_category,
                  image_url: imageUrl,
                  user_id: user_id,
                  user_name: "$user_firstname $user_lastname",
                  user_image_url: user_image_url,
                  user_create_at: user_create_at,
                  user_email: user_email,
                  video_title: uploaded_video_title,
                  video_tag: uploaded_video_tag,
                  video_description: uploaded_video_description,
                  video_groomlyfe_count: 0,
                  video_view_count: 0,
                  video_like_count: 0,
                  notificationId: notId,
                  isStreaming: false);
              VideoData().addVideoDB(video);
              setState(() {
                isUploading = false;
              });
              ToastShow("Success!", context, Colors.green[700]).init();
              animation_opacity = 0.0;
              setState(() {});
              Future.delayed(Duration(milliseconds: 500), () {
                tab_index = 0;
                animation_opacity = 1.0;
                setState(() {
                  title = "VENUE";
                });
              });
              print("added");
            } else {
              setState(() {
                ToastShow("Faild!", context, Colors.red[700]).init();
                isUploading = false;
              });
            }
          } else {
            setState(() {
              ToastShow("Faild!", context, Colors.red[700]).init();
              isUploading = false;
            });
          }
        } else {
          setState(() {
            ToastShow("Faild!", context, Colors.red[700]).init();
            isUploading = false;
          });
        }
      } catch (e) {
        setState(() {
          ToastShow("Faild!", context, Colors.red[700]).init();
          isUploading = false;
        });
      }
    } else {
      setState(() {
        ToastShow("Faild!", context, Colors.red[700]).init();
        isUploading = false;
      });
    }
  }
}
