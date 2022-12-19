//import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

//when to upload video, get thumbnails from video uploading
class GetThumbnails {
  Future<Uint8List?> getThumbnailsImage(videofile) async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      final folderPath = appDocDir.path;
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videofile.path,
        imageFormat: ImageFormat.PNG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );
      print("00000000000000000000000000000000000000000000000");
      return uint8list;
    } catch (e) {
      print("099999999999999999999999999999999999999999999999");

      print(e.toString());
      return null;
    }
  }
}
