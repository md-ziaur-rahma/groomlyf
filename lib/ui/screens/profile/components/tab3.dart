import 'package:flutter/material.dart';
import 'package:groomlyfe/controllers/firestore_service.dart';
import 'package:groomlyfe/models/glean.dart';
import 'package:groomlyfe/ui/screens/profile/components/requests.dart';

class Tab3 extends StatefulWidget {
  final userId;
  const Tab3({this.userId});

  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: StreamBuilder<List<Glean>>(
        stream: FirestoreService.requestStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No Requests',
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
          if (snapshot.hasData) {
            List<Glean> gleans = snapshot.data!;
            if (gleans.length == 0) {
              return Center(
                child: Text(
                  'No Requests',
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
                return RequestProfile(
                  userId: glean.userId,
                  glean: glean,
                  isDivider: (gleans.length > 1 && (index + 1) != gleans.length)
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
      ),
    );
  }
}
