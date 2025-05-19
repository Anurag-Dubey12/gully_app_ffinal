import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'MultiImageViewerWidget.dart';

Future<XFile?> imagePickerHelper() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  return image;
}

Future<List<XFile?>?> multipleimagePickerHelper() async {
  final ImagePicker picker = ImagePicker();
  final List<XFile> images = await picker.pickMultiImage();
  return images ?? [];
}

Future<String> convertImageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  final mimeType = lookupMimeType(image.path);

  final String base64Image = base64Encode(bytes);
  // logger.d("The base64 image is: $base64Image");
  return mimeType != null ? 'data:$mimeType;base64,$base64Image' : base64Image;
}

Future<String> convertVideoToBase64(XFile image) async {
  return await compute(_encodeFileToBase64, image);
}

// This function runs in the isolate
String _encodeFileToBase64(XFile image) {
  final bytes = File(image.path).readAsBytesSync();
  final mimeType = lookupMimeType(image.path);

  final String base64Image = base64Encode(bytes);
  // Note: Logger may not work in isolate, consider removing this debug line
  // logger.d("The base64 image is: $base64Image");

  return mimeType != null ? 'data:$mimeType;base64,$base64Image' : base64Image;
}

// MARK: Image Viewer
void imageViewer(BuildContext context, String? photoUrl, bool isnetworkimage,
    {VoidCallback? onTap}) {
  if (photoUrl == null || photoUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No image available')),
    );
    return;
  }

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (BuildContext context, _, __) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: Hero(
                tag: 'tournamentLogo',
                child: GestureDetector(
                  onTap: onTap ?? () {},
                  child: AnimatedBuilder(
                    animation: const AlwaysStoppedAnimation(1.0),
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                          CurvedAnimation(
                            parent: ModalRoute.of(context)!.animation!,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: CurvedAnimation(
                            parent: ModalRoute.of(context)!.animation!,
                            curve: Curves.easeInOut,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: isnetworkimage
                                    ? Image.network(
                                        toImageUrl(photoUrl),
                                        width: Get.width,
                                        height: Get.height,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child; 
                                          } else {
                                           
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/logo.png',
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      )
                                    : Image.file(
                                        File(photoUrl!),
                                        width: Get.width,
                                        height: Get.height,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    ),
  );
}

ImageProvider _getImageProvider(String photoUrl) {
  if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
    return FallbackImageProvider(
      toImageUrl(photoUrl),
      'assets/images/logo.png',
    );
  } else {
    return FileImage(File(photoUrl));
  }
}
void multiImageViewer(BuildContext context, List<String?> imageUrls,
    int initialIndex, bool isNetworkImage) {
  if (imageUrls.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No images available')),
    );
    return;
  }

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (BuildContext context, _, __) {
        return MultiImageViewerWidget(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          isNetworkImage: isNetworkImage,
        );
      },
    ),
  );
}
