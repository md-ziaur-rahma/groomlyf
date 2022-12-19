import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/upload_provider.dart';
import 'package:provider/provider.dart';

class UploadIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UploadProvider _uploadProvider = Provider.of<UploadProvider>(context);
    return _uploadProvider.uploadTask != null
        ? StreamBuilder<TaskSnapshot>(stream: _uploadProvider.uploadTask!.snapshotEvents,
        builder: (_, snapshot) {
          var event = snapshot.data;
          double progressPercent = event != null? event.bytesTransferred / event.totalBytes : 0;
            return Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3, color: Colors.black54, spreadRadius: 3)
                  ],),
              margin: EdgeInsets.symmetric(horizontal: 35),
              alignment: Alignment.center,
              child: Text('Uploading ${(progressPercent * 100).toStringAsFixed(2)} %'),
            );
          }
          )
        : Offstage();
  }
}
