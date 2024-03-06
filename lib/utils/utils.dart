import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
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

errorSnackBar(String errorMessage) => Get.isDialogOpen ?? false
    ? null
    : Get.defaultDialog(
        title: 'Oops!',
        contentPadding: const EdgeInsets.all(10),
        titlePadding: const EdgeInsets.all(10),
        titleStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
        confirm: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppTheme.primaryColor,
            ),
            child: const Text('OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ),
        middleText: errorMessage,
      );

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

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  final address = await placemarkFromCoordinates(latitude, longitude)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];

    final currentAddress =
        '${place.subLocality}  ${place.subAdministrativeArea} ${place.administrativeArea}';
    logger.d('Location ::$currentAddress');
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

String getAssetFromRole(String role) {
  switch (role) {
    case 'Captain':
      return 'assets/images/bat.png';
    case 'Batsman':
      return 'assets/images/bat.png';
    case 'Bowler':
      return 'assets/images/ball.png';
    case 'Wicket Keeper':
      return 'assets/images/helmet.png';
    case 'All Rounder':
      return 'assets/images/allrounder.png';
    default:
      return 'assets/images/bat.png';
  }
}
