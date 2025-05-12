import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import '../ui/screens/home_screen.dart';

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

Future errorSnackBar(String errorMessage,
        {bool forceDialogOpen = false, String? title}) async =>
    (Get.isDialogOpen ?? false) && !forceDialogOpen
        ? null
        : Get.defaultDialog(
            title: title ?? 'Oops!',
            contentPadding: const EdgeInsets.all(10),
            titlePadding: const EdgeInsets.all(10),
            titleStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
            confirm: InkWell(
              onTap: () {
                // Get.back();
                Get.close();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

Future successSnackBar(String successMessage,
        {String? title,
        bool istournamentScreen = false,
        bool isback = false}) async =>
    Get.isDialogOpen ?? false
        ? null
        : await Get.defaultDialog(
            title: title ?? 'Yayy!',
            contentPadding: const EdgeInsets.all(10),
            titlePadding: const EdgeInsets.all(10),
            titleStyle: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
            confirm: InkWell(
              onTap: () {
                istournamentScreen
                    ? Get.offAll(() => const HomeScreen(),
                        predicate: (route) => route.name == '/HomeScreen')
                    : isback
                        ? Get.back()
                        : Get.close();
                // Get.back();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            middleText: successMessage,
          );

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  final address = await placemarkFromCoordinates(latitude, longitude)
      .then((List<Placemark> placemarks) {
    if (placemarks.isEmpty) {
      //logger.d'No address found');
      return 'Click here to Select Location';
    }
    Placemark place = placemarks[0];
    //logger.d'Place ::${place.toJson()}');
    String currentAddress = "";
    //  currentAddress =
    //     '${place.name} ${place.subLocality}  ${place.subAdministrativeArea} ${place.administrativeArea}';
    // modify above line to get the address in the format you want, if name is not available, you can use place.street,if subLocality is not available, you can use place.locality and so on
    if (place.name != null) {
      currentAddress += place.name ?? "";
    } else {
      currentAddress += place.street ?? "";
    }
    currentAddress += ", ";
    if (place.subLocality != null) {
      currentAddress += place.subLocality ?? "";
    } else {
      currentAddress += place.locality ?? "";
    }
    currentAddress += ", ";
    if (place.subAdministrativeArea != null) {
      currentAddress += place.subAdministrativeArea ?? "";
    }
    if (place.administrativeArea != null &&
        (place.name == null || place.name == "")) {
      currentAddress += place.administrativeArea ?? "";
    }

    //logger.d'Location ::$currentAddress');
    return currentAddress;
  }).catchError((e) {
    errorSnackBar('Unable to fetch address $e');
    //logger.e(e);
    throw e;
  });
  return address;
}

String getCurrentDay() {
  return DateFormat('EEEE').format(DateTime.now());
}

String toImageUrl(String endpoint) {
  return "https://gully-team-bucket.s3.amazonaws.com/$endpoint";
}

String getAssetFromRole(String role) {
  switch (role) {
    case 'captain':
      return 'assets/images/captian.png';
    case 'Batsman':
      return 'assets/images/bat.png';
    case 'Bowler':
      return 'assets/images/ball.png';
    case 'Wicket Keeper':
      return 'assets/images/helmet.png';
    case 'All Rounder':
      return 'assets/images/allrounder.png';
    default:
      return 'assets/images/captain.png';
  }
}

Future<Duration> getVideoDuration(File videoFile) async {
  final videoPlayerController = VideoPlayerController.file(videoFile);
  await videoPlayerController.initialize();
  final duration = videoPlayerController.value.duration;
  await videoPlayerController.dispose();
  return duration;
}
 // MARK: Email Validation
  String? validateEmail(String email) {
    final RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$");
    if (email.isEmpty) {
      return AppConstants.pleaseEnterYourEmail;
    }

    // Basic email format validation
    if (!emailRegExp.hasMatch(email)) {
      return AppConstants.enterValildEmailAddress;
    }

    // Allowed Gmail domains
    final allowedDomains = [
      'gmail.com',
      'googlemail.com',
      'outlook.com',
      'yahoo.com',
      'hotmail.com',
    ];

    // Extract domain part
    final domain = email.split('@').last.toLowerCase();

    if (!allowedDomains.contains(domain)) {
      return "Please enter a valid Email address \nE.g xyz@gmail.com or xyz@outlook.com";
    }

    return null;
  }