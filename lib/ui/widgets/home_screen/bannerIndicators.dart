import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class BannerIndicators extends StatelessWidget {
  final MiscController controller;
  
  const BannerIndicators({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.banners.isEmpty) {
        return _buildShimmerIndicators();
      } else {
        return _buildActiveIndicators();
      }
    });
  }

  Widget _buildShimmerIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 12,
          ),
        ),
        const SizedBox(width: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3, // Default number of indicators for shimmer
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 10,
                width: index == 0 ? 15 : 8, // First one is active
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.arrow_back_ios_new,
          size: 12,
          color: AppTheme.darkYellowColor,
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            controller.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 10,
              width: controller.indexvalue.value == index ? 15 : 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: controller.indexvalue.value == index
                    ? AppTheme.darkYellowColor
                    : Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppTheme.darkYellowColor,
        ),
      ],
    );
  }
}