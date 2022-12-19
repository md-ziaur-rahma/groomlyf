class Glean {
  String? userId;
  int? status;
  Glean({this.userId, this.status});
}

class Counts {
  final int? audience;
  final int? requests;
  Counts({this.audience, this.requests});
}

class Audience {
  final String? createdAt;
  final String? name;
  final String? email;
  final String? photoURL;
  final String? notificationId;
  final String? id;
  final Videoview? videoview;
  Audience({
    this.createdAt,
    this.name,
    this.email,
    this.photoURL,
    this.notificationId,
    this.id,
    this.videoview,
  });
}

class Videoview {
  final int favNumber;
  final int faceNumber;
  final int starNumber;

  Videoview({this.faceNumber = 0, this.favNumber = 0, this.starNumber = 0});
}
