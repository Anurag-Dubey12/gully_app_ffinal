import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:get/get.dart';

class NoTournamentCard extends StatelessWidget {
  const NoTournamentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        width: Get.width,
        // height: 100,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                "assets/images/empty.png",
                scale: 2.5,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.no_matches,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
