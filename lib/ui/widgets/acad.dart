import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/intro_card.dart';
import 'package:groomlyfe/ui/widgets/questions/question1.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//acad widget in home screen "acad tab screen"
class AcadWidget extends StatefulWidget {
  @override
  _AcadWidgetState createState() => _AcadWidgetState();
}

class _AcadWidgetState extends State<AcadWidget> {
  late YoutubePlayerController _controller;
  late var glAcademyProvider;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=pfq000AF1i8&amp=&feature=youtu.be")!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
      ),
    );
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.grey[200],
        child: Column(
          children: [
            IntroCard(),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('glAcademy').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    child: Text(
                      "Please check your interent connection",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "phenomena-bold",
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  bool result = false;
                  snapshot.data!.docs.forEach((f) {
                    if (f.id == user_id) {
                      result = true;
                    }
                  });
                  if (!result || glAcademyProvider.showGLAcademyQuestions) {
                    // displays the GL Academy questions
                    return Card(
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 300,
                            minWidth: double.maxFinite,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Question1(),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.black,
                          height: 45.0,
                          shape: StadiumBorder(),
                          child: FittedBox(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.restore,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  "Restart GL Academy Questionaire",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    fontFamily: "phenomena-bold",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              glAcademyProvider.restartQuestion();
                              glAcademyProvider.showGLAcademyQuestions = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        YoutubePlayer(
                          controller: _controller,
                          progressIndicatorColor: Colors.black,
                        ),
                      ],
                    );
                  }
                }
                return Center(
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
