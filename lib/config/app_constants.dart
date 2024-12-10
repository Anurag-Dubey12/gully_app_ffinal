import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();
  static const String appName = 'Gully Cricket';
  static const baseUrl = kReleaseMode
      ? "http://3.7.92.159:3000/api"
      // : "http://192.168.0.105:3000/api";//personL
      : "http://192.168.29.10:3000/api";//Office
      // : "http://3.7.92.159:3000/api";//server
  // : "http://172.20.10.5:3000/api";
  static const websocketUrl =
      kReleaseMode ? "ws://65.1.61.197:3001" : "ws://65.1.61.197:3001";
  static const String s3BucketUrl =
      "https://gully-team-bucket.s3.amazonaws.com/";
}
