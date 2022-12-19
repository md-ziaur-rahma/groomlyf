import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/screens/profile/profile.dart';
import 'package:video_player/video_player.dart';

//avatar..............................
class Avatar {
  final String? photourl;
  final String? userid;
  String? notificationId;
  BuildContext context;
  GlobalKey<ScaffoldState>? scaffoldKey = new GlobalKey<ScaffoldState>();
  Avatar(this.photourl, this.userid, this.scaffoldKey, this.context,
      {this.notificationId});

  Widget smallLogoHome() {
    return GestureDetector(
        child: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: photourl == ""
                ? Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: photourl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        photourl,
                        userid,
                        notificationId,
                      )));
        });
  }

  Widget smallLogoHomeWhite() {
    return GestureDetector(
        child: Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: new ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: photourl == ""
                  ? Image.asset(
                      "assets/images/user.png",
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: photourl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        photourl,
                        userid,
                        notificationId,
                      )));
        });
  }

  Widget smallLogoVideo(VideoPlayerController _controller) {
    return GestureDetector(
      child: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: photourl == ""
                ? Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: photourl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
          )),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    photourl,
                    userid,
                    notificationId,
                  ))),
    );
  }

  Widget smallLogoMessage() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            photourl,
            userid,
            notificationId,
          ),
        ),
      ),
      child: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: photourl == ""
                ? Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: photourl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
          )),
    );
  }

  whiteBorderLogo() {
    return GestureDetector(
      child: Container(
        width: 60,
        height: 60,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: new ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: photourl == ""
              ? Image.asset(
                  "assets/images/user.png",
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: photourl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              photourl,
              userid,
              notificationId,
            ),
          ),
        );
      },
    );
  }
}
