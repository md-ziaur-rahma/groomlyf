import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/widgets/video_picker_dialog.dart';
import 'package:image_picker/image_picker.dart';

//when upload video, video piker
class VideoPickerHandler {
  late CustomVideoPickerDialog videoPicker;
  final AnimationController? controller;
  final VideoPickerListner listener;

  VideoPickerHandler({required this.listener, required this.controller});

  openCamera() async {
    videoPicker.dismissDialog();
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);
    listener.userVideo(video);
  }

  openGallery() async {
    videoPicker.dismissDialog();
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    listener.userVideo(video);
  }

  void init() {
    videoPicker = CustomVideoPickerDialog(listener: this, controller: controller);
    videoPicker.initState();
  }

  showDialog(BuildContext context) {
    videoPicker.getImage(context);
  }
}

abstract class VideoPickerListner {
  userVideo(XFile? _video);
}
