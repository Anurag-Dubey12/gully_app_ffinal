import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
