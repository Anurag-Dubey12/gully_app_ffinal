import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';

SnackbarController showSnackBar(
    {required String title, required String message, required bool isError}) {
  return Get.snackbar(title, message,
      backgroundColor: !isError
          ? AppTheme.lightTheme.colorScheme.background.withOpacity(0.67)
          : Colors.red.withOpacity(0.87),
      colorText: !isError ? Colors.black : Colors.white);
}
