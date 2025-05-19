import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ShopImagePicker extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;
  final Function(List<XFile>) onImageSelected;
  final Function(int) removedAtIndex;
  final int maxImages;
  final bool isNetworkFetch;

  const ShopImagePicker(
      {Key? key,
      required this.images,
      required this.onImagesChanged,
      required this.onImageSelected,
      required this.removedAtIndex,
      this.maxImages = 3,
      this.isNetworkFetch = false})
      : super(key: key);

  @override
  State<ShopImagePicker> createState() => _ShopImagePickerState();
}

class _ShopImagePickerState extends State<ShopImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];
  List<XFile> _shopImages = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.images);
    _shopImages = widget.images.map((image) => XFile(image)).toList();
  }

  Future<void> _pickImage() async {
    if (_images.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'You can only upload a maximum of ${widget.maxImages} images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final File file = File(image.path);
        // int fileSizeInBytes = await file.length();
        // double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        // if (fileSizeInMB > 2) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('File size should be less than 2MB'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        //   return;
        // }

        final String extension = image.path.split('.').last.toLowerCase();
        if (extension != 'jpg' && extension != 'png' && extension != 'jpeg') {
          errorSnackBar("Please select a PNG or JPG image");
          return;
        }

        setState(() {
          _images.add(image.path);
          print("Image Selected:${_images}");
          _shopImages.add(image);
          widget.onImagesChanged(_images);
          widget.onImageSelected(_shopImages);
        });
      }
    } catch (e) {
      print("Failed to get image:${e.toString()}");
      errorSnackBar("Something went wrong");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_currentIndex >= _images.length) {
        _currentIndex = _images.length - 1;
      }
      if (_currentIndex < 0) _currentIndex = 0;
      widget.onImagesChanged(_images);
      widget.removedAtIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Shop Images (max 3)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1)),
          child: _images.isEmpty
              ? _buildAddImageButton()
              : Stack(
                  children: [
                    PageView.builder(
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            if (widget.isNetworkFetch)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.network(
                                    toImageUrl(_images[index]),
                                    fit: BoxFit.cover,
                                    height: Get.height,
                                  ),
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(File(_images[index])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (_images.length < widget.maxImages)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImage,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo,
              color: Colors.black,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Shop Images (${_images.length}/${widget.maxImages})',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
