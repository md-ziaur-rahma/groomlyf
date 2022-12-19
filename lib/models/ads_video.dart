

class AdsVideo {
  String? id;
  String? ad_url;
  DateTime? created_at;
  String? date;
  String? description;
  String? filename;
  String? thumb_url;
  int? view_count;
  bool? is_image;

  AdsVideo(
      {this.id,
      this.ad_url,
      this.created_at,
      this.date,
      this.description,
      this.filename,
      this.thumb_url,
      this.view_count,
      this.is_image});

  AdsVideo.fromDocument(Map<dynamic, dynamic> data)
      : ad_url = data["ad_url"],
        created_at =
            DateTime.fromMillisecondsSinceEpoch(data["created_at"] * 1000),
        date = data["date"],
        description = data["description"],
        filename = data["filename"],
        thumb_url = data["thumb_url"],
        view_count = data["view_count"],
        is_image = data['is_image'];

  Map<String, dynamic> toJson() {
    return {
      "ad_url": ad_url,
      "created_at": (created_at!.millisecondsSinceEpoch / 1000).round(),
      "date": date,
      "description": description,
      "filename": filename,
      "thumb_url": thumb_url,
      "view_count": view_count,
      "is_image": is_image
    };
  }
}
