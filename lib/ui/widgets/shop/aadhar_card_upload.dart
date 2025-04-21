import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class AadharCardUpload extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const AadharCardUpload({super.key, required this.onSubmit});

  @override
  State<AadharCardUpload> createState() => _AadhaarBottomSheetState();
}

class _AadhaarBottomSheetState extends State<AadharCardUpload> {
  AadhaarSide selectedSide = AadhaarSide.front;
  File? frontImage;
  File? backImage;
  bool imageUploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Capture Image",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              title: const Text("Upload from Gallery",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.photo, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        imageUploaded = true;
      });

      File file = File(image.path);
      if (selectedSide == AadhaarSide.front) {
        frontImage = file;
      } else {
        backImage = file;
      }
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Exit Aadhaar Verification?"),
            content:
                const Text("If you close, the whole process has to be redone."),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Exit"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 7,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
//            Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.85), // Light semi-transparent background
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 4,
//           offset: Offset(0, 2),
//         )
//       ],
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Text(
//             "Please upload both the front and back sides of your Aadhaar card for verification.",
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Icon(
//             Icons.close,
//             size: 20,
//             color: Colors.grey[800],
//           ),
//         )
//       ],
//     ),
//   ),
// ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<AadhaarSide>(
                    value: AadhaarSide.front,
                    groupValue: selectedSide,
                    activeColor: Colors.white,
                    onChanged: (value) =>
                        setState(() => selectedSide = value!)),
                Text('Front Side',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedSide == AadhaarSide.front
                            ? Colors.white
                            : Colors.black)),
                SizedBox(width: Get.width * 0.16),
                Radio<AadhaarSide>(
                    value: AadhaarSide.back,
                    groupValue: selectedSide,
                    onChanged: (value) =>
                        setState(() => selectedSide = value!)),
                Text('Back Side',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedSide == AadhaarSide.back
                            ? Colors.white
                            : Colors.black)),
              ],
            ),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: Get.height * 0.19,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1)),
                child: selectedSide == AadhaarSide.front &&
                            frontImage != null ||
                        selectedSide == AadhaarSide.back && backImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                            selectedSide == AadhaarSide.front
                                ? frontImage!
                                : backImage!,
                            fit: BoxFit.cover,
                            width: Get.width),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo,
                                color: Colors.black, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              selectedSide == AadhaarSide.front
                                  ? 'Upload Front Side of Aadhaar'
                                  : 'Upload Back Side of Aadhaar',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            SizedBox(height: Get.height * 0.14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: PrimaryButton(
                      title: "Close",
                      color: Colors.grey,
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  child: PrimaryButton(
                      title: "Submit",
                      onTap: () {
                        if (frontImage != null && backImage != null) {
                          widget.onSubmit({
                            "frontImage": frontImage?.path ?? '',
                            "backImage": backImage?.path ?? '',
                          });
                        } else {
                          Get.snackbar(
                            'Oops',
                            AppConstants.aadharBothSideImage,
                            snackPosition: SnackPosition.top,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(12),
                            borderRadius: 8,
                          );
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum AadhaarSide { front, back }
