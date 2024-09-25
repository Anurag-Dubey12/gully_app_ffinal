import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';

class ImageUploadWidget extends StatelessWidget {
  final XFile? image;
  final VoidCallback onTap;
  final String hintText;

  const ImageUploadWidget({
    Key? key,
    required this.image,
    required this.onTap,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Text(
                hintText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: Get.width,
                height: 200,
                child: GestureDetector(
                  onLongPress: () {
                    imageViewer(context, image!.path, false);
                  },
                  child: Image.file(
                    File(image!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}