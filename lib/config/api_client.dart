import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';

import 'preferences.dart';

class GetConnectClient extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'http://192.168.1.4:3000';
    httpClient.timeout = const Duration(seconds: 13);
    httpClient.addRequestModifier<dynamic>((request) {
      logger.d("--> ${request.method.toUpperCase()}: ${request.url}");
      logger.d("Headers: ${request.headers.toString()}");

      return request;
    });
    httpClient.addResponseModifier((request, response) {
      if (kDebugMode) {
        logger.i("<-- END HTTP | STATUS ${response.statusCode}");
        logger.i(
            "--> START RESPONSE ${request.method.toUpperCase()}: ${request.url} -->");
        logger.i("${response.body}");
        logger.i("<-- END RESPONSE ");
      }
      return response;
    });
  }

  Preferences preferences = Get.find();

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) {
    try {
      return super.get(url,
          headers: {'Authorization': 'Bearer ${preferences.getToken()}'},
          contentType: contentType,
          query: query,
          decoder: decoder);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
      {String? contentType,
      Map<String, dynamic>? query,
      Map<String, String>? headers,
      T Function(dynamic)? decoder,
      dynamic Function(double)? uploadProgress}) {
    return super.post(url, body,
        contentType: contentType,
        query: query,
        // headers: {'Authorization': 'Bearer ${preferences.getToken()}'},
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3QzMDBAZ21haWwuY29tIiwidXNlcklkIjoiNjU3NGQzMjkxYWVkNGQ2N2JjYjVhZjY4IiwiZnVsbE5hbWUiOiJ0ZXN0MyIsImNvb3JkaW5hdGVzIjp7ImxhdGl0dWRlIjoxOS4yMTIwMDksImxvbmdpdHVkZSI6NzIuODYxNTU3LCJwbGFjZU5hbWUiOiJLYW5kaXZhbGkgRWFzdCJ9LCJpYXQiOjE3MDI1NDc0MDMsImV4cCI6MTczNDEwNTAwM30.sAQF44oxc93PiwupFp4FJT_7BPYxDtoJvMIgKk-T--U'
        },
        decoder: decoder,
        uploadProgress: uploadProgress);
  }

  @override
  Future<Response<T>> delete<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) {
    return super.delete(url,
        headers: {'Authorization': 'Bearer ${preferences.getToken()}'},
        contentType: contentType,
        query: query,
        decoder: decoder);
  }
}
