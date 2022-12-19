import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/ui/screens/video_play.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:groomlyfe/ui/widgets/video_upload_detail.dart';

class Tab1 extends StatefulWidget {
  final userId;
  final bool? protect;
  const Tab1({this.userId, this.protect = false});

  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: StreamBuilder<List<Video>>(
        stream: FirestoreService.myVideosStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Shine is Empty',
                style: TextStyle(
                  fontFamily: "phenomena-bold",
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            List<Video>? videos = snapshot.data;
            if (widget.protect!) {
              return Center(
                child: Text(
                  "${videos!.length} shine(s)",
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: videos!.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                if (video == null) return Offstage();
                return buildVideoItem(context, video);
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildVideoItem(BuildContext context, Video video) {
    return SizedBox(
      height: 200.0,
      width: double.maxFinite,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Card(
            elevation: 10.0,
            margin: EdgeInsets.all(0.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => Video_small_play(null, video),
                      ),
                    );
                  },
                  onLongPress: () {
                    removeVideo(video);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          image: DecorationImage(
                            image: NetworkImage(video.image_url!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox.expand(
                        child: Container(
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 16.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        video.video_category != null
                            ? video.video_category!
                            : "",
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      video.video_title != null && video.video_title!.isEmpty
                          ? Offstage()
                          : Text(
                              video.video_title != null
                                  ? video.video_title!
                                  : "",
                              style: TextStyle(
                                fontFamily: "phenomena-bold",
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
                if (video.user_id == user_id) buildImageEditButton(video)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageEditButton(Video video) {
    return Positioned(
      top: 10.0,
      right: 10.0,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onTap: () async {
            var dlgResult = await showDialog(
              context: context,
              builder: (_) => MyDialog(
                null,
                isEditing: true,
                video_title: video.video_title,
                video_category: video.video_category,
                video_description: video.video_description,
                video_tag: video.video_tag,
                thumb_url: video.image_url,
              ),
            );
            if (dlgResult == "success") {
              await FirebaseDatabase.instance
                  .ref()
                  .child('video')
                  .child(video.key!)
                  .update({
                "video_title": uploaded_video_title,
                "video_category": uploaded_video_category,
                "video_description": uploaded_video_description,
                "video_tag": uploaded_video_tag
              });
              ToastShow("Success.\nWill effect after restart the app.", context,
                      Colors.green[700])
                  .init();
              try {
                setState(() {});
              } catch (_) {}
            }
          },
        ),
      ),
    );
  }

  void removeVideo(Video video) async {
    if (video.user_id == user_id) {
      await showDialog(
        context: (context),
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Are you sure you want to remove this video',
              style: TextStyle(
                fontFamily: "phenomena-bold",
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final FirebaseDatabase _database = FirebaseDatabase.instance;
                  await _database
                      .reference()
                      .child("video")
                      .child(video.key!)
                      .remove();
                  Navigator.pop(context);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                    fontFamily: "phenomena-bold",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        },
      );
    }
  }
}
