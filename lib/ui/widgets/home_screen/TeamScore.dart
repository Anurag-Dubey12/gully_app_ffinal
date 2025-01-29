import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/utils.dart';

class TeamScore extends StatelessWidget {
  final Color color;
  final String teamName;
  final String? teamLogo;
  final String score;
  final bool isSchedule;

  const TeamScore(
      {super.key, required this.color,
      required this.teamName,
      required this.score,
      this.teamLogo,
      this.isSchedule = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              isSchedule
                  ? CircleAvatar(
                      radius: 20.0,
                      backgroundImage: FallbackImageProvider(
                        toImageUrl(teamLogo ?? ''),
                        'assets/images/logo.png',
                      ),
                    )
                  : Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  teamName,
                  style: Get.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            score,
            style:
                Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
