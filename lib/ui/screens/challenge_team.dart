import 'package:flutter/material.dart';

import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../../config/app_constants.dart';

class ChallengeTeam extends StatelessWidget {
  const ChallengeTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            AppConstants.challengeTeamTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(AppConstants.challengeTeamMessage),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                onTap: () {
                  // Get.to(() =>  SearchChallengeTeam(
                  //   team: w,
                  // ));
                },
                title: AppConstants.payNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
