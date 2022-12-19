import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/video.dart';
import 'package:groomlyfe/notification/notification_service.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:groomlyfe/ui/widgets/video_upload_detail.dart';
import 'package:groomlyfe/util/database.dart';
import 'package:groomlyfe/util/get_thumbnails.dart';
import 'package:groomlyfe/util/storage.dart';

Future<String?> _video_upload_detail_go(_image, context) async {
  String? returnVal =
      await showDialog(context: context, builder: (_) => MyDialog(_image));
  print(returnVal);
  return returnVal;
}

Future<bool> userVideo(File _video, BuildContext context) async {
  final DateTime now = DateTime.now();
  final String millSeconds = now.millisecond.toString();
  final String year = now.year.toString();
  final String month = now.month.toString();
  final String date = now.day.toString();
  final String today = ('$year-$month-$date');
  print(_video.path.split(".").last);

  if (_video != null) {
    bool b = await _video.exists();
    print("vedio file name :- ${_video.path}");
    print("vedio file Size :- $b");

    if (_video.path.split(".").last == "mp4") {
      try {
        var _image = await GetThumbnails().getThumbnailsImage(_video);
        if (_image != null) {
          var check_success = "success";
          // var check_success = await _video_upload_detail_go(_image, context);
          if (check_success == "success") {
            ToastShow("Video is uploading ...", context, Colors.black).init();
            var image_url = await Storage()
                .uploadImageFile(_image, "$user_id/$today/$millSeconds");

            var video_url = await Storage().uploadVideoFile(
                context, _video, "$user_id/$today/$millSeconds");

            print(video_url);
            print(image_url);
            if (video_url != "Failed") {
              NotificationService service = NotificationService();
              final notId = await service.getPlayerId();
              int random = Random().nextInt(1000000000);
              String video_id = "$random-$millSeconds";
              Video video = Video(
                ID: video_id,
                video_url: video_url,
                video_category: "DIY",
                image_url: image_url,
                user_id: user_id,
                user_name: "$user_firstname $user_lastname",
                user_image_url: user_image_url,
                user_create_at: user_create_at,
                user_email: user_email,
                video_title: DateTime.now().toString(),
                video_tag: uploaded_video_tag,
                video_description: uploaded_video_description,
                video_groomlyfe_count: 0,
                video_view_count: 0,
                video_like_count: 0,
                notificationId: notId,
                isStreaming: true,
              );
              await VideoData().addVideoDB(video);
              ToastShow("Success!", context, Colors.green[700]).init();
              return true;
            } else {
              ToastShow("Failed to upload video", context, Colors.red[700])
                  .init();
              return false;
            }
          } else {
            ToastShow("Failed to upload video", context, Colors.red[700])
                .init();
            return false;
          }
        } else {
          return false;
        }
      } catch (e) {
        ToastShow("Unknown error encountered while uploading", context,
                Colors.red[700])
            .init();
        return false;
      }
    } else {
      ToastShow("Invalid Video Type!. Please select Mp4 videos", context,
              Colors.red[700])
          .init();
      return false;
    }
  } else {
    ToastShow("Cancelled", context, Colors.red[700]).init();
    return false;
  }
}
