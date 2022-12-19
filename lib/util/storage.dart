import 'dart:async';
import 'dart:io';
import 'dart:math';
//import 'dart:typed_data';
//import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
//import 'package:amazon_s3_cognito/aws_region.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/providers/upload_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

//upload video
class Storage {
  static final Storage _instance = new Storage.internal();
  String random_path = Random().nextInt(1000000000).toString();

  Storage.internal();

  factory Storage() {
    return _instance;
  }

  Future<String> uploadVideoFile(
      BuildContext context, File file, String path_url) async {
    UploadProvider _uploadProvider =
        Provider.of<UploadProvider>(context, listen: false);
    print(Path.basename(file.path));
    String url = "";
    String imagePath =
        "Files/$path_url/$random_path${Path.basename(file.path)}";
//    photoUrl = await AmazonS3Cognito.upload(file.path, "groomly", "ap-northeast-1:e869d061-eceb-4c1f-843e-6c716f16fe6e", imagePath, AwsRegion.AP_NORTHEAST_1, AwsRegion.AP_NORTHEAST_1);
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imagePath);
    print("PAth:: ${storageReference.fullPath}");
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      _uploadProvider.setStorageUploadTask = uploadTask;
      url = await storageReference.getDownloadURL();
      _uploadProvider.setStorageUploadTask = null;
    });
    print('File Uploaded');
    return url;
  }

  Future<String> uploadFile(File? file, String? path_url) async {
    if (file == null) {
      return "";
    }
    print(Path.basename(file.path));
    String url = "";
    String imagePath =
        "Files/$path_url/$random_path${Path.basename(file.path)}";
//    photoUrl = await AmazonS3Cognito.upload(file.path, "groomly", "ap-northeast-1:e869d061-eceb-4c1f-843e-6c716f16fe6e", imagePath, AwsRegion.AP_NORTHEAST_1, AwsRegion.AP_NORTHEAST_1);
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imagePath);
    UploadTask uploadTask = storageReference.putFile(file);
    // await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      url = fileURL;
    });
    return url;
  }

  Future<String> uploadImageFile(Uint8List file, String path_url) async {
    String photoUrl = "";
    String imagePath = "Files/$path_url/$random_path ";
//    photoUrl = await AmazonS3Cognito.upload(file, "groomly", "ap-northeast-1:e869d061-eceb-4c1f-843e-6c716f16fe6e", imagePath, AwsRegion.AP_NORTHEAST_1, AwsRegion.AP_NORTHEAST_1);
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imagePath);
    UploadTask uploadTask = storageReference.putData(file);
    // await uploadTask.onComplete;
    await uploadTask.whenComplete(() async {
      photoUrl = await storageReference.getDownloadURL();
    });
    print('File Uploaded');
    print(photoUrl);
    return photoUrl;
  }

  Future directoriesList() async {
    List<String> directory = [];
    final DateTime now = DateTime.now();
    final String millSeconds = now.millisecond.toString();
    final String year = now.year.toString();
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String today = ('$year-$month-$date');

    String path = "livestreams" +
        "," +
        user_id! +
        "," +
        today +
        "," +
        millSeconds +
        "," +
        random_path;
    directory = path.split(",");
    return directory;
  }
}
