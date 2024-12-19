import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FallbackImageProvider.dart';

class CustomItemCheckbox extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;
  final double? imageRadius;
  final TextStyle? titleStyle;
  final Color? selectedColor;
  final Color? borderColor;
  final Color? checkColor;

  const CustomItemCheckbox({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.imageRadius = 20,
    this.titleStyle,
    this.selectedColor,
    this.borderColor,
    this.checkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? selectedColor ?? theme.primaryColor
                : borderColor ?? Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.white : Colors.grey[50],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? selectedColor ?? theme.primaryColor
                      : Colors.grey[400]!,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
                color: isSelected
                    ? selectedColor ?? theme.primaryColor
                    : Colors.white,
              ),
              child: isSelected
                  ? Icon(
                Icons.check,
                size: 14,
                color: checkColor ?? Colors.white,
              )
                  : null,
            ),
            if (imageUrl != null) ...[
              const SizedBox(width: 12),
              CircleAvatar(
                radius: imageRadius,
                backgroundImage: FallbackImageProvider(
                    imageUrl!,'assets/images/logo.png'
                ),
              ),
            ],
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: titleStyle?.copyWith(
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 16
                ) ?? theme.textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}