import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../widgets/custom_drop_down_field.dart';

class LookingForScreen extends StatefulWidget {
  const LookingForScreen({super.key});

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends State<LookingForScreen> {
  String? selectedValue;
  String? selectedValue2;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/sports_icon.png'),
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('What i am looking for?',
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What are you looking for?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropDownWidget(
                    title: 'Select Team Name',
                    onSelect: (e) {
                      setState(() {
                        selectedValue = e;
                      });
                      Get.back();
                    },
                    selectedValue: selectedValue,
                    items: const ['Batsman', 'Bowler', 'Wicket Keeper'],
                  ),
                  const SizedBox(height: 10),
                  const Text('Location',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropDownWidget(
                    title: 'Select Team Name',
                    onSelect: (e) {
                      setState(() {
                        selectedValue = e;
                      });
                      Get.back();
                    },
                    selectedValue: selectedValue,
                    items: const ['Mumbai', 'Anderi', 'Pune'],
                  ),
                  const SizedBox(height: 10),
                  const Text('Add contact for',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 53,
                    child: CustomTextField(
                      filled: true,
                      helperText: 'Contact Number',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: Get.width / 2,
                      child: PrimaryButton(onTap: () {}),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('My Posts',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Bhavesh Pant is looking for a team to join as a batsman in Mumbai'),
                                Text('2 hours ago',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      AppTheme.secondaryYellowColor,
                                  child: Icon(Icons.contact_page),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
