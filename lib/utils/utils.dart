import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';

class ApiResponse {
  final bool? status;
  final String? message;
  final Map<String, dynamic>? data;

  ApiResponse(
      {required this.status, required this.message, required this.data});
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
        status: json['status'] ?? true,
        message: json['message'],
        data: json['data']);
  }
}

errorSnackBar(String errorMessage) => Get.isSnackbarOpen
    ? null
    : Get.snackbar('Error', errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        messageText: Text(errorMessage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        duration: const Duration(seconds: 3));

successSnackBar(String successMessage) => Get.isSnackbarOpen
    ? null
    : Get.snackbar('Success', successMessage,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        messageText: Text(successMessage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        duration: const Duration(seconds: 3));

Future<String> getAddressFromLatLng(Position position) async {
  final address =
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];

    final currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    logger.d('Location $currentAddress');
    return currentAddress;
  }).catchError((e) {
    logger.e(e);
    return 'Select Location';
  });
  return address;
}

String toImageUrl(String endpoint) {
  return "https://gully-team-bucket.s3.amazonaws.com/$endpoint";
}
