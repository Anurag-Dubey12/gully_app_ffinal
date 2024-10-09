import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../theme/theme.dart';

class PackageInfo extends StatelessWidget {
  final Map<String, dynamic> package;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageInfo({
    required this.package,
    required this.isSelected,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final packageName = package['package'];
    final price = package['price'];
    final duration = package['Duration'];
    final borderColor = package['Border_color'];
    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.white,
              border: Border.all(
                color: isSelected ? borderColor : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    packageName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? borderColor : AppTheme.primaryColor,
                    ),
                  ),
                ),
                Text(
                  'Price: $price',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Duration: $duration',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 10,
              top: 35,
              child: Icon(
                Icons.check_circle,
                color: borderColor,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}