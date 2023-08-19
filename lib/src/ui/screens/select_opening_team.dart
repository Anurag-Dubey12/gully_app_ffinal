import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/score_card.dart';
import 'package:gully_app/src/ui/screens/select_opening_players.dart';
import 'package:gully_app/src/ui/widgets/custom_text_field.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

class SelectOpeningTeam extends StatefulWidget {
  const SelectOpeningTeam({super.key});

  @override
  State<SelectOpeningTeam> createState() => _SelectOpeningTeamState();
}

class _SelectOpeningTeamState extends State<SelectOpeningTeam> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Select Opening Team',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Host Team',
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
          const Text('Visitor Team',
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

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Toss won by?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: false,
                            onChanged: (value) {},
                          ),
                          const Text('CSK'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: true,
                            onChanged: (value) {},
                          ),
                          const Text('KKR'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Opted to?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: false,
                            onChanged: (value) {},
                          ),
                          const Text('Bat'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: true,
                            onChanged: (value) {},
                          ),
                          const Text('Bowl'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Total Overs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const CustomTextField(
            filled: true,
          ),
          const SizedBox(height: 20),
          PrimaryButton(onTap: () {
            Get.to(() => const ScoreCardScreen());
          })
        ],
      ),
    ));
  }
}
