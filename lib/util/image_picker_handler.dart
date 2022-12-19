import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groomlyfe/ui/widgets/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../ui/widgets/image_picker_dialog.dart';


//when to sign up, pick image
class ImagePickerHandler {
  late CustomImagePickerDialog imagePicker;
  AnimationController? _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await (ImagePicker().pickImage(source: ImageSource.camera) as FutureOr<XFile>);
    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await (ImagePicker().pickImage(source: ImageSource.gallery) as FutureOr<XFile>);
    cropImage(image);
  }

  void init() {
    imagePicker = new CustomImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(XFile image) async {
    CroppedFile croppedFile = await (ImageCropper().cropImage(
      sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],

    ) as FutureOr<CroppedFile>);

    _listener.userImage(File(croppedFile.path));
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}