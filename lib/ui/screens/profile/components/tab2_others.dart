import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/ui/screens/profile/components/audience2.dart';

class Tab2Others extends StatefulWidget {
  final userId;
  final bool? protect;
  const Tab2Others({this.userId, this.protect = false});

  @override
  _Tab2OthersState createState() => _Tab2OthersState();
}

class _Tab2OthersState extends State<Tab2Others>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        child: StreamBuilder<bool?>(
          stream: FirestoreService.isGleaned(user_id, widget.userId),
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return StreamBuilder<List<Glean>>(
                stream:
                    FirestoreService.followingsAudience(widget.userId, user_id),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError) {
                    return Center(
                      child: Text(
                        'No glean yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "phenomena-bold",
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  if (snapshot2.hasData) {
                    List<Glean>? gleans = snapshot2.data;
                    if (widget.protect!) {
                      return Center(
                        child: Text(
                          "${gleans!.length} glean(s)",
                          style: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (gleans!.length == 0) {
                      return Center(
                        child: Text(
                          'No glean yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "phenomena-bold",
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: gleans.length,
                      itemBuilder: (context, index) {
                        final glean = gleans[index];
                        return AudienceProfile2(
                          isGleaned: snapshot1.data,
                          glean: glean,
                          isDivider: (gleans.length > 1 &&
                                  (index + 1) != gleans.length)
                              ? true
                              : false,
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
            return Offstage();
          },
        ));
  }
}
