import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/util/video_picker_handler.dart';
// import 'package:youtube_api/youtube_api.dart';
import 'package:groomlyfe/util/youtube_api_lib/youtube_api.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//gltv widget in gltv tab of home screen.......................
const String key =
    "AIzaSyDwv59d_dSyqyuqtMUoDIf4LJBg43JijVU"; // ** ENTER YOUTUBE API KEY HERE **

class YouTubeView extends StatefulWidget {
  String userID = '';
  VoidCallback callback;

  YouTubeView(this.userID, this.callback);

  @override
  _YouTubeViewState createState() => _YouTubeViewState();
}

class _YouTubeViewState extends State<YouTubeView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _is_loading = true;
  bool dis_vid = false;
  AnimationController? _animationController;

  //video search field key.................................................
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();

  //video search field controller.......................................
  TextEditingController _search_controller = TextEditingController();

  //video picker handler for uploading video.............
  VideoPickerHandler? videoPicker;

  //video controller in home page
  late VideoPlayerController _controller;
  static List<String> query_list = [
    "hair cutting",
    "hair cutting men",
    "haircut tutorial for beginners",
    "hairstyles",
    "short hairstyles men",
    "haircut for men",
    "haircut for men tutorial",
    "haircut tutorial",
    "hair tutorial",
    "hair tutorial braid",
    "hair cut style of boys",
    "haircut",
    "asmr haircut men",
    "asmr haircut roleplay",
    "asmr haircut barber",
    "asmr haircut fast",
    "asmr haircut male",
    "Haircut and Style"
  ];
  YoutubeAPI ytApi = new YoutubeAPI(key, maxResults: 20);
  List<YT_API> ytResult = [];
  List<YT_API> yTempResult = [];
  List<YT_API> episodes = [];
  String query = "";
  int? currentVideoIndex;

  @override
  void initState() {
    callAPI();
    super.initState();
  }

  //get youtube videos/...............

  callAPI() async {
    setState(() {
      _is_loading = true;
    });

    String query = query_list[Random().nextInt(query_list.length)];
    List<YT_API> ytResultGetValues = [];
    List<YT_API> episodes_videos = [];

    episodes_videos = await ytApi.search("new episodes");

    ytResultGetValues = await ytApi.search("$query");

    List<int> random_index = [];
    while (random_index.length < 10) {
      bool random_check = true;

      int random = Random().nextInt(episodes_videos.length);
      if (random_index.isNotEmpty) {
        for (int item in random_index) {
          if (item == random) {
            random_check = false;
            break;
          }
        }
      }
      if (random_check) {
        random_index.add(random);
      }
    }

    episodes = [];
    for (int i = 5; i < 10; i++) {
      episodes.add(episodes_videos[random_index[i]]);
    }

    ytResult = [];
    yTempResult = [];
    for (int item in random_index) {
      ytResult.add(ytResultGetValues[item]);
      yTempResult.add(ytResultGetValues[item]);
    }

    setState(() {
      print('UI Updated');
      _is_loading = false;
    });
  }

  searchData1(String query) {
    if (query.isNotEmpty) {
      if (yTempResult.isNotEmpty) {
        ytResult.clear();
        for (int i = 0; i < yTempResult.length; i++) {
          if (yTempResult[i]
              .title!
              .toLowerCase()
              .contains(query.toLowerCase())) {
            ytResult.add(yTempResult[i]);
          }
        }
      }
    } else {
      ytResult.clear();
      ytResult.addAll(yTempResult);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80.0),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 5,
              right: 7,
              left: 7,
              top: 20,
            ),
            child: Row(
              mainAxisAlignment:
                  tab_index == 5 || tab_index == 3 || tab_index == 1
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                title.toLowerCase() == "venue"
                    ? InkWell(
                        onTap: () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                          animation_opacity = 0.0;
                          setState(() {});
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment(1.5, -1),
                                children: <Widget>[
                                  Text(
                                    "Venue",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: "phenomena-bold",
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "GL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'phenomena-regular',
                                        color: Colors.black),
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
                              widget.callback();
                              // Navigator.pushReplacementNamed(context, '/home');
                              /*  Provider.of<AdsProvider>(
                                    context,
                                    listen: false)
                                    .cancelAds(value: true);
                                if (tab_index != 0) {
                                  animation_opacity = 0.0;
                                  setState(() {});
                                  Future.delayed(
                                      Duration(
                                          milliseconds:
                                          500), () {
                                    tab_index = 0;
                                    animation_opacity = 1.0;
                                    if (_venue_visible) {
                                      _venue_visible =
                                      false;
                                    }
                                    setState(() {
                                      _showAds = true;
                                      title = "VENUE";
                                    });
                                  });
                                }*/
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                          Image.asset(
                            "assets/images/${title.toLowerCase()}.png",
                            width: title.toLowerCase() == "glacad" ? 50 : 30,
                          ),
                        ],
                      ),
                title.toLowerCase() == "venue" ||
                        title.toLowerCase() == "glacad"
                    ? Container()
                    : tab_index == 4
                        ? Container(
                            margin: EdgeInsets.only(left: 0.0),
                            child: Text(
                              "${title.toLowerCase()}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'phenomena-bold',
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${title.toLowerCase()}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontFamily: 'phenomena-bold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                tab_index == 5 || tab_index == 3 || tab_index == 1
                    ? Offstage(
                        child: Container(
                          width: device_width * 0.5,
                        ),
                      )
                    : InkWell(
                        onTap: () {},
                        child: Container(
                          width: device_width * 0.6,
                          height: 30,
                          child: SimpleAutoCompleteTextField(
                            key: key1,
                            controller: _search_controller,
                            suggestions: query_list,
                            clearOnSubmit: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "mantserrat-bold"),
                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              hintText: "enter something...",
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                            ),
                            submitOnSuggestionTap: true,
                            textChanged: (s) async {
                              searchData1(s);
                            },
                            textSubmitted: (text) async {
                              print("onSubmit");
                            },
                          ),
                        ),
                      ),
                Avatar(user_image_url, widget.userID, scaffoldKey, context)
                    .smallLogoHome(),
              ],
            ),
          ),
        ),
        body: Container(
          height: device_height,
          child: _is_loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: (device_height - 160) * 0.35,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(milliseconds: 5000),
                          autoPlayCurve: Curves.linear,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 5000),
                          /*  pauseAutoPlayOnTouch: Duration(seconds: 2),
                      onPageChanged: (c) {},*/
                          scrollDirection: Axis.horizontal,
                        ),
                        items: episodes.map((youtube_video) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Player(id: youtube_video.id)));
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: (device_width) * 0.5,
                                    width: device_width,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 4, right: 4),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                width: device_width,
                                                height: device_height,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        kTransparentImage,
                                                    image:
                                                        "${youtube_video.thumbnail['high']['url']}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    // Where the linear gradient begins and ends
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    // Add one stop for each color. Stops should increase from 0 to 1
                                                    stops: [0.1, 0.5, 0.7, 0.9],
                                                    colors: [
                                                      // Colors are easy thanks to Flutter's Colors class.
                                                      Colors.grey
                                                          .withOpacity(0.0),
                                                      Colors.grey
                                                          .withOpacity(0.2),
                                                      Colors.black26,
                                                      Colors.black54,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        FittedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  youtube_video.kind!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontFamily:
                                                          "phenomena-bold"),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  youtube_video.title!,
                                                  style: TextStyle(
                                                      color: Colors.white,
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
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, right: 30, left: 30),
                                  ),
                                ],
                              ));
                        }).toList(),
                      ),
                      ytResult.isNotEmpty
                          ? Column(
                              children: ytResult.map((youtube_video) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Player(id: youtube_video.id)));
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      VisibilityDetector(
                                        key: ValueKey(youtube_video.id),
                                        onVisibilityChanged:
                                            (VisibilityInfo info) {
                                          var index =
                                              ytResult.indexOf(youtube_video);
                                          int i = 0;
                                          if (info.visibleFraction == 1) {
                                            setState(() {
                                              i = index;
                                              print(i);
                                              currentVideoIndex = i;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: (device_width) * 0.5,
                                          width: device_width,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 4, right: 4),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: device_width,
                                                      height: device_height,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: currentVideoIndex ==
                                                                (ytResult.indexOf(
                                                                    youtube_video))
                                                            ? Player(
                                                                id: youtube_video
                                                                    .id,
                                                                isAudio: true,
                                                              )
                                                            : FadeInImage
                                                                .memoryNetwork(
                                                                placeholder:
                                                                    kTransparentImage,
                                                                image:
                                                                    "${youtube_video.thumbnail['high']['url']}",
                                                                fit: BoxFit
                                                                    .cover,
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      youtube_video.kind!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              "phenomena-bold"),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      youtube_video.title!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                          fontFamily:
                                                              "phenomena-bold"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              right: 30,
                                              left: 30),
                                        ),
                                      ),
                                    ],
                                  ));
                            }).toList())
                          : Center(
                              child: Container(child: Text("No Data Found!")),
                            ),
                    ],
                  ),
                ),
        ));
  }
}

//youtube video player screen.........................................................
class Player extends StatefulWidget {
  String? id;
  bool? isAudio;

  Player({this.id, this.isAudio});

  @override
  _YoutubePlayerState createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<Player> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: "${widget.id}",
      flags: YoutubePlayerFlags(autoPlay: true, mute: widget.isAudio ?? false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                actionsPadding: EdgeInsets.only(left: 16.0),
                bottomActions: [
                  CurrentPosition(),
                  SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  SizedBox(width: 10.0),
                  RemainingDuration(),
                  FullScreenButton(),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              left: 8.0,
              child: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
