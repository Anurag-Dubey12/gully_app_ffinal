import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

Future<XFile?> imagePickerHelper() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  return image;
}
Future<List<XFile?>?> multipleimagePickerHelper() async {
  final ImagePicker picker = ImagePicker();
  final List<XFile> images = await picker.pickMultiImage();
  return images ??[];
}



Future<String> convertImageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  final mimeType = lookupMimeType(image.path);

  final String base64Image = base64Encode(bytes);
  return mimeType != null ? 'data:$mimeType;base64,$base64Image' : base64Image;
}

void imageViewer(BuildContext context, String? photoUrl,bool isnetworkimage) {
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
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: isnetworkimage ?
                  Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FallbackImageProvider(
                          toImageUrl(photoUrl),
                          'assets/images/logo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ):
                  Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(photoUrl)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
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