
//unusing
class GLTV_video {
  String? kind;
  String? id;
  String? channelTitle;
  String? title;
  String? description;
  String? publishedAt;
  String? channelId;
  Thumbnails? thumbnails;
  String? channelurl;
  String? url;

  GLTV_video({this.kind, this.id, this.channelTitle, this.title, this.description, this.publishedAt, this.channelId, this.thumbnails, this.channelurl, this.url});

  GLTV_video.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    id = json['id'];
    channelTitle = json['channelTitle'];
    title = json['title'];
    description = json['description'];
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    thumbnails = json['thumbnails'] != null ? new Thumbnails.fromJson(json['thumbnails']) : null;
    channelurl = json['channelurl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['id'] = this.id;
    data['channelTitle'] = this.channelTitle;
    data['title'] = this.title;
    data['description'] = this.description;
    data['publishedAt'] = this.publishedAt;
    data['channelId'] = this.channelId;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails!.toJson();
    }
    data['channelurl'] = this.channelurl;
    data['url'] = this.url;
    return data;
  }
}

class Thumbnails {
  Default? defaults;
  Default? medium;
  Default? high;

  Thumbnails({this.defaults, this.medium, this.high});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    defaults = json['default'] != null ? new Default.fromJson(json['default']) : null;
    medium = json['medium'] != null ? new Default.fromJson(json['medium']) : null;
    high = json['high'] != null ? new Default.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.defaults != null) {
      data['default'] = this.defaults!.toJson();
    }
    if (this.medium != null) {
    data['medium'] = this.medium!.toJson();
    }
    if (this.high != null) {
    data['high'] = this.high!.toJson();
    }
    return data;
  }
}

class Default {
  String? url;
  int? width;
  int? height;

  Default({this.url, this.width, this.height});

  Default.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
