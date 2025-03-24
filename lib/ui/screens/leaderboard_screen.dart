import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gully_app/ui/screens/player_ranking_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../config/app_constants.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                AppConstants.leaderboardTitle,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      _Card(
                        title: AppConstants.playerRankingTitle,
                        onTap: () {
                          Get.to(() => const PlayerRankingScreen());
                        },
                      ),
                      _Card(
                        title: AppConstants.teamRankingTitle,
                        onTap: () {},
                      ),
                      _Card(
                        title: AppConstants.topPerformerTitle,
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Function onTap;
  final String title;
  const _Card({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1.4,
              color: AppTheme.secondaryYellowColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.secondaryYellowColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
