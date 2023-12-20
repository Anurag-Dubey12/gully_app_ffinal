import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../config/preferences.dart';
import 'app_logger.dart';

class GetConnectClient extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'http://13.232.103.173/api/user';
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
        headers: {'Authorization': 'Bearer ${preferences.getToken()}'},
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
