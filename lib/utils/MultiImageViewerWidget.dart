import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/utils/utils.dart';

import 'FallbackImageProvider.dart';

class MultiImageViewerWidget extends StatefulWidget {
  final List<String?> imageUrls;
  final int initialIndex;
  final bool isNetworkImage;

  MultiImageViewerWidget({
    required this.imageUrls,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  @override
  State<MultiImageViewerWidget> createState() => _MultiImageViewerWidgetState();
}

class _MultiImageViewerWidgetState extends State<MultiImageViewerWidget> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void previousImage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void nextImage() {
    if (currentIndex < widget.imageUrls.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canGoPrevious = currentIndex > 0;
    final bool canGoNext = currentIndex < widget.imageUrls.length - 1;

    return WillPopScope(
      onWillPop: () async => true,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: Hero(
              tag: 'multiImageViewer$currentIndex',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  width:Get.width,
                  height: Get.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.isNetworkImage
                          ? FallbackImageProvider(
                        toImageUrl(widget.imageUrls[currentIndex]!),
                        'assets/images/logo.png',
                      )
                          : FileImage(File(widget.imageUrls[currentIndex]!)) as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: canGoPrevious ? previousImage : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: canGoPrevious ? Colors.white : Colors.white38,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: canGoNext ? nextImage : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: canGoNext ? Colors.white : Colors.white38,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}