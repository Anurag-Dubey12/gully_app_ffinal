import 'package:flutter/material.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/theme/theme.dart';

Widget shopDayTimingRow(String day, ShopModel shop,
    {bool isHighlighted = false}) {
  final timing = shop.shopTiming?[day];
  final bool isOpen = timing?.isOpen ?? false;
  final String timeText =
      isOpen ? '${timing?.openTime} - ${timing?.closeTime}' : 'Closed';

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    decoration: BoxDecoration(
      color: isHighlighted ? AppTheme.primaryColor.withOpacity(0.1) : null,
      borderRadius: isHighlighted ? BorderRadius.circular(8) : null,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? AppTheme.primaryColor : Colors.black,
          ),
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOpen ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              timeText,
              style: TextStyle(
                color: isHighlighted ? AppTheme.primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget shopInfo(String title, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

String? getExpirationTag(ShopModel shop) {
  final now = DateTime.now();
  final packageEndDate = shop.packageEndDate;

  if (packageEndDate == null) return null;

  final daysDifference = packageEndDate.difference(now).inDays;
  if (daysDifference >= 0 && daysDifference <= 6) {
    return "Expires in $daysDifference day${daysDifference == 1 ? '' : 's'}";
  } else if (daysDifference < 0) {
    return "Expired ${-daysDifference} day${-daysDifference == 1 ? '' : 's'} ago";
  }

  return null;
}
