import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/utils/app_logger.dart';

import 'preferences.dart';

class GetConnectClient extends GetConnect {
  final Preferences preferences;
  GetConnectClient({required this.preferences});
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = AppConstants.baseUrl;
    httpClient.timeout = const Duration(seconds: 25);
    httpClient.addRequestModifier<dynamic>((request) {
      logger.d("--> ${request.method.toUpperCase()}: ${request.url}");
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${preferences.getToken()}'
      });
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

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) {
    try {
      return super
          .get(url, contentType: contentType, query: query, decoder: decoder);
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
        decoder: decoder,
        uploadProgress: uploadProgress);
  }

  @override
  Future<Response<T>> delete<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) {
    return super
        .delete(url, contentType: contentType, query: query, decoder: decoder);
  }
}
