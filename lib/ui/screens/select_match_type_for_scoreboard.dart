
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../data/controller/scoreboard_controller.dart';
import 'current_tournament_list.dart';
import 'select_challenge_for_scoreboard.dart';

class SelectMatchCategory extends StatefulWidget {
  const SelectMatchCategory({
    super.key,
  });

  @override
  State<SelectMatchCategory> createState() => _SelectMatchCategoryState();
}

class _SelectMatchCategoryState extends State<SelectMatchCategory> {
  @override
  Widget build(BuildContext context) {
    final scorerboardController = Get.find<ScoreBoardController>();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Select Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                )),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  _Card(
                    title: 'Tournaments',
                    onTap: () {
                      Get.to(() => const CurrentTournamentListScreen(
                            redirectType: RedirectType.scoreboard,
                          ));
                      scorerboardController.isChallenge = false;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _Card(
                    title: 'Challenge',
                    onTap: () {
                      Get.to(() => const SelectChallengeForScoreboard());
                      scorerboardController.isChallenge = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Function onTap;
  const _Card({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Ink(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: AppTheme.secondaryYellowColor)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Text(
                title,
              ),
              const Spacer(),

              /// forwad icon
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryYellowColor,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
