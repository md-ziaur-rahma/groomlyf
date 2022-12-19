import 'dart:convert' show base64, jsonEncode, utf8;

import "package:http/http.dart" as http;

import 'google_cloud_utils.dart';

class AgoraUtils {
  // Agora AppId
  static const APP_ID = '448581577fa340228396373fe8adb995';
  static const APP_ID_FOR_ACCUIRE = "2df64d6912384b3db982c1f2a6cd9321";
  static const CUSTOMER_SECRET_KEY = "af18cfa897554f3bae22e56deb5f5e57";
  static const CUSTOMER_ID = "bbb0c78d8d0540259bbd1c91ff1faabd";
}

class AgoraServices {
  String baseUrl = "https://api.agora.io/v1/apps/";
  Future acquire({required String channel, required String uid}) async {
    String plainCredentials =
        AgoraUtils.CUSTOMER_ID + ":" + AgoraUtils.CUSTOMER_SECRET_KEY;
    String base64Credentials = base64.encode(utf8.encode(plainCredentials));
    String authorizationHeader = "Basic " + base64Credentials;
    var headers = {
      "Authorization": authorizationHeader,
      "Content-Type": "application/json;charset=utf-8"
    };
    print(baseUrl + AgoraUtils.APP_ID_FOR_ACCUIRE + "/cloud_recording/acquire");
    var response = http.post(
        Uri.parse(baseUrl +
            AgoraUtils.APP_ID_FOR_ACCUIRE +
            "/cloud_recording/acquire"),
        headers: headers,
        body: jsonEncode({
          "cname": "deep",
          "uid": "90786543",
          "clientRequest": {
            "resourceExpiredHour": 24,
          }
        }));

    return response;
  }

  Future startCloudRecording(
      {required String resourceId,
      required String channel,
      required String uid,
      required List<String> directory}) async {
    String plainCredentials =
        AgoraUtils.CUSTOMER_ID + ":" + AgoraUtils.CUSTOMER_SECRET_KEY;
    String base64Credentials = base64.encode(utf8.encode(plainCredentials));
    String authorizationHeader = "Basic " + base64Credentials;
    var headers = {
      "Authorization": authorizationHeader,
      "Content-Type": "application/json;charset=utf-8"
    };
    var response = http.post(
        Uri.parse(baseUrl +
            AgoraUtils.APP_ID_FOR_ACCUIRE +
            "/cloud_recording/resourceid/$resourceId/mode/mix/start"),
        headers: headers,
        body: jsonEncode({
          "cname": "deep",
          "uid": "90786543",
          "clientRequest": {
            "token": "0062df64d6912384b3db982c1f2a6cd9321IABEmmPoeTGratbwjBwKEIb7MsU9sYMh4pOq+w3i+xaRlF1Yk5MAAAAAEACDxJolC2O7YgEAAQAKY7ti",
            "recordingConfig": {
              "maxIdleTime": 30,
              "streamTypes": 2,
              "audioProfile": 1,
              "channelType": 1,
              "videoStreamType": 0,
              "transcodingConfig": {
                "height": 640,
                "width": 360,
                "bitrate": 500,
                "fps": 15,
                "mixedVideoLayout": 1,
                "backgroundColor": "#FFFFFF",
              },
            },
            "recordingFileConfig": {
              "avFileType": ["hls", "mp4"],
            },
            "storageConfig": {
              "vendor": 6,
              "region": 0,
              "bucket": GoogleCloudUtils.BUCKET_NAME,
              "accessKey": GoogleCloudUtils.ACCESS_KEY,
              "secretKey": GoogleCloudUtils.SECRET_KEY,
              // "fileNamePrefix": ["livestreams"]
            }
          }
        }));
    return response;
  }

  Future stopCloudRecording(
      {required String channel,
      required String uid,
      required String sid,
      required resourceId}) async {
    String plainCredentials =
        AgoraUtils.CUSTOMER_ID + ":" + AgoraUtils.CUSTOMER_SECRET_KEY;
    String base64Credentials = base64.encode(utf8.encode(plainCredentials));
    String authorizationHeader = "Basic " + base64Credentials;
    var headers = {
      "Authorization": authorizationHeader,
      "Content-Type": "application/json;charset=utf-8"
    };
    var response = http.post(
        Uri.parse(baseUrl +
            AgoraUtils.APP_ID_FOR_ACCUIRE +
            "/cloud_recording/resourceid/$resourceId/sid/$sid/mode/mix/stop"),
        headers: headers,
        body: jsonEncode({
          "cname": "deep",
          "uid": "90786543",
          "clientRequest": {
            "resourceExpiredHour": 24,
          }
        }));
    return response;
  }

  Future getRecordingQuery(
      {required String channel,
      required String uid,
      required String sid,
      required resourceId}) async {
    String plainCredentials =
        AgoraUtils.CUSTOMER_ID + ":" + AgoraUtils.CUSTOMER_SECRET_KEY;
    String base64Credentials = base64.encode(utf8.encode(plainCredentials));
    String authorizationHeader = "Basic " + base64Credentials;
    var headers = {
      "Authorization": authorizationHeader,
      "Content-Type": "application/json;charset=utf-8"
    };
    var response = http.get(
      Uri.parse(baseUrl +
          AgoraUtils.APP_ID_FOR_ACCUIRE +
          "/cloud_recording/resourceid/$resourceId/sid/$sid/mode/mix/query"),
      headers: headers,
    );
    return response;
  }
}
