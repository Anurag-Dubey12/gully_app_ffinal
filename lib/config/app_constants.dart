import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();
  static const String appName = 'Gully Cricket';
  static const baseUrl =
      kReleaseMode ? "http://65.0.80.235:3000" : "http://192.168.1.11:3000";
  static const websocketUrl =
      kReleaseMode ? "ws://13.233.149.139:3001" : "ws://192.168.1.6:3001";
  static const String s3BucketUrl =
      "https://gully-team-bucket.s3.amazonaws.com/";
}
// google_api=AIzaSyAiDKwhd7BPTxhp2z9JnuD3Gy-2NaYHARw