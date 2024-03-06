import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoTournamentCard extends StatelessWidget {
  const NoTournamentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        width: Get.width,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              "assets/images/empty.png",
              scale: 6,
            ),
            const SizedBox(height: 10),
            Text(
              'Oops, No matches on this day.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
