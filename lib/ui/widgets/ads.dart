import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/providers/shop_registration.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

//ad dialog "pop up" when to click ads image
class AdsDialog extends StatefulWidget {
  final CachedVideoPlayerController? videoController;
  final CachedNetworkImage? imageController;
  final bool? isImage;
  AdsDialog({this.videoController, this.imageController, this.isImage});
  _AdsDialogState createState() => _AdsDialogState();
}

class _AdsDialogState extends State<AdsDialog> {
  int waiting_time = 0;

  @override
  void initState() {
    super.initState();
    _video_init();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isImage == false) widget.videoController!.dispose();
  }

  //ad video init............................
  _video_init() async {
    Timer.periodic(Duration(milliseconds: ads_duration_seconds * 10), (timer) {
      setState(() {
        waiting_time += ads_duration_seconds * 10;
      });
      if (waiting_time == ads_duration_seconds * 1000) {
        timer.cancel();
      }
    });
    if (widget.isImage == false)
      setState(() {
        widget.videoController!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: new Material(
          type: MaterialType.transparency,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
//              image: new DecorationImage(image: new AssetImage("assets/images/ads.png"),
//                fit: BoxFit.cover
//              ),
              ),
              child: Stack(
                alignment: Alignment(1, 1),
                children: <Widget>[
                  //ad video
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.isImage!
                          ? Container(
                              // color: Colors.transparent,
                              child: widget.imageController,
                            )
                          : Container(
                              child: widget.videoController!.value.isInitialized
                                  ? CachedVideoPlayer(widget.videoController!)
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                    ),
                  ),

                  //ad timming status
                  Container(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                    ),
                    child: LinearPercentIndicator(
                      lineHeight: 25.0,
                      percent: waiting_time / (ads_duration_seconds * 1000),
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          waiting_time == ads_duration_seconds * 1000
                              ? Text(
                                  "Ad Complete",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "phenomena-regular",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              : Text(
                                  "Ad 1 of 1",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "phenomena-regular",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                          waiting_time == ads_duration_seconds * 1000
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Provider.of<AdsProvider>(context,
                                            listen: false)
                                        .refresh();
                                  },
                                  child: Text(
                                    "continue >",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "phenomena-regular",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      backgroundColor: Colors.blue[800],
                      progressColor: Colors.blue[300],
                    ),
                  ),
                ],
              )),
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
