import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/add_player_to_team.dart';
import 'package:gully_app/src/ui/widgets/custom_text_field.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

class SelectOpeningPlayer extends StatefulWidget {
  const SelectOpeningPlayer({super.key});

  @override
  State<SelectOpeningPlayer> createState() => _SelectOpeningPlayerState();
}

class _SelectOpeningPlayerState extends State<SelectOpeningPlayer> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Select Opening Players',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Strikers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CustomTextField(
              filled: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                size: 44,
              ),
              readOnly: true,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            const Text('Non-Strikers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CustomTextField(
              filled: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                size: 44,
              ),
              readOnly: true,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            const Text('Opening Bowler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CustomTextField(
              filled: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                size: 44,
              ),
              readOnly: true,
              onTap: () {},
            ),
            // container with white bg and border radius of 10 with two items in row having text and radio btn
            const SizedBox(height: 20),
            const Spacer(),
            PrimaryButton(
              onTap: () {
                Get.to(() => const AddPlayersToTeam());
              },
              title: 'Start Match',
            )
          ],
        ),
      ),
    ));
  }
}
