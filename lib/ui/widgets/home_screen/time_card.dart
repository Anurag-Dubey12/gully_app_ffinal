import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';

import '../../theme/theme.dart';

class TimeCard extends GetView<TournamentController> {
  final String title;
  final bool isSelected;
  const TimeCard({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 90,
        // height: 8,
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.secondaryYellowColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: isSelected
                      ? AppTheme.secondaryYellowColor.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          title,
          style: Get.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.black,
          ),
        )),
      ),
    );
  }
}
