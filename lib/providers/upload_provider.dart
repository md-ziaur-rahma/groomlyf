import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UploadProvider with ChangeNotifier {
  UploadTask? _uploadTask;
  set setStorageUploadTask(UploadTask? task) {
    _uploadTask = task;
    notifyListeners();
  }

  UploadTask? get uploadTask => _uploadTask;
}
